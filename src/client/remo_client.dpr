program remo_client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  DeskUnZipUnit in '..\..\lib\Core\DeskUnZipUnit.pas',
  _frDeskScreen in '_frDeskScreen.pas' {frDeskScreen: TFrame},
  Protocols in '..\..\lib\Core\Protocols.pas',
  RemoteClient in '..\..\lib\RemoteClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;

end.
