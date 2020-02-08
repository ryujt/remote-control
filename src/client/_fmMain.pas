unit _fmMain;

interface

uses
  JsonData,
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
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
  public
  published
    procedure rp_Connected(AJsonData: TJsonData);
    procedure rp_Disconnected(AJsonData: TJsonData);
    procedure rp_ErPeerConnected(AJsonData: TJsonData);
    procedure rp_PeerConnected(AJsonData:TJsonData);
    procedure rp_PeerDisconnected(AJsonData:TJsonData);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientUnit;

{$R *.dfm}

procedure TfmMain.btConnectClick(Sender: TObject);
begin
  plTop.Visible := false;
  TClientUnit.Obj.sp_SetConnectionID(StrToIntDef(edCode.Text, 0));
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  tmClose.Enabled := true;
  TCore.Obj.Finalize;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TClientUnit.Obj.Connect;

  TCore.Obj.View.Add(Self);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  TCore.Obj.View.Remove(Self);
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

procedure TfmMain.rp_Connected(AJsonData: TJsonData);
begin
  Caption := 'Remote control - 서버 접속 완료';
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.rp_Disconnected(AJsonData: TJsonData);
begin
  MessageDlg('서버와 접속이 끊어져서 프로그램을 종료합니다.', mtWarning, [mbOK], 0);
  Close;
end;

procedure TfmMain.rp_ErPeerConnected(AJsonData: TJsonData);
begin
  MessageDlg('잘못된 아이디로 접속을 시도하였습니다.' + #13#10 + '아이디를 확인하여주시기 바랍니다.', mtWarning, [mbOK], 0);
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.rp_PeerConnected(AJsonData: TJsonData);
begin
  Caption := 'Remote control - 원격 제어 중';
end;

procedure TfmMain.rp_PeerDisconnected(AJsonData: TJsonData);
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

end.
