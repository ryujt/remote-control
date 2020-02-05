unit ServerUnit;

interface

uses
  Config, Global, Protocols,
  DebugTools, SuperSocketUtils, SuperSocketServer, MemoryPool,
  SysUtils, Classes;

type
  TServerUnit = class
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
    procedure sp_PeerConnected(AConnection:TConnection);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TServerUnit;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TServerUnit }

var
  MyObject : TServerUnit = nil;

class function TServerUnit.Obj: TServerUnit;
begin
  if MyObject = nil then MyObject := TServerUnit.Create;
  Result := MyObject;
end;

procedure TServerUnit.on_FSocket_Connected(AConnection: TConnection);
begin
  {$IFDEF DEBUG}
  Trace('TVideoServer.on_FSocket_Connected - ' + AConnection.Text);
  {$ENDIF}

  AConnection.Send( GetTextPacket(FMemoryPool, ptText, AConnection.Text) );

  AConnection.Tag := -1;

  // TODO: 추후 인증 처리 필요
  AConnection.IsLogined := true;
end;

procedure TServerUnit.on_FSocket_Disconnected(AConnection: TConnection);
begin
  {$IFDEF DEBUG}
  Trace('TVideoServer.on_FSocket_Disconnected - ' + AConnection.Text);
  {$ENDIF}
end;

procedure TServerUnit.on_FSocket_Received(AConnection: TConnection;
  APacket: PPacket);
var
  packet: PPacket;
  PacketType : TPacketType;
begin
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

procedure TServerUnit.rp_SetConnectionID(AConnection: TConnection;
  APacket: PPacket);
var
  packet : PConnectionIDPacket absolute APacket;
begin
  {$IFDEF DEBUG}
  Trace('TVideoServer.rp_SetConnectionID - ' + Format('%d <--> %d', [packet^.ID, AConnection.ID]));
  {$ENDIF}

  AConnection.Tag := packet^.ID;
  FSocket.ConnectionList.Items[packet^.ID].Tag := AConnection.ID;

  sp_PeerConnected(AConnection);
  sp_PeerConnected(FSocket.ConnectionList.Items[packet^.ID]);
end;

procedure TServerUnit.sp_PeerConnected(AConnection: TConnection);
var
  packet : TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ptPeerConnected);
  AConnection.Send( GetPacketClone(FMemoryPool, @packet) );
end;

procedure TServerUnit.Start;
begin
  FSocket.Start;
end;

procedure TServerUnit.Stop;
begin
  FSocket.Stop;
end;

constructor TServerUnit.Create;
begin
  inherited;

  {$IFDEF WIN64}
  FMemoryPool := TMemoryPool64.Create(MEMORY_POOL_SIZE_64);
  {$ELSE}
  FMemoryPool := TMemoryPool32.Create(MEMORY_POOL_SIZE_32);
  {$ENDIF}

  FSocket := TSuperSocketServer.Create(false);
  FSocket.UseNagel := false;
  FSocket.Port := PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
  FSocket.OnReceived := on_FSocket_Received;
end;

destructor TServerUnit.Destroy;
begin
  FreeAndNil(FMemoryPool);
  FreeAndNil(FSocket);

  inherited;
end;

initialization
  MyObject := TServerUnit.Create;
end.