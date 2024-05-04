program PDFViewerDB;







{$R *.dres}

uses
  Vcl.Forms,
  Vcl.Controls,
  Unit1 in 'Unit1.pas' {Form1},
  PassWord in 'PassWord.pas' {PasswordDlg},
  Unit3 in 'Unit3.pas' {Form3},
  ABOUT in 'ABOUT.pas' {AboutBox},
  OKCANCL2 in 'OKCANCL2.pas' {OKRightDlg},
  Unit4 in 'Unit4.pas' {DataModule4: TDataModule},
  Thread in 'Thread.pas';

{$R *.res}

procedure createForms;
begin
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  end;

begin
  Application.Initialize;
  DataModule4 := TDataModule4.Create(nil);
  with TPasswordDlg.Create(nil) do
  begin
    Unit1.PassWord := DataModule4.FDTable2.FieldByName('pass').AsString;
    if Unit1.PassWord = '' then
      createForms
    else
    begin
      Update;
      while ShowModal = mrOK do
        if PassWord.Text = Unit1.PassWord then
          break;
      if ModalResult = mrOK then
      begin
        createForms;
        Release;
        DataModule4.Free;
        Application.CreateForm(TPasswordDlg, PasswordDlg);
        Application.CreateForm(TDataModule4, DataModule4);
      end;
    end;
  end;
  Application.Run;

end.
