object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Figure 1.6: '#1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1080' '#1079#1072#1075#1088#1091#1079#1082#1072
  ClientHeight = 343
  ClientWidth = 539
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
    539
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object LblCopy: TLabel
    Left = 8
    Top = 322
    Width = 84
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #169' Quadr0, 2006.'
    Enabled = False
    Transparent = True
  end
  object VT: TVirtualStringTree
    Left = 8
    Top = 39
    Width = 523
    Height = 250
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toExtendedFocus]
    TreeOptions.StringOptions = [toAutoAcceptEditChange]
    OnGetText = VTGetText
    OnLoadNode = VTLoadNode
    OnNewText = VTNewText
    OnSaveNode = VTSaveNode
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = #1057#1090#1088#1086#1082#1072
      end
      item
        Position = 1
        Width = 200
        WideText = #1063#1080#1089#1083#1086
      end>
  end
  object BtnLoad: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 1
    OnClick = BtnLoadClick
  end
  object BtnSave: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = BtnSaveClick
  end
  object BtnClear: TButton
    Left = 375
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 3
    OnClick = BtnClearClick
  end
  object BtnFill: TButton
    Left = 456
    Top = 8
    Width = 75
    Height = 25
    Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 4
    OnClick = BtnFillClick
  end
  object BtnLoadXML: TButton
    Left = 170
    Top = 8
    Width = 95
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' (XML)'
    TabOrder = 5
    OnClick = BtnLoadXMLClick
  end
  object BtnSaveXML: TButton
    Left = 271
    Top = 8
    Width = 98
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' (XML)'
    TabOrder = 6
    OnClick = BtnSaveXMLClick
  end
  object BtnExportHTML: TButton
    Left = 8
    Top = 295
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1069#1082#1089#1087#1086#1088#1090' HTML'
    TabOrder = 7
    OnClick = BtnExportHTMLClick
  end
  object BtnExportRTF: TButton
    Left = 111
    Top = 295
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1069#1082#1089#1087#1086#1090#1088' RTF'
    TabOrder = 8
    OnClick = BtnExportRTFClick
  end
  object BtnExportANSI: TButton
    Left = 215
    Top = 295
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1069#1082#1089#1087#1086#1088#1090' ANSI'
    TabOrder = 9
    OnClick = BtnExportANSIClick
  end
  object BtnExportUNICODE: TButton
    Left = 319
    Top = 295
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1069#1082#1089#1087#1086#1088#1090' UNICODE'
    TabOrder = 10
    OnClick = BtnExportUNICODEClick
  end
  object BtnExportCSV: TButton
    Left = 423
    Top = 295
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1069#1082#1089#1087#1086#1090#1088' CSV'
    TabOrder = 11
    OnClick = BtnExportCSVClick
  end
end
