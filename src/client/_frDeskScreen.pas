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

procedure TfrDeskScreen.rp_DeskScreenIsReady(AJsonData: TJsonData);
begin
  TClientUnit.Obj.DeskUnZip.GetBitmap(Image.Picture.Bitmap);
  Image.Width  := TClientUnit.Obj.DeskUnZip.Width;
  Image.Height := TClientUnit.Obj.DeskUnZip.Height;

  // TODO: Bitmap이 화면보다 큰 경우 처리
end;

end.