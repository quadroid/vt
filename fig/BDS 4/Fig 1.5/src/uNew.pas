unit uNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ExtCtrls, VirtualTrees;

type
  TStrArr = array of String;

  // Класс для получения доступных файлов *.jpg катринок
  TImageProvider = class
  private
    FImages: TStrArr;
    FIndex, FCount: Integer;
  public
    procedure GetImages;
    property Images: TStrArr read FImages;
    property Index: Integer read FIndex write FIndex;
    property Count: Integer read FCount write FCount;
  end;

  TfrmNew = class(TForm)
    Gb: TGroupBox;
    BtnCancel: TButton;
    BtnOK: TButton;
    LblName: TLabel;
    EdName: TEdit;
    Label2: TLabel;
    LblMass: TLabel;
    PnImg: TPanel;
    EdMass: TEdit;
    UpDnMass: TUpDown;
    Img: TImage;
    UpDnImg: TUpDown;
    LblPrice: TLabel;
    EdPrice: TEdit;
    UpDnPrice: TUpDown;
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure UpDnImgClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
  private
    ImageProv: TImageProvider;
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

uses
  uMain;

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * TImageProvider * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TImageProvider.GetImages;
var
  fs: TSearchRec;
begin
  FCount := 0;
  FIndex := -1;
  if FindFirst(ExtractFilePath(Application.ExeName) + '*.jpg', faAnyFile, fs) = 0 then
    repeat
      Inc(FCount);
      SetLength(FImages, Length(FImages) + 1);
      FImages[Length(FImages) - 1] := fs.Name;
    until
      FindNext(fs) <> 0;
  SysUtils.FindClose(fs);
  if FCount > 0 then
    Index := 0;
end;

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * TfrmNew * * * * * * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
// Добавление нового узла в дерево.
//------------------------------------------------------------------------------
procedure TfrmNew.BtnOKClick(Sender: TObject);
var
  NewNode: PVirtualNode;
  ItemData: PItemNode;
begin
  NewNode := frmMain.VT.AddChild(nil);
  ItemData := frmMain.VT.GetNodeData(NewNode);
  with ItemData^ do
  begin
    Name := EdName.Text;
    Process := 0;
    Image := ImageProv.Images[UpDnImg.Position];
    Mass := StrToIntDef(EdMass.Text, 0);
    PriceKg := StrToIntDef(EdPrice.Text, 0);
    PersonalThread := 0;
  end;
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmNew.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmNew.FormCreate(Sender: TObject);
begin
  ImageProv := TImageProvider.Create;
  ImageProv.GetImages;
  UpDnImg.Max := ImageProv.Count - 1;
  if ImageProv.Index > -1 then
    Img.Picture.LoadFromFile(ImageProv.Images[ImageProv.Index])
  else
    UpDnImg.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmNew.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ImageProv);
end;

//------------------------------------------------------------------------------

procedure TfrmNew.UpDnImgClick(Sender: TObject; Button: TUDBtnType);
begin
  if ImageProv.Index > -1 then
    Img.Picture.LoadFromFile(ImageProv.Images[UpDnImg.Position]);
end;

end.
