object PasswordDlg: TPasswordDlg
  Left = 694
  Top = 519
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12497#12473#12527#12540#12489#12480#12452#12450#12525#12464
  ClientHeight = 93
  ClientWidth = 233
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  Position = poDesigned
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 91
    Height = 15
    Caption = #12497#12473#12527#12540#12489#12398#20837#21147':'
  end
  object Password: TEdit
    Left = 8
    Top = 27
    Width = 217
    Height = 23
    PasswordChar = '*'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 69
    Top = 59
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 150
    Top = 59
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 2
  end
end
