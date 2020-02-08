unit DeskUnZipUnit;

interface

uses
  Config, ClientUnitInterface,
  DeskZipUtils, DeskUnZip,
  DebugTools, RyuLibBase, SuperSocketUtils, Scheduler,
  Windows, SysUtils, Classes, Graphics;

const
  TASK_DESKZIP = 1;

type
  TDeskUnZipUnit = class
  private
    FSocket: IClientUnitInterface;
    FDeskUnZip: TDeskUnZip;
  private
    FScheduler: TScheduler;
    procedure on_DeskUnZip_repeat(Sender: TObject);
    procedure on_DeskZip_task(Sender: TObject; ATask: integer; AText: string;
      AData: pointer; ASize: integer; ATag: integer);

    procedure do_execute(APacket: PPacket);
  private
    function GetBitmapHeight: integer;
    function getBitmapWidth: integer;
    function GetHeight: integer;
    function GetWidth: integer;
  public
    constructor Create(ASocket: IClientUnitInterface); reintroduce;
    destructor Destroy; override;

    procedure Terminate;

    procedure Execute(APacket: PPacket);

    procedure GetBitmap(ABitmap: TBitmap);
  public
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;

    property BitmapWidth: integer read getBitmapWidth;
    property BitmapHeight: integer read GetBitmapHeight;
  end;

implementation

uses
  Core;

{ TDeskUnZipUnit }

constructor TDeskUnZipUnit.Create(ASocket: IClientUnitInterface);
begin
  FSocket := ASocket;

  FDeskUnZip := TDeskUnZip.Create;

  FScheduler := TScheduler.Create;
  FScheduler.OnTask := on_DeskZip_task;
  FScheduler.OnRepeat := on_DeskUnZip_repeat;
end;

destructor TDeskUnZipUnit.Destroy;
begin
  FreeAndNil(FDeskUnZip);
  FreeAndNil(FScheduler);

  inherited;
end;

procedure TDeskUnZipUnit.do_execute(APacket: PPacket);
begin
  try
    FDeskUnZip.Execute(pointer(APacket));
    if APacket^.PacketType = Byte(ftFrameEnd) then TCore.Obj.View.sp_DeskScreenIsReady;
  finally
    FreeMem(APacket);
  end;
end;

procedure TDeskUnZipUnit.Execute(APacket: PPacket);
begin
  FScheduler.Add(TASK_DESKZIP, APacket^.Clone);
end;

procedure TDeskUnZipUnit.GetBitmap(ABitmap: TBitmap);
begin
  FDeskUnZip.GetBitmap(ABitmap);
end;

function TDeskUnZipUnit.GetBitmapHeight: integer;
begin
  Result := FDeskUnZip.BitmapHeight;
end;

function TDeskUnZipUnit.getBitmapWidth: integer;
begin
  Result := FDeskUnZip.BitmapWidth;
end;

function TDeskUnZipUnit.GetHeight: integer;
begin
  Result := FDeskUnZip.Height;
end;

function TDeskUnZipUnit.GetWidth: integer;
begin
  Result := FDeskUnZip.Width;
end;

procedure TDeskUnZipUnit.on_DeskUnZip_repeat(Sender: TObject);
begin

end;

procedure TDeskUnZipUnit.on_DeskZip_task(Sender: TObject; ATask: integer;
  AText: string; AData: pointer; ASize, ATag: integer);
begin
  case ATask of
    TASK_DESKZIP: do_execute(AData);
  end;
end;

procedure TDeskUnZipUnit.Terminate;
begin
  FScheduler.TerminateNow;
end;

end.
