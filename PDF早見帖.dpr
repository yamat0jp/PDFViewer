program PDFëÅå©íü;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PassWord in 'PassWord.pas' {PasswordDlg},
  Unit3 in 'Unit3.pas' {Form3},
  ABOUT in 'ABOUT.pas' {AboutBox},
  OKCANCL2 in 'OKCANCL2.pas' {OKRightDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.Run;

end.
