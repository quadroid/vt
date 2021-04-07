object frmNew: TfrmNew
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 217
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Gb: TGroupBox
    Left = 8
    Top = 8
    Width = 255
    Height = 169
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072
    TabOrder = 0
    object LblName: TLabel
      Left = 16
      Top = 24
      Width = 77
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EdName
    end
    object Label2: TLabel
      Left = 16
      Top = 70
      Width = 72
      Height = 13
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077':'
    end
    object LblMass: TLabel
      Left = 112
      Top = 70
      Width = 34
      Height = 13
      Caption = #1052#1072#1089#1089#1072':'
      FocusControl = EdMass
    end
    object LblPrice: TLabel
      Left = 112
      Top = 116
      Width = 100
      Height = 13
      Caption = #1062#1077#1085#1072' '#1079#1072' '#1082#1080#1083#1086#1075#1088#1072#1084#1084':'
      FocusControl = EdPrice
    end
    object EdName: TEdit
      Left = 16
      Top = 43
      Width = 225
      Height = 21
      TabOrder = 0
    end
    object PnImg: TPanel
      Left = 16
      Top = 89
      Width = 66
      Height = 66
      BevelOuter = bvLowered
      Color = clWindow
      ParentBackground = False
      TabOrder = 1
      object Img: TImage
        Left = 1
        Top = 1
        Width = 64
        Height = 64
        Align = alClient
        ExplicitLeft = 24
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object EdMass: TEdit
      Left = 112
      Top = 89
      Width = 113
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object UpDnMass: TUpDown
      Left = 225
      Top = 89
      Width = 16
      Height = 21
      Associate = EdMass
      TabOrder = 3
    end
    object UpDnImg: TUpDown
      Left = 82
      Top = 89
      Width = 16
      Height = 66
      Associate = PnImg
      TabOrder = 4
      OnClick = UpDnImgClick
    end
    object EdPrice: TEdit
      Left = 112
      Top = 135
      Width = 113
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object UpDnPrice: TUpDown
      Left = 225
      Top = 135
      Width = 16
      Height = 21
      Associate = EdPrice
      TabOrder = 6
    end
  end
  object BtnCancel: TButton
    Left = 190
    Top = 183
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object BtnOK: TButton
    Left = 109
    Top = 183
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = BtnOKClick
  end
end
