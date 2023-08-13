unit OKCANCL2;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs,
  SkiSys.GS_Api, SkiSys.GS_Converter, SkiSys.GS_ParameterConst,
  SkiSys.GS_gdevdsp;

type
  TOKRightDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Image1: TImage;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    pdf: TGS_PdfConverter;
  end;

var
  OKRightDlg: TOKRightDlg;

implementation

{$R *.dfm}

uses Unit3, ABOUT;

procedure TOKRightDlg.FormCreate(Sender: TObject);
begin
  pdf := TGS_PdfConverter.Create;
end;

procedure TOKRightDlg.FormDestroy(Sender: TObject);
begin
  pdf.Free;
end;

procedure TOKRightDlg.SpeedButton1Click(Sender: TObject);
var
  ABmp: TGS_Image;
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := ChangeFileExt(ExtractFileName(OpenDialog1.FileName), '');
    Screen.Cursor := crHourGlass;
    pdf.Params.Device := DISPLAY_DEVICE_NAME;
    pdf.UserParams.Clear;
    pdf.ToPdf(OpenDialog1.FileName, '', false);
    if pdf.GSDisplay.PageCount > 0 then
    begin
      ABmp := pdf.GSDisplay.GetPage(0);
      Image1.Picture.Assign(ABmp);
    end;
    Screen.Cursor:=crDefault;
  end;
end;

end.
