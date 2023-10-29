program PDFViewerDB;

uses
  Vcl.Forms, Vcl.Controls,
  Unit1 in 'Unit1.pas' {Form1} ,
  PassWord in 'PassWord.pas' {PasswordDlg} ,
  Unit3 in 'Unit3.pas' {Form3} ,
  ABOUT in 'ABOUT.pas' {AboutBox} ,
  OKCANCL2 in 'OKCANCL2.pas' {OKRightDlg};

{$R *.res}

begin
  Application.Initialize;
  with TPasswordDlg.Create(nil) do
  begin
    Update;
    while ShowModal = mrOK do
      if PassWord.Text = 'password' then
        break;
    if ModalResult = mrOK then
    begin
      Application.MainFormOnTaskbar := true;
      Application.CreateForm(TForm1, Form1);
      Application.CreateForm(TForm3, Form3);
      Application.CreateForm(TAboutBox, AboutBox);
      Application.CreateForm(TOKRightDlg, OKRightDlg);
    end;
    Release;
  end;
  Application.Run;

end.
