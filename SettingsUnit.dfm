object SettingsForm: TSettingsForm
  Left = 587
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 169
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    294
    169)
  PixelsPerInch = 96
  TextHeight = 13
  object PixelsPerQuadrantLabel: TLabel
    Left = 8
    Top = 40
    Width = 90
    Height = 13
    Caption = 'Pixels per quadrant'
  end
  object TimesLabel: TLabel
    Left = 48
    Top = 62
    Width = 16
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'x'
    Layout = tlCenter
  end
  object FontLabel: TLabel
    Left = 133
    Top = 63
    Width = 50
    Height = 13
    Caption = 'Font name'
  end
  object FontSizeLabel: TLabel
    Left = 133
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Font size'
  end
  object OriginLabel: TLabel
    Left = 8
    Top = 97
    Width = 27
    Height = 13
    Caption = 'Origin'
  end
  object PixelsPerQuadrantEdit: TEdit
    Left = 8
    Top = 59
    Width = 40
    Height = 21
    TabOrder = 0
    Text = '20'
    OnChange = PixelsPerQuadrantEditChange
    OnKeyPress = AllowOnlyNumbersKeyPress
  end
  object PixelsPerQuadrantFakeEdit: TEdit
    Left = 64
    Top = 59
    Width = 40
    Height = 21
    TabStop = False
    Enabled = False
    TabOrder = 4
    Text = '20'
  end
  object OkSettingsButton: TButton
    Left = 211
    Top = 136
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 3
    OnClick = OkSettingsButtonClick
  end
  object FontNameCombo: TComboBox
    Left = 133
    Top = 82
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object FontSizeEdit: TEdit
    Left = 133
    Top = 27
    Width = 40
    Height = 21
    TabOrder = 1
    OnKeyPress = AllowOnlyNumbersKeyPress
  end
  object TopLeftRadio: TRadioButton
    Left = 8
    Top = 138
    Width = 113
    Height = 17
    Caption = 'Top-left corner'
    TabOrder = 5
  end
  object CenterRadio: TRadioButton
    Left = 8
    Top = 115
    Width = 113
    Height = 17
    Caption = 'Center'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object RealSizeCheckBox: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Real size'
    TabOrder = 7
    OnClick = RealSizeCheckBoxClick
  end
end
