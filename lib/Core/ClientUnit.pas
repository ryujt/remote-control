unit ClientUnit;

interface

uses
  Config, Protocols,
  DebugTools, SuperSocketUtils, SuperSocketClient, JsonData,
  SysUtils, Classes, TypInfo;

type
  TClientUnit = class
  private
    FJsonData : TJsonData;
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
  public
    property Connected : boolean read GetConnected;
    property ConnectionID : integer read FConnectionID;
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
var
  PacketType : TPacketType;
begin
  if APacket^.PacketType = 0 then Exit;

  PacketType := TPacketType(APacket^.PacketType);

  case PacketType of
    ptText: rp_Text(APacket);
    else;
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

procedure TClientUnit.sp_SetConnectionID(AID: integer);
var
  packet : TConnectionIDPacket;
begin
  packet.PacketSize := SizeOf(TConnectionIDPacket);
  packet.PacketType := ptSetConnectionID;
  packet.ID := AID;
  FSocket.Send(@packet);
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
  FSocket.UseNagel := true;
  FSocket.OnConnected := on_FSocket_connected;
  FSocket.OnDisconnected := on_FSocket_disconnected;
  FSocket.OnReceived := on_FSocket_Received;
end;

destructor TClientUnit.Destroy;
begin
  FreeAndNil(FSocket);
  FreeAndNil(FJsonData);

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