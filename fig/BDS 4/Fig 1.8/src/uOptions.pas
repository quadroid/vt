unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees;

type
  TfrmOptions = class(TForm)
    GroupBox: TGroupBox;
    LblHintMode: TLabel;
    LblHintAnimation: TLabel;
    LblDrawSelectionMode: TLabel;
    LblButtonStyle: TLabel;
    CBoxHintMode: TComboBox;
    CBoxHintAnimation: TComboBox;
    CBoxSelection: TComboBox;
    CBoxButtonStyle: TComboBox;
    LblNodeAlignment: TLabel;
    CBoxNodeAlignment: TComboBox;
    LblAnimationDuration: TLabel;
    EdAnimationDuration: TEdit;
    LblExpaandDelay: TLabel;
    EdExpandDelay: TEdit;
    LblScrollDelay: TLabel;
    EdScrollDelay: TEdit;
    LblScrollInterval: TLabel;
    EdAutoScroll: TEdit;
    LblCurveRadius: TLabel;
    EdCurveRadius: TEdit;
    LblLineMode: TLabel;
    CBoxLineMode: TComboBox;
    LblIndent: TLabel;
    EdIndent: TEdit;
    LblLineStyle: TLabel;
    CBoxLineStyle: TComboBox;
    procedure EdChangeDelayChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FChanging: Boolean;
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

uses
  uMain;

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * TfrmOptions * * * * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
procedure TfrmOptions.EdChangeDelayChange(Sender: TObject);
begin
  if FChanging then
    Exit;
  frmMain.VT.HintMode := TVTHintMode(CBoxHintMode.ItemIndex);
  frmMain.VT.HintAnimation := THintAnimationType(CBoxHintAnimation.ItemIndex);
  frmMain.VT.DrawSelectionMode := TVTDrawSelectionMode(CBoxSelection.ItemIndex);
  frmMain.VT.ButtonStyle := TVTButtonStyle(CBoxButtonStyle.ItemIndex);
  frmMain.VT.NodeAlignment := TVTNodeAlignment(CBoxNodeAlignment.ItemIndex);
  frmMain.VT.AnimationDuration := StrToIntDef(EdAnimationDuration.Text, 200);
  frmMain.VT.AutoExpandDelay := StrToIntDef(EdExpandDelay.Text, 1000);
  frmMain.VT.AutoScrollDelay := StrToIntDef(EdScrollDelay.Text, 1000);
  frmMain.VT.AutoScrollInterval := StrToIntDef(EdAutoScroll.Text, 1);
  frmMain.VT.SelectionCurveRadius := StrToIntDef(EdCurveRadius.Text, 0);
  frmMain.VT.LineMode := TVTLineMode(CBoxLineMode.ItemIndex);
  frmMain.VT.Indent := StrToIntDef(EdIndent.Text, 18);
  frmMain.VT.LineStyle := TVTLineStyle(CBoxLineStyle.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  FChanging := True;
  CBoxHintMode.ItemIndex := Ord(frmMain.VT.HintMode);
  CBoxHintAnimation.ItemIndex := Ord(frmMain.VT.HintAnimation);
  CBoxSelection.ItemIndex := Ord(frmMain.VT.DrawSelectionMode);
  CBoxButtonStyle.ItemIndex := Ord(frmMain.VT.ButtonStyle);
  CBoxNodeAlignment.ItemIndex := Ord(frmMain.VT.NodeAlignment);
  EdAnimationDuration.Text := IntToStr(frmMain.VT.AnimationDuration);
  EdExpandDelay.Text := IntToStr(frmMain.VT.AutoExpandDelay);
  EdScrollDelay.Text := IntToStr(frmMain.VT.AutoScrollDelay);
  EdAutoScroll.Text := IntToStr(frmMain.VT.AutoScrollInterval);
  EdCurveRadius.Text := IntToStr(frmMain.VT.SelectionCurveRadius);
  CBoxLineMode.ItemIndex := Ord(frmMain.VT.LineMode);
  EdIndent.Text := IntToStr(frmMain.VT.Indent);
  CBoxLineStyle.ItemIndex := Ord(frmMain.VT.LineStyle);
  FChanging := False;
end;

end.
