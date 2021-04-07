object frmMain: TfrmMain
  Left = 0
  Top = 0
  Width = 497
  Height = 427
  Caption = 'Figure 1.4: IVTEditLink'
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
    489
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object LblCopy: TLabel
    Left = 397
    Top = 8
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #169' 2006, Quadr0.'
    Enabled = False
    Transparent = True
  end
  object VT: TVirtualStringTree
    Left = 8
    Top = 27
    Width = 473
    Height = 358
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultNodeHeight = 21
    EditDelay = 0
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible, hoAutoSpring]
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toEditable, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
    TreeOptions.StringOptions = [toAutoAcceptEditChange]
    OnChange = VTChange
    OnCreateEditor = VTCreateEditor
    OnEditing = VTEditing
    OnGetText = VTGetText
    OnPaintText = VTPaintText
    OnNewText = VTNewText
    Columns = <
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 0
        Width = 234
        WideText = #1055#1072#1088#1072#1084#1077#1090#1088
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
        Position = 1
        Width = 235
        WideText = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
  end
end
