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
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
    FDMemTable1: TFDMemTable;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    Image2: TImage;
    Image3: TImage;
    ActionManager1: TActionManager;
    Open: TAction;
    Action3: TAction;
    Back: TAction;
    doubleScreen: TAction;
    Delete: TAction;
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
    FDMemTable1PAGE_ID: TIntegerField;
    FDMemTable1IMAGE: TBlobField;
    FDMemTable1TITLE_ID: TIntegerField;
    FDMemTable1SUBIMAGE: TBooleanField;
    StatusBar1: TStatusBar;
    FDQuery1: TFDQuery;
    PaintBox1: TPaintBox;
    RePaint: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure OpenExecute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure BackExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure doubleScreenExecute(Sender: TObject);
    procedure ReversePageExecute(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure DeleteExecute(Sender: TObject);
    procedure uninstallExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure RePaintExecute(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: integer);
    procedure TabSheet3Resize(Sender: TObject);
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
  PageControl1.TabIndex:=0;
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
  if PageControl1.TabIndex = 0 then
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
  TabSheet3Resize(Sender);
  pageList := TList<TPageLayout>.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  pageList.Free;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  PaintBox1Paint(Sender);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  str: string;
begin
  if ListBox1.ItemIndex = -1 then
    Exit;
  PageControl1.TabIndex:=1;
  Back.Enabled := true;
  doubleScreen.Enabled := true;
  ReversePage.Enabled := true;
  Panel2.Show;
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

procedure TForm1.ListBox1DragDrop(Sender, Source: TObject; X, Y: integer);
var
  cnt: integer;
begin
  if ListBox1.ItemIndex > -1 then
  begin
    cnt := ListBox1.ItemAtPos(Point(X, Y), false);
    if cnt = ListBox1.Items.Count then
      dec(cnt);
    ListBox1.Items.Move(ListBox1.ItemIndex, cnt);
    PaintBox1Paint(Sender);
  end;
end;

procedure TForm1.ListBox1DragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: Boolean);
begin
  if ListBox1.ItemIndex > 0 then
    Accept := true;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  rect: TRect;
  bmp: TBitmap;
  pos: TPoint;
  procedure makeRect(topleft: TPoint);
  begin
    rect.Left := topleft.X;
    rect.Top := topleft.Y;
    if FDTable1.FieldByName('subimage').AsBoolean then
    begin
      rect.Right := topleft.X + 160;
      rect.Bottom := topleft.Y + 120;
    end
    else
    begin
      rect.Right := topleft.X + 120;
      rect.Bottom := topleft.Y + 160;
    end;
  end;

begin
  rect.TopLeft:=Point(0,0);
  rect.Width:=PaintBox1.Width;
  rect.Height:=PaintBox1.Height;
  PaintBox1.Canvas.FillRect(rect);
  PaintBox1.Canvas.Pen.Color := clRed;
  PaintBox1.Canvas.Pen.Width := 10;
  bmp := TBitmap.Create;
  try
    for var i := 0 to ListBox1.Items.Count - 1 do
    begin
      FDTable1.Locate('title;page_id', VarArrayOf([ListBox1.Items[i], 1]));
      bmp.Assign(FDTable1.FieldByName('image'));
      pos.X := 30 + i * 120;;
      pos.Y := 30;
      makeRect(pos);
      if ListBox1.ItemIndex = i then
        PaintBox1.Canvas.Rectangle(rect);
      PaintBox1.Canvas.StretchDraw(rect, bmp);
    end;
  finally
    bmp.Free;
  end;
end;

procedure TForm1.RePaintExecute(Sender: TObject);
begin
  PaintBox1Paint(Sender);
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
  TabSheet3Resize(Sender);
end;

procedure TForm1.TabSheet3Resize(Sender: TObject);
var
  img1, img2: TImage;
begin
  if PageControl1.TabIndex = 2 then
  begin
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
    img1.Height := TabSheet3.Height;
    img2.Height := TabSheet3.Height;
    if (Sender = TabSheet3) and not img1.Picture.Graphic.Empty then
      img1.Width := Round(img2.Height / img1.Picture.Graphic.Height *
        img1.Picture.Graphic.Width);
    if (Sender = TabSheet3) and not img2.Picture.Graphic.Empty then
      img2.Width := Round(img2.Height / img2.Picture.Graphic.Height *
        img1.Picture.Graphic.Width);
    img1.Left := -img1.Width + TabSheet3.Width div 2;
    img2.Left := TabSheet3.Width div 2;
    img1.Top := 0;
    img2.Top := 0;
  end;
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
  TabSheet3Resize(Sender);
  case double of
    pgSingle, pgSemi:
      begin
        PageControl1.TabIndex:=1;
        Image1.Picture.Assign(FDMemTable1.FieldByName('image'));
        StatusBar1.Panels[3].Text := FDMemTable1.FieldByName('page_id')
          .AsString;
      end;
    pgDouble:
      begin
        PageControl1.TabIndex:=2;
        Image2.Picture.Assign(FDMemTable1.FieldByName('image'));
        FDMemTable1.Next;
        Image3.Picture.Assign(FDMemTable1.FieldByName('image'));
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
