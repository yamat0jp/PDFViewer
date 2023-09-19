unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.DB, Vcl.ExtCtrls,
  Vcl.DBCtrls, Data.Bind.Components, Data.Bind.DBScope, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.Grids, Vcl.DBGrids;

type
  TForm2 = class(TForm)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Image1: TImage;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    Image2: TImage;
    Button1: TButton;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  stream: TStream;
begin
  FDTable1.Edit;
  stream:=FDTable1.CreateBlobStream(FDTable1.FieldByName('image'),bmWrite);
  try
    Image2.Picture.Graphic.SaveToStream(stream);
  finally
    FDTable1.Post;
    stream.Free;
  end;
end;

end.
