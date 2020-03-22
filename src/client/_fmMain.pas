unit _fmMain;

interface

uses
  Config,
  DebugTools, Para,
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
    tmClose: TTimer;
    tmStart: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmStartTimer(Sender: TObject);
  private
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

uses
  RemoteClient;

{$R *.dfm}

procedure TfmMain.btConnectClick(Sender: TObject);
begin
  plTop.Visible := false;
  TRemoteClient.Obj.sp_SetConnectionID( StrToIntDef(edCode.Text, 0) );
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  tmClose.Enabled := true;
  TRemoteClient.Obj.Terminate;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  FormStyle := fsStayOnTop;

  TRemoteClient.Obj.OnConnectError := on_connect_error;
  TRemoteClient.Obj.OnConnected := on_connected;
  TRemoteClient.Obj.OnDisconnected := on_disconnected;
  TRemoteClient.Obj.OnConnectionID := on_connection_id;
  TRemoteClient.Obj.OnPeerConnectError := on_peer_connect_error;
  TRemoteClient.Obj.OnPeerConnected := on_peer_connected;
  TRemoteClient.Obj.OnPeerDisconnected := on_peer_disconnected;

  if GetSwitchValue('host') <> '' then begin
    Trace( Format('remo_client.exe - host: %s, port: %s', [GetSwitchValue('host'), GetSwitchValue('port')]) );

    plTop.Visible := false;
    TRemoteClient.Obj.Connect( GetSwitchValue('host'), StrToIntDef(GetSwitchValue('port'), 0) );
  end else begin
    TRemoteClient.Obj.Connect(Gateway_Host, Gateway_Port);
  end;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TRemoteClient.Obj.sp_KeyDown(Key);
end;

procedure TfmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TRemoteClient.Obj.sp_KeyUp(Key);
end;

procedure TfmMain.on_connected(ASender: TObject);
begin
  Caption := 'Remote control - 서버 접속 완료';

  if GetSwitchValue('code') <> '' then begin
    Trace( Format('remo_client.exe - code: %s', [GetSwitchValue('code')]) );
    TRemoteClient.Obj.sp_SetConnectionID( StrToIntDef(GetSwitchValue('code'), 0) );
  end else begin
    plTop.Visible := true;
    edCode.SetFocus;
  end;
end;

procedure TfmMain.on_connection_id(ASender: TObject; AConnectionID: integer);
begin

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
  Caption := 'Remote control - 원격 제어 중';
end;

procedure TfmMain.on_peer_connect_error(ASender: TObject);
begin
  MessageDlg('잘못된 아이디로 접속을 시도하였습니다.' + #13#10 + '아이디를 확인하여주시기 바랍니다.', mtWarning, [mbOK], 0);
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.on_peer_disconnected(ASender: TObject);
begin
  MessageDlg('상대방과의 연결이 끊어졌습니다.', mtWarning, [mbOK], 0);
  Caption := 'Remote control - 원격 대기 중';
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmMain.tmStartTimer(Sender: TObject);
begin
  tmStart.Enabled := false;

  SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  FormStyle := fsNormal;
end;

end.
