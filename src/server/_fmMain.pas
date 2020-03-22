unit _fmMain;

interface

uses
  Config, RemoteServer,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    tmClose: TTimer;
    plMain: TPanel;
    edCode: TEdit;
    Label1: TLabel;
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FRemoteServer : TRemoteServer;
    procedure on_connect_error(ASender:TObject);
    procedure on_connected(ASender:TObject);
    procedure on_disconnected(ASender:TObject);
    procedure on_connection_id(ASender:TObject; AConnectionID:integer);
    procedure on_peer_connect_error(ASender:TObject);
    procedure on_peer_connected(ASender:TObject);
    procedure on_peer_disconnected(ASender:TObject);
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  FRemoteServer.Terminate;
  tmClose.Enabled := true;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FRemoteServer := TRemoteServer.Create;
  FRemoteServer.OnConnectError := on_connect_error;
  FRemoteServer.OnConnected := on_connected;
  FRemoteServer.OnDisconnected := on_disconnected;
  FRemoteServer.OnConnectionID := on_connection_id;
  FRemoteServer.OnPeerConnectError := on_peer_connect_error;
  FRemoteServer.OnPeerConnected := on_peer_connected;
  FRemoteServer.OnPeerDisconnected := on_peer_disconnected;
  FRemoteServer.Connect(Gateway_Host, Gateway_Port);
end;

procedure TfmMain.on_connected(ASender: TObject);
begin
  Caption := '원격 대기 중';
end;

procedure TfmMain.on_connection_id(ASender: TObject; AConnectionID: integer);
begin
  edCode.Text := IntToStr(AConnectionID);
end;

procedure TfmMain.on_connect_error(ASender: TObject);
begin
  MessageDlg('서버에 접속할 수가 없습니다.', mtError, [mbOK], 0);
  Close;
end;

procedure TfmMain.on_disconnected(ASender: TObject);
begin
  MessageDlg('서버와 접속이 끊어져서 프로그램을 종료합니다.', mtWarning, [mbOK], 0);
  Close;
end;

procedure TfmMain.on_peer_connected(ASender: TObject);
begin
  Caption := '원격 제어 중';
end;

procedure TfmMain.on_peer_connect_error(ASender: TObject);
begin
  Caption := '원격 접속 중에 에러가 발생';
end;

procedure TfmMain.on_peer_disconnected(ASender: TObject);
begin
  Caption := '원격 대기 중';
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

end.
