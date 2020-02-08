unit Config;

interface

uses
  Disk;

const
  MEMORY_POOL_SIZE_32 = 1024 * 1024 * 512;
  MEMORY_POOL_SIZE_64 = 1024 * 1024 * 1024;

var
  Gateway_Host : string = '127.0.0.1';
  Gateway_Port : integer = 8282;

implementation

initialization
  Gateway_Host := IniString (GetExecPath+'Options.ini', 'Server', 'Host', '127.0.0.1');
  Gateway_Port := IniInteger(GetExecPath+'Options.ini', 'Server', 'Port', 8282);
end.
