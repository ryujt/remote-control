unit Global;

interface

uses
  RemoteControlUtils,
  SuperSocketUtils, MemoryPool,
  SysUtils, Classes;

function GetPacketClone(AMemoryPool: TMemoryPool; APacket: PPacket): PPacket;
function GetTextPacket(AMemoryPool: TMemoryPool; APacketType: TPacketType; const AText: string): PPacket;

implementation

function GetPacketClone(AMemoryPool: TMemoryPool; APacket: PPacket): PPacket;
begin
  if APacket^.PacketSize = 0 then begin
    Result := nil;
    Exit;
  end;

  AMemoryPool.GetMem(Pointer(Result), APacket^.PacketSize);
  APacket^.Clone(Result);
end;

function GetTextPacket(AMemoryPool: TMemoryPool; APacketType: TPacketType;
  const AText: string): PPacket;
var
  ssData: TStringStream;
begin
  if AText = '' then begin
    AMemoryPool.GetMem(Pointer(Result), SizeOf(Word) + SizeOf(Byte));
    Result^.PacketType := Byte(APacketType);
    Result^.DataSize := 0;
    Exit;
  end;

  ssData := TStringStream.Create(AText);
  try
    AMemoryPool.GetMem(Pointer(Result), ssData.Size + SizeOf(Word) + SizeOf(Byte));
    Result^.PacketType := Byte(APacketType);
    Result^.DataSize := ssData.Size;
    Move(ssData.Memory^, Result^.Data^, ssData.Size);
  finally
    ssData.Free;
  end;
end;

end.
