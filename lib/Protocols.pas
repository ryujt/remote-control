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
    ptMouseDownLeft, ptMouseDownMiddle, ptMouseDownRight,
    ptMouseMoveLeft, ptMouseMoveMiddle, ptMouseMoveRight,
    ptMouseUpLeft, ptMouseUpMiddle, ptMouseUpRight
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
