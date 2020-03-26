program remo_gateway;

uses
  ThreadUtils,
  Windows,
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  RemoteGateway in 'RemoteGateway.pas',
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas';

{$R *.res}

begin
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriorityFast;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
