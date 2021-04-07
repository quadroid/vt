{
  Пример № 5 - Создание собственных редакторов данных.
  Пример иллюстрирует создание и использование различных типов
  редактооров данных для дерева в соответствии с типом данных.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, VirtualTrees, ExtCtrls, Mask, ComCtrls;

type
  TVTEditorKind = (
    ekString, // TEdit
    ekMemo, // TMemo
    ekComboBox, // TComboBox
    ekColor, // TColorBox
    ekDate, // TDateTimePicker
    ekMask, // TMaskedEdit
    ekProgress // TProgressBar
  );

  PVTEditNode = ^TVTEditNode;

  TVTEditNode = record
    Kind: TVTEditorKind;
    Value: String;
    Changed: Boolean;
  end;

  // Наш класс, реализующий интерфейс IVTEditLink.
  // Он будет базовым для всех типов редакторов. Тип создаваемого редактора
  // для каждого узла будет определять по значению поля Kind у записи данных
  // узла (TVTEditNode).
  // Этот вариант более рационален, так как не придётся для каждого типа данных
  // создавать разные классы, релаизующие один и тот же интерфейс по почти
  // идентичной схеме.
  TVTCustomEditor = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // Базовый класс для каждого типа редактора
    FTree: TVirtualStringTree; // Ссылка на дерево, вызвавшее редактирование
    FNode: PVirtualNode;       // Редактируемый узел
    FColumn: Integer;          // Его колонка, в которой оно происходит
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;

    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    LblCopy: TLabel;
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VTPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VTCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure VTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ValueTypes: array[0..6] of TVTEditorKind = (
    ekString, // Имя
    ekMemo, // Описание
    ekComboBox, // Тип
    ekColor, // Цвет
    ekDate, // Дата
    ekMask, // Маска
    ekProgress // Процесс
  );
  // Значения по умолчанию
  DefaultValues: array[0..6] of String = (
    'Свитер',
    'Мягкий и тёплый.',
    'Шерсть',
    'clRed',
    '24.06.2006',
    '798-77-66',
    '70 %'
  );
  // Имена параметров
  ValueNames: array[0..6] of String = (
    'Имя изделия',
    'Комментарий',
    'Материал',
    'Цвет изделия',
    'Дата изготовления',
    'Телефон склада',
    'Процесс доставки'
  );

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * TVTCustomEditor * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
destructor TVTCustomEditor.Destroy;
begin
  FreeAndNil(FEdit);
  inherited;
end;

//------------------------------------------------------------------------------
// Для обработки нажатий с клавиатуры.
// Отмена редактироваеия по Escape, завершение редактирования по Enter,
// и переход между узлами по Up/Down, если список элементов у комбо бокса или
// редактора даты не выпущен.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanContinue: Boolean;
begin
  CanContinue := True;
  case Key of
    VK_ESCAPE: // Нажали Escape
      if CanContinue then
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN: // Нажали Enter
      if CanContinue then
      begin
        // Если Ctrl для TMemo не зажат, то завершаем редактирование
        // Сдеалем так, чтобы можно было по Ctrl+Enter вставлять в Memo
        // новую линию.
        if (FEdit is TMemo) and (Shift = []) then
          FTree.EndEditNode
        else if not(FEdit is TMemo) then
          FTree.EndEditNode;
        Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        // Проверить, не идёт ли работа с редактором. Если идёт, то запретить
        // активность дерева, если нет, то передать нажатие дереву.
        CanContinue := Shift = [];
        if FEdit is TComboBox then
          CanContinue := CanContinue and not TComboBox(FEdit).DroppedDown;
        if FEdit is TDateTimePicker then
          CanContinue :=  CanContinue and not TDateTimePicker(FEdit).DroppedDown;
        if CanContinue then
        begin
          // Передача клавиши дереву
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

//------------------------------------------------------------------------------
// Началось редактирование, нужно показать редактор и установить ему фокус.
//------------------------------------------------------------------------------
function TVTCustomEditor.BeginEdit: Boolean;
begin
  Result := True;
  with FEdit do
  begin
    Show;
    SetFocus;
  end;
end;

//------------------------------------------------------------------------------
// Отменилось, прячем редактор.
//------------------------------------------------------------------------------
function TVTCustomEditor.CancelEdit: Boolean;
 begin
  Result := True;
  FEdit.Hide;
end;

//------------------------------------------------------------------------------
// Успешно завершилось, прячем редактор, обновляем данные узла и возвращаем
// фокус дереву.
//------------------------------------------------------------------------------
function TVTCustomEditor.EndEdit: Boolean;
var
  Txt: String;
begin
  Result := True;
  if FEdit is TEdit then
    Txt := TEdit(FEdit).Text
  else if FEdit is TMemo then
    Txt := TEdit(FEdit).Text
  else if FEdit is TComboBox then
    Txt := TComboBox(FEdit).Text
  else if FEdit is TColorBox then
    Txt := ColorToString(TColorBox(FEdit).Selected)
  else if FEdit is TDateTimePicker then
  begin
    Txt := DateToStr(TDateTimePicker(FEdit).DateTime);
  end
  else if FEdit is TMaskEdit then
    Txt := TMaskEdit(FEdit).Text
  else if FEdit is TProgressBar then
    Txt := IntToStr(TProgressBar(FEdit).Position) + ' %';
  // Изменяем текст узла (поле Value у TVTEditNode) через событие OnNewText
  // у дерева
  FTree.Text[FNode, FColumn] := Txt;
  FEdit.Hide;
  FTree.SetFocus;
end;

//------------------------------------------------------------------------------
// Возвращаем границы редактора.
//------------------------------------------------------------------------------
function TVTCustomEditor.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

//------------------------------------------------------------------------------
// В подготовке к редактированию мы должны создать экземпляр TWinControl
// нужного класса потомка в соответствии с полем Kind у TVTEditNode.
//------------------------------------------------------------------------------
function TVTCustomEditor.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex): Boolean;
var
  VTEditNode: PVTEditNode;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FreeAndNil(FEdit);
  VTEditNode := FTree.GetNodeData(Node);
  case VTEditNode.Kind of
    ekString:
    begin
      FEdit := TEdit.Create(nil);
      with FEdit as TEdit do
      begin
        AutoSize := False;
        Visible := False;
        Parent := Tree;
        Text := VTEditNode.Value;
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekMemo:
    begin
      FEdit := TMemo.Create(nil);
      with FEdit as TMemo do
      begin
        Visible := False;
        Parent := Tree;
        ScrollBars := ssVertical;
        Text := VTEditNode.Value;
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekComboBox:
    begin
      FEdit := TComboBox.Create(nil);
      with FEdit as TComboBox do
      begin
        Visible := False;
        Parent := Tree;
        Text := VTEditNode.Value;
        Items.Add('Шерсть');
        Items.Add('Хлопок');
        Items.Add('Шёлк');
        Items.Add('Кожа');
        Items.Add('Велюр');
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekColor:
    begin
      FEdit := TColorBox.Create(nil);
      with FEdit as TColorBox do
      begin
        Visible := False;
        Parent := Tree;
        Selected := StringToColor(VTEditNode.Value);
        Style := Style + [cbPrettyNames];
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekMask:
    begin
      FEdit := TMaskEdit.Create(nil);
      with FEdit as TMaskEdit do
      begin
        AutoSize := False;
        Visible := False;
        Parent := Tree;
        EditMask := '999-99-99';
        Text := VTEditNode.Value;
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekDate:
    begin
      FEdit := TDateTimePicker.Create(nil);
      with FEdit as TDateTimePicker do
      begin
        Visible := False;
        Parent := Tree;
        Date := StrToDate(VTEditNode.Value);
        OnKeyDown := EditKeyDown;
      end;
    end;
    ekProgress:
    begin
      FEdit := TProgressBar.Create(nil);
      with FEdit as TProgressBar do
      begin
        Visible := False;
        Parent := Tree;
        Position := StrToIntDef(VTEditNode.Value, 70);
      end;
    end
  else
    Result := False;
  end;
end;

//------------------------------------------------------------------------------
// Обработка сообщений Windows для редактора.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

//------------------------------------------------------------------------------
// Устанавливает границы редактора в соответствии с шириной и высотой колонки.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
  if FEdit is TMemo then
    FEdit.Height := 80;
end;

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  NewNode: PVirtualNode;
  VTEditNode: PVTEditNode;
begin
  VT.NodeDataSize := SizeOf(TVTEditNode);
  for i := 0 to 6 do
  begin
    NewNode := VT.AddChild(nil);
    VTEditNode := VT.GetNodeData(NewNode);
    with VTEditNode^ do
    begin
      Kind := ValueTypes[i];
      Value := DefaultValues[i];
      Changed := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with Sender do
  begin
    if Assigned(Node) then
    begin
      // Убираем паузу перед редактированием узла. Что бы ни случилось с узлом,
      // (кликнули, выделили) сразу начётся редактирование колонки.
      VT.EditNode(Node, 1);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TVTCustomEditor.Create;
end;

//------------------------------------------------------------------------------
// Разрешаем редактировать только второую колонку.
//------------------------------------------------------------------------------
procedure TfrmMain.VTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column > 0;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  VTEditNode: PVTEditNode;
begin
  case Column of
    0: CellText := ValueNames[Node.Index];
    1:
    begin
      VTEditNode := Sender.GetNodeData(Node);
      CellText := VTEditNode^.Value;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Обновляем виртуальные данные после редактирования.
//------------------------------------------------------------------------------
procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  VTEditNode: PVTEditNode;
begin
  VTEditNode := Sender.GetNodeData(Node);
  with VTEditNode^ do
  begin
    if not Changed then
      Changed := Value <> NewText;
    Value := StringReplace(NewText, #13#10, ' ', [rfReplaceAll]);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  VTEditNode: PVTEditNode;
begin
  VTEditNode := Sender.GetNodeData(Node);
  if VTEditNode.Changed then
    TargetCanvas.Font.Style := [fsBold]
  else
    TargetCanvas.Font.Style := [];
end;

end.
