unit Thread;

interface

uses
  System.Classes, Vcl.Graphics, Zlib;

type
  TMyThread = class(TThread)
  private
    { Private �錾 }
    FIndex: integer;
    FImg: TGraphic;
    FStream: TStream;
    function GetStream: TStream;
  protected
    procedure Execute; override;
  public
    constructor Create(AIndex: integer; AImg: TGraphic);
    destructor Destroy; override;
    property Stream: TStream read GetStream;
  end;

  TZipThread = class(TMyThread)
  public
    constructor Create(AIndex: integer; AImg: TGraphic);
    destructor Destroy; override;
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

constructor TMyThread.Create(AIndex: integer; AImg: TGraphic);
begin
  inherited Create(false);
  FreeOnTerminate := false;
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
  { �X���b�h�Ƃ��Ď��s�������R�[�h�������ɋL�q���Ă������� }
  zs := TZCompressionStream.Create(clMax, FStream);
  try
    FImg.SaveToStream(zs);
  finally
    zs.Free;
  end;
end;

function TMyThread.GetStream: TStream;
begin
  if not Finished then
    WaitFor;
  result := FStream;
end;

{ TZipThread }

constructor TZipThread.Create(AIndex: integer; AImg: TGraphic);
begin
  inherited;
  FImg := TBitmap.Create;
  FImg.Assign(AImg);
end;

destructor TZipThread.Destroy;
begin
  FImg.Free;
  inherited;
end;

end.
