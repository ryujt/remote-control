unit Protocols;

interface

uses
  SuperSocketUtils,
  Classes, SysUtils;

type
  TPacketType = (
    ptNone=100,
    ptSetConnectionID,
    ptPeerConnected,
    ptText,
    ptKeyDown, ptKeyUp,
    ptMouseDown, ptMouseMove, ptMouseUp
  );

  TConnectionIDPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    ID : integer;
  end;
  PConnectionIDPacket = ^TConnectionIDPacket;

  TRemoteControlPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    Key : word;
    X, Y : integer;
  end;
  PRemoteControlPacket = ^TRemoteControlPacket;

implementation

end.
