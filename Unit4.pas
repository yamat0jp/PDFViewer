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
  FireDAC.Comp.BatchMove, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Async, FireDAC.Comp.UI;

type
  TDataModule4 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDMemTable1: TFDMemTable;
    FDTable2pass: TStringField;
    FDTable1ID: TIntegerField;
    FDTable1PAGE_ID: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable1TITLE_ID: TIntegerField;
    FDTable1TITLE: TStringField;
    FDTable1SUBIMAGE: TIntegerField;
    FDGUIxAsyncExecuteDialog1: TFDGUIxAsyncExecuteDialog;
    FDQuery1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
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
  FDTable1.FetchOptions.Mode := fmAll;
  FDTable2.Open;
end;

end.
