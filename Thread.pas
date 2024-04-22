unit Thread;

interface

uses
  System.Classes, Vcl.Graphics, Zlib, SkiSys.GS_Api, SkiSys.GS_Converter,
  SkiSys.GS_ParameterConst, SkiSys.GS_gdevdsp, Data.DB, System.SyncObjs;

type
  TMyThread = class(TThread)
  private
    { Private 宣言 }
    FIndex: integer;
    FImg: TGraphic;
    FStream: TStream;
  protected
    procedure Execute; override;
  public
    constructor Create(AIndex: integer; AImg: TGraphic); virtual;
    destructor Destroy; override;
    property Stream: TStream read FStream;
  end;

  TZipThread = class(TMyThread)
  public
    constructor Create(AIndex: integer; AImg: TGraphic); override;
    destructor Destroy; override;
  end;

implementation

{
  重要: ビジュアル コンポーネントにおけるオブジェクトのメソッドとプロパティは、Synchronize を使って
  呼び出されるメソッドでのみ使用できます。たとえば、次のようになります。

  Synchronize(UpdateCaption);

  UpdateCaption は、たとえば次のようなコードになります。

  procedure TMyThread.UpdateCaption;
  begin
  Form1.Caption := 'スレッドで更新されました';
  end;

  あるいは

  Synchronize(
  procedure
  begin
  Form1.Caption := '無名メソッドを通じてスレッドで更新されました'
  end
  )
  );

  ここでは、無名メソッドが渡されています。

  同様に、開発者は上記と同じようなパラメータで Queue メソッドを呼び出すことができます。
  ただし、別の TThread クラスを第 1 パラメータとして渡し、呼び出し元のスレッドを
  もう一方のスレッドでキューに入れます。

}

uses Unit4, Unit1;

{ TMyThread }

constructor TMyThread.Create(AIndex: integer; AImg: TGraphic);
begin
  inherited Create(false);
  FIndex := AIndex;
  FImg := AImg;
  FStream := TMemoryStream.Create;
end;

destructor TMyThread.Destroy;
begin
  FStream.Free;
  inherited;
end;

procedure TMyThread.Execute;
var
  zs: TStream;
begin
  { スレッドとして実行したいコードをここに記述してください }
  zs := TZCompressionStream.Create(clMax, FStream);
  try
    FImg.SaveToStream(zs);
  finally
    zs.Free;
  end;
end;

{ TZipThread }

constructor TZipThread.Create(AIndex: integer; AImg: TGraphic);
begin
  inherited;
  FImg:=TBitmap.Create;
  FImg.Assign(AImg);
end;

destructor TZipThread.Destroy;
begin
  FImg.Free;
  inherited;
end;

end.
