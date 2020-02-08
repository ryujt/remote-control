program remo_server;

uses
  Windows,
  ThreadUtils,
  AnimationControl,
  DrawFullWindow,
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  ViewBase in '..\..\lib\Core\ViewBase.pas',
  ClientUnit in '..\..\lib\Core\ClientUnit.pas',
  Core in 'Core\Core.pas',
  View in 'Core\View.pas',
  DeskZipUnit in '..\..\lib\Core\DeskZipUnit.pas',
  DeskUnZipUnit in '..\..\lib\Core\DeskUnZipUnit.pas',
  Protocols in '..\..\lib\Core\Protocols.pas',
  ClientUnitInterface in '..\..\lib\Core\ClientUnitInterface.pas';

{$R *.res}

begin
  SetPriorityClass( GetCurrentProcess, REALTIME_PRIORITY_CLASS );
  SetThreadPriorityFast;

  DisableAnimation;
  DisableDrawFullWindow;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;

  RestoreAnimation;
  RestoreDrawFullWindow;
end.
