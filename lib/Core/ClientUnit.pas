unit ClientUnit;

interface

uses
  Config, ClientUnitInterface, Protocols,
  DeskZipUtils, DeskZipUnit, DeskUnZipUnit,
  RyuLibBase, DebugTools, SuperSocketUtils, SuperSocketClient, JsonData,
  Windows, SysUtils, Classes, TypInfo;

type
  TClientUnit = class (TInterfaceBase, IClientUnitInterface)
  private
    // 지금 처음 화면 전송을 시작하는가?
    FIsFirstScreen: boolean;

    FJsonData: TJsonData;
    FDeskZip: TDeskZipUnit;
    FDeskUnZip: TDeskUnZipUnit;
  private
    FSocket: TSuperSocketClient;
    procedure on_FSocket_connected(ASender: TObject);
    procedure on_FSocket_disconnected(ASender: TObject);
    procedure on_FSocket_Received(ASender: TObject; APacket: PPacket);
  private
    procedure do_deskzip_packet(APacket: PPacket);
    procedure do_remote_control_packet(APacket: PPacket);
  private
    procedure rp_Text(APacket: PPacket);
  private
    FConnectionID: integer;
    function GetConnected: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj: TClientUnit;

    procedure Terminate;

    procedure Connect;
    procedure Discoonect;
  public // IClientUnitInterface
    procedure Send(APacket:PPacket);

    procedure sp_SetConnectionID(AID: integer);
    procedure sp_AskDeskZip;

    procedure sp_MouseDown(AMode, AX, AY: integer);
    procedure sp_MouseMove(AX, AY: integer);
    procedure sp_MouseUp(AMode, AX, AY: integer);

    procedure sp_KeyDown(AKey: integer);
    procedure sp_KeyUp(AKey: integer);
  public
    property Connected: boolean read GetConnected;
    property ConnectionID: integer read FConnectionID;

    property DeskZip: TDeskZipUnit read FDeskZip;
    property DeskUnZip: TDeskUnZipUnit read FDeskUnZip;
  end;

implementation

uses
  Core;

{ TClientUnit }

var
  MyObject: TClientUnit = nil;

class function TClientUnit.Obj: TClientUnit;
begin
  if MyObject = nil then
    MyObject := TClientUnit.Create;
  Result := MyObject;
end;

procedure TClientUnit.on_FSocket_connected(ASender: TObject);
begin

end;

procedure TClientUnit.on_FSocket_disconnected(ASender: TObject);
begin

end;

procedure TClientUnit.on_FSocket_Received(ASender: TObject; APacket: PPacket);
begin
{$IFDEF DEBUG}
  // Trace( Format('TClientUnit.on_FSocket_Received - %d', [APacket^.PacketType]) );
{$ENDIF}
  if APacket^.PacketType < 100 then
    do_deskzip_packet(APacket)
  else
    do_remote_control_packet(APacket);
end;

procedure TClientUnit.rp_Text(APacket: PPacket);
var
  id: integer;
begin
{$IFDEF DEBUG}
  Trace(Format('TClientUnit.rp_Text - %s', [APacket^.Text]));
{$ENDIF}
  FJsonData.Text := APacket^.Text;

  id := FJsonData.Integers['id'];

  // 복잡해 보이도록 "Random(1024) * CONNECTION_POOL_SIZE"를 더한다.
  // 실제 사용에서는 CONNECTION_POOL_SIZE로 나눠서 나머지만 취급하기 때문에 더하나 안하나 마찬가지
  Randomize;
  FConnectionID := Random(1024) * CONNECTION_POOL_SIZE + id;

  TCore.Obj.View.sp_ConnectionID(FConnectionID);
end;

procedure TClientUnit.Send(APacket: PPacket);
begin
  FSocket.Send(APacket);
end;

procedure TClientUnit.sp_AskDeskZip;
var
  packet: TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ftAskDeskZip);
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_KeyDown(AKey: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptKeyDown;
  packet.Key := AKey;
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_KeyUp(AKey: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptKeyUp;
  packet.Key := AKey;
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_MouseDown(AMode, AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseDown;
  packet.Key := AMode;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_MouseMove(AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseMove;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_MouseUp(AMode, AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseUp;
  packet.Key := AMode;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_SetConnectionID(AID: integer);
var
  packet: TConnectionIDPacket;
begin
  packet.PacketSize := SizeOf(TConnectionIDPacket);
  packet.PacketType := ptSetConnectionID;
  packet.id := AID;
  FSocket.Send(@packet);

  sp_AskDeskZip;
end;

procedure TClientUnit.Terminate;
begin
  FSocket.Terminate;
end;

procedure TClientUnit.Connect;
begin
  FIsFirstScreen := true;
  FSocket.Connect(HOST, PORT);
end;

constructor TClientUnit.Create;
begin
  inherited;

  FConnectionID := -1;
  FIsFirstScreen := true;

  FJsonData := TJsonData.Create;

  FSocket := TSuperSocketClient.Create(true);
  FSocket.UseNagel := false;
  FSocket.OnConnected := on_FSocket_connected;
  FSocket.OnDisconnected := on_FSocket_disconnected;
  FSocket.OnReceived := on_FSocket_Received;

  FDeskZip := TDeskZipUnit.Create(Self);
  FDeskUnZip := TDeskUnZipUnit.Create(Self);
end;

destructor TClientUnit.Destroy;
begin
  FreeAndNil(FJsonData);
  FreeAndNil(FSocket);
  FreeAndNil(FDeskZip);

  inherited;
end;

procedure TClientUnit.Discoonect;
begin
  FSocket.Disconnect;
end;

procedure TClientUnit.do_deskzip_packet(APacket: PPacket);
begin
  case TFrameType(APacket^.PacketType) of
    ftNeedNext:
      ;

    ftAskDeskZip:
      begin
        // TODO: 모니터 선택 가능하도록
        if FIsFirstScreen then
          FDeskZip.Prepare(0);
        FIsFirstScreen := false;

        FDeskZip.Execute;
      end;

    ftEndOfDeskZip:
      ;

    ftFrameStart, ftBitmap, ftJpeg, ftPixel:
      FDeskUnZip.Execute(APacket);

    ftFrameEnd:
      begin
        FDeskUnZip.Execute(APacket);
        // sp_AskDeskZip
      end;
  end;
end;

procedure TClientUnit.do_remote_control_packet(APacket: PPacket);
const
  KEYEVENTF_KEYDOWN = 0;
var
  packet: PRemoteControlPacket absolute APacket;
begin
  case TPacketType(APacket^.PacketType) of
    ptPeerConnected:
      ;
    ptText:
      rp_Text(APacket);

    ptMouseMove:
      SetCursorPos(packet^.X, packet^.Y);
    ptMouseDown, ptMouseUp:
      Mouse_Event(packet^.Key, packet^.X, packet^.Y, 0, 0);

    ptKeyDown:
      Keybd_Event(packet^.Key, MapVirtualKey(packet^.Key, 0),
        KEYEVENTF_KEYDOWN, 0);
    ptKeyUp:
      Keybd_Event(packet^.Key, MapVirtualKey(packet^.Key, 0),
        KEYEVENTF_KEYUP, 0);
  end;
end;

function TClientUnit.GetConnected: boolean;
begin
  Result := FSocket.Connected;
end;

initialization

MyObject := TClientUnit.Create;

end.
