unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.OleServer, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.DBCtrls, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Vcl.Menus, FireDAC.Stan.StorageBin, Vcl.ComCtrls, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.IB, FireDAC.Phys.IBDef;

type
  TPageState = (pgSingle, pgSemi, pgDouble);

  TPageLayout = record
    Left, Right: integer;
  end;

  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    ActionMainMenuBar1: TActionMainMenuBar;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Image1: TImage;
    Panel1: TPanel;
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
    FDMemTable1: TFDMemTable;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    Panel3: TPanel;
    Image2: TImage;
    Image3: TImage;
    ActionManager1: TActionManager;
    Open: TAction;
    Action3: TAction;
    Back: TAction;
    doubleScreen: TAction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Delete: TAction;
    ToolButton3: TToolButton;
    ReversePage: TAction;
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    FDTable1ID: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable1TITLE_ID: TIntegerField;
    FDTable1TITLE: TStringField;
    FDTable1SUBIMAGE: TBooleanField;
    D1: TMenuItem;
    uninstall: TAction;
    FDTable1PAGE_ID: TIntegerField;
    Refresh: TAction;
    FDMemTable1PAGE_ID: TIntegerField;
    FDMemTable1IMAGE: TBlobField;
    FDMemTable1TITLE_ID: TIntegerField;
    FDMemTable1SUBIMAGE: TBooleanField;
    StatusBar1: TStatusBar;
    FDQuery1: TFDQuery;
    procedure OpenExecute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure BackExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure doubleScreenExecute(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure ReversePageExecute(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure DeleteExecute(Sender: TObject);
    procedure uninstallExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private êÈåæ }
    double: TPageState;
    reverse: Boolean;
    pageList: TList<TPageLayout>;
    procedure AddImagePage(Index: integer);
    procedure countPictures;
    function returnPos(page: integer; var double: TPageState): integer;
    function checkSemi(num: integer): Boolean;
  public
    { Public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses SkiSys.GS_Api, SkiSys.GS_Converter, SkiSys.GS_ParameterConst,
  SkiSys.GS_gdevdsp;

var
  pdf: TGS_PdfConverter;
  id, title_id: integer;

procedure TForm1.OpenExecute(Sender: TObject);
var
  title: string;
begin
  if OpenDialog1.Execute then
  begin
    title := ChangeFileExt(ExtractFileName(OpenDialog1.FileName), '');
    if ListBox1.Items.IndexOf(title) > -1 then
      Exit;
    ListBox1.Items.Add(title);
    with FDTable1 do
    begin
      Last;
      id := FieldByName('id').AsInteger;
      IndexFieldNames := 'title_id';
      Last;
      title_id := FieldByName('title_id').AsInteger + 1;
      IndexFieldNames := 'id';
    end;
    pdf := TGS_PdfConverter.Create;
    try
      Screen.Cursor := crHourGlass;
      pdf.Params.PdfTitle := title;
      pdf.Params.Device := DISPLAY_DEVICE_NAME;
      pdf.UserParams.Clear;
      pdf.ToPdf(OpenDialog1.FileName, '', false);
      for var i := 0 to pdf.GSDisplay.PageCount - 1 do
        AddImagePage(i);
    finally
      Screen.Cursor := crDefault;
      pdf.Free;
    end;
  end;
end;

procedure TForm1.AddImagePage(Index: integer);
var
  ABmp: TGS_Image;
begin
  with FDTable1 do
  begin
    inc(id);
    AppendRecord([id, Index + 1, nil, title_id, pdf.Params.PdfTitle, false]);
    Edit;
  end;
  ABmp := pdf.GSDisplay.GetPage(Index);
  try
    FDTable1.FieldByName('image').Assign(ABmp);
    if ABmp.Width > ABmp.Height then
      FDTable1.FieldByName('subimage').AsBoolean := true;
  finally
    FDTable1.Post;
    ABmp.Free;
  end;
end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BackExecute(Sender: TObject);
begin
  Panel1.Show;
  Panel2.Hide;
  Back.Enabled := false;
  doubleScreen.Enabled := false;
  ReversePage.Enabled := false;
  FDMemTable1.Close;
end;

procedure TForm1.doubleScreenExecute(Sender: TObject);
var
  cnt: integer;
begin
  if Panel1.Visible then
    Exit;
  cnt := FDMemTable1.FieldByName('page_id').AsInteger;
  if not doubleScreen.Checked then
  begin
    double := pgSingle;
    TrackBar1.Max := FDMemTable1.RecordCount - 1;
    TrackBar1.Position := cnt - 1;
  end
  else
  begin
    countPictures;
    TrackBar1.Max := pageList.Count - 1;
    cnt := returnPos(cnt, double);
    if TrackBar1.Position = cnt then
      TrackBar1Change(Sender)
    else
      TrackBar1.Position := cnt;
  end;
  StatusBar1.Panels[1].Text := (TrackBar1.Max + 1).ToString;
end;

procedure TForm1.DeleteExecute(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then
    Exit;
  FDTable1.Filter := 'title = ' + QuotedStr(ListBox1.Items[ListBox1.ItemIndex]);
  FDTable1.Filtered := true;
  FDTable1.First;
  while not FDTable1.Eof do
    FDTable1.Delete;
  FDTable1.Filtered := false;
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  title: string;
begin
  with FDTable1 do
  begin
    First;
    while Eof = false do
    begin
      title := FieldByName('title').AsString;
      if ListBox1.Items.IndexOf(title) = -1 then
        ListBox1.Items.Add(title);
      Next;
    end;
  end;
  Panel3Resize(Sender);
  pageList := TList<TPageLayout>.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  pageList.Free;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  str: string;
begin
  if ListBox1.ItemIndex = -1 then
    Exit;
  Panel1.Hide;
  Panel2.Show;
  Back.Enabled := true;
  doubleScreen.Enabled := true;
  ReversePage.Enabled := true;
  TrackBar1.SetFocus;
  str := FDTable1.Lookup('title', ListBox1.Items[ListBox1.ItemIndex],
    'title_id');
  FDTable1.Filter := 'title_id = ' + str;
  FDTable1.Filtered := true;
  FDMemTable1.Data := FDTable1.Data;
  FDMemTable1.Open;
  FDTable1.Filtered := false;
  doubleScreenExecute(Sender);
  TrackBar1Change(Sender);
end;

procedure TForm1.Panel3Resize(Sender: TObject);
var
  img1, img2: TImage;
begin
  if Panel3.Visible then
  begin
    Panel3.Show;
    if not reverse then
    begin
      img1 := Image2;
      img2 := Image3;
    end
    else
    begin
      img2 := Image2;
      img1 := Image3;
    end;
    img1.Height := Panel3.Height;
    img2.Height := Panel3.Height;
    if (Sender = Panel3) and not img1.Picture.Graphic.Empty then
      img1.Width := Round(img2.Height / img1.Picture.Graphic.Height *
        img1.Picture.Graphic.Width);
    if (Sender = Panel3) and not img2.Picture.Graphic.Empty then
      img2.Width := Round(img2.Height / img2.Picture.Graphic.Height *
        img1.Picture.Graphic.Width);
    img1.Left := -img1.Width + Panel3.Width div 2;
    img2.Left := Panel3.Width div 2;
    img1.Top := 0;
    img2.Top := 0;
  end;
end;

function TForm1.checkSemi(num: integer): Boolean;
begin
  result := pageList[num].Right = 0;
end;

function TForm1.returnPos(page: integer; var double: TPageState): integer;
begin
  result := 0;
  for var i := 0 to pageList.Count - 1 do
    if (page = pageList[i].Left) or (page = pageList[i].Right) then
    begin
      if checkSemi(i) then
        double := pgSemi
      else
        double := pgDouble;
      result := i;
    end;
end;

procedure TForm1.ReversePageExecute(Sender: TObject);
begin
  reverse := ReversePage.Checked;
  Panel3Resize(Sender);
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
var
  cnt: integer;
begin
  if Sender = ToolButton7 then
    FDMemTable1.Next
  else
  begin
    if double = pgSingle then
      cnt := 1
    else
      cnt := 3;
    for var i := 1 to cnt do
      FDMemTable1.Prior;
  end;
  TrackBar1Change(Sender);
end;

procedure TForm1.countPictures;
var
  cnt: integer;
  bool: Boolean;
  p: TPageLayout;
begin
  cnt := 0;
  pageList.Clear;
  FDMemTable1.First;
  while not FDMemTable1.Eof do
  begin
    p.Right := 0;
    bool := FDMemTable1.FieldByName('subimage').AsBoolean;
    if cnt = 0 then
    begin
      p.Left := FDMemTable1.FieldByName('page_id').AsInteger;
      if bool then
        pageList.Add(p)
      else
        cnt := 1;
    end
    else
    begin
      cnt := 0;
      if bool then
      begin
        pageList.Add(p);
        continue;
      end
      else
        p.Right := FDMemTable1.FieldByName('page_id').AsInteger;
      pageList.Add(p);
    end;
    FDMemTable1.Next;
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  p: TPageLayout;
begin
  if double = pgSingle then
    FDMemTable1.Locate('page_id', TrackBar1.Position + 1)
  else
  begin
    p := pageList[TrackBar1.Position];
    if checkSemi(TrackBar1.Position) then
      double := pgSemi
    else
      double := pgDouble;
    FDMemTable1.Locate('page_id', p.Left);
  end;
  Panel3Resize(Sender);
  case double of
    pgSingle, pgSemi:
      begin
        Image1.Picture.Assign(FDMemTable1.FieldByName('image'));
        Panel3.Hide;
        StatusBar1.Panels[3].Text := FDMemTable1.FieldByName('page_id')
          .AsString;
      end;
    pgDouble:
      begin
        Image2.Picture.Assign(FDMemTable1.FieldByName('image'));
        FDMemTable1.Next;
        Image3.Picture.Assign(FDMemTable1.FieldByName('image'));
        Panel3.Show;
        StatusBar1.Panels[3].Text := Format('%d , %d', [p.Left, p.Right]);
      end;
  end;
end;

procedure TForm1.uninstallExecute(Sender: TObject);
begin
  while ListBox1.Items.Count > 0 do
  begin
    ListBox1.ItemIndex := 0;
    DeleteExecute(Sender);
  end;
end;

end.
