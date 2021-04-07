program Figure15;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uNew in 'uNew.pas' {frmNew};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Figure 1.5: Отрисовка';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
