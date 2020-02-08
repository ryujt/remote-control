program remo_client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Core in 'Core\Core.pas',
  View in 'Core\View.pas',
  ClientUnit in '..\..\lib\Core\ClientUnit.pas',
  ViewBase in '..\..\lib\Core\ViewBase.pas',
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  DeskZipUnit in '..\..\lib\Core\DeskZipUnit.pas',
  DeskUnZipUnit in '..\..\lib\Core\DeskUnZipUnit.pas',
  _frDeskScreen in '_frDeskScreen.pas' {frDeskScreen: TFrame},
  ClientUnitInterface in '..\..\lib\Core\ClientUnitInterface.pas',
  Protocols in '..\..\lib\Core\Protocols.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;

end.
