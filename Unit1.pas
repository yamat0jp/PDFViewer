unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.OleServer, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Menus, FireDAC.Stan.StorageBin, Vcl.ComCtrls, System.UITypes,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TPageState = (pgSingle, pgSemi, pgDouble);

  TPageLayout = record
    Left, Right: integer;
  end;

  TForm1 = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    Image1: TImage;
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
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
    D1: TMenuItem;
    uninstall: TAction;
    StatusBar1: TStatusBar;
    PaintBox1: TPaintBox;
    RePaint: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    version: TAction;
    TabSheet4: TTabSheet;
    Memo1: TMemo;
    Action1: TAction;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
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
    procedure versionExecute(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1DblClick(Sender: TObject);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PageControl1MouseEnter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private 宣言 }
    double: TPageState;
    reverse: Boolean;
    pageList: TList<TPageLayout>;
    hyousi: Boolean;
    procedure AddImagePage(Index: integer);
    procedure countPictures;
    function returnPos(page: integer; var double: TPageState): integer;
    function checkSemi(num: integer): Boolean;
    function makeRect(bmp: TBitmap): TRect;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;
  password: string;

implementation

{$R *.dfm}

uses SkiSys.GS_Api, SkiSys.GS_Converter, SkiSys.GS_ParameterConst,
  SkiSys.GS_gdevdsp, Unit3, ABOUT, OKCANCL2, Unit4;

var
  id, title_id: integer;
  title: string;
  pdf: TGS_PdfConverter;

const
  query = 'select * from pdfdatabase where page_id = 1 order by id asc';

procedure TForm1.OpenExecute(Sender: TObject);
var
  p: ^TRect;
  procedure exitProc;
  begin
    OKRightDlg.OleContainer1.DestroyObject;
    OKRightDlg.Edit1.Text := '';
    DataModule4.FDQuery1.Close;
    DataModule4.FDQuery1.Open(query);
    PaintBox1Paint(Sender);
  end;

begin
  if (OKRightDlg.ShowModal = mrOK) and (OKRightDlg.Edit1.Text <> '') then
  begin
    pdf := TGS_PdfConverter.Create;
    try
      Screen.Cursor := crHourGlass;
      pdf.Params.Device := DISPLAY_DEVICE_NAME;
      pdf.UserParams.Clear;
      pdf.ToPdf(OKRightDlg.OpenDialog1.FileName, '', false);
      if pdf.GSDisplay.PageCount = 0 then
        Exit;
      title := OKRightDlg.Edit1.Text;
      if ListBox1.Items.IndexOf(title) > -1 then
        Exit;
      hyousi := OKRightDlg.CheckBox1.Checked;
      New(p);
      p^ := makeRect(pdf.GSDisplay.GetPage(0));
      ListBox1.Items.AddObject(title, Pointer(p));
      with DataModule4.FDTable1 do
      begin
        Filtered := false;
        Open;
        Last;
        id := FieldByName('id').AsInteger;
        IndexFieldNames := 'title_id';
        Last;
        title_id := FieldByName('title_id').AsInteger + 1;
        IndexFieldNames := 'id';
      end;
      for var i := 0 to pdf.GSDisplay.PageCount - 1 do
        AddImagePage(i);
      DataModule4.FDTable1.Close;
    finally
      pdf.Free;
      Screen.Cursor := crDefault;
      exitProc;
    end;
  end;
  exitProc;
end;

procedure TForm1.AddImagePage(Index: integer);
var
  ABmp: TGS_Image;
begin
  with DataModule4.FDTable1 do
  begin
    inc(id);
    AppendRecord([id, Index + 1, nil, title_id, title, 0]);
    Edit;
  end;
  ABmp := pdf.GSDisplay.GetPage(Index);
  DataModule4.FDTable1.FieldByName('image').Assign(ABmp);
  if (ABmp.Width > ABmp.Height) or (hyousi and (index + 1 = 1)) then
    DataModule4.FDTable1.FieldByName('subimage').AsInteger := 1;
  DataModule4.FDTable1.Post;
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
  PageControl1.TabIndex := 4;
end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BackExecute(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  Panel2.Hide;
  doubleScreen.Enabled := false;
  ReversePage.Enabled := false;
  DataModule4.FDMemTable1.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Edit1.Text = Unit1.password then
  begin
    Unit1.password := Edit2.Text;
    Edit1.Text := '';
    Edit2.Text := '';
    PageControl1.TabIndex := 0;
    with DataModule4 do
    begin
      FDTable2.Edit;
      FDTable2.FieldByName('pass').AsString := Unit1.password;
      FDTable2.Post;
    end;
    Showmessage('パスワードを変更いたしました。');
  end;
end;

procedure TForm1.doubleScreenExecute(Sender: TObject);
var
  cnt: integer;
begin
  if PageControl1.TabIndex = 0 then
    Exit;
  cnt := DataModule4.FDMemTable1.FieldByName('page_id').AsInteger;
  if not doubleScreen.Checked then
  begin
    double := pgSingle;
    TrackBar1.Max := DataModule4.FDMemTable1.RecordCount - 1;
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
var
  id: integer;
begin
  id := ListBox1.ItemIndex;
  if id = -1 then
    Exit;
  with DataModule4.FDTable1 do
  begin
    Filter := 'title = ' + QuotedStr(ListBox1.Items[id]);
    Filtered := true;
    Open;
    First;
    while not Eof do
      Delete;
    Close;
  end;
  Dispose(Pointer(ListBox1.Items.Objects[id]));
  ListBox1.Items.Delete(id);
  PaintBox1Paint(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
  p: ^TRect;
begin
  with DataModule4.FDQuery1 do
  begin
    Open(query);
    bmp := TBitmap.Create;
    try
      while not Eof do
      begin
        title := FieldByName('title').AsString;
        if ListBox1.Items.IndexOf(title) = -1 then
        begin
          bmp.Assign(FieldByName('image'));
          New(p);
          p^ := makeRect(bmp);
          ListBox1.Items.AddObject(title, Pointer(p));
        end;
        Next;
      end;
    finally
      bmp.Free;
    end;
  end;
  TabSheet3Resize(Sender);
  pageList := TList<TPageLayout>.Create;
  hyousi := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  pageList.Free;
  for var i := 0 to ListBox1.Items.Count - 1 do
    Dispose(Pointer(ListBox1.Items.Objects[i]));
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vkEscape then
    BackExecute(Sender);
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  if WindowState = wsNormal then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = TMouseButton.mbRight then
    PageControl1.ActivePageIndex := 3;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  PaintBox1Paint(Sender);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then
    Exit;
  Form3.Left := Left + (Width - Form3.Width) div 2;
  Form3.Top := Top + (Height - Form3.Height) div 2;
  Form3.Show;
  Application.ProcessMessages;
  PageControl1.TabIndex := 1;
  Back.Enabled := true;
  doubleScreen.Enabled := true;
  ReversePage.Enabled := true;
  Panel2.Show;
  TrackBar1.SetFocus;
  with DataModule4.FDQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from pdfdatabase where title = :str');
    Params.ParamByName('str').AsString := ListBox1.Items[ListBox1.ItemIndex];
    Open;
    DataModule4.FDMemTable1.Data := Data;
    DataModule4.FDMemTable1.Open;
    Close;
    Open(query);
  end;
  Form3.Hide;
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

function TForm1.makeRect(bmp: TBitmap): TRect;
var
  num, consw, consh: integer;
begin
  num := 120;
  if bmp.Width > bmp.Height then
  begin
    consw := num;
    consh := Round(num * bmp.Height / bmp.Width);
  end
  else
  begin
    consh := num;
    consw := Round(num * bmp.Width / bmp.Height);
  end;
  result.Left := Random(PaintBox1.Width - consw);
  result.Top := Random(PaintBox1.Height - consh);
  result.Width := consw;
  result.Height := consh;
end;

procedure TForm1.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = TMouseButton.mbRight then
    PageControl1.ActivePageIndex := 1;
end;

procedure TForm1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := false;
end;

procedure TForm1.PageControl1MouseEnter(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 3 then
    PageControl1.ActivePageIndex := 1;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  rect: ^TRect;
  bmp: TBitmap;
begin
  if not DataModule4.FDQuery1.Active then
    DataModule4.FDQuery1.Open(query);
  Randomize;
  PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
  PaintBox1.Canvas.Pen.Color := clRed;
  PaintBox1.Canvas.Pen.Width := 10;
  bmp := TBitmap.Create;
  try
    for var i := 0 to ListBox1.Items.Count - 1 do
    begin
      if ListBox1.ItemIndex = i then
        continue;
      DataModule4.FDQuery1.Locate('title', ListBox1.Items[i]);
      bmp.Assign(DataModule4.FDQuery1.FieldByName('image'));
      rect := Pointer(ListBox1.Items.Objects[i]);
      PaintBox1.Canvas.StretchDraw(rect^, bmp);
    end;
    id := ListBox1.ItemIndex;
    if id > -1 then
    begin
      DataModule4.FDQuery1.Locate('title', ListBox1.Items[id]);
      bmp.Assign(DataModule4.FDQuery1.FieldByName('image'));
      rect := Pointer(ListBox1.Items.Objects[id]);
      PaintBox1.Canvas.Rectangle(rect^);
      PaintBox1.Canvas.StretchDraw(rect^, bmp);
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
    DataModule4.FDMemTable1.Next
  else
  begin
    if double = pgSingle then
      cnt := 1
    else
      cnt := 3;
    for var i := 1 to cnt do
      DataModule4.FDMemTable1.Prior;
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
  DataModule4.FDMemTable1.First;
  while not DataModule4.FDMemTable1.Eof do
  begin
    p.Right := 0;
    bool := DataModule4.FDMemTable1.FieldByName('subimage').AsInteger = 1;
    if cnt = 0 then
    begin
      p.Left := DataModule4.FDMemTable1.FieldByName('page_id').AsInteger;
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
        p.Right := DataModule4.FDMemTable1.FieldByName('page_id').AsInteger;
      pageList.Add(p);
    end;
    DataModule4.FDMemTable1.Next;
  end;
  if cnt > 0 then
    pageList.Add(p);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  p: TPageLayout;
begin
  if double = pgSingle then
    DataModule4.FDMemTable1.Locate('page_id', TrackBar1.Position + 1)
  else
  begin
    p := pageList[TrackBar1.Position];
    if checkSemi(TrackBar1.Position) then
      double := pgSemi
    else
      double := pgDouble;
    DataModule4.FDMemTable1.Locate('page_id', p.Left);
  end;
  TabSheet3Resize(Sender);
  case double of
    pgSingle, pgSemi:
      begin
        PageControl1.TabIndex := 1;
        Image1.Picture.Assign(DataModule4.FDMemTable1.FieldByName('image'));
        StatusBar1.Panels[3].Text := DataModule4.FDMemTable1.FieldByName
          ('page_id').AsString;
      end;
    pgDouble:
      begin
        PageControl1.TabIndex := 2;
        Image2.Picture.Assign(DataModule4.FDMemTable1.FieldByName('image'));
        DataModule4.FDMemTable1.Next;
        Image3.Picture.Assign(DataModule4.FDMemTable1.FieldByName('image'));
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

procedure TForm1.versionExecute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
