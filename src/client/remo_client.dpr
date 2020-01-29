program remo_client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Protocols in '..\..\lib\Protocols.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
