object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 265
  ClientWidth = 369
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
  object GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 249
    TabOrder = 0
    object LblHintMode: TLabel
      Left = 11
      Top = 13
      Width = 49
      Height = 13
      Caption = 'HintMode:'
    end
    object LblHintAnimation: TLabel
      Left = 119
      Top = 13
      Width = 70
      Height = 13
      Caption = 'HintAnimation:'
    end
    object LblDrawSelectionMode: TLabel
      Left = 11
      Top = 59
      Width = 98
      Height = 13
      Caption = 'DrawSelectionMode:'
    end
    object LblButtonStyle: TLabel
      Left = 119
      Top = 59
      Width = 60
      Height = 13
      Caption = 'ButtonStyle:'
    end
    object LblNodeAlignment: TLabel
      Left = 227
      Top = 13
      Width = 72
      Height = 13
      Caption = 'NodeAlignment'
    end
    object LblAnimationDuration: TLabel
      Left = 11
      Top = 105
      Width = 92
      Height = 13
      Caption = 'AnimationDuration:'
    end
    object LblExpaandDelay: TLabel
      Left = 120
      Top = 105
      Width = 93
      Height = 13
      Caption = 'AutoExpand Delay:'
    end
    object LblScrollDelay: TLabel
      Left = 227
      Top = 105
      Width = 82
      Height = 13
      Caption = 'AutoScroll Delay:'
    end
    object LblScrollInterval: TLabel
      Left = 119
      Top = 197
      Width = 93
      Height = 13
      Caption = 'AutoScroll Interval:'
    end
    object LblCurveRadius: TLabel
      Left = 11
      Top = 151
      Width = 203
      Height = 13
      Caption = #1047#1072#1082#1088#1091#1075#1083#1080#1090#1100' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082' '#1074#1099#1076#1077#1083#1077#1085#1080#1103':'
    end
    object LblLineMode: TLabel
      Left = 227
      Top = 59
      Width = 49
      Height = 13
      Caption = 'LineMode:'
    end
    object LblIndent: TLabel
      Left = 11
      Top = 197
      Width = 41
      Height = 13
      Caption = #1054#1090#1089#1090#1091#1087':'
    end
    object LblLineStyle: TLabel
      Left = 239
      Top = 197
      Width = 67
      Height = 13
      Caption = #1051#1080#1085#1080#1080' '#1089#1077#1090#1082#1080':'
    end
    object CBoxHintMode: TComboBox
      Left = 11
      Top = 32
      Width = 102
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'hmDefault'
        'hmHint'
        'hmHintAndDefault'
        'hmTooltip')
    end
    object CBoxHintAnimation: TComboBox
      Left = 119
      Top = 32
      Width = 102
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'hatNone'
        'hatFade'
        'hatSlide'
        'hatSystemDefault')
    end
    object CBoxSelection: TComboBox
      Left = 11
      Top = 78
      Width = 102
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'smDottedRectangle'
        'smBlendedRectangle')
    end
    object CBoxButtonStyle: TComboBox
      Left = 119
      Top = 78
      Width = 102
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'bsRectangle'
        'bsTriangle')
    end
    object CBoxNodeAlignment: TComboBox
      Left = 227
      Top = 32
      Width = 114
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'naFromBottom'
        'naFromTop'
        'naProportional')
    end
    object EdAnimationDuration: TEdit
      Left = 11
      Top = 124
      Width = 102
      Height = 21
      TabOrder = 5
      OnChange = EdChangeDelayChange
    end
    object EdExpandDelay: TEdit
      Left = 119
      Top = 124
      Width = 102
      Height = 21
      TabOrder = 6
      OnChange = EdChangeDelayChange
    end
    object EdScrollDelay: TEdit
      Left = 227
      Top = 124
      Width = 114
      Height = 21
      TabOrder = 7
      OnChange = EdChangeDelayChange
    end
    object EdAutoScroll: TEdit
      Left = 119
      Top = 216
      Width = 102
      Height = 21
      TabOrder = 8
      OnChange = EdChangeDelayChange
    end
    object EdCurveRadius: TEdit
      Left = 11
      Top = 170
      Width = 330
      Height = 21
      TabOrder = 9
      OnChange = EdChangeDelayChange
    end
    object CBoxLineMode: TComboBox
      Left = 227
      Top = 78
      Width = 114
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 10
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'lmNormal'
        'lmBands')
    end
    object EdIndent: TEdit
      Left = 11
      Top = 216
      Width = 102
      Height = 21
      TabOrder = 11
      OnChange = EdChangeDelayChange
    end
    object CBoxLineStyle: TComboBox
      Left = 227
      Top = 216
      Width = 114
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 12
      OnChange = EdChangeDelayChange
      Items.Strings = (
        'lsCustomStyle'
        'lsDotted'
        'lsSolid')
    end
  end
end
