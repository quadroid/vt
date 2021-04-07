object frmNode: TfrmNode
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' TVirtualNode'
  ClientHeight = 561
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LblIndex: TLabel
    Left = 208
    Top = 271
    Width = 32
    Height = 13
    Caption = '&Index:'
    FocusControl = EdIndex
    Transparent = True
  end
  object LblChildCount: TLabel
    Left = 208
    Top = 317
    Width = 59
    Height = 13
    Caption = '&Child Count:'
    FocusControl = EdChildCount
    Transparent = True
  end
  object LblNodeHeight: TLabel
    Left = 208
    Top = 363
    Width = 63
    Height = 13
    Caption = '&Node Height:'
    FocusControl = EdNodeHeight
    Transparent = True
  end
  object LblName: TLabel
    Left = 17
    Top = 509
    Width = 31
    Height = 13
    Caption = 'N&ame:'
    FocusControl = EdName
    Transparent = True
  end
  object LblAlign: TLabel
    Left = 17
    Top = 271
    Width = 27
    Height = 13
    Caption = 'A&lign:'
    FocusControl = EdAlign
    Transparent = True
  end
  object LblTotalCount: TLabel
    Left = 17
    Top = 317
    Width = 60
    Height = 13
    Caption = '&Total Count:'
    FocusControl = EdTotalCount
    Transparent = True
  end
  object LblTotalHeight: TLabel
    Left = 17
    Top = 363
    Width = 62
    Height = 13
    Caption = 'Total Height:'
    FocusControl = EdTotalHeight
    Transparent = True
  end
  object Bvl: TBevel
    Left = 17
    Top = 409
    Width = 378
    Height = 2
    Shape = bsTopLine
  end
  object LblPrevSibling: TLabel
    Left = 17
    Top = 417
    Width = 56
    Height = 13
    Caption = 'PrevSibling:'
    FocusControl = EdPrevSibling
    Transparent = True
  end
  object LblNextSibling: TLabel
    Left = 208
    Top = 417
    Width = 57
    Height = 13
    Caption = 'NextSibling:'
    FocusControl = EdNextSibling
    Transparent = True
  end
  object LblFirstChild: TLabel
    Left = 17
    Top = 463
    Width = 48
    Height = 13
    Caption = 'FirstChild:'
    FocusControl = EdFirstChild
    Transparent = True
  end
  object LblLastChild: TLabel
    Left = 208
    Top = 463
    Width = 47
    Height = 13
    Caption = 'LastChild:'
    Transparent = True
  end
  object LblParent: TLabel
    Left = 208
    Top = 509
    Width = 36
    Height = 13
    Caption = 'Parent:'
    Transparent = True
  end
  object EdIndex: TEdit
    Left = 208
    Top = 290
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 0
  end
  object EdChildCount: TEdit
    Left = 208
    Top = 336
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 1
    OnChange = CbDisabledClick
  end
  object EdNodeHeight: TEdit
    Left = 206
    Top = 382
    Width = 187
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 2
  end
  object GbStates: TGroupBox
    Left = 17
    Top = 11
    Width = 185
    Height = 254
    Caption = 'States'
    TabOrder = 3
    object CbInitialized: TCheckBox
      Left = 23
      Top = 24
      Width = 146
      Height = 17
      Caption = 'Initialized'
      TabOrder = 0
      OnClick = CbInitializedClick
    end
    object CbChecking: TCheckBox
      Left = 23
      Top = 39
      Width = 146
      Height = 17
      Caption = 'Checking'
      TabOrder = 1
      OnClick = CbInitializedClick
    end
    object CbClipboard: TCheckBox
      Left = 23
      Top = 54
      Width = 146
      Height = 17
      Caption = 'Cut or Copy'
      TabOrder = 2
      OnClick = CbInitializedClick
    end
    object CbDisabled: TCheckBox
      Left = 23
      Top = 69
      Width = 146
      Height = 17
      Caption = 'Disabled'
      TabOrder = 3
      OnClick = CbDisabledClick
    end
    object CbDeleting: TCheckBox
      Left = 23
      Top = 84
      Width = 146
      Height = 17
      Caption = 'Deleting'
      TabOrder = 4
      OnClick = CbInitializedClick
    end
    object CbExpanded: TCheckBox
      Left = 23
      Top = 99
      Width = 146
      Height = 17
      Caption = 'Expanded'
      TabOrder = 5
      OnClick = CbDisabledClick
    end
    object CbHasChildren: TCheckBox
      Left = 23
      Top = 114
      Width = 146
      Height = 17
      Caption = 'Has Children'
      TabOrder = 6
      OnClick = CbInitializedClick
    end
    object CbVisible: TCheckBox
      Left = 23
      Top = 129
      Width = 58
      Height = 17
      Caption = 'Visible'
      TabOrder = 7
      OnClick = CbDisabledClick
    end
    object BtnShowAll: TButton
      Left = 94
      Top = 129
      Width = 75
      Height = 16
      Caption = 'Show All'
      TabOrder = 8
      OnClick = BtnShowAllClick
    end
    object CbSelected: TCheckBox
      Left = 23
      Top = 145
      Width = 145
      Height = 17
      Caption = 'Selected'
      TabOrder = 9
      OnClick = CbDisabledClick
    end
    object CbAllHidden: TCheckBox
      Left = 23
      Top = 160
      Width = 146
      Height = 17
      Caption = 'All Children Hidden'
      TabOrder = 10
      OnClick = CbInitializedClick
    end
    object CbClearing: TCheckBox
      Left = 23
      Top = 176
      Width = 145
      Height = 17
      Caption = 'Clearing'
      TabOrder = 11
      OnClick = CbInitializedClick
    end
    object CbMultiline: TCheckBox
      Left = 23
      Top = 193
      Width = 145
      Height = 17
      Caption = 'Multiline'
      TabOrder = 12
      OnClick = CbDisabledClick
    end
    object CbHeightMeasured: TCheckBox
      Left = 23
      Top = 208
      Width = 145
      Height = 17
      Caption = 'Height Measured'
      TabOrder = 13
      OnClick = CbInitializedClick
    end
    object CbToggling: TCheckBox
      Left = 23
      Top = 224
      Width = 145
      Height = 17
      Caption = 'Toggling'
      TabOrder = 14
      OnClick = CbInitializedClick
    end
  end
  object EdName: TEdit
    Left = 17
    Top = 528
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 4
  end
  object GbCheck: TGroupBox
    Left = 208
    Top = 11
    Width = 185
    Height = 131
    Caption = 'Check States'
    TabOrder = 5
    object RbUnCheckedNormal: TRadioButton
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'UnCheckedNormal'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = CbDisabledClick
    end
    object RbUnCheckedPressed: TRadioButton
      Left = 16
      Top = 39
      Width = 153
      Height = 17
      Caption = 'UnCheckedPressed'
      TabOrder = 1
      OnClick = CbDisabledClick
    end
    object RbCheckedPressed: TRadioButton
      Left = 16
      Top = 69
      Width = 153
      Height = 17
      Caption = 'CheckedPressed'
      TabOrder = 2
      OnClick = CbDisabledClick
    end
    object RbCheckedNormal: TRadioButton
      Left = 16
      Top = 54
      Width = 153
      Height = 17
      Caption = 'CheckedNormal'
      TabOrder = 3
      OnClick = CbDisabledClick
    end
    object RbMixedPressed: TRadioButton
      Left = 16
      Top = 99
      Width = 153
      Height = 17
      Caption = 'MixedPressed'
      TabOrder = 4
      OnClick = CbDisabledClick
    end
    object RbMixedNormal: TRadioButton
      Left = 16
      Top = 84
      Width = 153
      Height = 17
      Caption = 'MixedNormal'
      TabOrder = 5
      OnClick = CbDisabledClick
    end
  end
  object EdAlign: TEdit
    Left = 17
    Top = 290
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
    OnChange = CbDisabledClick
  end
  object EdTotalCount: TEdit
    Left = 17
    Top = 336
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 7
  end
  object EdTotalHeight: TEdit
    Left = 17
    Top = 382
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 8
  end
  object GbType: TGroupBox
    Left = 208
    Top = 148
    Width = 185
    Height = 117
    Caption = 'Check Type'
    TabOrder = 9
    object RbNone: TRadioButton
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'None'
      TabOrder = 0
      OnClick = CbDisabledClick
    end
    object RbTriStateCheckBox: TRadioButton
      Left = 16
      Top = 40
      Width = 153
      Height = 17
      Caption = 'TriStateCheckBox'
      TabOrder = 1
      OnClick = CbDisabledClick
    end
    object RbCheckBox: TRadioButton
      Left = 16
      Top = 56
      Width = 113
      Height = 17
      Caption = 'CheckBox'
      TabOrder = 2
      OnClick = CbDisabledClick
    end
    object RbRadio: TRadioButton
      Left = 16
      Top = 71
      Width = 113
      Height = 17
      Caption = 'RadioButton'
      TabOrder = 3
      OnClick = CbDisabledClick
    end
    object RbButton: TRadioButton
      Left = 16
      Top = 86
      Width = 113
      Height = 17
      Caption = 'Button'
      TabOrder = 4
      OnClick = CbDisabledClick
    end
  end
  object EdPrevSibling: TEdit
    Left = 17
    Top = 436
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 10
  end
  object EdNextSibling: TEdit
    Left = 206
    Top = 436
    Width = 187
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 11
  end
  object EdFirstChild: TEdit
    Left = 17
    Top = 482
    Width = 185
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 12
  end
  object EdLastChild: TEdit
    Left = 208
    Top = 482
    Width = 187
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 13
  end
  object EdParent: TEdit
    Left = 208
    Top = 528
    Width = 187
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 14
  end
end
