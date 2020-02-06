object frDeskScreen: TfrDeskScreen
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    TabOrder = 0
    object Image: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      AutoSize = True
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
      OnMouseUp = ImageMouseUp
    end
  end
end
