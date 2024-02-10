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
  Data.Bind.DBScope;

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
    procedure countPictures;
    function returnPos(page: integer; var double: TPageState): integer;
    function checkSemi(num: integer): Boolean;
    function ZipReader: Boolean;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;
  password: string;

implementation

{$R *.dfm}

uses SkiSys.GS_Api, SkiSys.GS_Converter, SkiSys.GS_ParameterConst,
  SkiSys.GS_gdevdsp, Unit3, ABOUT, OKCANCL2, Unit4, System.Zip, Jpeg;

var
  id, title_id: integer;
  title: string;
  pdf: TGS_PdfConverter;

const
  query = 'select * from pdfdatabase where page_id = 1 order by id asc';

function makeRect(jpg: TJpegImage): TRect;
var
  num, consw, consh: integer;
begin
  num := 120;
  if jpg.Width > jpg.Height then
  begin
    consw := num;
    consh := Round(num * jpg.Height / jpg.Width);
  end
  else
  begin
    consh := num;
    consw := Round(num * jpg.Width / jpg.Height);
  end;
  result.Left := Random(Form1.PaintBox1.Width - consw);
  result.Top := Random(Form1.PaintBox1.Height - consh);
  result.Width := consw;
  result.Height := consh;
end;

procedure TForm1.OpenExecute(Sender: TObject);
var
  sub: integer;
  Jpeg: TJpegImage;
  p: ^TRect;
begin
  try
    if (OKRightDlg.ShowModal = mrOK) and (OKRightDlg.Edit1.Text <> '') and not ZipReader
    then
    begin
      pdf := TGS_PdfConverter.Create;
      Jpeg := TJpegImage.Create;
      DataModule4.FDTable1.Open;
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
        Jpeg.Assign(pdf.GSDisplay.GetPage(0));
        New(p);
        p^ := makeRect(Jpeg);
        ListBox1.Items.AddObject(title, Pointer(p));
        with DataModule4.FDQuery1 do
        begin
          Open('select COUNT(*) as cnt from pdfdatabase;');
          if FieldByName('cnt').AsInteger = 0 then
          begin
            id := 1;
            title_id := 1;
          end
          else
          begin
            Open('select MAX(id) as id from pdfdatabase;');
            id := FieldByName('id').AsInteger + 1;
            Open('select MAX(title_id) as title_id from pdfdatabase;');
            title_id := FieldByName('title_id').AsInteger + 1;
          end;
          Close;
        end;
        for var i := 0 to pdf.GSDisplay.PageCount - 1 do
        begin
          Jpeg.Assign(pdf.GSDisplay.GetPage(i));
          if (Jpeg.Width > Jpeg.Height) or (hyousi and (i + 1 = 1)) then
            sub := 1
          else
            sub := 0;
          DataModule4.FDTable1.AppendRecord([id, i + 1, Jpeg, title_id,
            title, sub]);
          inc(id);
        end;
      finally
        pdf.Free;
        Jpeg.Free;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    OKRightDlg.OleContainer1.DestroyObject;
    OKRightDlg.Edit1.Text := '';
  end;
  PaintBox1Paint(Sender);
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
  Jpeg: TJpegImage;
  p: ^TRect;
begin
  with DataModule4.FDQuery1 do
  begin
    Open(query);
    Jpeg := TJpegImage.Create;
    try
      while not Eof do
      begin
        title := FieldByName('title').AsString;
        if ListBox1.Items.IndexOf(title) = -1 then
        begin
          Jpeg.Assign(FieldByName('image'));
          New(p);
          p^ := makeRect(Jpeg);
          ListBox1.Items.AddObject(title, Pointer(p));
        end;
        Next;
      end;
    finally
      Jpeg.Free;
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
    FetchAll;
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
  Jpeg: TJpegImage;
begin
  if not DataModule4.FDQuery1.Active then
    DataModule4.FDQuery1.Open(query);
  Randomize;
  PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
  PaintBox1.Canvas.Pen.Color := clRed;
  PaintBox1.Canvas.Pen.Width := 10;
  Jpeg := TJpegImage.Create;
  try
    for var i := 0 to ListBox1.Items.Count - 1 do
    begin
      if ListBox1.ItemIndex = i then
        continue;
      DataModule4.FDQuery1.Locate('title', ListBox1.Items[i]);
      Jpeg.Assign(DataModule4.FDQuery1.FieldByName('image'));
      rect := Pointer(ListBox1.Items.Objects[i]);
      PaintBox1.Canvas.StretchDraw(rect^, Jpeg);
    end;
    id := ListBox1.ItemIndex;
    if id > -1 then
    begin
      DataModule4.FDQuery1.Locate('title', ListBox1.Items[id]);
      Jpeg.Assign(DataModule4.FDQuery1.FieldByName('image'));
      rect := Pointer(ListBox1.Items.Objects[id]);
      PaintBox1.Canvas.Rectangle(rect^);
      PaintBox1.Canvas.StretchDraw(rect^, Jpeg);
    end;
  finally
    Jpeg.Free;
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

procedure dirdelete(name: string);
var
  i: integer;
  rec: TSearchRec;
begin
  i := FindFirst(name + '\*', faDirectory, rec);
  while i = 0 do
  begin
    if (rec.name <> '.') and (rec.name <> '..') then
      dirdelete(name + '\' + rec.name);
    i := FindNext(rec);
  end;
  RemoveDir(name);
  FindClose(rec);
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

function TForm1.ZipReader: Boolean;
var
  sub: integer;
  s: string;
  cnt: integer;
  Jpeg: TJpegImage;
  Zip: TZipFile;
  p: ^TRect;
begin
  result := false;
  s := OKRightDlg.OpenDialog1.FileName;
  if ExtractFileExt(s) = '.zip' then
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
        id := 1;
        title_id := 1;
      end
      else
      begin
        Open('select MAX(id) as id from pdfdatabase;');
        id := FieldByName('id').AsInteger + 1;
        Open('select MAX(title_id) as title_id from pdfdatabase;');
        title_id := FieldByName('title_id').AsInteger + 1;
      end;
      Close;
    end;
    Zip := TZipFile.Create;
    Jpeg := TJpegImage.Create;
    if not DirectoryExists('temp') then
      MkDir('temp');
    try
      cnt := 1;
      Zip.Open(s, zmRead);
      for var i := 0 to Zip.FileCount - 1 do
      begin
        if ExtractFileExt(Zip.FileName[i]) <> '.jpg' then
          continue;
        s := Zip.FileName[i];
        Zip.Extract(s, 'temp');
        Jpeg.LoadFromFile('temp\' + s);
        DeleteFile('temp\' + s);
        if cnt = 1 then
        begin
          New(p);
          p^ := makeRect(Jpeg);
          ListBox1.Items.AddObject(title, Pointer(p));
        end;
        if (Jpeg.Width > Jpeg.Height) or (hyousi and (cnt = 1)) then
          sub := 1
        else
          sub := 0;
        DataModule4.FDTable1.AppendRecord([id, cnt, Jpeg, title_id,
          title, sub]);
        inc(id);
        inc(cnt);
      end;
    finally
      Zip.Free;
      Jpeg.Free;
      Screen.Cursor := crDefault;
      OKRightDlg.Edit1.Text := '';
      dirdelete(ExtractFilePath(Application.ExeName) + 'temp');
    end;
    result := true;
  end;
  PaintBox1Paint(nil);
end;

end.
