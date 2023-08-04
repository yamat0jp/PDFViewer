program PDFViewer;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PassWord in 'PassWord.pas' {PasswordDlg},
  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Form3:=TForm3.Create(nil);
  Form3.Show;
  Application.ProcessMessages;
  Application.CreateForm(TForm1, Form1);
  Form3.Release;
  Application.Run;

end.
