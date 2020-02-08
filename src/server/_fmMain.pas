unit _fmMain;

interface

uses
  JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    tmClose: TTimer;
    plMain: TPanel;
    edCode: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  published
    procedure rp_Connected(AJsonData: TJsonData);
    procedure rp_Disconnected(AJsonData: TJsonData);
    procedure rp_ConnectionID(AJsonData:TJsonData);
    procedure rp_PeerConnected(AJsonData:TJsonData);
    procedure rp_PeerDisconnected(AJsonData:TJsonData);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientUnit;

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  tmClose.Enabled := true;
  TCore.Obj.Finalize;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TCore.Obj.View.Add(Self);

  TClientUnit.Obj.Connect;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  TCore.Obj.View.Remove(Self);
end;

procedure TfmMain.rp_Connected(AJsonData: TJsonData);
begin
  Caption := '원격 대기 중';
end;

procedure TfmMain.rp_ConnectionID(AJsonData: TJsonData);
begin
  edCode.Text := AJsonData.Values['ID'];
end;

procedure TfmMain.rp_Disconnected(AJsonData: TJsonData);
begin
  MessageDlg('서버와 접속이 끊어져서 프로그램을 종료합니다.', mtWarning, [mbOK], 0);
  Close;
end;

procedure TfmMain.rp_PeerConnected(AJsonData: TJsonData);
begin
  Caption := '원격 제어 중';
end;

procedure TfmMain.rp_PeerDisconnected(AJsonData: TJsonData);
begin
  Caption := '원격 대기 중';
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

end.
