{
  Пример № 3 - Обзор основных событий компонента.
  Пример иллюстрирует заполнение дерева узлами и отображение данных,
  а также использование различных методов дерева для работы с текстом
  и отрисовкой узлов.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, VirtualTrees, Menus, XPMan, ImgList,
  Math;

type
  TGradientKind = (gkHorz, gkVert);

  PPhoneNode = ^TPhoneNode;

  TPhoneNode = record
    Name, Mobile, HomePhone: WideString;
    Enabled, Editable: Boolean;
    ImageIndex: Integer;
    Fg, Bg: TColor;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    LblSearch: TLabel;
    Pages: TPageControl;
    EdSearch: TEdit;
    RbName: TRadioButton;
    RbPhone: TRadioButton;
    LblManagement: TLabel;
    BvlManagement: TBevel;
    BvlSearch: TBevel;
    TabElem: TTabSheet;
    TabDisplay: TTabSheet;
    PopupMenu: TPopupMenu;
    LblName: TLabel;
    LblHome: TLabel;
    LblMobile: TLabel;
    EdName: TEdit;
    EdMobile: TEdit;
    EdHome: TEdit;
    BtnAdd: TButton;
    LblElemProps: TLabel;
    RbEnabled: TRadioButton;
    RbDisabled: TRadioButton;
    CbEditable: TCheckBox;
    Label5: TLabel;
    LblText: TLabel;
    CBoxText: TColorBox;
    CBoxBg: TColorBox;
    LblBg: TLabel;
    CBoxImage: TComboBoxEx;
    BvlElemProps: TBevel;
    mAdd: TMenuItem;
    SpAdd: TMenuItem;
    mDelete: TMenuItem;
    BtnEdit: TButton;
    BtnFind: TButton;
    ImageList: TImageList;
    ImageListHot: TImageList;
    ImageListDisabled: TImageList;
    ImageListColumn: TImageList;
    PopupMenuColumn: TPopupMenu;
    mNameColumn: TMenuItem;
    mPhoneColumn: TMenuItem;
    CbVSStyle: TCheckBox;
    LblCopy: TLabel;
    procedure CbVSStyleClick(Sender: TObject);
    procedure VTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VTIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode;
      const SearchText: WideString; var Result: Integer);
    procedure mPhoneColumnClick(Sender: TObject);
    procedure mNameColumnClick(Sender: TObject);
    procedure VTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure mDeleteClick(Sender: TObject);
    procedure mAddClick(Sender: TObject);
    procedure VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VTPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VTBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure VTGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer; var ImageList: TCustomImageList);
    procedure FormCreate(Sender: TObject);
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnFindClick(Sender: TObject);
  private
    procedure LoadNode(ANode: PVirtualNode);
  public
    { Public declarations }
  end;

  procedure GradFill(DC: HDC; ARect: TRect; ClrTopLeft, ClrBottomRight: TColor;
    Kind: TGradientKind);

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * uMain.pas * * * * * * * * * * * * * * * * * }
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
// Получение данных из ветки.
//------------------------------------------------------------------------------
procedure TfrmMain.LoadNode(ANode: PVirtualNode);
var
  PhoneNode: PPhoneNode;
begin
  if Assigned(ANode) then
  begin
    PhoneNode := VT.GetNodeData(ANode);
    with PhoneNode^ do
    begin
      EdName.Text := Name;
      EdMobile.Text := Mobile;
      EdHome.Text := HomePhone;
      case Enabled of
        True: RbEnabled.Checked := True;
        False: RbDisabled.Checked := True;
      end;
      CbEditable.Checked := Editable;
      CBoxImage.ItemIndex := ImageIndex;
      CBoxText.Selected := Fg;
      CBoxBg.Selected := Bg;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Добавление нового пустого узла.
//------------------------------------------------------------------------------
procedure TfrmMain.mAddClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  PhoneNode: PPhoneNode;
begin
  NewNode := VT.AddChild(VT.FocusedNode);
  PhoneNode := VT.GetNodeData(NewNode);
  if Assigned(PhoneNode) then
    with PhoneNode^ do
    begin
      Name := 'Без имени';
      Mobile := '';
      HomePhone := '';
      Enabled := True;
      Editable := True;
      ImageIndex := 0;
      Fg := clWindowText;
      Bg := clWindow;
    end;
end;

//------------------------------------------------------------------------------
// Удаленеие всех выделенных веток.
//------------------------------------------------------------------------------
procedure TfrmMain.mDeleteClick(Sender: TObject);
begin
  VT.DeleteSelectedNodes;
end;

//------------------------------------------------------------------------------
// Скрытие/отображение колонок.
//------------------------------------------------------------------------------
procedure TfrmMain.mNameColumnClick(Sender: TObject);
begin
  if mNameColumn.Checked then
    VT.Header.Columns[0].Options := VT.Header.Columns[0].Options + [coVisible]
  else
    VT.Header.Columns[0].Options := VT.Header.Columns[0].Options - [coVisible];
end;

//------------------------------------------------------------------------------

procedure TfrmMain.mPhoneColumnClick(Sender: TObject);
begin
  if mPhoneColumn.Checked then
    VT.Header.Columns[1].Options := VT.Header.Columns[1].Options + [coVisible]
  else
    VT.Header.Columns[1].Options := VT.Header.Columns[1].Options - [coVisible];
end;

//------------------------------------------------------------------------------
// Добавление нового узла и заполнение данными.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnAddClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  PhoneNode: PPhoneNode;
begin
  NewNode := VT.AddChild(VT.FocusedNode);
  PhoneNode := VT.GetNodeData(NewNode);
  if Assigned(PhoneNode) then
    with PhoneNode^ do
    begin
      Name := EdName.Text;
      Mobile := EdMobile.Text;
      HomePhone := EdHome.Text;
      Enabled := RbEnabled.Checked;
      Editable := CbEditable.Checked;
      ImageIndex := CBoxImage.ItemIndex;
      Fg := CBoxText.Selected;
      Bg := CBoxBg.Selected
    end;
end;

//------------------------------------------------------------------------------
// Редактирвоание данных.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnEditClick(Sender: TObject);
var
  PhoneNode: PPhoneNode;
begin
  PhoneNode := VT.GetNodeData(VT.FocusedNode);
  if Assigned(PhoneNode) then
    with PhoneNode^ do
    begin
      Name := EdName.Text;
      Mobile := EdMobile.Text;
      HomePhone := EdHome.Text;
      Enabled := RbEnabled.Checked;
      Editable := CbEditable.Checked;
      ImageIndex := CBoxImage.ItemIndex;
      Fg := CBoxText.Selected;
      Bg := CBoxBg.Selected;
      VT.Invalidate;
    end;
end;

//------------------------------------------------------------------------------
// Рекурсивный перебор всех элементов и сравнение текстовых переменных.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnFindClick(Sender: TObject);

  function FindNode(ANode: PVirtualNode;
    const APattern: WideString): PVirtualNode;
  var
    NextNode: PVirtualNode;
    PhoneNode: PPhoneNode;
  begin
    Result := nil;
    NextNode := ANode.FirstChild;
    if Assigned(NextNode) then
      repeat
        PhoneNode := VT.GetNodeData(NextNode);
        if Assigned(PhoneNode) then
          if RbName.Checked then
            if PhoneNode^.Name = APattern then
            begin
              Result := NextNode;
              Exit;
            end
            else
          else
            if PhoneNode^.Mobile = APattern then
            begin
              Result := NextNode;
              Exit;
            end;
        // Ищем в дочерних ветках
        Result := FindNode(NextNode, APattern);
        // Переходим на соседнюю ветку...
        NextNode := NextNode.NextSibling;
      until
        //...пока не вмажемся лбом в стену :)
        NextNode = nil;
  end;

var
  FoundNode: PVirtualNode;
begin
  if VT.RootNodeCount > 0 then
  begin
    FoundNode := FindNode(VT.RootNode, EdSearch.Text);
    LoadNode(FoundNode);
    if Assigned(FoundNode) then
    begin
      VT.ClearSelection;
      VT.FocusedNode := FoundNode;
      Include(VT.FocusedNode.States, vsSelected);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CbVSStyleClick(Sender: TObject);
begin
  VT.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  VT.NodeDataSize := SizeOf(TPhoneNode);
end;

//------------------------------------------------------------------------------
// Методы дерева.
//------------------------------------------------------------------------------
// Заливка фона.
//------------------------------------------------------------------------------
procedure TfrmMain.VTBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  PhoneNode: PPhoneNode;
  BigGrad, SmallGrad: TRect;
begin
  if not CbVSStyle.Checked then
  begin
    PhoneNode := VT.GetNodeData(Node);
    if Assigned(PhoneNode) then
      with TargetCanvas do
      begin
        Brush.Color := PhoneNode^.Bg;
        FillRect(CellRect);
      end;
  end
  else if Column = 0 then
  begin
    // Рисуем фон градиентный фон в стиле заголовка Студии
    BigGrad := CellRect;
    Dec(BigGrad.Bottom, 2);
    SmallGrad := BigGrad;
    SmallGrad.Top := SmallGrad.Bottom;
    Inc(SmallGrad.Bottom, 2);
    GradFill(TargetCanvas.Handle, BigGrad, clInactiveCaptionText, clWindow, gkHorz);
    GradFill(TargetCanvas.Handle, SmallGrad, clHighlight, clWindow, gkHorz);
  end;
end;

//------------------------------------------------------------------------------
// Что-то произошло. Что бы то ни было, лучше контроллы обновить...
//------------------------------------------------------------------------------
procedure TfrmMain.VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  LoadNode(Node);
end;

//------------------------------------------------------------------------------
// Похоже на callback функцию, как в WinAPI.
// Сравнение двух узлов во время сортировки по алфавитному критерию.
//------------------------------------------------------------------------------
procedure TfrmMain.VTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
begin
  Result := WideCompareStr(VT.Text[Node1, Column], VT.Text[Node2, Column]);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
var
  PhoneNode: PPhoneNode;
begin
  Allowed := False;
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
    Allowed := PhoneNode^.Editable;
end;

//------------------------------------------------------------------------------
// Получаем индекс картинки для узла и выбираем в каком состоянии его надо
// нарисовать:
// - Нормальном;
// - Активном;
// - Выключенном.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer;
  var ImageList: TCustomImageList);
var
  PhoneNode: PPhoneNode;
begin
  if Column > 0 then
    Exit;
  ImageIndex := -1;
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
  begin
    ImageList := Self.ImageList;
    if Node = Sender.HotNode then
      ImageList := ImageListHot;
    if not PhoneNode^.Enabled then
      ImageList := ImageListDisabled;
    ImageIndex := PhoneNode^.ImageIndex;
  end;
end;

//------------------------------------------------------------------------------
// Получаем текст: статический и обычный.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  PhoneNode: PPhoneNode;
begin
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
    case Column of
      0:
        if TextType = ttNormal then
          CellText := PhoneNode^.Name;
      1:
      case TextType of
        ttNormal: CellText := PhoneNode^.Mobile;
        ttStatic: CellText := '(' + PhoneNode^.HomePhone + ')';
      end;
    end;
end;

//------------------------------------------------------------------------------
// Изменяем порядок сортировки у кликнутой колонки и пересортировываем дерево.
//------------------------------------------------------------------------------
procedure TfrmMain.VTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Column = 2 then
  begin
    PopupMenuColumn.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    Exit;
  end;
  if Button = mbLeft then
  begin
    VT.Header.SortColumn := Column;
    if VT.Header.SortDirection = sdAscending then
    begin
      VT.Header.SortDirection := sdDescending;
      VT.SortTree(Column, VT.Header.SortDirection);
    end
    else begin
      VT.Header.SortDirection := sdAscending;
      VT.SortTree(Column, VT.Header.SortDirection);
    end;
  end;
end;

//------------------------------------------------------------------------------
// Поиск по инкременту.
// Сравниваем две строки до длины наименьшей.
//------------------------------------------------------------------------------
procedure TfrmMain.VTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  PhoneNode: PPhoneNode;
begin
  Result := 0;
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
  begin
    Result := StrLIComp(PAnsiChar(AnsiString(SearchText)),
      PAnsiChar(AnsiString(PhoneNode^.Name)),
       Min(Length(SearchText), Length(PhoneNode^.Name)));
  end;
end;

//------------------------------------------------------------------------------
// Юзер подредактировал текст.
// Обновляем данные, которые за этот текст отвечали.
//------------------------------------------------------------------------------
procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  PhoneNode: PPhoneNode;
begin
  if Length(NewText) = 0 then
    Exit;
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
  begin
    case Column of
      0: PhoneNode^.Name := NewText;
      1: PhoneNode^.Mobile := NewText;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Устанавливаем цвет текста.
// Если узел является выделенным и дерево при этом имеет фокус, то нарисовать
// подсвеченный текст.
//------------------------------------------------------------------------------
procedure TfrmMain.VTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  PhoneNode: PPhoneNode;
begin
  PhoneNode := VT.GetNodeData(Node);
  if Assigned(PhoneNode) then
    TargetCanvas.Font.Color := PhoneNode^.Fg;
  if (vsSelected in Node.States) and (Sender.Focused) then
    TargetCanvas.Font.Color := clHighlightText;
end;

end.
