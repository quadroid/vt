{
  Пример № 2 - Углублённая работа с данными.
  Пример иллюстрирует различные сособы заполнения дерева узлами и
  отображение данных.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, XPMan, Menus;

type
  PPhoneNode = ^TPhoneNode;

  TPhoneNode = record
    Name, // Имя человека
    Phone: WideString; // Телефон
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    GbElement: TGroupBox;
    BtnAdd: TButton;
    BtnEdit: TButton;
    GbOther: TGroupBox;
    BtnInsertBefore: TButton;
    BtnInsertAfter: TButton;
    BtnChildFirst: TButton;
    BtnChildLast: TButton;
    LblName: TLabel;
    EdName: TEdit;
    LblPhone: TLabel;
    EdPhone: TEdit;
    BtnDelete: TButton;
    PopupMenu: TPopupMenu;
    mEntry: TMenuItem;
    mChildren: TMenuItem;
    LblCopy: TLabel;
    procedure BtnEditClick(Sender: TObject);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure mChildrenClick(Sender: TObject);
    procedure mEntryClick(Sender: TObject);
    procedure BtnChildLastClick(Sender: TObject);
    procedure BtnChildFirstClick(Sender: TObject);
    procedure BtnInsertAfterClick(Sender: TObject);
    procedure BtnInsertBeforeClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  VT.NodeDataSize := SizeOf(TPhoneNode);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnAddClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  NewPhone: PPhoneNode;
begin
  NewNode := VT.AddChild(VT.FocusedNode);
  NewPhone := VT.GetNodeData(NewNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnDeleteClick(Sender: TObject);
begin
  PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

//------------------------------------------------------------------------------
// Доступ к данным активной ветки.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnEditClick(Sender: TObject);
var
  NewPhone: PPhoneNode;
begin
  NewPhone := VT.GetNodeData(VT.FocusedNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------
// Удаляем весь узел.
//------------------------------------------------------------------------------
procedure TfrmMain.mEntryClick(Sender: TObject);
begin
  VT.DeleteNode(VT.FocusedNode);
end;

//------------------------------------------------------------------------------
// Удаляем только дочерние элементы узла.
//------------------------------------------------------------------------------
procedure TfrmMain.mChildrenClick(Sender: TObject);
begin
  VT.DeleteChildren(VT.FocusedNode);
end;

//------------------------------------------------------------------------------
// Вставляем новый элемент перед активным узлом.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnInsertBeforeClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  NewPhone: PPhoneNode;
begin
  NewNode := VT.InsertNode(VT.FocusedNode, amInsertBefore);
  NewPhone := VT.GetNodeData(NewNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------
// Вставляем новый элемент после активного узла.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnInsertAfterClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  NewPhone: PPhoneNode;
begin
  NewNode := VT.InsertNode(VT.FocusedNode, amInsertAfter);
  NewPhone := VT.GetNodeData(NewNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------
// Вставляем новый элемент первым дочерним элементом активного узла.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnChildFirstClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  NewPhone: PPhoneNode;
begin
  NewNode := VT.InsertNode(VT.FocusedNode, amAddChildFirst);
  NewPhone := VT.GetNodeData(NewNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------
// Вставляем новый элемент последним дочерним элементом активного узла.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnChildLastClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  NewPhone: PPhoneNode;
begin
  NewNode := VT.InsertNode(VT.FocusedNode, amAddChildLast);
  NewPhone := VT.GetNodeData(NewNode);
  if Assigned(NewPhone) then
    with NewPhone^ do
    begin
      Name := EdName.Text;
      Phone := EdPhone.Text;
    end;
end;

//------------------------------------------------------------------------------
// Функции дерева.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  PhoneNode: PPhoneNode;
begin
  PhoneNode := Sender.GetNodeData(Node);
  if Assigned(PhoneNode) then
    case Column of
      0: CellText := PhoneNode^.Name;
      1: CellText := PhoneNode^.Phone;
    end;
end;

end.
