program remo_gateway;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  ServerUnit in 'ServerUnit.pas',
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  Protocols in '..\..\lib\Core\Protocols.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
