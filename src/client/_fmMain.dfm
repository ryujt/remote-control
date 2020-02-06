object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'RemoteControl - Client'
  ClientHeight = 729
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 135
    Top = 6
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  inline frDeskScreen1: TfrDeskScreen
    Left = 8
    Top = 35
    Width = 992
    Height = 686
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 35
    ExplicitWidth = 992
    ExplicitHeight = 686
    inherited ScrollBox: TScrollBox
      Width = 992
      Height = 686
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 992
      ExplicitHeight = 686
    end
  end
end
