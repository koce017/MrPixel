object RealSizeForm: TRealSizeForm
  Left = 277
  Top = 160
  BorderStyle = bsToolWindow
  ClientHeight = 85
  ClientWidth = 116
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RealSizePaintBox: TPaintBox
    Left = 0
    Top = 0
    Width = 116
    Height = 85
    Align = alClient
    OnPaint = RealSizePaintBoxPaint
    ExplicitWidth = 135
  end
end
