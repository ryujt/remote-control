unit RemoteGateway;

interface

uses
  Config, Global, RemoteControlUtils,
  DebugTools, SuperSocketUtils, SuperSocketServer, MemoryPool,
  SysUtils, Classes;

type
  TRemoteGateway = class
  private
    FMemoryPool : TMemoryPool;
  private
    FSocket : TSuperSocketServer;
    procedure on_FSocket_Connected(AConnection:TConnection);
    procedure on_FSocket_Disconnected(AConnection:TConnection);
    procedure on_FSocket_Received(AConnection:TConnection; APacket:PPacket);
  private
    procedure rp_SetConnectionID(AConnection:TConnection; APacket:PPacket);
  private
    procedure sp_ErPeerConnected(AConnection:TConnection);
    procedure sp_PeerConnected(AConnection:TConnection);
    procedure sp_PeerDisconnected(AConnection:TConnection);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TRemoteGateway;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TRemoteGateway }

var
  MyObject : TRemoteGateway = nil;

class function TRemoteGateway.Obj: TRemoteGateway;
begin
  if MyObject = nil then MyObject := TRemoteGateway.Create;
  Result := MyObject;
end;

procedure TRemoteGateway.on_FSocket_Connected(AConnection: TConnection);
var
  packet : TConnectionIDPacket;
begin
  {$IFDEF DEBUG}
  Trace('TServerUnit.on_FSocket_Connected - ' + AConnection.Text);
  {$ENDIF}

  packet.PacketSize := SizeOf(TConnectionIDPacket);
  packet.PacketType := ptConnectionID;
  packet.id := AConnection.ID;

  AConnection.Send(@packet);
  AConnection.Tag := -1;

  // TODO: 추후 인증 처리 필요
  AConnection.IsLogined := true;
end;

procedure TRemoteGateway.on_FSocket_Disconnected(AConnection: TConnection);
begin
  {$IFDEF DEBUG}
  Trace('TServerUnit.on_FSocket_Disconnected - ' + AConnection.Text);
  {$ENDIF}

  if AConnection.Tag <> -1 then sp_PeerDisconnected(FSocket.ConnectionList.Items[AConnection.Tag]);
end;

procedure TRemoteGateway.on_FSocket_Received(AConnection: TConnection;
  APacket: PPacket);
var
  packet: PPacket;
  PacketType : TPacketType;
begin
  {$IFDEF DEBUG}
  if APacket^.PacketType >= 100 then
    Trace( Format('TServerUnit.on_FSocket_Received - %d', [APacket^.PacketType]) );
  {$ENDIF}

  Packet := GetPacketClone(FMemoryPool, APacket);
  if Packet = nil then Exit;

  PacketType := TPacketType(packet^.PacketType);

  case PacketType of
    ptNone: ;
    ptSetConnectionID: rp_SetConnectionID(AConnection, APacket);

    else begin
      if AConnection.Tag <> -1 then FSocket.ConnectionList.Items[AConnection.Tag].Send(packet);
    end;
  end;
end;

procedure TRemoteGateway.rp_SetConnectionID(AConnection: TConnection;
  APacket: PPacket);
var
  server : TConnection;
  packet : PConnectionIDPacket absolute APacket;
begin
  {$IFDEF DEBUG}
  Trace('TServerUnit.rp_SetConnectionID - ' + Format('%d <--> %d', [packet^.ID, AConnection.ID]));
  {$ENDIF}

  server := FSocket.ConnectionList.Items[packet^.ID];

  if server.ID <> packet^.ID then begin
    sp_ErPeerConnected(AConnection);
  end else begin
    server.Tag := AConnection.ID;
    AConnection.Tag := packet^.ID;

    sp_PeerConnected(AConnection);
    sp_PeerConnected(server);
  end;
end;

procedure TRemoteGateway.sp_ErPeerConnected(AConnection: TConnection);
var
  packet : TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ptErPeerConnected);
  AConnection.Send( GetPacketClone(FMemoryPool, @packet) );
end;

procedure TRemoteGateway.sp_PeerConnected(AConnection: TConnection);
var
  packet : TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ptPeerConnected);
  AConnection.Send( GetPacketClone(FMemoryPool, @packet) );
end;

procedure TRemoteGateway.sp_PeerDisconnected(AConnection: TConnection);
var
  packet : TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ptPeerDisconnected);
  AConnection.Send( GetPacketClone(FMemoryPool, @packet) );
end;

procedure TRemoteGateway.Start;
begin
  FSocket.Start;
end;

procedure TRemoteGateway.Stop;
begin
  FSocket.Stop;
end;

constructor TRemoteGateway.Create;
begin
  inherited;

  {$IFDEF WIN64}
  FMemoryPool := TMemoryPool64.Create(MEMORY_POOL_SIZE_64);
  {$ELSE}
  FMemoryPool := TMemoryPool32.Create(MEMORY_POOL_SIZE_32);
  {$ENDIF}

  FSocket := TSuperSocketServer.Create(false);
  FSocket.UseNagel := false;
  FSocket.Port := Gateway_Port;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
  FSocket.OnReceived := on_FSocket_Received;
end;

destructor TRemoteGateway.Destroy;
begin
  FreeAndNil(FMemoryPool);
  FreeAndNil(FSocket);

  inherited;
end;

initialization
  MyObject := TRemoteGateway.Create;
end.