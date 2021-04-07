object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Figure 1.0: '#1048#1085#1080#1094#1080#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1077#1088#1077#1074#1072
  ClientHeight = 401
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  DesignSize = (
    409
    401)
  PixelsPerInch = 96
  TextHeight = 13
  object LblCopy: TLabel
    Left = 317
    Top = 20
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #169' Quadr0, 2006.'
    Enabled = False
    Transparent = True
  end
  object VT: TVirtualStringTree
    Left = 8
    Top = 39
    Width = 393
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoHotTrack, hoRestrictDrag, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    OnGetText = VTGetText
    Columns = <
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 0
        Width = 239
        WideText = #1048#1084#1103
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 1
        Width = 150
        WideText = #1058#1077#1083#1077#1092#1086#1085
      end>
  end
  object BtnLoad: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = #1047'&'#1072#1075#1088#1091#1079#1080#1090#1100
    Default = True
    TabOrder = 1
    OnClick = BtnLoadClick
  end
  object BtnClear: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = '&'#1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
    OnClick = BtnClearClick
  end
end
