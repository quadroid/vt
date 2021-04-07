{
  Пример № 6 - Полное изменение отрисовки дерева.
  Пример иллюстрирует самостоятельную отрисовку всех узлов
  дерева с помощью класса TVirtualDrawTree, имитируя менеджер закачек
  браузера Mozilla Firefox.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, VirtualTrees, ImgList, XPMan, StdCtrls, ExtCtrls,
  XMLDoc, XMLIntf, JPEG, Math;

const
  // Сообщение для уведомления дерева потоком от том, что необходимо
  // перерисовать указанный узел
  VT_REPAINTTREE = WM_USER + 500;

type
  TGradientKind = (gkHorz, gkVert);

  PItemNode = ^TItemNode;

  TItemNode = record
    Image, Name: String;
    Mass, PriceKg: Word;
    Process: Byte;
    PersonalThread: Cardinal;
  end;

  // Поток, имитирующий выполнение какой-то операции
  TProcessThread = class(TThread)
  private
    FWnd: HWND; // Хендл формы. Необходим для отсылки сообщений ему
    FNode: PVirtualNode; // Узел, за который поток отвечает
    FValue: Byte; // Процесс доставки
    procedure RepaintTree;
    procedure CheckDeleted;
  public
    constructor Create(Suspended: Boolean; var InitialValue: Byte;
      CallingForm: HWND; VTNode: PVirtualNode);
  protected
    procedure Execute; override;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualDrawTree;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    BtnAdd: TToolButton;
    ImageList: TImageList;
    PnEdit: TPanel;
    LblFind: TLabel;
    EdFind: TEdit;
    BtnDelete: TToolButton;
    StatusBar: TStatusBar;
    procedure VTResize(Sender: TObject);
    procedure VTGetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var R: TRect);
    procedure VTDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure VTGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
    procedure EdFindChange(Sender: TObject);
    procedure VTClick(Sender: TObject);
    procedure VTGetCursor(Sender: TBaseVirtualTree; var Cursor: TCursor);
    procedure VTDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    // Этот экземпляр класса TProgressBar мы при каждой отрисовке будем
    // заполнять необходимыми настройками и отрисовывать в узле.
    FProgress: TProgressBar;
    procedure LoadData;
    procedure SaveData;
  public
    { Public declarations }
  protected
    procedure VTREPAINTTREE(var Message: TMessage); message VT_REPAINTTREE;
  end;

  procedure GradFill(DC: HDC; ARect: TRect; ClrTopLeft, ClrBottomRight: TColor;
    Kind: TGradientKind);

var
  frmMain: TfrmMain;

implementation

uses
  uNew;

{$R *.dfm}

//------------------------------------------------------------------------------
// Рисует градиент.
//------------------------------------------------------------------------------
procedure GradFill(DC: HDC; ARect: TRect; ClrTopLeft, ClrBottomRight: TColor;
  Kind: TGradientKind);
var
  GradientCache: array [0..16] of array of Cardinal;
  NextCacheIndex: Integer;

  function FindGradient(Size: Integer; CL, CR: Cardinal): Integer;
  begin
    Assert(Size > 0);
    Result := 16 - 1;
    while Result >= 0 do
    begin
      if (Length(GradientCache[Result]) = Size) and
        (GradientCache[Result][0] = CL) and
        (GradientCache[Result][Length(GradientCache[Result]) - 1] = CR) then Exit;
      Dec(Result);
    end;
  end;

  function MakeGradient(Size: Integer; CL, CR: Cardinal): Integer;
  var
    R1, G1, B1: Integer;
    R2, G2, B2: Integer;
    R, G, B: Integer;
    I: Integer;
    Bias: Integer;
  begin
    Assert(Size > 0);
    Result := NextCacheIndex;
    Inc(NextCacheIndex);
    if NextCacheIndex >= 16 then NextCacheIndex := 0;
    R1 := CL and $FF;
    G1 := CL shr 8 and $FF;
    B1 := CL shr 16 and $FF;
    R2 := Integer(CR and $FF) - R1;
    G2 := Integer(CR shr 8 and $FF) - G1;
    B2 := Integer(CR shr 16 and $FF) - B1;
    SetLength(GradientCache[Result], Size);
    Dec(Size);
    Bias := Size div 2;
    if Size > 0 then
      for I := 0 to Size do
      begin
        R := R1 + (R2 * I + Bias) div Size;
        G := G1 + (G2 * I + Bias) div Size;
        B := B1 + (B2 * I + Bias) div Size;
        GradientCache[Result][I] := R + G shl 8 + B shl 16;
      end
    else
    begin
      R := R1 + R2 div 2;
      G := G1 + G2 div 2;
      B := B1 + B2 div 2;
      GradientCache[Result][0] := R + G shl 8 + B shl 16;
    end;
  end;

  function GetGradient(Size: Integer; CL, CR: Cardinal): Integer;
  begin
    Result := FindGradient(Size, CL, CR);
    if Result < 0 then Result := MakeGradient(Size, CL, CR);
  end;

var
  Size, I, Start, Finish: Integer;
  GradIndex: Integer;
  R, CR: TRect;
  Brush: HBRUSH;
begin
  NextCacheIndex := 0;
  if not RectVisible(DC, ARect) then
    Exit;
  ClrTopLeft := ColorToRGB(ClrTopLeft);
  ClrBottomRight := ColorToRGB(ClrBottomRight);
  GetClipBox(DC, CR);
  if Kind = gkHorz then
  begin
    Size := ARect.Right - ARect.Left;
    if Size <= 0 then Exit;
    Start := 0; Finish := Size - 1;
    if CR.Left > ARect.Left then Inc(Start, CR.Left - ARect.Left);
    if CR.Right < ARect.Right then Dec(Finish, ARect.Right - CR.Right);
    R := ARect; Inc(R.Left, Start); R.Right := R.Left + 1;
  end
  else begin
    Size := ARect.Bottom - ARect.Top;
    if Size <= 0 then Exit;
    Start := 0; Finish := Size - 1;
    if CR.Top > ARect.Top then Inc(Start, CR.Top - ARect.Top);
    if CR.Bottom < ARect.Bottom then Dec(Finish, ARect.Bottom - CR.Bottom);
    R := ARect; Inc(R.Top, Start); R.Bottom := R.Top + 1;
  end;
  GradIndex := GetGradient(Size, ClrTopLeft, ClrBottomRight);
  for I := Start to Finish do
  begin
    Brush := CreateSolidBrush(GradientCache[GradIndex][I]);
    Windows.FillRect(DC, R, Brush);
    OffsetRect(R, Integer(Kind = gkHorz), Integer(Kind = gkVert));
    DeleteObject(Brush);
  end;
end;

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * TProcessThread * * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
constructor TProcessThread.Create(Suspended: Boolean;
  var InitialValue: Byte; CallingForm: HWND; VTNode: PVirtualNode);
begin
  inherited Create(Suspended);
  FWnd := CallingForm;
  FNode := VTNode;
  FValue := InitialValue;
  FreeOnTerminate := True;
end;

//------------------------------------------------------------------------------
// Отсылаем сообщение форме о том, что узлу FNode необходима перерисовка
// Параметры:
//   WParam - адрес узла;
//   LParam - текущее значение процесса доставки.
//------------------------------------------------------------------------------
procedure TProcessThread.RepaintTree;
begin
  SendMessage(FWnd, VT_REPAINTTREE, Integer(FNode), FValue);
end;

//------------------------------------------------------------------------------
// Проверить не был ли удалён узел, за который мы отвечает. Если был, то
// делать нам больше нечего.
//------------------------------------------------------------------------------
procedure TProcessThread.CheckDeleted;
begin
  if not Assigned(FNode) then
    Terminate;
end;

//------------------------------------------------------------------------------

procedure TProcessThread.Execute;
begin
  while FValue < 100 do
  begin
    Sleep(100);
    Synchronize(CheckDeleted);
    Inc(FValue);
    Synchronize(RepaintTree);
  end;
end;

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.VTREPAINTTREE(var Message: TMessage);
var
  Node: PVirtualNode;
  ItemNode: PItemNode;
begin
  Node := Pointer(Message.WParam);
  if Assigned(Node) then
  begin
    ItemNode := VT.GetNodeData(Node);
    ItemNode^.Process := Message.LParam;
    VT.RepaintNode(Node);
  end;
end;

//------------------------------------------------------------------------------
// Помещает фоновую картинку в нижний правый угол.
//------------------------------------------------------------------------------
procedure TfrmMain.VTResize(Sender: TObject);
begin
  VT.BackgroundOffsetX := VT.Width - 130;
  VT.BackgroundOffsetY := VT.Height - 130;
end;

//------------------------------------------------------------------------------
// Загрузка нашей миниатюрной "базы данных".
// База данных представлена XML файлом. Чтение с помощью msxml.dll.
//------------------------------------------------------------------------------
procedure TfrmMain.LoadData;
var
  i: Integer;
  NewNode: PVirtualNode;
  NodeData: PItemNode;
  XMLDocument: TXMLDocument;
begin
  if not FileExists('db.db') then
    Exit;
  XMLDocument := TXMLDocument.Create(Self);
  try
    XMLDocument.LoadFromFile('db.db');
    // Для каждой ветки XML дерева создать узел в дереве и зарузить поля
    // для структуры данных из аттрибутов
    // Не забываем использовать блоки Begin/End Update.
    VT.BeginUpdate;
    try
      for i := 0 to XMLDocument.DocumentElement.ChildNodes.Count - 1 do
      begin
        NewNode := VT.AddChild(nil);
        NodeData := VT.GetNodeData(NewNode);
        with NodeData^ do
        begin
          Image := VarToStr(XMLDocument.DocumentElement.ChildNodes[i].Attributes['Image']);
          Name := VarToStr(XMLDocument.DocumentElement.ChildNodes[i].Attributes['Name']);
          Mass := StrToIntDef(
                  VarToStr(
                  XMLDocument.DocumentElement.ChildNodes[i].Attributes['Mass']
                  ), 0);
          PriceKg := StrToIntDef(
                  VarToStr(
                  XMLDocument.DocumentElement.ChildNodes[i].Attributes['Price']
                  ), 0);
        end;
      end;
    finally
      VT.EndUpdate;
    end;
  finally
    FreeAndNil(XMLDocument);
  end;
end;

//------------------------------------------------------------------------------
// Сохранение базы данных.
//------------------------------------------------------------------------------
procedure TfrmMain.SaveData;
var
  NextNode: PVirtualNode;
  NodeData: PItemNode;
  XMLDocument: TXMLDocument;
begin
  XMLDocument := TXMLDocument.Create(Self);
  try
    with XMLDocument do
    begin
      Active := True;
      Encoding := 'UTF-16';
      Options := Options + [doNodeAutoIndent, doNodeAutoCreate];
      AddChild('ShopDB');
    end;
    NextNode := VT.GetFirst;
    if Assigned(NextNode) then
      repeat
        NodeData := VT.GetNodeData(NextNode);
        with XMLDocument.DocumentElement.AddChild('Item'), NodeData^ do
        begin
          Attributes['Image'] := Image;
          Attributes['Name'] := Name;
          Attributes['Mass'] := Mass;
          Attributes['Price'] := PriceKg;
        end;
        NextNode := NextNode.NextSibling;
      until
        NextNode = nil;
    XMLDocument.SaveToFile('db.db');
  finally
    FreeAndNil(XMLDocument);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnAddClick(Sender: TObject);
begin
  with TfrmNew.Create(Self) do
    ShowModal;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnDeleteClick(Sender: TObject);
begin
  VT.DeleteSelectedNodes;
end;

//------------------------------------------------------------------------------
// Инкрементный поиск по дереву.
//------------------------------------------------------------------------------
procedure TfrmMain.EdFindChange(Sender: TObject);
var
  Next: PVirtualNode;
  ItemNode: PItemNode;
begin
  Next := VT.GetFirst;
  if Assigned(Next) then
    repeat
      ItemNode := VT.GetNodeData(Next);
      if StrLIComp(PChar(ItemNode^.Name), PChar(EdFind.Text), Min(
        Length(EdFind.Text), Length(ItemNode^.Name))) = 0 then
      begin
        with VT do
        begin
          ClearSelection;
          FocusedNode := Next;
          ScrollIntoView(FocusedNode, True);
        end;
        Exit;
      end;
      Next := Next.NextSibling;
    until
      Next = nil;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Cur: HCursor;
begin
  VT.NodeDataSize := SizeOf(TItemNode);
  FProgress := TProgressBar.Create(nil);
  with FProgress do
  begin
    Visible := False;
    Parent := VT;
  end;
  LoadData;
  // Загружаем стандартный курсор руки из системы (вместо кривого и
  // самопального от Borland)
  Cur := LoadCursor(0, IDC_HAND);
  if Cur <> 0 then
    Screen.Cursors[crHandPoint] := Cur;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SaveData;
  FreeAndNil(FProgress);
end;

//------------------------------------------------------------------------------
// Функции дерева.
//------------------------------------------------------------------------------
// Здесь мы определяем был ли произведён клик на надпись "Доставить" или
// "Отмена" и выполняем положенные действия.
//------------------------------------------------------------------------------
procedure TfrmMain.VTClick(Sender: TObject);
var
  Pt: TPoint;
  Node: PVirtualNode;
  NodeData: PItemNode;
  NRect: TRect;
  NewThread: TProcessThread;
  D: Integer;
  Inf: tagScrollInfo;
begin
  // Поулчаем координаты курсора
  GetCursorPos(Pt);
  // Положение курсора в дереве через них
  Pt := VT.ScreenToClient(Pt);
  // И узел из всей этой бодяги, находящийся под курсором
  Node := VT.GetNodeAt(Pt.X, Pt.Y);
  // Здесь мы выясняем виден ли вертикальный скролл у дерева.
  // nMax будет меньше или равен высоте дерева, если скрола нет.
  with Inf do
  begin
    cbSize := SizeOf(tagScrollInfo);
    fMask := SIF_RANGE;
  end;
  GetScrollInfo(VT.Handle, SB_VERT, Inf);
  if (Inf.nMax > VT.Height) then
    D := GetSystemMetrics(SM_CXHTHUMB)
  else
    D := 0;
  // Если узел под курсором есть...
  if Node <> nil then
  begin
    // ...то получаем его координаты
    NRect := VT.GetDisplayRect(Node, -1, False);
    // Если курсор над надписью "Доставить", то...
    if (Pt.X > VT.Width - 71 - D) and (Pt.X < VT.Width - 16 - D) and
      (Pt.Y > NRect.Bottom - 42) and
      (Pt.Y < NRect.Bottom - 29) then
    begin
      // ...запускаем поток доставки, если заказ ещё не дошёл и хендл потока у
      // узла равен нулю (т.е. поток для этого узла ещё не запускался)
      NodeData := VT.GetNodeData(Node);
      if (NodeData^.Process < 100) and (NodeData^.PersonalThread = 0) then
      begin
        NewThread := TProcessThread.Create(True, NodeData^.Process, Self.Handle, Node);
        // Запоминаем хендл потока
        NodeData^.PersonalThread := NewThread.Handle;
        NewThread.Resume;
      end
      else
        MessageBox(Handle, 'Заказ уже принят.', PChar(Application.Title),
          MB_ICONINFORMATION or MB_OK or MB_DEFBUTTON1 or MB_APPLMODAL);
     end
    // Если над "Отмена"
    else if (Pt.X > VT.Width - 71 - D) and (Pt.X < VT.Width - 35 - D) and
      (Pt.Y > NRect.Bottom - 29) and
      (Pt.Y < NRect.Bottom - 16) then
    begin
      // Убиваем поток
      NodeData := VT.GetNodeData(Node);
      TerminateThread(NodeData^.PersonalThread, 1);
      NodeData^.PersonalThread := 0;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Отрисовка всплывающей подсказки.
//------------------------------------------------------------------------------
procedure TfrmMain.VTDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
  Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  NodeData: PItemNode;
  Th: Integer;
  ImgRect, RealRect, NameRect, PriceRect: TRect;
  Img: TPicture;
begin
  // Области отрисовки различных элементов
  Th := HintCanvas.TextHeight('Wj');
  RealRect := R;
  // Границы картинки
  ImgRect := RealRect;
  with ImgRect do
  begin
    Inc(Left, 16);
    Inc(Top, 8);
    Right := Left + 64;
    Bottom := Top + 64;
  end;
  // Границы текста наименования
  NameRect := RealRect;
  with NameRect do
  begin
    Inc(Left, 96);
    Inc(Top, 8);
    Bottom := Top + Th;
  end;
  // Границы текста общей цены
  PriceRect := RealRect;
  with PriceRect do
  begin
    Inc(Left, 96);
    Dec(Bottom, 16);
    Top := Bottom - Th;
  end;
  // Рисуем фон
  with HintCanvas do
  begin
    with Brush do
    begin
      Color := clInfoBk;
      Style := bsSolid;
    end;
    Pen.Color := clBlack;
    Pen.Width := 1;
    // Жёлтый фон и чёрная рамка по бокам
    Rectangle(RealRect);
  end;
  // Текст
  NodeData := Sender.GetNodeData(Node);
  with HintCanvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWindowText;
    // Наименование
    Font.Style := [fsBold];
    if NodeData^.Process = 0 then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (не доcтавлено)')
    else if (NodeData^.Process > 0) and (NodeData^.Process < 100) then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (доставляется)')
    else if NodeData^.Process = 100 then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (доставлено)');
    // Общая цена
    Font.Style := [];
    TextOut(PriceRect.Left, PriceRect.Top, 'Общая цена: ' + IntToStr(NodeData^.PriceKg * NodeData^.Mass) + ' р.');
  end;
  // Картинка
  Img := TPicture.Create;
  try
    Img.LoadFromFile(NodeData^.Image);
    HintCanvas.Draw(ImgRect.Left, ImgRect.Top, Img.Graphic);
    with HintCanvas, ImgRect do
    begin
      Pen.Width := 2;
      Pen.Color := $00B99D7F;
      Rectangle(Rect(ImgRect.Left, Top, Left + Img.Width, Top + Img.Height));
    end;
  finally
    FreeAndNil(Img);
  end;
  // Отображаем процесс выполнения
  with FProgress do
  begin
    Position := NodeData^.Process;
    Width := RealRect.Right - 96 - 16;
    PaintTo(HintCanvas, NameRect.Left, NameRect.Top + Th + Th div 2);
  end;
end;

//------------------------------------------------------------------------------
// Отрисовка узла.
//------------------------------------------------------------------------------
procedure TfrmMain.VTDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  NodeData: PItemNode;
  Th: Integer;
  ImgRect, RealRect, NameRect, GetRect, CancelRect, MassRect, PriceRect: TRect;
  Img: TPicture;
begin
  // Области отрисовки различных элементов
  Th := PaintInfo.Canvas.TextHeight('Wj');
  RealRect := PaintInfo.CellRect;
  ImgRect := RealRect;
  with ImgRect do
  begin
    Inc(Left, 16);
    Inc(Top, 16);
    Right := Left + 64;
    Bottom := Top + 64;
  end;
  NameRect := RealRect;
  with NameRect do
  begin
    Inc(Left, 96);
    Inc(Top, 16);
    Bottom := Top + Th;
  end;
  GetRect := RealRect;
  with GetRect do
  begin
    Dec(Bottom, 16 + Th);
    Top := Bottom - Th;
    Dec(Right, 16);
    Left := Right - PaintInfo.Canvas.TextWidth('Доставить');
  end;
  CancelRect := GetRect;
  with CancelRect do
  begin
    Inc(Top, Th);
    Inc(Bottom, Th);
  end;
  MassRect := RealRect;
  with MassRect do
  begin
    Inc(Left, 96);
    Dec(Bottom, 16 + Th);
    Top := Bottom - Th;
  end;
  PriceRect := MassRect;
  with PriceRect do
  begin
    Inc(Top, Th);
    Inc(Bottom, Th);
  end;
  // Рисуем фон
  with PaintInfo.Canvas do
  begin
    with Brush do
    begin
      Color := clWindow;
      Style := bsSolid;
    end;
    Pen.Color := $00B99D7F;
  end;
  if PaintInfo.Node = Sender.FocusedNode then
    GradFill(PaintInfo.Canvas.Handle, RealRect, $00EAE2D9, $00D7C8B7, gkVert)
  else
    PaintInfo.Canvas.FillRect(RealRect);
  // Текст
  NodeData := Sender.GetNodeData(PaintInfo.Node);
  with PaintInfo.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWindowText;
    // Наименование
    Font.Style := [fsBold];
    if NodeData^.Process = 0 then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (не доcтавлено)')
    else if (NodeData^.Process > 0) and (NodeData^.Process < 100) then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (доставляется)')
    else if NodeData^.Process = 100 then
      TextOut(NameRect.Left, NameRect.Top, NodeData^.Name + ' (доставлено)');
    // Масса
    Font.Style := [];
    TextOut(MassRect.Left, MassRect.Top, 'Масса: ' + IntToStr(NodeData^.Mass) + ' кг.');
    // Цена
    TextOut(PriceRect.Left, PriceRect.Top, 'Цена за килограмм: ' + IntToStr(NodeData^.PriceKg) + ' р.');
    // Доставить
    with Font do
    begin
      Style := [fsUnderline];
      Color := clBlue;
    end;
    TextOut(GetRect.Left, GetRect.Top, 'Доставить');
    // Отмена
    TextOut(CancelRect.Left, CancelRect.Top, 'Отмена');
  end;
  // Картинка
  Img := TPicture.Create;
  try
    Img.LoadFromFile(NodeData^.Image);
    PaintInfo.Canvas.Draw(ImgRect.Left, ImgRect.Top, Img.Graphic);
    if PaintInfo.Node = Sender.FocusedNode then
      with PaintInfo.Canvas, ImgRect do
      begin
        Pen.Width := 2;
        Rectangle(Rect(ImgRect.Left, Top, Left + Img.Width, Top + Img.Height));
      end;
  finally
    FreeAndNil(Img);
  end;
  // Процесс
  if PaintInfo.Node = Sender.FocusedNode then
    with FProgress do
    begin
      Position := NodeData^.Process;
      Width := RealRect.Right - 96 - 16;
      PaintTo(PaintInfo.Canvas, NameRect.Left, NameRect.Top + Th + Th div 2);
    end;
end;

//------------------------------------------------------------------------------
// Метод предназначен для отобрадения курсора руки над надписями "Доставить"
// и "Отмена", которые нарсованны в стиле ссылок.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetCursor(Sender: TBaseVirtualTree; var Cursor: TCursor);
var
  Pt: TPoint;
  Node: PVirtualNode;
  NRect: TRect;
  D: Integer;
  Inf: tagScrollInfo;
begin
  GetCursorPos(Pt);
  Pt := Sender.ScreenToClient(Pt);
  Node := Sender.GetNodeAt(Pt.X, Pt.Y);
  with Inf do
  begin
    cbSize := SizeOf(tagScrollInfo);
    fMask := SIF_RANGE;
  end;
  GetScrollInfo(Sender.Handle, SB_VERT, Inf);
  if (Inf.nMax > Sender.Height) then
    D := GetSystemMetrics(SM_CXHTHUMB)
  else
    D := 0;
  if Node <> nil then
  begin
    NRect := Sender.GetDisplayRect(Node, -1, False);
    if ((Pt.X > Sender.Width - 71 - D) and (Pt.X < Sender.Width - 16 - D) and
      (Pt.Y > NRect.Bottom - 42) and
      (Pt.Y < NRect.Bottom - 29))
      or
      ((Pt.X > Sender.Width - 71 - D) and (Pt.X < Sender.Width - 35 - D) and
      (Pt.Y > NRect.Bottom - 29) and
      (Pt.Y < NRect.Bottom - 16))
    then
      Cursor := crHandPoint
    else
      Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var R: TRect);
begin
  with R do
  begin
    Left := 0;
    Top := 0;
    Right := 250;
    Bottom := 80;
  end;
end;

//------------------------------------------------------------------------------
// Получение ширины узла. Если вы включили опцию toFullRowSelect, то
// в контексте данного примера это событие необязательно.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
var
  D: Integer;
  Inf: tagScrollInfo;
begin
  with Inf do
  begin
    cbSize := SizeOf(tagScrollInfo);
    fMask := SIF_RANGE;
  end;
  GetScrollInfo(Sender.Handle, SB_VERT, Inf);
  if (Inf.nMax > Sender.Height) then
    D := GetSystemMetrics(SM_CXHTHUMB)
  else
    D := 0;
  // Вычитаем из ширины дерева ширину вертикального скрола, отступа и края
  // дерева
  NodeWidth := Sender.Width - D - Integer(VT.Indent) - VT.Margin;
end;

end.
