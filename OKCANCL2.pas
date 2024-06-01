unit OKCANCL2;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs, Zip,
  Vcl.OleCtnrs, Clipbrd, System.Threading;

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

uses Unit1;

procedure TOKRightDlg.SpeedButton1Click(Sender: TObject);
var
  s: string;
  Zip: TZipFile;
  pic: TPicture;
  st: TStream;
  head: TZipHeader;
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := ChangeFileExt(ExtractFileName(OpenDialog1.FileName), '');
    s := LowerCase(ExtractFileExt(OpenDialog1.FileName));
    if s = '.pdf' then
      OleContainer1.CreateObjectFromFile(OpenDialog1.FileName, false)
    else if s = '.zip' then
    begin
      Zip := TZipFile.Create;
      pic := TPicture.Create;
      st := TMemoryStream.Create;
      try
        Zip.Open(OpenDialog1.FileName, zmRead);
        Form1.arr := Zip.FileNames;
        if (Zip.FileCount > 0) and (LowerCase(ExtractFileExt(Zip.FileName[0]))
          = '.jpg') then
        begin
          Zip.Read(0, st, head);
          pic.LoadFromStream(st);
          Clipboard.Assign(pic);
          OleContainer1.Paste;
          Clipboard.Clear;
        end;
      finally
        Zip.Free;
        pic.Free;
        st.Free;
      end;
    end;
  end;
end;

end.
