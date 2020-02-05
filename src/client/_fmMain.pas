unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  ClientUnit;

{$R *.dfm}

procedure TfmMain.Button1Click(Sender: TObject);
begin
  TClientUnit.Obj.sp_SetConnectionID( StrToIntDef(Edit1.Text, 0) );
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TClientUnit.Obj.Connect;
end;

end.
