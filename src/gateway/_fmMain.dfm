object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Remote control - Gateway'
  ClientHeight = 44
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object tmClose: TTimer
    Enabled = False
    OnTimer = tmCloseTimer
    Left = 24
    Top = 8
  end
end
