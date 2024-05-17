unit OKCANCL2;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs,
  Vcl.OleCtnrs;

type
  TOKRightDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    OleContainer1: TOleContainer;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  OKRightDlg: TOKRightDlg;

implementation

{$R *.dfm}

procedure TOKRightDlg.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := ChangeFileExt(ExtractFileName(OpenDialog1.FileName), '');
    if ExtractFileExt(OpenDialog1.FileName) = '.pdf' then
      OleContainer1.CreateObjectFromFile(OpenDialog1.FileName, false);
  end;
end;

end.
