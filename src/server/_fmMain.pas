unit _fmMain;

interface

uses
  JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
  published
    procedure rp_ConnectionID(AJsonData:TJsonData);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientUnit;

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TCore.Obj.View.Add(Self);

  TClientUnit.Obj.Connect;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  TCore.Obj.View.Remove(Self);
end;

procedure TfmMain.rp_ConnectionID(AJsonData: TJsonData);
begin
  Caption := AJsonData.Values['ID'];
end;

end.
