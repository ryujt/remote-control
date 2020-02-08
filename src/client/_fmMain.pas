unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, _frDeskScreen,
  Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    btConnect: TButton;
    edCode: TEdit;
    frDeskScreen: TfrDeskScreen;
    plTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  ClientUnit;

{$R *.dfm}

procedure TfmMain.btConnectClick(Sender: TObject);
begin
  plTop.Visible := false;
  TClientUnit.Obj.sp_SetConnectionID(StrToIntDef(edCode.Text, 0));
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TClientUnit.Obj.Connect;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TClientUnit.Obj.sp_KeyDown(Key);
end;

procedure TfmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TClientUnit.Obj.sp_KeyUp(Key);
end;

end.
