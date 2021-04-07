object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Figure 1.1: '#1044#1080#1085#1072#1084#1080#1095#1077#1089#1082#1072#1103' '#1088#1072#1073#1086#1090#1072' '#1089' '#1076#1077#1088#1077#1074#1086#1084
  ClientHeight = 393
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  OnCreate = FormCreate
  DesignSize = (
    529
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object VT: TVirtualStringTree
    Left = 184
    Top = 8
    Width = 337
    Height = 377
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoHotTrack, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    TabOrder = 0
    TreeOptions.AnimationOptions = [toAnimatedToggle]
    TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toExtendedFocus, toMiddleClickSelect, toRightClickSelect]
    OnGetText = VTGetText
    Columns = <
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 0
        Width = 183
        WideText = #1048#1084#1103
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 1
        Width = 150
        WideText = #1058#1077#1083#1077#1092#1086#1085
      end>
  end
  object GbElement: TGroupBox
    Left = 8
    Top = 8
    Width = 170
    Height = 121
    Caption = #1069#1083#1077#1084#1077#1085#1090
    TabOrder = 1
    object LblName: TLabel
      Left = 16
      Top = 16
      Width = 23
      Height = 13
      Caption = '&'#1048#1084#1103':'
      FocusControl = EdName
    end
    object LblPhone: TLabel
      Left = 16
      Top = 62
      Width = 48
      Height = 13
      Caption = '&'#1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EdPhone
    end
    object EdName: TEdit
      Left = 16
      Top = 35
      Width = 137
      Height = 21
      TabOrder = 0
      Text = #1053#1086#1074#1099#1081' '#1082#1086#1085#1090#1072#1082#1090
    end
    object EdPhone: TEdit
      Left = 16
      Top = 81
      Width = 137
      Height = 21
      TabOrder = 1
      Text = 'xxx-xx-xx'
    end
  end
  object BtnAdd: TButton
    Left = 8
    Top = 135
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = BtnAddClick
  end
  object BtnEdit: TButton
    Left = 8
    Top = 166
    Width = 170
    Height = 25
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 3
    OnClick = BtnEditClick
  end
  object GbOther: TGroupBox
    Left = 8
    Top = 197
    Width = 170
    Height = 188
    Anchors = [akLeft, akTop, akBottom]
    Caption = #1044#1088#1091#1075#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
    TabOrder = 4
    object LblCopy: TLabel
      Left = 16
      Top = 167
      Width = 84
      Height = 13
      Caption = #169' Quadr0, 2006.'
      Enabled = False
      Transparent = True
    end
    object BtnInsertBefore: TButton
      Left = 16
      Top = 24
      Width = 137
      Height = 25
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1087#1086#1074#1077#1088#1093
      TabOrder = 0
      OnClick = BtnInsertBeforeClick
    end
    object BtnInsertAfter: TButton
      Left = 16
      Top = 55
      Width = 137
      Height = 25
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1087#1086#1089#1083#1077
      TabOrder = 1
      OnClick = BtnInsertAfterClick
    end
    object BtnChildFirst: TButton
      Left = 16
      Top = 86
      Width = 137
      Height = 35
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1087#1077#1088#1074#1099#1084' '#1074' '#1088#1086#1076#1080#1090#1077#1083#1103
      TabOrder = 2
      WordWrap = True
      OnClick = BtnChildFirstClick
    end
    object BtnChildLast: TButton
      Left = 16
      Top = 127
      Width = 137
      Height = 34
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1080#1084' '#1074' '#1088#1086#1076#1080#1090#1077#1083#1103
      TabOrder = 3
      WordWrap = True
      OnClick = BtnChildLastClick
    end
  end
  object BtnDelete: TButton
    Left = 89
    Top = 135
    Width = 89
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = BtnDeleteClick
  end
  object PopupMenu: TPopupMenu
    Left = 8
    Top = 8
    object mEntry: TMenuItem
      Caption = #1042#1077#1089#1100' '#1091#1079#1077#1083
      OnClick = mEntryClick
    end
    object mChildren: TMenuItem
      Caption = #1058#1086#1083#1100#1082#1086' '#1076#1086#1095#1077#1088#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      OnClick = mChildrenClick
    end
  end
end
