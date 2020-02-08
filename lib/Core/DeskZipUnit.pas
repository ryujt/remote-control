unit DeskZipUnit;

interface

uses
  Config, ClientUnitInterface,
  DeskZipUtils, DeskZip,
  DebugTools, RyuLibBase, Scheduler,
  SuperSocketClient,
  Windows, SysUtils, Classes, Graphics, Forms;

const
  TASK_PREPARE = 1;
  TASK_EXECUTE = 2;

type
  TDeskZipUnit = class
  private
    FSocket: IClientUnitInterface;
    FDeskZip: TDeskZip;
  private
    FScheduler: TScheduler;
    procedure on_DeskZip_repeat(Sender: TObject);
    procedure on_DeskZip_task(Sender: TObject; ATask: integer; AText: string;
      AData: pointer; ASize: integer; ATag: integer);

    procedure do_prepare(AMonitorIndex: integer);
    procedure do_execute;
  public
    constructor Create(ASocket: IClientUnitInterface); reintroduce;
    destructor Destroy; override;

    procedure Terminate;

    procedure Prepare(AMonitorIndex: integer);
    procedure Execute;
  end;

implementation

{ TDeskZipUnit }

constructor TDeskZipUnit.Create(ASocket: IClientUnitInterface);
begin
  FSocket := ASocket;

  FDeskZip := TDeskZip.Create;
  FDeskZip.setSpeed(SPEED_FAST);

  FScheduler := TScheduler.Create;
  FScheduler.OnRepeat := on_DeskZip_repeat;
  FScheduler.OnTask := on_DeskZip_task;
end;

destructor TDeskZipUnit.Destroy;
begin
  FreeAndNil(FDeskZip);
  FreeAndNil(FScheduler);

  inherited;
end;

procedure TDeskZipUnit.do_execute;
var
  frame: PFrameBase;
begin
  FDeskZip.Execute(0, 0);
  frame := FDeskZip.GetDeskFrame;
  while frame <> nil do
  begin
    FSocket.Send(pointer(frame));
    frame := FDeskZip.GetDeskFrame;
  end;

  FSocket.sp_AskDeskZip;
end;

procedure TDeskZipUnit.do_prepare(AMonitorIndex: integer);
begin
  FDeskZip.Prepare(Screen.Monitors[AMonitorIndex].Width,
    Screen.Monitors[AMonitorIndex].Height);
end;

procedure TDeskZipUnit.Execute;
begin
  FScheduler.Add(TASK_EXECUTE);
end;

procedure TDeskZipUnit.on_DeskZip_repeat(Sender: TObject);
begin
  //
end;

procedure TDeskZipUnit.on_DeskZip_task(Sender: TObject; ATask: integer;
  AText: string; AData: pointer; ASize, ATag: integer);
begin
  case ATask of
    TASK_PREPARE:
      do_prepare(ATag);
    TASK_EXECUTE:
      do_execute;
  end;
end;

procedure TDeskZipUnit.Prepare(AMonitorIndex: integer);
begin
  FScheduler.Add(TASK_PREPARE, '', nil, 0, AMonitorIndex);
end;

procedure TDeskZipUnit.Terminate;
begin
  FScheduler.TerminateNow;
end;

end.
