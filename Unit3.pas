unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.AppEvnts, System.SyncObjs, FireDAC.Stan.Option, Threading;

type
  TForm3 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ApplicationEvents1: TApplicationEvents;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit4, Unit1;

procedure TForm3.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ModalResult := mrOK;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  with DataModule4 do
  begin
    FDTable1.Filter := 'title = ' +
      QuotedStr(Form1.ListBox1.Items[Form1.ListBox1.ItemIndex]);
    Label2.Caption := 'Fetching';
    if FDMemTable1.Active then
      FDMemTable1.Close;
    FDMemTable1.Data := FDTable1.Data;
    FDMemTable1.Open;
  end;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrAbort;
    DataModule4.FDTable1.AbortJob;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  Left := Form1.Left + (Form1.Width - Width) div 2;
  Top := Form1.Top + (Form1.Height - Height) div 2;
  Label2.Caption := 'Filtering';
  ModalResult := mrNone;
end;

end.
