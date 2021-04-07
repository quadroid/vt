program Figure17;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uNode in 'uNode.pas' {frmNode};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNode, frmNode);
  Application.Run;
end.
