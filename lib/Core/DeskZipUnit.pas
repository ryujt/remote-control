unit DeskZipUnit;

interface

uses
  Config,
  DeskZipUtils, DeskZip,
  DebugTools, RyuLibBase, Scheduler, DynamicQueue, SuperSocketUtils, SuperSocketClient,
  Windows, SysUtils, Classes, Graphics;

const
  TASK_EXECUTE = 1;

type
  TDeskZipUnit = class
  private
    FSocket : TSuperSocketClient;
    FDeskZip : TDeskZip;
  private
    FScheduler : TScheduler;
    procedure on_DeskZip_repeat(Sender:TObject);
    procedure on_DeskZip_task(Sender:TObject; ATask:integer; AText:string; AData:pointer; ASize:integer; ATag:integer);

    procedure do_execute;
  public
    constructor Create(ASocket:TSuperSocketClient); reintroduce;
    destructor Destroy; override;

    procedure Terminate;

    procedure Prepare(AWidth,AHeight:integer);
    procedure Execute;
  end;

implementation

{ TDeskZipUnit }

constructor TDeskZipUnit.Create(ASocket: TSuperSocketClient);
begin
  FSocket := ASocket;

  FDeskZip := TDeskZip.Create;

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
  frame : PFrameBase;
begin
  FDeskZip.Execute(0, 0);
  frame := FDeskZip.GetDeskFrame;
  while frame <> nil do begin
    FSocket.Send( Pointer(frame) );
    frame := FDeskZip.GetDeskFrame;
  end;
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
    TASK_EXECUTE: do_execute;
  end;
end;

procedure TDeskZipUnit.Prepare(AWidth, AHeight: integer);
begin
  FDeskZip.Prepare(AWidth, AHeight);
end;

procedure TDeskZipUnit.Terminate;
begin
  FScheduler.TerminateNow;
end;

end.
