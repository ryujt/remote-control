unit ClientUnitInterface;

interface

uses
  SuperSocketUtils,
  SysUtils, Classes;

type
  IClientUnitInterface = interface
    ['{3794125B-BEDF-482D-ADCA-1A75042D060F}']

     procedure Send(APacket:PPacket);

    procedure sp_SetConnectionID(AID: integer);
    procedure sp_AskDeskZip;

    procedure sp_MouseDown(AMode, AX, AY: integer);
    procedure sp_MouseMove(AX, AY: integer);
    procedure sp_MouseUp(AMode, AX, AY: integer);

    procedure sp_KeyDown(AKey: integer);
    procedure sp_KeyUp(AKey: integer);
  end;

implementation

end.
