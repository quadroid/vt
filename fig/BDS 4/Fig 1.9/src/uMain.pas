{
  Пример №10 - Взаимодействие с базами данных.
  Пример иллюстрирует обращение к базе данных, чтение записей,
  сортировку данных и их редактирование.
  Примечание: пример использует стандартную базу данных Delphi: "DBDEMOS".
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, VirtualTrees, ImgList, XPMan, DB, DBTables,
  StdCtrls;

type
  PDBRec = ^TDBRec;

  TDBRec = record
    ANum: Integer;
    AFirstName,
    ALastName: WideString;
    Initialized: Boolean; // True, если узел был заполнен начальными данными
  end;

  TfrmMain = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    BtnOpen: TToolButton;
    SpOpen: TToolButton;
    BtnClose: TToolButton;
    VT: TVirtualStringTree;
    ImageList: TImageList;
    Table: TTable;
    BtnCopy: TToolButton;
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure VTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    FUpdatingNum: Integer; // Здесь будем хранить изменившийся номер
                           // сотрудника.
    procedure LoadDB;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.BtnCloseClick(Sender: TObject);
begin
  VT.Clear;
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnOpenClick(Sender: TObject);
begin
  LoadDB;
end;

//------------------------------------------------------------------------------
// Подготавливает дерево и начинает заполнение.
//------------------------------------------------------------------------------
procedure TfrmMain.LoadDB;
begin
  if not Table.Active then
    Table.Open;
  with Table do
  begin
    Filtered := False;
    Filter := '';
    First;
  end;
  with VT do
  begin
    Clear;
    NodeDataSize := SizeOf(TDBRec);
    RootNodeCount := Table.RecordCount;
    Header.SortColumn := 0;
    // Для сортировки дерева рекомендуется передать последний параметр как
    // True, чтобы каждый отсортированный узел обновил свои данные.
    SortTree(0, sdAscending, True);
  end;
end;

//------------------------------------------------------------------------------
// Функции дерева.
//------------------------------------------------------------------------------
// Процедура сравнения двух узлов. Всё как обычно.
//------------------------------------------------------------------------------
procedure TfrmMain.VTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Rec1, Rec2: PDBRec;
begin
  with Sender do
  begin
    Rec1 := GetNodeData(Node1);
    Rec2 := GetNodeData(Node2);
  end;
  case Column of
    0:
    begin
      Result := 0;
      if Rec1.ANum > Rec2.ANum then
        Result := 1
      else
        Result := -1;
    end;
    1: Result := WideCompareText(Rec1.AFirstName, Rec2.AFirstName);
    2: Result := WideCompareText(Rec1.ALastName, Rec2.ALastName);
  end;
end;

//------------------------------------------------------------------------------
// Чистим память от строк.
//------------------------------------------------------------------------------
procedure TfrmMain.VTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  DBRec: PDBRec;
begin
  DBRec := Sender.GetNodeData(Node);
  if Assigned(DBRec) then
    Finalize(DBRec^);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  DBRec: PDBRec;
begin
  DBRec := Sender.GetNodeData(Node);
  case Column of
    0: CellText := IntToStr(DBRec.ANum);
    1: CellText := DBRec.AFirstName;
    2: CellText := DBRec.ALastName;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Sender.SortColumn <> Column then
      Sender.SortColumn := Column;
    if Sender.SortDirection = sdAscending then
      Sender.SortDirection := sdDescending
    else
      Sender.SortDirection := sdAscending;
    VT.SortTree(Sender.SortColumn, Sender.SortDirection, True);
  end;
end;

//------------------------------------------------------------------------------
// Основная процедура в этом примере. Её задача - заполнять каждый новый
// узел данными из таблицы. После считывания очередной запиcи из таблицы,
// мы перемещаемся на следующую методом Next, пока не закончится база данных.
// В сортировке этот метод необходим для обновления данных. Хотя, на самом
// деле, можно обойтись и без инициализации во время сортировки.
//------------------------------------------------------------------------------
procedure TfrmMain.VTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  DBRec: PDBRec;
begin
  DBRec := Sender.GetNodeData(Node);
  if not DBRec.Initialized then
  begin
    Initialize(DBRec^);
    with DBRec^ do
    begin
      ANum := StrToInt(Table.FieldByName('EmpNo').AsString);
      AFirstName := Table.FieldByName('FirstName').AsString;
      ALastName := Table.FieldByName('LastName').AsString;
      Initialized := True;
    end;
  end
  else begin
    // Запись уже была заполнена начальными данными при загрузке значений
    // таблицы. Значит, нужно просто обновить данные узла. После редактирования,
    // к примеру.
    with Table do
    begin
      Filtered := True;
      Filter := 'EmpNo = ' + #39 + IntToStr(FUpdatingNum) + #39;
      if RecordCount > 0 then
        with DBRec^ do
        begin
          ANum := StrToInt(Table.FieldByName('EmpNo').AsString);
          AFirstName := Table.FieldByName('FirstName').AsString;
          ALastName := Table.FieldByName('LastName').AsString;
        end;
    end;
  end;
  if not Table.Eof then
    Table.Next;
end;

//------------------------------------------------------------------------------
// Вносит изменения в базу данных.
//------------------------------------------------------------------------------
procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  DBRec: PDBRec;
begin
  if NewText = '' then
    Exit;
  DBRec := Sender.GetNodeData(Node);
  with Table do
  begin
    Filtered := True;
    // Включает фильтрацию и по индексу сотрудника находит необходимую
    // запись в таблице.
    Filter := 'EmpNo = ' + #39 + IntToStr(DBRec.ANum) + #39;
    if RecordCount > 0 then
    begin
      Table.Edit;
      try
        // Если запись найдена, то можно внести изменения
        case Column of
          0: Table.FieldByName('EmpNo').AsInteger := StrToIntDef(NewText, 0);
          1: Table.FieldByName('FirstName').AsString := NewText;
          2: Table.FieldByName('LastName').AsString := NewText;
        end;
        Table.Post;
        // Эта переменная нужна будет в событии инициализации узла.
        // С помошью неё будет выбрана изменившаяся запись путём фильтрации
        // и обновлены данные узла.
        // Необходимость в этой переменной состоит в том, что
        // в событии инициализации нельзя использовать фильтрацию по
        // DBRec.ANum, т.к. пользователь мог отредактировать первую колонку и
        // DBRec.ANum указывал бы на старый индекс записи, тогда как новый
        // содержался бы в NewText.
        if Column = 0 then
          FUpdatingNum := StrToIntDef(NewText, 0)
        else
          FUpdatingNum := StrToIntDef(VT.Text[Node, 0], 0);
        Sender.ReinitNode(Node, False);
      except
        // Ошибка...
      end;
    end
    else
      MessageBox(Self.Handle, 'Ошибка: Запись не найдена.',
        PChar(Application.Title), MB_OK or MB_ICONERROR or MB_APPLMODAL or
          MB_DEFBUTTON1);
  end;
end;

end.
