object InspectVariableForm: TInspectVariableForm
  Left = 306
  Top = 202
  Caption = 'Variable Name'
  ClientHeight = 262
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object VariableValueMemo: TMemo
    Left = 0
    Top = 0
    Width = 284
    Height = 262
    Align = alClient
    Lines.Strings = (
      'Variable Value')
    ReadOnly = True
    TabOrder = 0
  end
end
