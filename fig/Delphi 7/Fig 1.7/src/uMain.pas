{
  Пример № 8 - Обзор типа TVirtualNode.
  Пример иллюстрирует работу с типом TVirtualNode.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, XPMan, Menus, StdCtrls, ImgList;

type
  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    PopupMenu: TPopupMenu;
    mCheck: TMenuItem;
    mUncheck: TMenuItem;
    SpUncheck: TMenuItem;
    mDelete: TMenuItem;
    mAdd: TMenuItem;
    ImageList: TImageList;
    LblImages: TLabel;
    CBoxImages: TComboBox;
    CbThemes: TCheckBox;
    LblCopy: TLabel;
    BtnOptions: TButton;
    procedure VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VTStateChange(Sender: TBaseVirtualTree; Enter,
      Leave: TVirtualTreeStates);
    procedure BtnOptionsClick(Sender: TObject);
    procedure CBoxImagesChange(Sender: TObject);
    procedure CbThemesClick(Sender: TObject);
    procedure VTMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; var NodeHeight: Integer);
    procedure mDeleteClick(Sender: TObject);
    procedure mAddClick(Sender: TObject);
    procedure mUncheckClick(Sender: TObject);
    procedure mCheckClick(Sender: TObject);
    procedure VTChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VTInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var ChildCount: Cardinal);
    procedure VTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FormCreate(Sender: TObject);
  private
    // Последний узел, состояние отметки которого изменилось.
    // Нам нужно для показа PopupMenu над узлами с отметкой-кнопкой.
    FCheckingNode: PVirtualNode;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uNode;

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.BtnOptionsClick(Sender: TObject);
begin
  frmNode.Show;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CBoxImagesChange(Sender: TObject);
begin
  VT.CheckImageKind := TCheckImageKind(CBoxImages.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CbThemesClick(Sender: TObject);
begin
  if CbThemes.Checked then
    VT.TreeOptions.PaintOptions := VT.TreeOptions.PaintOptions + [toThemeAware]
  else
    VT.TreeOptions.PaintOptions := VT.TreeOptions.PaintOptions - [toThemeAware];
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  with VT do
  begin
    RootNodeCount := 6;
    ReinitNode(VT.RootNode, True);
  end;
end;

//------------------------------------------------------------------------------
// Добавляем ещё один рутовый узел.
//------------------------------------------------------------------------------
procedure TfrmMain.mAddClick(Sender: TObject);
var
  NewNode: PVirtualNode;
begin
  NewNode := VT.AddChild(nil);
  VT.ReinitNode(NewNode, True);
end;

//------------------------------------------------------------------------------
// Отметить все узлы.
//------------------------------------------------------------------------------
procedure TfrmMain.mCheckClick(Sender: TObject);

  procedure Check(const AParent: PVirtualNode);
  var
    NextNode: PVirtualNode;
  begin
    NextNode := AParent.FirstChild;
    if Assigned(NextNode) then
      repeat
        if not(NextNode.CheckType = ctRadioButton) then
          NextNode.CheckState := csCheckedNormal;
        Check(NextNode);
        NextNode := NextNode.NextSibling;
      until
        NextNode = nil;
  end;

begin
  Check(VT.RootNode);
end;

//------------------------------------------------------------------------------
// Удалить рутовый узел.
//------------------------------------------------------------------------------
procedure TfrmMain.mDeleteClick(Sender: TObject);
begin
  VT.DeleteNode(FCheckingNode);
end;

//------------------------------------------------------------------------------
// Снять отметку у всех узлов.
//------------------------------------------------------------------------------
procedure TfrmMain.mUncheckClick(Sender: TObject);

  procedure UnCheck(const AParent: PVirtualNode);
  var
    NextNode: PVirtualNode;
  begin
    NextNode := AParent.FirstChild;
    if Assigned(NextNode) then
      repeat
        if not(NextNode.CheckType = ctRadioButton) then
          NextNode.CheckState := csUnCheckedNormal;
        UnCheck(NextNode);
        NextNode := NextNode.NextSibling;
      until
        NextNode = nil;
  end;

begin
  UnCheck(VT.RootNode);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if Assigned(frmNode) then
    frmNode.UpdateStateDisplay;
end;

//------------------------------------------------------------------------------
// Состояние отметки узла было изменено.
// Если это рутовый узел с кнопкой, то пказать PopupMenu.
//------------------------------------------------------------------------------
procedure TfrmMain.VTChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Pt: TPoint;
begin
  if Node.CheckType = ctButton then
  begin
    FCheckingNode := Node;
    GetCursorPos(Pt);
    PopupMenu.Popup(Pt.X, Pt.Y);
  end;
end;

//------------------------------------------------------------------------------
// Устанавливаем различный текст в зависимости от типа отметки.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  case Node.CheckType of
    ctNone: CellText := 'Узел с отметкой ctNone';
    ctTriStateCheckBox: CellText := 'Узел с отметкой ctTriStateCheckBox';
    ctCheckBox: CellText := 'Узел с отметкой ctCheckBox';
    ctRadioButton: CellText := 'Узел с отметкой ctRadioButton';
    ctButton: CellText := 'Узел с отметкой ctButton';
  end;
end;

//------------------------------------------------------------------------------
// Добавляем по шесть дочерних узлов, пока не достигнем пятого уровня
// вложенности.
//------------------------------------------------------------------------------
procedure TfrmMain.VTInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var ChildCount: Cardinal);
begin
  if Sender.GetNodeLevel(Node) < 5 then
    ChildCount := 6
  else
    ChildCount := 0;
end;

//------------------------------------------------------------------------------
// Устанавливаем тип отметки в зависимости от уровня вложенности.
//------------------------------------------------------------------------------
procedure TfrmMain.VTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Lvl: Integer;
begin
  Lvl := Sender.GetNodeLevel(Node);
  if Lvl < 5 then
  begin
    InitialStates := InitialStates + [ivsHasChildren];
    case Lvl of
      0: Node.CheckType := ctButton;
      1: Node.CheckType := ctRadioButton;
      2: Node.CheckType := ctTriStateCheckBox;
      3: Node.CheckType := ctTriStateCheckBox;
      4: Node.CheckType := ctCheckBox;
      5: Node.CheckType := ctNone;
    end;
    if (Node.Index = 0) and (Node.CheckType = ctRadioButton) then
      Node.CheckState := csCheckedNormal;
  end;
end;

//------------------------------------------------------------------------------
// Различная высота для узлов.
//------------------------------------------------------------------------------
procedure TfrmMain.VTMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  case VT.GetNodeLevel(Node) of
    0: NodeHeight := 24;
    1: NodeHeight := 20;
    2: NodeHeight := 26;
    3: NodeHeight := 22;
    4: NodeHeight := 28;
    5: NodeHeight := 18;
  end;
  if vsMultiline in Node.States then
    NodeHeight := NodeHeight + 4 + VT.ComputeNodeHeight(TargetCanvas,
      Node, 0);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTStateChange(Sender: TBaseVirtualTree; Enter,
  Leave: TVirtualTreeStates);
begin
  if Assigned(frmNode) then
    frmNode.UpdateStateDisplay;
end;

end.
