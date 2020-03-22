program remo_gateway;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  RemoteGateway in 'RemoteGateway.pas',
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
