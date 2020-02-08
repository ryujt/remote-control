object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #49436#48260' '#51217#49549' '#51473
  ClientHeight = 121
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 121
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 92
    ExplicitTop = 16
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label1: TLabel
      Left = 16
      Top = 25
      Width = 44
      Height = 13
      Caption = #51217#49549#53076#46300
    end
    object edCode: TEdit
      Left = 16
      Top = 44
      Width = 285
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object tmClose: TTimer
    Enabled = False
    OnTimer = tmCloseTimer
    Left = 260
    Top = 4
  end
end
