{
  Пример № 4 - Принципы реализации Drag&Drop.
  Пример иллюстрирует реализацию полноценного Drag&Drop между VT
  и различными приложениями с поддержкой множетсва форматов данных.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, XPMan, ActiveX, ComCtrls, ActnList,
  ShlObj, ShellApi;

type
  PItemNode = ^TItemNode;

  TItemNode = record
    Name: WideString;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    VT2: TVirtualStringTree;
    RichEdit: TRichEdit;
    LblCopy: TLabel;
    ActionList: TActionList;
    actCopy: TAction;
    actCut: TAction;
    actPaste: TAction;
    ListBox: TListBox;
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure BtnPasteClick(Sender: TObject);
    procedure VTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormCreate(Sender: TObject);
    procedure BtnCutClick(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
  private
    procedure AddUnicodeText(DataObject: IDataObject;
      Target: TVirtualStringTree; Mode: TVTNodeAttachMode);
    procedure AddFile(DataObject: IDataObject;
      Target: TVirtualStringTree; Mode: TVTNodeAttachMode);
    procedure AddVCLText(Target: TVirtualStringTree;
      const Text: WideString; Mode: TVTNodeAttachMode);
    procedure InsertData(Sender: TVirtualStringTree;
      DataObject: IDataObject; Formats: TFormatArray;
      Effect: Integer; Mode: TVTNodeAttachMode);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * uMain.pas * * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
// Метод предназначен для обработки ЮНИКОД-текста, хранящегося в буфере обмена.
// Хранимый текст получается и разделяется на линии, которые затем вставляются
// в дерево в качестве новых узлов.
//------------------------------------------------------------------------------
procedure TfrmMain.AddUnicodeText(DataObject: IDataObject;
  Target: TVirtualStringTree; Mode: TVTNodeAttachMode);
var
  // Структура, которая будет запрашивать указатеь на глобальные данные
  FormatEtc: TFormatEtc;
  // Структура с данными
  Medium: TStgMedium;
  // Указатель на строку
  OLEData,
  // Для прохода цикла с целью разделения текста на строки
  Head, Tail: PWideChar;
  // Узел, получающий новую ветку
  TargetNode,
  // Новая ветка
  Node: PVirtualNode;
  // Её данные
  Data: PItemNode;
begin
  if Mode <> amNowhere then
  begin
    // Заполняем струкутру для получения ЮНИКОД-текста
    with FormatEtc do
    begin
      cfFormat := CF_UNICODETEXT;
      // Нет у нас никакого девайса...
      ptd := nil;
      // Нам нужно содержание (текст в данном случае)
      dwAspect := DVASPECT_CONTENT;
      // Нет страницы для мультистраничных данных
      lindex := -1;
      // Мы будем получать указатель на данные через глобальную память
      tymed := TYMED_HGLOBAL;
    end;
    // Есть ли ЮНИКОД-текст для нашего запроса?
    if DataObject.QueryGetData(FormatEtc) = S_OK then
    begin
      // Опа, есть, можем получить данные
      if DataObject.GetData(FormatEtc, Medium) = S_OK then
      begin
        // Вот они:
        OLEData := GlobalLock(Medium.hGlobal);
        if Assigned(OLEData) then
        begin
          Target.BeginUpdate;
          // Выбираем место для вставки, если переданное = nil
          TargetNode := Target.DropTargetNode;
          if TargetNode = nil then
            TargetNode := Target.FocusedNode;
          // Разбиваем текст на строки
          Head := OLEData;
          try
            while Head^ <> #0 do
            begin
              Tail := Head;
              while not (Tail^ in [WideChar(#0), WideChar(#13), WideChar(#10), WideChar(#9)]) do
                Inc(Tail);
              if Head <> Tail then
              begin
                // Добавляем новую ноду, если есть хотя бы один символ
                // для строки.
                Node := Target.InsertNode(TargetNode, Mode);
                Data := Target.GetNodeData(Node);
                Data^.Name := Head;
                SetLength(Data^.Name, (Tail - Head));
              end;
              // Пропускаем табы
              if Tail^ = #9 then
                Inc(Tail);
              // Символы переноса каретки и конца строки
              if Tail^ = #13 then
                Inc(Tail);
              if Tail^ = #10 then
                Inc(Tail);
              // Шагаем дальше
              Head := Tail;
            end;
          finally
            GlobalUnlock(Medium.hGlobal);
            Target.EndUpdate;
          end;
        end;
        // Вот это лучше не забывать делать
        ReleaseStgMedium(Medium);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Получение имён файлов, брошеных на нас из Explorer'a.
//------------------------------------------------------------------------------
procedure TfrmMain.AddFile(DataObject: IDataObject;
  Target: TVirtualStringTree; Mode: TVTNodeAttachMode);
var
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  OLEData: PDropFiles;
  Files: PChar;
  Str: String;
  TargetNode,
  Node: PVirtualNode;
  Data: PItemNode;
begin
  if Mode <> amNowhere then
  begin
    // На этот раз нас интересует есть ли в буфере CF_HDROP формат
    with FormatEtc do
    begin
      cfFormat := CF_HDROP;
      ptd := nil;
      dwAspect := DVASPECT_CONTENT;
      lindex := -1;
      tymed := TYMED_HGLOBAL;
    end;
    if DataObject.QueryGetData(FormatEtc) = S_OK then
    begin
      if DataObject.GetData(FormatEtc, Medium) = S_OK then
      begin
        OLEData := GlobalLock(Medium.hGlobal);
        if Assigned(OLEData) then
        begin
          Target.BeginUpdate;
          TargetNode := Target.DropTargetNode;
          if TargetNode = nil then
            TargetNode := Target.FocusedNode;
          try
            // А вот с этим я долго мучался. В Microsoft зажрались и не дали
            // примера работы с DROPFILES структурой.
            // Оказывается список брошенных файлов хранится в адресе структуры
            // + offset, который и есть OLEData^.pFiles.
            Files := PChar(OLEData) + OLEData^.pFiles;
            // Список оканчивается двойным null символом
            while Files^ <> #0 do
            begin
              if OLEData^.fWide then
              begin
                Str := PWideChar(Files);
                // +1 нужен для того, чтобы перешагнуть null символ одного
                // из имён файлов в списке
                Inc(Files, (Length(PWideChar(Files)) + 1)*SizeOf(WideChar));
              end
              else begin
                Str := Files;
                // Аналогично
                Inc(Files, (Length(PChar(Files)) + 1)*SizeOf(Char));
              end;
              Node := Target.InsertNode(TargetNode, Mode);
              Data := Target.GetNodeData(Node);
              Data^.Name := Str;
            end;
          finally
            GlobalUnlock(Medium.hGlobal);
            Target.EndUpdate;
          end;
        end;
        ReleaseStgMedium(Medium);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Метод для получения строки из VCL контролов.
// Режем на линии.
//------------------------------------------------------------------------------
procedure TfrmMain.AddVCLText(Target: TVirtualStringTree;
  const Text: WideString; Mode: TVTNodeAttachMode);
var
  Head, Tail: PWideChar;
  TargetNode,
  Node: PVirtualNode;
  Data: PItemNode;
begin
  if Mode <> amNoWhere then
  begin
    Target.BeginUpdate;
    try
      TargetNode := Target.DropTargetNode;
      if TargetNode = nil then
        TargetNode := Target.FocusedNode;
      Head := PWideChar(Text);
      while Head^ <> #0 do
      begin
        Tail := Head;
        while not (Tail^ in [WideChar(#0), WideChar(#13), WideChar(#10), WideChar(#9)]) do
          Inc(Tail);
        if Head <> Tail then
        begin
          Node := Target.InsertNode(TargetNode, Mode);
          Data := Target.GetNodeData(Node);
          SetString(Data^.Name, Head, Tail - Head);
        end;
        if Tail^ = #9 then
          Inc(Tail);
        if Tail^ = #13 then
          Inc(Tail);
        if Tail^ = #10 then
          Inc(Tail);
        Head := Tail;
      end;
    finally
      Target.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.InsertData(Sender: TVirtualStringTree;
  DataObject: IDataObject; Formats: TFormatArray;
  Effect: Integer; Mode: TVTNodeAttachMode);
var
  FormatAccepted: Boolean; // True, если принятые данные уже обработались
  i: Integer;
begin
  // Ищем в переданных форматах тот, который можем обработать
  FormatAccepted := False;
  for i := 0 to High(Formats) do
  begin
    case Formats[i] of
      CF_HDROP: // Прибыл список файлов из Explorer'a.
      begin
        if not FormatAccepted then
        begin
          AddFile(DataObject, Sender as TVirtualStringTree, Mode);
          FormatAccepted := True;
        end;
      end;
      CF_UNICODETEXT: // ЮНИКОД-текст
      begin
        if not FormatAccepted then
        begin
          AddUnicodeText(DataObject, Sender as TVirtualStringTree, Mode);
          FormatAccepted := True;
        end;
      end;
      else if Formats[i] = CF_VIRTUALTREE then
      // Родной формат VT. Обрабатывает вставку своих же
      // TVirtualNode-узлов.
      begin
        if not FormatAccepted then
        begin
          Sender.ProcessDrop(DataObject, Sender.DropTargetNode, Effect, Mode);
          FormatAccepted := True;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnCopyClick(Sender: TObject);
begin
  if ActiveControl = VT then
    VT.CopyToClipBoard
  else if ActiveControl = VT2 then
    VT2.CopyToClipBoard
  else if ActiveControl = RichEdit then
    RichEdit.CopyToClipboard;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnCutClick(Sender: TObject);
begin
  if ActiveControl = VT then
    VT.CutToClipBoard
  else if ActiveControl = VT2 then
    VT2.CutToClipBoard
  else if ActiveControl = RichEdit then
    RichEdit.CutToClipBoard;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnPasteClick(Sender: TObject);
var
  DataObject: IDataObject;
  EnumFormat: IEnumFormatEtc;
  Format: TFormatEtc;
  Formats: TFormatArray;
  Fetched: Integer;
  Tree: TVirtualStringTree;
begin
  if ActiveControl is TVirtualStringTree then
  begin
    Tree := ActiveControl as TVirtualStringTree;
    // Попробуем сначала вставить данные простым методом VT.
    if not Tree.PasteFromClipboard then
    begin
      // Если VT сам не смог справиться со вставкой, значит пришли данные
      // несколько другого типа, чем просто TVirtualNode узлы.
      // Это может быть, к примеру, текст или картинка.
      // Сейчас мы это узнаем, покопавшись в форматах буфера обмена.
      OLEGetClipboard(DataObject);
      // Получить список доступных в буфере обмена форматов в массив Formats.
      if Succeeded(DataObject.EnumFormatEtc(DATADIR_GET, EnumFormat)) then
      begin
        EnumFormat.Reset;
        while EnumFormat.Next(1, Format, @Fetched) = S_OK do
        begin
          SetLength(Formats, Length(Formats) + 1);
          Formats[High(Formats)] := Format.cfFormat;
        end;
        InsertData(Tree, DataObject, Formats, DROPEFFECT_COPY, Tree.DefaultPasteMode);
      end;
    end;
  end
  else if ActiveControl is TRichEdit then
    RichEdit.PasteFromClipboard;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  VT.NodeDataSize := SizeOf(TItemNode);
  VT2.NodeDataSize := SizeOf(TItemNode);
  VT.RootNodeCount := 30;
  VT2.RootNodeCount := 30;
  RichEdit.Lines.LoadFromFile('rtf.rtf');
  for i := 0 to 9 do
    ListBox.Items.Add(Format('String %d', [i]));
end;

//------------------------------------------------------------------------------
// Функции дерева.
//------------------------------------------------------------------------------
procedure TfrmMain.VTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer; Mode: TDropMode);

  // Определяем как поступать с данными. Перемещать, копировать или ссылаться
  procedure DetermineEffect;
  begin
    // Нажаты ли какие-нибудь управляющие клавиши?
    if Shift = [] then
    begin
      // Неа, не нажаты
      // Тогда, если отправитель и получатель - одинаковые объекты (например,
      // если узлы перемещаются из одного и того же дерева), то
      // надо переместить узлы, в противном случае - копировать.
      if Source = Sender then
        Effect := DROPEFFECT_MOVE
      else
        Effect := DROPEFFECT_COPY;
    end
    else begin
      // Нажаты. В зависмости от комбинации решаем что делать
      if (Shift = [ssAlt]) or (Shift = [ssCtrl, ssAlt]) then
        Effect := DROPEFFECT_LINK
      else
        if Shift = [ssCtrl] then
          Effect := DROPEFFECT_COPY
        else
          Effect := DROPEFFECT_MOVE;
    end;
  end;

var
  Attachmode: TVTNodeAttachMode;
  Nodes: TNodeArray;
  i: Integer;
begin
  Nodes := nil;
  // Определяем куда добавлять узел в зависимости от того, куда была
  // брошена ветка.
  case Mode of
    dmAbove:
      AttachMode := amInsertBefore;
    dmOnNode:
      AttachMode := amAddChildLast;
    dmBelow:
      AttachMode := amInsertAfter;
  else
    AttachMode := amNowhere;
  end;
  if DataObject = nil then
  begin
    // Если не пришло интерфейса, то вставка проходит через VCL метод
    if Source is TVirtualStringTree then
    begin
      // Вставка из VT. Можем спокойно пользоваться его методами
      // копирования и перемещения.
      DetermineEffect;
      // Получем список узлов, которые будут участвовать в Drag&Drop
      Nodes := VT2.GetSortedSelection(True);
      // И работаем с каждым
      if Effect = DROPEFFECT_COPY then
      begin
        for i := 0 to High(Nodes) do
          VT2.CopyTo(Nodes[i], Sender.DropTargetNode, AttachMode, False);
      end
      else
        for i := 0 to High(Nodes) do
          VT2.MoveTo(Nodes[i], Sender.DropTargetNode, AttachMode, False);
    end
    else if Source is TListBox then
    begin
      // Вставка из объекта какого-то другого класса
      AddVCLText(Sender as TVirtualStringTree,
        (Source as TListBox).Items.Strings[(Source as TListBox).ItemIndex],
        AttachMode);
    end;
  end
  else begin
    // OLE drag&drop.
    // Effect нужен для передачи его источнику drag&drop, чтобы тот решил
    // что он будет делать со своими перетаскиваемыми данными.
    // Например, при DROPEFFECT_MOVE (перемещение) их нужно будет удалить,
    // при копировании - сохранить.
    if Source is TBaseVirtualTree then
      DetermineEffect
    else begin
      if Boolean(Effect and DROPEFFECT_COPY) then
        Effect := DROPEFFECT_COPY
      else
        Effect := DROPEFFECT_MOVE;
    end;
    InsertData(Sender as TVirtualStringTree, DataObject, Formats, Effect, AttachMode);
  end;
end;

//------------------------------------------------------------------------------
// В этом событии мы должны проверить есть ли среди перетаскиваемых веток
// родитель ветки, в которую происходит перетаскивание. Ведь нельзя
// же ветку-родитель перетащить в её дочерние элементы :).
//------------------------------------------------------------------------------
procedure TfrmMain.VTDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
  var Effect: Integer; var Accept: Boolean);

  // Возвращает True, если AParent - дочерний узел ANode.
  function IsNodeParent(AParent, ANode: PVirtualNode): Boolean;
  var
    NextParent: PVirtualNode;
  begin
    NextParent := AParent;
    repeat
      NextParent := NextParent.Parent;
    until
      (NextParent = Sender.RootNode) or (NextParent = nil) or
        (NextParent = ANode);
    Result := ANode = NextParent;
  end;

var
  i: Integer;
  Nodes: TNodeArray;
begin
  Accept := True;
  SetLength(Nodes, 0);
  if (Assigned(Sender.DropTargetNode)) and
    (Sender.DropTargetNode <> Sender.RootNode) then
    Nodes := (Sender as TVirtualStringTree).GetSortedSelection(True);
  if Length(Nodes) > 0 then
  begin
    for i := 0 to Length(Nodes) - 1 do
    begin
      Accept :=
        // Узел не должен быть родителем ветки, в которую производится вставка
        (not IsNodeParent(Sender.DropTargetNode, Nodes[i]))
        // Также, узел не должен равняться ветке-местоназначению вставки.
        // Т.е. мы должны запретить вставку узла в самого себя.
        and (not(Sender.DropTargetNode = Nodes[i]));
      // Отключаем вставку, если хотя бы одно из условий вернуло False
      if not Accept then
        Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  ItemNode: PItemNode;
begin
  ItemNode := Sender.GetNodeData(Node);
  if Assigned(ItemNode) then
    CellText := ItemNode^.Name;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  ItemNode: PItemNode;
begin
  ItemNode := Sender.GetNodeData(Node);
  if Assigned(ItemNode) then
    if Length(ItemNode^.Name) = 0 then
      ItemNode^.Name := 'Node Index № ' + IntToStr(Node.Index);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  ItemNode: PItemNode;
begin
  ItemNode := Sender.GetNodeData(Node);
  if Assigned(ItemNode) then
    ItemNode^.Name := NewText;
end;

end.
