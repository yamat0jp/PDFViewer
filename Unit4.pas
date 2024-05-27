unit Unit4;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageBin, FireDAC.Comp.BatchMove.DataSet,
  FireDAC.Comp.BatchMove, FireDAC.Phys.IB, FireDAC.Phys.IBDef;

type
  TDataModule4 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    FDQuery1: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDMemTable1: TFDMemTable;
    FDTable2pass: TStringField;
    FDTable1ID: TIntegerField;
    FDTable1PAGE_ID: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable1TITLE_ID: TIntegerField;
    FDTable1TITLE: TStringField;
    FDTable1SUBIMAGE: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDQuery1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  DataModule4: TDataModule4;

implementation

uses System.IOUtils, Vcl.Forms, Unit3;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModule4.DataModuleCreate(Sender: TObject);
var
  s: string;
begin
  s := TPath.GetDocumentsPath + '\PDFViewerDB';
  FDConnection1.Params.Database := s + '\PDFDATA.SDB';
  FDConnection1.Open;
  if not(FDTable1.Exists and FDTable2.Exists) then
    FDQuery1.ExecSQL;
  FDTable1.Open;
  FDTable2.Open;
end;

procedure TDataModule4.FDQuery1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Assigned(Form3) and Form3.Visible then
    Application.ProcessMessages;
end;

end.
