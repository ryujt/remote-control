object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Remote control - '#49436#48260' '#51217#49549' '#51473
  ClientHeight = 729
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  inline frDeskScreen: TfrDeskScreen
    Left = 0
    Top = 37
    Width = 1008
    Height = 692
    Align = alClient
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitTop = 37
    ExplicitWidth = 1008
    ExplicitHeight = 692
    inherited ScrollBox: TScrollBox
      Width = 1008
      Height = 692
      ExplicitWidth = 1008
      ExplicitHeight = 692
    end
  end
  object plTop: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object btConnect: TButton
      Left = 135
      Top = 6
      Width = 75
      Height = 25
      Caption = #50672#44208
      TabOrder = 0
      OnClick = btConnectClick
    end
    object edCode: TEdit
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object tmClose: TTimer
    Enabled = False
    OnTimer = tmCloseTimer
    Left = 24
    Top = 64
  end
end
