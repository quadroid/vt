object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Figure 1.3: Drag&Drop'
  ClientHeight = 487
  ClientWidth = 587
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
  PixelsPerInch = 96
  TextHeight = 13
  object LblCopy: TLabel
    Left = 493
    Top = 335
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Caption = #169' Quadr0, 2006.'
    Enabled = False
    Transparent = True
  end
  object VT: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 281
    Height = 321
    ClipboardFormats.Strings = (
      'CSV'
      'HTML Format'
      'Plain text'
      'Rich Text Format'
      'Rich Text Format Without Objects'
      'Unicode text')
    DragMode = dmAutomatic
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toMultiSelect]
    OnDragOver = VTDragOver
    OnDragDrop = VTDragDrop
    OnGetText = VTGetText
    OnInitNode = VTInitNode
    OnNewText = VTNewText
    Columns = <>
  end
  object VT2: TVirtualStringTree
    Left = 295
    Top = 8
    Width = 281
    Height = 321
    DragOperations = [doCopy, doMove, doLink]
    DragType = dtVCL
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toMultiSelect]
    OnDragAllowed = VTDragAllowed
    OnDragOver = VTDragOver
    OnDragDrop = VTDragDrop
    OnGetText = VTGetText
    OnInitNode = VTInitNode
    OnNewText = VTNewText
    Columns = <>
  end
  object RichEdit: TRichEdit
    Left = 8
    Top = 354
    Width = 281
    Height = 122
    HideScrollBars = False
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object ListBox: TListBox
    Left = 295
    Top = 354
    Width = 282
    Height = 123
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 3
  end
  object ActionList: TActionList
    Left = 16
    Top = 360
    object actCopy: TAction
      ShortCut = 16451
      OnExecute = BtnCopyClick
    end
    object actCut: TAction
      ShortCut = 16472
      OnExecute = BtnCutClick
    end
    object actPaste: TAction
      ShortCut = 16470
      OnExecute = BtnPasteClick
    end
  end
end
