program remo_client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\lib\Config.pas',
  _frDeskScreen in '_frDeskScreen.pas' {frDeskScreen: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;

end.
