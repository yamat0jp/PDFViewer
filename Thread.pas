unit Thread;

interface

uses
  System.Classes, Vcl.Graphics, Zlib, System.SysUtils, System.Types, Vcl.Skia,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg;

type
  TMyThread = class(TThread)
  private
    { Private �錾 }
    FImg: TBitmap;
    FStream: TMemoryStream;
    function GetStream: TMemoryStream;
  protected
    procedure Execute; override;
  public
    constructor Create(AImg: TGraphic); overload;
    constructor Create(const FileName: string; var ARect: TRect); overload;
    destructor Destroy; override;
    property Stream: TMemoryStream read GetStream;
  end;

implementation

{
  �d�v: �r�W���A�� �R���|�[�l���g�ɂ�����I�u�W�F�N�g�̃��\�b�h�ƃv���p�e�B�́ASynchronize ���g����
  �Ăяo����郁�\�b�h�ł̂ݎg�p�ł��܂��B���Ƃ��΁A���̂悤�ɂȂ�܂��B

  Synchronize(UpdateCaption);

  UpdateCaption �́A���Ƃ��Ύ��̂悤�ȃR�[�h�ɂȂ�܂��B

  procedure TMyThread.UpdateCaption;
  begin
  Form1.Caption := '�X���b�h�ōX�V����܂���';
  end;

  ���邢��

  Synchronize(
  procedure
  begin
  Form1.Caption := '�������\�b�h��ʂ��ăX���b�h�ōX�V����܂���'
  end
  )
  );

  �����ł́A�������\�b�h���n����Ă��܂��B

  ���l�ɁA�J���҂͏�L�Ɠ����悤�ȃp�����[�^�� Queue ���\�b�h���Ăяo�����Ƃ��ł��܂��B
  �������A�ʂ� TThread �N���X��� 1 �p�����[�^�Ƃ��ēn���A�Ăяo�����̃X���b�h��
  ��������̃X���b�h�ŃL���[�ɓ���܂��B

}

{ TMyThread }

constructor TMyThread.Create(AImg: TGraphic);
begin
  inherited Create(false);
  FreeOnTerminate := false;
  FImg := TBitmap.Create;
  FImg.Assign(AImg);
  FStream := TMemoryStream.Create;
end;

constructor TMyThread.Create(const FileName: string; var ARect: TRect);
var
  pic: TPicture;
begin
  inherited Create(false);
  FreeOnTerminate := false;
  FStream := TMemoryStream.Create;
  FImg := TBitmap.Create;
  pic := TPicture.Create;
  try
    pic.LoadFromFile(FileName);
    FImg.Width := pic.Graphic.Width;
    FImg.Height := pic.Graphic.Height;
    FImg.Canvas.Draw(0, 0, pic.Graphic);
  finally
    pic.Free;
  end;
  ARect := Rect(0, 0, FImg.Width, FImg.Height);
end;

destructor TMyThread.Destroy;
begin
  FStream.Free;
  FImg.Free;
  inherited;
end;

procedure TMyThread.Execute;
var
  zs: TStream;
begin
  { �X���b�h�Ƃ��Ď��s�������R�[�h�������ɋL�q���Ă������� }
  zs := TZCompressionStream.Create(clMax, FStream);
  try
    FImg.SaveToStream(zs);
  finally
    zs.Free;
  end;
end;

function TMyThread.GetStream: TMemoryStream;
begin
  if not Finished then
    WaitFor;
  result := FStream;
end;

end.
