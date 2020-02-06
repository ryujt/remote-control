unit _frDeskScreen;

interface

uses
  FrameBase, JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrDeskScreen = class(TFrame, IFrameBase)
    ScrollBox: TScrollBox;
    Image: TImage;
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_DeskScreenIsReady(AJsonData:TJsonData);
  end;

implementation

uses
  Core, ClientUnit;

{$R *.dfm}

{ TfrDeskScreen }

procedure TfrDeskScreen.AfterShow;
begin

end;

procedure TfrDeskScreen.BeforeShow;
begin

end;

procedure TfrDeskScreen.BeforeClose;
begin

end;

constructor TfrDeskScreen.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrDeskScreen.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrDeskScreen.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft   : TClientUnit.Obj.sp_MouseDown(MOUSEEVENTF_LEFTDOWN, X, Y);
    mbMiddle : TClientUnit.Obj.sp_MouseDown(MOUSEEVENTF_MIDDLEDOWN, X, Y);
    mbRight  : TClientUnit.Obj.sp_MouseDown(MOUSEEVENTF_RIGHTDOWN, X, Y);
  end;
end;

procedure TfrDeskScreen.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  TClientUnit.Obj.sp_MouseMove(X, Y);
end;

procedure TfrDeskScreen.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft   : TClientUnit.Obj.sp_MouseUp(MOUSEEVENTF_LEFTUP, X, Y);
    mbMiddle : TClientUnit.Obj.sp_MouseUp(MOUSEEVENTF_MIDDLEUP, X, Y);
    mbRight  : TClientUnit.Obj.sp_MouseUp(MOUSEEVENTF_RIGHTUP, X, Y);
  end;
end;

procedure TfrDeskScreen.rp_DeskScreenIsReady(AJsonData: TJsonData);
begin
  TClientUnit.Obj.DeskUnZip.GetBitmap(Image.Picture.Bitmap);
  Image.Width  := TClientUnit.Obj.DeskUnZip.Width;
  Image.Height := TClientUnit.Obj.DeskUnZip.Height;

  // TODO: Bitmap이 화면보다 큰 경우 처리
end;

end.

  PACKET_MOUSE_MOVE       = MOUSEEVENTF_MOVE;
  PACKET_MOUSE_LEFTDOWN   = MOUSEEVENTF_LEFTDOWN;
  PACKET_MOUSE_LEFTUP     = MOUSEEVENTF_LEFTUP;
  PACKET_MOUSE_RIGHTDOWN  = MOUSEEVENTF_RIGHTDOWN;
  PACKET_MOUSE_RIGHTUP    = MOUSEEVENTF_RIGHTUP;
  PACKET_MOUSE_MIDDLEDOWN = MOUSEEVENTF_MIDDLEDOWN;
  PACKET_MOUSE_MIDDLEUP   = MOUSEEVENTF_MIDDLEUP;
  PACKET_MOUSE_WHEEL      = MOUSEEVENTF_WHEEL;