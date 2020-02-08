unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    tmClose: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  ServerUnit;

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  tmClose.Enabled := true;
  TServerUnit.Obj.Stop;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TServerUnit.Obj.Start;
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

end.
