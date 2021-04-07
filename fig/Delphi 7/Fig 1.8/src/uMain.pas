{
  Пример № 9 - Небольшие примеры кода.
  Пример иллюстрирует использование различных функций VT,
  не попавших под категории выше.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, XPMan, JPEG, Math;

type
  PUser = ^TUser;

  TUser = record
    Name: String;
    Messages: Word;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    CbMultiline: TCheckBox;
    BtnOptions: TButton;
    LblCopy: TLabel;
    CbBlendedSelection: TCheckBox;
    procedure VTResize(Sender: TObject);
    procedure VTGetLineStyle(Sender: TBaseVirtualTree; var Bits: Pointer);
    procedure VTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure VTInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var ChildCount: Cardinal);
    procedure VTHeaderDrawQueryElements(Sender: TVTHeader;
      var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
    procedure FormDestroy(Sender: TObject);
    procedure VTAdvancedHeaderDraw(Sender: TVTHeader;
      var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
    procedure VTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VTMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; var NodeHeight: Integer);
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure CbBlendedSelectionClick(Sender: TObject);
    procedure CbMultilineClick(Sender: TObject);
    procedure BtnOptionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ImgUser, ImgMsg, ImgGrad: TPicture;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Arr: TByteArray;

implementation

uses
  uOptions;

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.BtnOptionsClick(Sender: TObject);
begin
  frmOptions.Show;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CbBlendedSelectionClick(Sender: TObject);
begin
  if CbBlendedSelection.Checked then
    VT.TreeOptions.PaintOptions := VT.TreeOptions.PaintOptions + [toUseBlendedSelection]
  else
    VT.TreeOptions.PaintOptions := VT.TreeOptions.PaintOptions - [toUseBlendedSelection];
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CbMultilineClick(Sender: TObject);
begin
  VT.ReinitNode(VT.RootNode, True);
  VT.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  VT.NodeDataSize := SizeOf(TUser);
  VT.RootNodeCount := 6;
  VT.ReinitNode(VT.RootNode, True);
  ImgUser := TPicture.Create;
  ImgUser.LoadFromFile('user.jpg');
  ImgMsg := TPicture.Create;
  ImgMsg.LoadFromFile('msg.jpg');
  ImgGrad := TPicture.Create;
  ImgGrad.LoadFromFile('grad.jpg');
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ImgUser);
  FreeAndNil(ImgMsg);
  FreeAndNil(ImgGrad);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTAdvancedHeaderDraw(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
begin
  if hpeBackground in Elements then
    with PaintInfo.TargetCanvas do
    begin
      // Рисуем фон всего заголовка дерева
      Brush.Color := $00C9C9C9;
      FillRect(PaintInfo.PaintRectangle);
      // Растягиваем градиент
      StretchDraw(PaintInfo.PaintRectangle, ImgGrad.Graphic);
      if PaintInfo.Column <> nil then
      begin
        // Необходимо нарисовать заголовок какой-то конкретной колонки
        case PaintInfo.Column.Index of
          // Пользователь
          0: Draw(PaintInfo.PaintRectangle.Left + ((PaintInfo.PaintRectangle.Right - PaintInfo.PaintRectangle.Left) div 2) - (ImgUser.Width div 2),
            PaintInfo.PaintRectangle.Top, ImgUser.Graphic);
          // Кол-во сообщений
          1: Draw(PaintInfo.PaintRectangle.Left + ((PaintInfo.PaintRectangle.Right - PaintInfo.PaintRectangle.Left) div 2) - (ImgMsg.Width div 2),
            PaintInfo.PaintRectangle.Top, ImgMsg.Graphic);
        end;
      end;
    end;
end;

//------------------------------------------------------------------------------
// Передача текста подсказки дереву в зависимости от её типа.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
  var HintText: WideString);
begin
  if VT.HintMode <> hmTooltip then
    HintText := 'Хинт из OnGetHint события: текст подсказки...'
  else
    HintText := VT.Text[Node, Column];
end;

//------------------------------------------------------------------------------
// Задаём стиль линий дерева. Чем больше значение байта, тем реже будут
// повторяться точки.
//------------------------------------------------------------------------------
procedure TfrmMain.VTGetLineStyle(Sender: TBaseVirtualTree; var Bits: Pointer);
var
  i: Integer;
begin
  Bits := @Arr;
  for i := 0 to Length(Arr) - 1 do
    Arr[i] := 254;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  User: PUser;
begin
  User := Sender.GetNodeData(Node);
  case Sender.GetNodeLevel(Node) of
    0:
    case Column of
      0: CellText := User^.Name;
      1: CellText := IntToStr(User^.Messages);
    end;
    1:
    case Column of
      0:
      case Node.Index of
        0: CellText := 'В тематичкских разделах';
        1: CellText := 'Во флейме';
      end;
      1:
      case Node.Index of
        0: CellText := IntToStr(User^.Messages div 4);
        1: CellText := IntToStr(trunc(User^.Messages * (3/4)));
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Передаёи в набор те элементы, которые мы будем заменять.
// Непереданные элементы (hpeDropMark, hpeHeaderGlyph, hpeSortGlyph)
// останутся на совести дерева.
//------------------------------------------------------------------------------
procedure TfrmMain.VTHeaderDrawQueryElements(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
begin
  // Мы будем заменять текст колонок и фон всего заголовка
  Elements := [hpeBackground, hpeText];
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var ChildCount: Cardinal);
begin
  if Sender.GetNodeLevel(Node) = 0 then
    ChildCount := 2;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  User: PUser;
begin
  User := Sender.GetNodeData(Node);
  if Length(User^.Name) = 0 then
  begin
    User^.Name := 'Node Index: ' + IntToStr(Node.Index);
    User^.Messages := 0;
  end;
  // Мы точно знаем, что узлы первого уровня будут иметь по 2
  // дочерних узла, поэтому можем сообзить дереву заранее о том, что эта
  // ветка будет содержать дочерние.
  // Тогда дерево в свою очередь вызовет для неё событие OnInitChildren.
  if Sender.GetNodeLevel(Node) = 0 then
    Include(InitialStates, ivsHasChildren);
  // Включаем/выключаем поддержку многострочности
  if CbMultiline.Checked then
    Include(InitialStates, ivsMultiline)
  else begin
    Exclude(InitialStates, ivsMultiline);
    // НЕ ЗАБЫВАЙТЕ ВЫПОЛНЯТЬ ЭТО:
    Node.States := Node.States - [vsMultiline];
    // Это выключит многострочность для узлов, где она раньше была.
  end;
end;

//------------------------------------------------------------------------------
// Подсчёт высоты узлов в соответствии с высотой переносимого текста.
//------------------------------------------------------------------------------
procedure TfrmMain.VTMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if CbMultiline.Checked then
  begin
    NodeHeight := VT.ComputeNodeHeight(TargetCanvas, Node, 0) + 4;
    NodeHeight := Max(18, NodeHeight);
  end
  else
    NodeHeight := 18;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  User: PUser;
begin
  User := Sender.GetNodeData(Node);
  case Sender.GetNodeLevel(Node) of
    0:
    case Column of
      0: User^.Name := NewText;
      1: User^.Messages := StrToIntDef(NewText, 0);
    end;
    1: {ничего};
  end;
end;

//------------------------------------------------------------------------------
// Располагаем фоновую картинку по центру.
//------------------------------------------------------------------------------
procedure TfrmMain.VTResize(Sender: TObject);
begin
  VT.BackgroundOffsetX := (VT.Width div 2) - (VT.Background.Width div 2);
  VT.BackgroundOffsetY := (VT.Height div 2) - (VT.Background.Height div 2);
end;

end.
