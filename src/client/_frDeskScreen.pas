unit _frDeskScreen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrDeskScreen = class(TFrame)
    ScrollBox: TScrollBox;
    Image: TImage;
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure on_DeskScreenIsReady(ASender:TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  RemoteClient;

{$R *.dfm}

{ TfrDeskScreen }

constructor TfrDeskScreen.Create(AOwner: TComponent);
begin
  inherited;

  TRemoteClient.Obj.OnDeskScreenIsReady := on_DeskScreenIsReady;
end;

destructor TfrDeskScreen.Destroy;
begin

  inherited;
end;

procedure TfrDeskScreen.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:   TRemoteClient.Obj.sp_MouseDown(MOUSEEVENTF_LEFTDOWN,   X, Y);
    mbMiddle: TRemoteClient.Obj.sp_MouseDown(MOUSEEVENTF_MIDDLEDOWN, X, Y);
    mbRight:  TRemoteClient.Obj.sp_MouseDown(MOUSEEVENTF_RIGHTDOWN,  X, Y);
  end;
end;

procedure TfrDeskScreen.ImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  TRemoteClient.Obj.sp_MouseMove(X, Y);
end;

procedure TfrDeskScreen.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:   TRemoteClient.Obj.sp_MouseUp(MOUSEEVENTF_LEFTUP,   X, Y);
    mbMiddle: TRemoteClient.Obj.sp_MouseUp(MOUSEEVENTF_MIDDLEUP, X, Y);
    mbRight:  TRemoteClient.Obj.sp_MouseUp(MOUSEEVENTF_RIGHTUP,  X, Y);
  end;
end;

procedure TfrDeskScreen.on_DeskScreenIsReady(ASender: TObject);
begin
  TRemoteClient.Obj.GetBitmap(Image.Picture.Bitmap);
  Image.Width := TRemoteClient.Obj.Width;
  Image.Height := TRemoteClient.Obj.Height;

  // TODO: Bitmap이 화면보다 큰 경우 처리
end;

end.
