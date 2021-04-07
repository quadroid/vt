program Figure19;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Figure 1.9: VT и базы данных';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
