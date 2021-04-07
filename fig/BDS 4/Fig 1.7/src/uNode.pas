unit uNode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees;

type
  TfrmNode = class(TForm)
    LblIndex: TLabel;
    EdIndex: TEdit;
    LblChildCount: TLabel;
    EdChildCount: TEdit;
    EdNodeHeight: TEdit;
    LblNodeHeight: TLabel;
    GbStates: TGroupBox;
    CbInitialized: TCheckBox;
    CbChecking: TCheckBox;
    EdName: TEdit;
    CbClipboard: TCheckBox;
    CbDisabled: TCheckBox;
    CbDeleting: TCheckBox;
    CbExpanded: TCheckBox;
    GbCheck: TGroupBox;
    CbHasChildren: TCheckBox;
    CbVisible: TCheckBox;
    BtnShowAll: TButton;
    CbSelected: TCheckBox;
    CbAllHidden: TCheckBox;
    CbClearing: TCheckBox;
    CbMultiline: TCheckBox;
    CbHeightMeasured: TCheckBox;
    CbToggling: TCheckBox;
    RbUnCheckedNormal: TRadioButton;
    RbUnCheckedPressed: TRadioButton;
    RbCheckedPressed: TRadioButton;
    RbCheckedNormal: TRadioButton;
    RbMixedPressed: TRadioButton;
    RbMixedNormal: TRadioButton;
    LblName: TLabel;
    EdAlign: TEdit;
    LblAlign: TLabel;
    EdTotalCount: TEdit;
    EdTotalHeight: TEdit;
    LblTotalCount: TLabel;
    LblTotalHeight: TLabel;
    GbType: TGroupBox;
    RbNone: TRadioButton;
    RbTriStateCheckBox: TRadioButton;
    RbCheckBox: TRadioButton;
    RbRadio: TRadioButton;
    RbButton: TRadioButton;
    Bvl: TBevel;
    LblPrevSibling: TLabel;
    EdPrevSibling: TEdit;
    LblNextSibling: TLabel;
    EdNextSibling: TEdit;
    LblFirstChild: TLabel;
    EdFirstChild: TEdit;
    LblLastChild: TLabel;
    EdLastChild: TEdit;
    EdParent: TEdit;
    LblParent: TLabel;
    procedure CbInitializedClick(Sender: TObject);
    procedure BtnShowAllClick(Sender: TObject);
    procedure CbDisabledClick(Sender: TObject);
  private
    // Во избежание рекурсивных вызовов
    FUpdating: Boolean;
  public
    procedure UpdateStateDisplay;
  end;

var
  frmNode: TfrmNode;

implementation

uses
  uMain;

{$R *.dfm}

//------------------------------------------------------------------------------
{ * * * * * * * * * * * * * * * * * TfrmNode * * * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
procedure TfrmNode.BtnShowAllClick(Sender: TObject);
var
  Next: PVirtualNode;
begin
  Next := frmMain.VT.GetFirst;
  if Assigned(Next) then
    repeat
      Next.States := Next.States + [vsVisible];
      Next := frmMain.VT.GetNext(Next);
    until
      Next = nil;
end;

//------------------------------------------------------------------------------

procedure TfrmNode.CbDisabledClick(Sender: TObject);
var
  i: Integer;
  Node: PVirtualNode;
begin
  if FUpdating then
    Exit;
  if not Assigned(frmMain.VT.FocusedNode) then
    Exit;
  Node := frmMain.VT.FocusedNode;
  if Assigned(Node) then
  begin
    // States
    if CbDisabled.Checked then
      Include(Node.States, vsDisabled)
    else
      Exclude(Node.States, vsDisabled);
    if CbExpanded.Checked then
      Include(Node.States, vsExpanded)
    else
      Exclude(Node.States, vsExpanded);
    if CbVisible.Checked then
      Include(Node.States, vsVisible)
    else
      Exclude(Node.States, vsVisible);
    if CbSelected.Checked then
      Include(Node.States, vsSelected)
    else
      Exclude(Node.States, vsSelected);
    if CbMultiline.Checked then
      Include(Node.States, vsMultiline)
    else
      Exclude(Node.States, vsMultiline);
    // CheckState
    for i := 0 to GbCheck.ControlCount - 1 do
      if TRadioButton(GbCheck.Controls[i]).Checked then
      begin
        Node.CheckState := TCheckState(i);
        Exit;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmNode.CbInitializedClick(Sender: TObject);
var
  Evnt: TNotifyEvent;
begin
  if FUpdating then
    Exit;
  Evnt := (Sender as TCheckBox).OnClick;
  (Sender as TCheckBox).OnClick := nil;
  (Sender as TCheckBox).Checked := not (Sender as TCheckBox).Checked;
  (Sender as TCheckBox).OnClick := Evnt;
end;

//------------------------------------------------------------------------------

procedure TfrmNode.UpdateStateDisplay;
var
  Str: String;
  Node: PVirtualNode;
begin
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(frmMain.VT.FocusedNode) then
    Exit;
  Node := frmMain.VT.FocusedNode;
  FUpdating := True;
  try
    // States
    CbInitialized.Checked := vsInitialized in Node.States;
    CbChecking.Checked := vsChecking in Node.States;
    CbClipboard.Checked := vsCutOrCopy in Node.States;
    CbDisabled.Checked := vsDisabled in Node.States;
    CbDeleting.Checked := vsDeleting in Node.States;
    CbExpanded.Checked := vsExpanded in Node.States;
    CbHasChildren.Checked := vsHasChildren in Node.States;
    CbVisible.Checked := vsVisible in Node.States;
    CbSelected.Checked := vsSelected in Node.States;
    CbAllHidden.Checked := vsAllChildrenHidden in Node.States;
    CbClearing.Checked := vsClearing in Node.States;
    CbMultiline.Checked := vsMultiline in Node.States;
    CbHeightMeasured.Checked := vsHeightMeasured in Node.States;
    CbToggling.Checked := vsToggling in Node.States;
    // CheckState
    RbUnCheckedNormal.Checked := Node.CheckState = csUncheckedNormal;
    RbUnCheckedPressed.Checked := Node.CheckState = csUncheckedPressed;
    RbCheckedNormal.Checked := Node.CheckState = csCheckedNormal;
    RbCheckedPressed.Checked := Node.CheckState = csCheckedPressed;
    RbMixedNormal.Checked := Node.CheckState = csMixedNormal;
    RbMixedPressed.Checked := Node.CheckState = csMixedPressed;
    // CheckType
    RbNone.Checked := Node.CheckType = ctNone;
    RbTriStateCheckBox.Checked := Node.CheckType = ctTriStateCheckBox;
    RbCheckBox.Checked := Node.CheckType = ctCheckBox;
    RbRadio.Checked := Node.CheckType = ctRadioButton;
    RbButton.Checked := Node.CheckType = ctButton;
    // Значения
    EdAlign.Text := IntToStr(Node.Align);
    EdIndex.Text := IntToStr(Node.Index);
    EdTotalCount.Text := IntToStr(Node.TotalCount);
    EdChildCount.Text := IntToStr(Node.ChildCount);
    EdTotalHeight.Text := IntToStr(Node.TotalHeight);
    EdNodeHeight.Text := IntToStr(Node.NodeHeight);
    // Связи с другими узлами
    Str := '(not assinged)';
    EdPrevSibling.Text := Str;
    EdNextSibling.Text := Str;
    EdFirstChild.Text := Str;
    EdLastChild.Text := Str;
    EdParent.Text := Str;
    if Assigned(Node.PrevSibling) then
      EdPrevSibling.Text := frmMain.VT.Text[Node.PrevSibling, 0];
    if Assigned(Node.NextSibling) then
      EdNextSibling.Text := frmMain.VT.Text[Node.NextSibling, 0];
    if Assigned(Node.FirstChild) then
      EdFirstChild.Text := frmMain.VT.Text[Node.FirstChild, 0];
    if Assigned(Node.LastChild) then
      EdLastChild.Text := frmMain.VT.Text[Node.LastChild, 0];
    if (Assigned(Node.Parent)) and (Node.Parent <> frmMain.VT.RootNode) then
      EdParent.Text := frmMain.VT.Text[Node.Parent, 0];
    EdName.Text := frmMain.VT.Text[Node, 0];
  finally
    FUpdating := False;
  end;
end;

end.
