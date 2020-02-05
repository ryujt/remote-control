unit ClientUnit;

interface

uses
  Config, Protocols,
  DeskZipUtils, DeskZipUnit, DeskUnZipUnit,
  DebugTools, SuperSocketUtils, SuperSocketClient, JsonData,
  SysUtils, Classes, TypInfo, Forms;

type
  TClientUnit = class
  private
    FJsonData : TJsonData;
    FDeskZip : TDeskZipUnit;
    FDeskUnZip : TDeskUnZipUnit;
  private
    FSocket : TSuperSocketClient;
    procedure on_FSocket_connected(ASender:TObject);
    procedure on_FSocket_disconnected(ASender:TObject);
    procedure on_FSocket_Received(ASender:TObject; APacket:PPacket);

    procedure rp_Text(APacket:PPacket);
  private
    FConnectionID: integer;
    function GetConnected: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TClientUnit;

    procedure Terminate;

    procedure Connect;
    procedure Discoonect;

    procedure sp_SetConnectionID(AID:integer);
    procedure sp_AskDeskZip;
  public
    property Connected : boolean read GetConnected;
    property ConnectionID : integer read FConnectionID;

    property DeskZip : TDeskZipUnit read FDeskZip;
    property DeskUnZip : TDeskUnZipUnit read FDeskUnZip;
  end;

implementation

uses
  Core;

{ TClientUnit }

var
  MyObject : TClientUnit = nil;

class function TClientUnit.Obj: TClientUnit;
begin
  if MyObject = nil then MyObject := TClientUnit.Create;
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
//  Trace( Format('TClientUnit.on_FSocket_Received - %d', [APacket^.PacketType]) );
  {$ENDIF}

  case TPacketType(APacket^.PacketType) of
    ptPeerConnected: begin
      // TODO: 모니터 선택 가능하도록
      FDeskZip.Prepare(Screen.Monitors[0].Width, Screen.Monitors[0].Height);
    end;

    ptText: rp_Text(APacket);
  end;

  if APacket^.PacketType >= 100 then Exit;

  case TFrameType(APacket^.PacketType) of
    ftNeedNext: ;
    ftAskDeskZip: FDeskZip.Execute;
    ftEndOfDeskZip: ;

    ftFrameStart, ftBitmap, ftJpeg, ftPixel: FDeskUnZip.Execute(APacket);

    ftFrameEnd: begin
      FDeskUnZip.Execute(APacket);
      sp_AskDeskZip
    end;
  end;
end;

procedure TClientUnit.rp_Text(APacket: PPacket);
var
  id : integer;
begin
  {$IFDEF DEBUG}
  Trace( Format('TClientUnit.rp_Text - %s', [APacket^.Text]) );
  {$ENDIF}

  FJsonData.Text := APacket^.Text;

  id := FJsonData.Integers['id'];

  // 복잡해 보이도록 "Random(1024) * CONNECTION_POOL_SIZE"를 더한다.
  // 실제 사용에서는 CONNECTION_POOL_SIZE로 나눠서 나머지만 취급하기 때문에 더하나 안하나 마찬가지
  Randomize;
  FConnectionID := Random(1024) * CONNECTION_POOL_SIZE + id;

  TCore.Obj.View.sp_ConnectionID(FConnectionID);
end;

procedure TClientUnit.sp_AskDeskZip;
var
  packet : TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ftAskDeskZip);
  FSocket.Send(@packet);
end;

procedure TClientUnit.sp_SetConnectionID(AID: integer);
var
  packet : TConnectionIDPacket;
begin
  packet.PacketSize := SizeOf(TConnectionIDPacket);
  packet.PacketType := ptSetConnectionID;
  packet.ID := AID;
  FSocket.Send(@packet);

  sp_AskDeskZip;
end;

procedure TClientUnit.Terminate;
begin
  FSocket.Terminate;
end;

procedure TClientUnit.Connect;
begin
  FSocket.Connect(HOST, PORT);
end;

constructor TClientUnit.Create;
begin
  inherited;

  FConnectionID := -1;

  FJsonData := TJsonData.Create;

  FSocket := TSuperSocketClient.Create(true);
  FSocket.UseNagel := false;
  FSocket.OnConnected := on_FSocket_connected;
  FSocket.OnDisconnected := on_FSocket_disconnected;
  FSocket.OnReceived := on_FSocket_Received;

  FDeskZip := TDeskZipUnit.Create(FSocket);
  FDeskUnZip := TDeskUnZipUnit.Create(FSocket);
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

function TClientUnit.GetConnected: boolean;
begin
  Result := FSocket.Connected;
end;

initialization
  MyObject := TClientUnit.Create;
end.
