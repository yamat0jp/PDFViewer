object OKRightDlg: TOKRightDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #12480#12452#12450#12525#12464
  ClientHeight = 302
  ClientWidth = 539
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 401
    Height = 281
    Shape = bsFrame
  end
  object Image1: TImage
    Left = 32
    Top = 40
    Width = 161
    Height = 217
    Stretch = True
  end
  object SpeedButton1: TSpeedButton
    Left = 360
    Top = 54
    Width = 23
    Height = 22
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 248
    Top = 28
    Width = 57
    Height = 15
    Caption = 'Title Name'
  end
  object OKBtn: TButton
    Left = 444
    Top = 24
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 444
    Top = 54
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 224
    Top = 55
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 104
    Width = 97
    Height = 17
    Caption = #34920#32025#12354#12426
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.pdf'
    Filter = 'PDF|*.PDF'
    Left = 264
    Top = 160
  end
end
