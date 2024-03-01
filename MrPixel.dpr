program MrPixel;

uses
  FastMM4,
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  RealSizeUnit in 'RealSizeUnit.pas' {RealSizeForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  InspectVariableUnit in 'InspectVariableUnit.pas' {InspectVariableForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.Title := 'Mr. Pixel';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TRealSizeForm, RealSizeForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TInspectVariableForm, InspectVariableForm);
  Application.Run;
end.
