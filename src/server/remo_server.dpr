program remo_server;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  Protocols in '..\..\lib\Protocols.pas',
  View in 'Core\View.pas',
  ViewBase in '..\..\lib\Core\ViewBase.pas',
  ClientUnit in '..\..\lib\Core\ClientUnit.pas',
  Core in 'Core\Core.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
