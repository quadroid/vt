program Figure19;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Figure 1.9: VT � ���� ������';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
