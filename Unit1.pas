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
  FireDAC.Phys.SQLiteWrapper.Stat, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, SkiSys.GS_Api, SkiSys.GS_Converter,
  SkiSys.GS_ParameterConst, SkiSys.GS_gdevdsp, System.Zip, Thread,
  System.Threading,
  System.IOUtils;

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
    ProgressBar1: TProgressBar;
    Action2: TAction;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Label3: TLabel;
    Edit3: TEdit;
    UpDown1: TUpDown;
    ProgressBar2: TProgressBar;
    Panel1: TPanel;
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
    procedure Image1MoueDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure PageControl1MouseEnter(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TabSheet3MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
  private
    { Private 宣言 }
    double: TPageState;
    reverse, dm: Boolean;
    pageList: TList<TPageLayout>;
    fileList: TList<string>;
    pdf: TGS_PdfConverter;
    dp: TPoint;
    hyousi: Boolean;
    id_num, title_id: integer;
    title: string;
    procedure countPictures;
    procedure moment;
    procedure progressEvent(Sender: TObject; FileName: string;
      Header: TZipHeader; Position: Int64);
    procedure refreshLib;
    procedure ZipLoop;
    procedure LoadFromSQL(out bmp: TBitmap);
    procedure readCursor;
    function returnPos(page: integer; var double: TPageState): integer;
    function checkSemi(num: integer): Boolean;
    function ZipReader: Boolean;
  public
    { Public 宣言 }
    arr: TArray<string>;
    function checkExt(ext: string): Boolean;
  end;

var
  Form1: TForm1;
  password: string;

implementation

{$R *.dfm}

uses Unit3, ABOUT, OKCANCL2, Unit4, Zlib,
  System.NetEncoding, System.SyncObjs;

const
  query = 'select * from pdfdatabase where page_id = 1 order by id asc';
  crLeft = 5;
  crRight = 6;

function makeRect(img: TGraphic): TRect; overload;
var
  num, consw, consh: integer;
begin
  num := 120;
  if img.Width > img.Height then
  begin
    consw := num;
    consh := Round(num * img.Height / img.Width);
  end
  else
  begin
    consh := num;
    consw := Round(num * img.Width / img.Height);
  end;
  result.Left := Random(Form1.PaintBox1.Width - consw);
  result.Top := Random(Form1.PaintBox1.Height - consh);
  result.Width := consw;
  result.Height := consh;
end;

procedure makeRect(var Rect: TRect); overload;
var
  s: TRect;
  num, consw, consh: integer;
begin
  num := 120;
  s := Rect;
  if s.Width > s.Height then
  begin
    consw := num;
    consh := Round(num * s.Height / s.Width);
  end
  else
  begin
    consh := num;
    consw := Round(num * s.Width / s.Height);
  end;
  Rect.Left := Random(Form1.PaintBox1.Width - consw);
  Rect.Top := Random(Form1.PaintBox1.Height - consh);
  Rect.Width := consw;
  Rect.Height := consh;
end;

procedure TForm1.OpenExecute(Sender: TObject);
var
  sub, size: integer;
  p: ^TRect;
  img: TGraphic;
  threads: TArray<TMyThread>;
begin
  if (OKRightDlg.ShowModal = mrOK) and (OKRightDlg.Edit1.Text <> '') and not ZipReader
  then
  begin
    pdf := TGS_PdfConverter.Create;
    Screen.Cursor := crHourGlass;
    try
      pdf.Params.Device := DISPLAY_DEVICE_NAME;
      pdf.UserParams.Clear;
      pdf.ToPdf(OKRightDlg.OpenDialog1.FileName, '', false);
      size := pdf.GSDisplay.PageCount;
      if size = 0 then
        Exit;
      title := OKRightDlg.Edit1.Text;
      if ListBox1.Items.IndexOf(title) > -1 then
        Exit;
      hyousi := OKRightDlg.CheckBox1.Checked;
      New(p);
      p^ := makeRect(pdf.GSDisplay.GetPage(0));
      ListBox1.Items.AddObject(title, Pointer(p));
      with DataModule4.FDQuery1 do
      begin
        Open('select COUNT(*) as cnt from pdfdatabase;');
        if FieldByName('cnt').AsInteger = 0 then
        begin
          id_num := 1;
          title_id := 1;
        end
        else
        begin
          Open('select MAX(id) as id from pdfdatabase;');
          id_num := FieldByName('id').AsInteger + 1;
          Open('select MAX(title_id) as title_id from pdfdatabase;');
          title_id := FieldByName('title_id').AsInteger + 1;
        end;
        Close;
        SQL.Text :=
          ('insert into pdfdatabase (id, page_id, image, title_id, title, subimage) values (:id, :page_id, :image, :title_id, :title, :subimage);');
        Params.ArraySize := size;
      end;
      SetLength(threads, size);
      for var i := 0 to size - 1 do
        with DataModule4.FDQuery1 do
        begin
          ParamByName('id').AsIntegers[i] := id_num + i;
          ParamByName('page_id').AsIntegers[i] := i + 1;
          ParamByName('title_id').AsIntegers[i] := title_id;
          ParamByName('title').AsStrings[i] := title;
          img := pdf.GSDisplay.GetPage(i);
          if (img.Width > img.Height) or (hyousi and (i = 0)) then
            sub := 1
          else
            sub := 0;
          ParamByName('subimage').AsIntegers[i] := sub;
          threads[i] := TMyThread.Create(img);
        end;
      with DataModule4.FDQuery1 do
      begin
        for var i := 0 to size - 1 do
        begin
          ParamByName('image').LoadFromStream(threads[i].Stream, ftBlob, i);
          threads[i].Free;
        end;
        Execute(size, 0);
      end;
    finally
      pdf.Free;
      Finalize(threads);
      Screen.Cursor := crDefault;
      OKRightDlg.OleContainer1.DestroyObject;
      OKRightDlg.Edit1.Text := '';
    end;
  end;
  PaintBox1Paint(Sender);
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
  PageControl1.TabIndex := 4;
  Edit1.SetFocus;
end;

procedure TForm1.Action2Execute(Sender: TObject);
begin
  if DataModule4.FDMemTable1.Active then
    TrackBar1.Position := TrackBar1.Max - TrackBar1.Position;
end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BackExecute(Sender: TObject);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    bmp.Width := Image1.Width;
    bmp.Height := Image1.Height;
    Image1.Picture.Assign(bmp);
    Image2.Picture.Assign(bmp);
    Image3.Picture.Assign(bmp);
  finally
    bmp.Free;
  end;
  PageControl1.TabIndex := 0;
  Panel2.Hide;
  ReversePage.Enabled := false;
  DataModule4.FDMemTable1.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (Edit1.Text = Unit1.password) and (Edit1.Text <> Edit2.Text) then
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

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    FormStyle := fsStayOnTop;
  end
  else
    FormStyle := fsNormal;
  Edit3.Enabled := CheckBox1.Checked;
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
  with DataModule4.FDQuery1 do
  begin
    SQL.Text := 'delete from pdfdatabase where title = :title;';
    Params[0].AsString := ListBox1.Items[id];
    ExecSQL;
  end;
  Dispose(Pointer(ListBox1.Items.Objects[id]));
  ListBox1.Items.Delete(id);
  PaintBox1Paint(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
  p: ^TRect;
  s: string;
begin
  readCursor;
  with DataModule4.FDQuery1 do
  begin
    Open(query);
    try
      while not Eof do
      begin
        title := FieldByName('title').AsString;
        if ListBox1.Items.IndexOf(title) = -1 then
        begin
          LoadFromSQL(bmp);
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
  TabSheet3.Hint := Image1.Hint;
  TabSheet3Resize(Sender);
  pageList := TList<TPageLayout>.Create;
  hyousi := true;
  s := ExtractFilePath(Application.ExeName) + 'tmp';
  if DirectoryExists(s) then
    TDirectory.Delete(s, true);
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
var
  ctr: TControl;
begin
  ctr := Sender as TControl;
  if ctr.Cursor = crDefault then
    if WindowState = wsNormal then
      WindowState := wsMaximized
    else
      WindowState := wsNormal;
end;

procedure TForm1.Image1MoueDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  case Button of
    TMouseButton.mbRight:
      PageControl1.ActivePageIndex := 3;
    TMouseButton.mbLeft:
      if Image1.Cursor = crLeft then
        TrackBar1.Position := TrackBar1.Position - 1
      else if Image1.Cursor = crRight then
        TrackBar1.Position := TrackBar1.Position + 1
      else
      begin
        moment;
        dp := Point(X, Y);
        dm := true;
      end;
  end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  ctr: TControl;
begin
  ctr := Sender as TControl;
  if X < PageControl1.Width div 3 then
    ctr.Cursor := crLeft
  else if X > 2 * PageControl1.Width div 3 then
    ctr.Cursor := crRight
  else
  begin
    ctr.Cursor := crDefault;
    if dm and (WindowState <> wsMaximized) then
    begin
      Top := Top + Y - dp.Y;
      Left := Left + X - dp.X;
    end;
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  dm := false;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  ctr: TControl;
begin
  ctr := Sender as TControl;
  case Button of
    TMouseButton.mbRight:
      PageControl1.ActivePageIndex := 3;
    TMouseButton.mbLeft:
      if ctr.Cursor = crLeft then
        TrackBar1.Position := TrackBar1.Position - 1
      else if ctr.Cursor = crRight then
        TrackBar1.Position := TrackBar1.Position + 1
      else
      begin
        moment;
        dm := true;
        dp := Point(Mouse.CursorPos.X - Left, Mouse.CursorPos.Y - Top);
      end;
  end;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  ctr: TControl;
  len: integer;
begin
  ctr := Sender as TControl;
  len := (PageControl1.Width div 2) - ctr.Width;
  if (not reverse and (Sender = Image2)) or (reverse and (Sender = Image3)) then
  begin
    if (len < PageControl1.Width div 3) and (X + len < PageControl1.Width div 3)
    then
      ctr.Cursor := crLeft
    else
      ctr.Cursor := crDefault;
  end
  else if (len > PageControl1.Width div 3) or (X < PageControl1.Width div 6)
  then
    ctr.Cursor := crDefault
  else
    ctr.Cursor := crRight;
  TabSheet3.Cursor := ctr.Cursor;
  if dm and (ctr.Cursor = crDefault) then
  begin
    Left := Mouse.CursorPos.X - dp.X;
    Top := Mouse.CursorPos.Y - dp.Y;
  end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  PaintBox1Paint(Sender);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if (ListBox1.ItemIndex > -1) and (Form3.ShowModal = mrOK) then
  begin
    PageControl1.TabIndex := 1;
    Back.Enabled := true;
    doubleScreen.Enabled := true;
    ReversePage.Enabled := true;
    Panel2.Show;
    TrackBar1.SetFocus;
    doubleScreenExecute(Sender);
    if Action2.Checked then
      TrackBar1.Position := TrackBar1.Max
    else
      TrackBar1.Position := 0;
    TrackBar1Change(Sender);
  end;
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

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ListBox1DblClick(Sender);
end;

procedure TForm1.LoadFromSQL(out bmp: TBitmap);
var
  zs, sm: TStream;
begin
  with DataModule4.FDQuery1 do
  begin
    sm := CreateBlobStream(FieldByName('image'), bmRead);
    zs := TZDecompressionStream.Create(sm);
    bmp := TBitmap.Create;
    try
      bmp.LoadFromStream(zs);
    finally
      sm.Free;
      zs.Free;
    end;
  end;
end;

procedure TForm1.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = TMouseButton.mbRight then
    if double = pgSingle then
      PageControl1.ActivePageIndex := 1
    else
      PageControl1.ActivePageIndex := 2;
end;

procedure TForm1.moment;
begin
  if CheckBox1.Checked then
    Timer1.Enabled := not Timer1.Enabled;
  if Timer1.Enabled then
    Image1.Hint := 'ページめくり'
  else
    Image1.Hint := '一時停止';
  TabSheet3.Hint := Image1.Hint;
end;

procedure TForm1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := false;
end;

procedure TForm1.PageControl1MouseEnter(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 3 then
    if double = pgSingle then
      PageControl1.ActivePageIndex := 1
    else
      PageControl1.ActivePageIndex := 2;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  Rect: ^TRect;
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
      LoadFromSQL(bmp);
      Rect := Pointer(ListBox1.Items.Objects[i]);
      PaintBox1.Canvas.StretchDraw(Rect^, bmp);
    end;
    id_num := ListBox1.ItemIndex;
    if id_num > -1 then
      with DataModule4.FDQuery1 do
      begin
        Locate('title', ListBox1.Items[id_num]);
        LoadFromSQL(bmp);
        Rect := Pointer(ListBox1.Items.Objects[id_num]);
        PaintBox1.Canvas.Rectangle(Rect^);
        PaintBox1.Canvas.StretchDraw(Rect^, bmp);
      end;
  finally
    bmp.Free;
  end;
end;

procedure TForm1.progressEvent(Sender: TObject; FileName: string;
  Header: TZipHeader; Position: Int64);
begin
  ProgressBar1.Position := 100 - (100 * Position) div Header.CompressedSize;
  ProgressBar1.Update;
end;

procedure TForm1.readCursor;
begin
  Screen.Cursors[crLeft] := LoadCursorFromFile('left.cur');
  Screen.Cursors[crRight] := LoadCursorFromFile('right.cur');
end;

procedure TForm1.refreshLib;
var
  img: TBitmap;
  Rect: PRect;
begin
  for var i := 0 to ListBox1.Items.Count - 1 do
    Dispose(Pointer(ListBox1.Items.Objects[i]));
  ListBox1.Items.Clear;
  with DataModule4.FDQuery1 do
  begin
    Open(query);
    while not Eof do
    begin
      LoadFromSQL(img);
      try
        New(Rect);
        Rect^ := makeRect(img);
        ListBox1.Items.AddObject(FieldByName('title').AsString, Pointer(Rect));
      finally
        img.Free;
      end;
      Next;
    end;
  end;
end;

procedure TForm1.RePaintExecute(Sender: TObject);
begin
  PaintBox1Paint(Sender);
end;

function TForm1.checkExt(ext: string): Boolean;
var
  ls: TList<string>;
begin
  ls := TList<string>.Create;
  try
    ls.Add('.bmp');
    ls.Add('.jpg');
    ls.Add('.jpeg');
    ls.Add('.png');
    ls.Add('.gif');
    ls.Add('.webp');
    ls.Add('.svg');
    result := ls.IndexOf(ExtractFileExt(ext)) > -1;
  finally
    ls.Free;
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
  TabSheet3Resize(Sender);
end;

procedure TForm1.TabSheet3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if X < PageControl1.Width div 3 then
    TabSheet3.Cursor := crLeft
  else if X > 2 * PageControl1.Width div 3 then
    TabSheet3.Cursor := crRight
  else
    TabSheet3.Cursor := crDefault;
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
      img1.Width := Round(img1.Height / img1.Picture.Graphic.Height *
        img1.Picture.Graphic.Width);
    if (Sender = TabSheet3) and not img2.Picture.Graphic.Empty then
      img2.Width := Round(img2.Height / img2.Picture.Graphic.Height *
        img2.Picture.Graphic.Width);
    img1.Left := -img1.Width + TabSheet3.Width div 2;
    img2.Left := TabSheet3.Width div 2;
    img1.Top := 0;
    img2.Top := 0;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if reverse then
  begin
    if TrackBar1.Position = 0 then
      TrackBar1.Position := TrackBar1.Max;
  end
  else if TrackBar1.Position = TrackBar1.Max then
    TrackBar1.Position := 0;
  case PageControl1.ActivePageIndex of
    1, 2:
      if reverse then
        TrackBar1.Position := TrackBar1.Position - 1
      else
        TrackBar1.Position := TrackBar1.Position + 1;
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
        p.Left := DataModule4.FDMemTable1.FieldByName('page_id').AsInteger;
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
  zs, tmp: TStream;
  pos: integer;
begin
  if Action2.Checked then
    pos := TrackBar1.Max - TrackBar1.Position
  else
    pos := TrackBar1.Position;
  if double = pgSingle then
    DataModule4.FDMemTable1.Locate('page_id', pos + 1)
  else
  begin
    p := pageList[pos];
    if checkSemi(pos) then
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
        with DataModule4.FDMemTable1 do
          tmp := CreateBlobStream(FieldByName('image'), bmRead);
        zs := TZDecompressionStream.Create(tmp);
        try
          Image1.Picture.LoadFromStream(zs);
        finally
          tmp.Free;
          zs.Free;
        end;
        StatusBar1.Panels[3].Text := DataModule4.FDMemTable1.FieldByName
          ('page_id').AsString;
      end;
    pgDouble:
      begin
        PageControl1.TabIndex := 2;
        with DataModule4.FDMemTable1 do
          tmp := CreateBlobStream(FieldByName('image'), bmRead);
        zs := TZDecompressionStream.Create(tmp);
        try
          Image2.Picture.LoadFromStream(zs);
        finally
          zs.Free;
          tmp.Free;
        end;
        DataModule4.FDMemTable1.Next;
        with DataModule4.FDMemTable1 do
          tmp := CreateBlobStream(FieldByName('image'), bmRead);
        zs := TZDecompressionStream.Create(tmp);
        try
          Image3.Picture.LoadFromStream(zs);
        finally
          zs.Free;
          tmp.Free;
        end;
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

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  Timer1.Enabled := CheckBox1.Checked and not(UpDown1.Position = 0);
  Timer1.Interval := UpDown1.Position * 1000;
end;

procedure TForm1.versionExecute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TForm1.ZipLoop;
var
  sub: integer;
  s: string;
  Rect: TRect;
  Thread: TMyThread;
begin
  for var k := 0 to fileList.Count - 1 do
  begin
    s := fileList[k];
    ProgressBar2.Position := ProgressBar2.Position + 1;
    ProgressBar2.Update;
    Thread := TMyThread.Create(s, Rect);
    try
      if (Rect.Width > Rect.Height) or ((k = 0) and hyousi) then
        sub := 1
      else
        sub := 0;
      with DataModule4.FDQuery1 do
      begin
        Params[0].AsIntegers[k] := id_num + k;
        Params[1].AsIntegers[k] := k + 1;
        Params[2].LoadFromStream(Thread.Stream, ftBlob, k);
        Params[3].AsIntegers[k] := title_id;
        Params[4].AsStrings[k] := title;
        Params[5].AsIntegers[k] := sub;
      end;
    finally
      Thread.Free;
    end;
  end;
end;

function TForm1.ZipReader: Boolean;
var
  s, t: string;
begin
  result := false;
  s := OKRightDlg.OpenDialog1.FileName;
  t := ExtractFilePath(Application.ExeName) + 'tmp';
  if LowerCase(ExtractFileExt(s)) = '.zip' then
  begin
    title := OKRightDlg.Edit1.Text;
    if ListBox1.Items.IndexOf(title) > -1 then
      Exit;
    hyousi := OKRightDlg.CheckBox1.Checked;
    Screen.Cursor := crHourGlass;
    with DataModule4.FDQuery1 do
    begin
      Open('select COUNT(*) as cnt from pdfdatabase;');
      if FieldByName('cnt').AsInteger = 0 then
      begin
        id_num := 1;
        title_id := 1;
      end
      else
      begin
        Open('select MAX(id) as id from pdfdatabase;');
        id_num := FieldByName('id').AsInteger + 1;
        Open('select MAX(title_id) as title_id from pdfdatabase;');
        title_id := FieldByName('title_id').AsInteger + 1;
      end;
      Close;
      SQL.Text :=
        'insert into pdfdatabase (id, page_id, image, title_id, title, subimage) values (:id, :page_id, :image, :title_id, :title, :subimage);';
    end;
    if not DirectoryExists('tmp') then
      MkDir('tmp');
    ProgressBar1.Max := 100;
    ProgressBar2.Max := Length(arr);
    ProgressBar1.Position := 0;
    ProgressBar2.Position := 0;
    Panel1.Show;
    fileList := TList<string>.Create;
    try
      TZipFile.ExtractZipFile(s, t, progressEvent);
      for var name in arr do
        if checkExt(name) then
          fileList.Add(t + '\' + name)
        else
          DeleteFile(t + '\' + name);
      DataModule4.FDQuery1.Params.ArraySize := fileList.Count;
      ZipLoop;
      DataModule4.FDQuery1.Execute(fileList.Count, 0);
    finally
      fileList.Free;
      Finalize(arr);
      Screen.Cursor := crDefault;
      OKRightDlg.Edit1.Text := '';
      refreshLib;
      TDirectory.Delete(t, true);
      Panel1.Hide;
    end;
    result := true;
  end;
  PaintBox1Paint(nil);
end;

end.
