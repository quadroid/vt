{
  Пример № 7 - Сохранение и загрузка VT из файла.
  Пример иллюстрирует сохранение и загрузку дерева стандартными
  средствами VT, а также импорт и экспорт дерева в различные форматы
  данных.
  Примечание:
  Результат ЮНИКОД-сохранения возможно будет видеть только в примере,
  скомпилированным BDS 4 из соответствующей папки.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, XPMan, XMLDoc, XMLIntf, ShellApi;

const
  Strs: array[0..4] of WideString = (
    'Lorem ipsum dolor sit amet',
    'Praesent euismod tincidunt dui',
    'Vestibulum in felis',
    'Praesent quis sem. In massa erat',
    'Mauris laoreet'
  );
  Ints: array[0..4] of Integer = (
    938,
    5346,
    23,
    789,
    2888
  );

type
  PNodeData = ^TNodeData;

  TNodeData = record
    Caption: WideString;
    Value: Integer;
  end;

  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    BtnLoad: TButton;
    BtnSave: TButton;
    BtnClear: TButton;
    BtnFill: TButton;
    BtnLoadXML: TButton;
    BtnSaveXML: TButton;
    BtnExportHTML: TButton;
    BtnExportRTF: TButton;
    BtnExportANSI: TButton;
    BtnExportUNICODE: TButton;
    BtnExportCSV: TButton;
    LblCopy: TLabel;
    procedure BtnExportCSVClick(Sender: TObject);
    procedure BtnExportUNICODEClick(Sender: TObject);
    procedure BtnExportANSIClick(Sender: TObject);
    procedure BtnExportRTFClick(Sender: TObject);
    procedure BtnExportHTMLClick(Sender: TObject);
    procedure BtnSaveXMLClick(Sender: TObject);
    procedure BtnLoadXMLClick(Sender: TObject);
    procedure VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnFillClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.BtnClearClick(Sender: TObject);
begin
  VT.Clear;
end;

//------------------------------------------------------------------------------
// Экспорт в обычный текстовый файл.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnExportANSIClick(Sender: TObject);
var
  Fs: TFileStream;
  Str: String;
  Data: Pointer;
begin
  Fs := TFileStream.Create('ansi.txt', fmCreate);
  try
    Str := VT.ContentToText(tstAll, #9);
    Data := PChar(Str);
    Fs.WriteBuffer(Data^, Length(Str));
  finally
    FreeAndNil(fs);
  end;
  ShellExecute(Handle, 'open', 'ansi.txt', nil, nil, SW_RESTORE);
end;

//------------------------------------------------------------------------------
// Экспорт в таблицу.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnExportCSVClick(Sender: TObject);
var
  Fs: TFileStream;
  Str: String;
  Data: Pointer;
begin
  Fs := TFileStream.Create('csv.csv', fmCreate);
  try
    Str := VT.ContentToText(tstAll, ListSeparator);
    Data := PChar(Str);
    Fs.WriteBuffer(Data^, Length(Str));
  finally
    FreeAndNil(fs);
  end;
  ShellExecute(Handle, 'open', 'csv.csv', nil, nil, SW_RESTORE);
end;

//------------------------------------------------------------------------------
// HTML-формтаированная таблица.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnExportHTMLClick(Sender: TObject);
const
  HTMLHead = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">'#13#10 +
    '<html>'#13#10 +
    '<head>'#13#10 +
    '  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">'#13#10 +
    '  <title>Virtual Treeview HTML</title>'#13#10 +
    '</head>'#13#10 +
    '<body>'#13#10;
  HTMLFoot = '</body>'#13#10 +
    '</html>' + #13#10;
var
  Fs: TFileStream;
  Str: String;
  Data: Pointer;
begin
  Fs := TFileStream.Create('html.html', fmCreate);
  try
    Str := HTMLHead + VT.ContentToHTML(tstAll) + HTMLFoot;
    Data := PChar(Str);
    Fs.WriteBuffer(Data^, Length(Str));
  finally
    FreeAndNil(fs);
  end;
  ShellExecute(Handle, 'open', 'html.html', nil, nil, SW_RESTORE);
end;

//------------------------------------------------------------------------------
// RTF-форматированная таблица.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnExportRTFClick(Sender: TObject);
var
  Fs: TFileStream;
  Str: String;
  Data: Pointer;
begin
  Fs := TFileStream.Create('rtf.rtf', fmCreate);
  try
    Str := VT.ContentToRTF(tstAll);
    Data := PChar(Str);
    Fs.WriteBuffer(Data^, Length(Str));
  finally
    FreeAndNil(fs);
  end;
  ShellExecute(Handle, 'open', 'rtf.rtf', nil, nil, SW_RESTORE);
end;

//------------------------------------------------------------------------------
// ЮНИКОД-текст.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnExportUNICODEClick(Sender: TObject);
var
  Fs: TFileStream;
  WStr: WideString;
  Data: Pointer;
begin
  Fs := TFileStream.Create('unicode.txt', fmCreate);
  try
    WStr := VT.ContentToUnicode(tstAll, #9);
    Data := PWideChar(WStr);
    Fs.WriteBuffer(Data^, Length(WStr)*SizeOf(WideChar));
  finally
    FreeAndNil(fs);
  end;
  ShellExecute(Handle, 'open', 'unicode.txt', nil, nil, SW_RESTORE);
end;

//------------------------------------------------------------------------------
// Заполняем случайными данными.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnFillClick(Sender: TObject);
var
  i, j: Integer;
  NewNode1, NewNode2: PVirtualNode;
  ItemData: PNodeData;
begin
  Randomize;
  for i := 0 to 1 do
  begin
    NewNode1 := VT.AddChild(nil);
    ItemData := VT.GetNodeData(NewNode1);
    with ItemData^ do
    begin
      Caption := Strs[Random(4)];
      Value := Ints[Random(4)];
    end;
    for j := 0 to 9 do
    begin
      NewNode2 := VT.AddChild(NewNode1);
      ItemData := VT.GetNodeData(NewNode2);
      with ItemData^ do
      begin
        Caption := Strs[Random(4)];
        Value := Ints[Random(4)];
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Загрузка бинарного файла.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnLoadClick(Sender: TObject);
begin
  VT.LoadFromFile('vt.dat');
end;

//------------------------------------------------------------------------------
// Загрузка XML.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnLoadXMLClick(Sender: TObject);
var
  XMLDocument: TXMLDocument;

  procedure LoadXML(const ANodeList: IXMLNodeList; AParent: PVirtualNode);
  var
    i: Integer;
    NewNode: PVirtualNode;
    NodeData: PNodeData;
  begin
    for i := 0 to ANodeList.Count - 1 do
    begin
      NewNode := VT.AddChild(AParent);
      NodeData := VT.GetNodeData(NewNode);
      with NodeData^ do
      begin
        Caption := VarToWideStr(ANodeList[i].Attributes['Caption']);
        Value := StrToIntDef(
                VarToStr(
                ANodeList[i].Attributes['Value']
                ), 0);
      end;
      LoadXML(ANodeList[i].ChildNodes, NewNode);
    end;
  end;

begin
  if not FileExists('vt.xml') then
  begin
    MessageBox(Handle, 'Файл vt.xml не найден.', PChar(Application.Title),
      MB_ICONINFORMATION + MB_OK);
    Exit;
  end;
  XMLDocument := TXMLDocument.Create(Self);
  try
    XMLDocument.LoadFromFile('vt.xml');
    // Для каждой ветки XML дерева создать узел в дереве и зарузить поля
    // для структуры данных из аттрибутов
    // Не забываем использовать блоки Begin/End Update.
    VT.BeginUpdate;
    try
      LoadXML(XMLDocument.DocumentElement.ChildNodes, nil);
    finally
      VT.EndUpdate;
    end;
  finally
    FreeAndNil(XMLDocument);
  end;
end;

//------------------------------------------------------------------------------
// Сохранение в бинарный файл.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnSaveClick(Sender: TObject);
begin
  VT.SaveToFile('vt.dat');
end;

//------------------------------------------------------------------------------
// Сохранение в XML файл.
//------------------------------------------------------------------------------
procedure TfrmMain.BtnSaveXMLClick(Sender: TObject);
var
  XMLDocument: TXMLDocument;

  procedure SaveXML(ANode: PVirtualNode; const AParent: IXMLNode);
  var
    NewNode: IXMLNode;
    NextNode: PVirtualNode;
    NodeData: PNodeData;
  begin
    NextNode := ANode.FirstChild;
    if Assigned(NextNode) then
      repeat
        NodeData := VT.GetNodeData(NextNode);
        NewNode := AParent.AddChild('Node');
        with NewNode, NodeData^ do
        begin
          Attributes['Caption'] := Caption;
          Attributes['Value'] := Value;
        end;
        SaveXML(NextNode, NewNode);
        NextNode := NextNode.NextSibling;
      until
        NextNode = nil;
  end;

begin
  XMLDocument := TXMLDocument.Create(Self);
  try
    with XMLDocument do
    begin
      Active := True;
      Encoding := 'UTF-16';
      AddChild('VirtualTreeview');
      Options := Options + [doNodeAutoIndent];
    end;
    SaveXML(VT.RootNode, XMLDocument.DocumentElement);
    XMLDocument.SaveToFile('vt.xml');
  finally
    FreeAndNil(XMLDocument);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  VT.NodeDataSize := SizeOf(TNodeData);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  ItemData: PNodeData;
begin
  ItemData := Sender.GetNodeData(Node);
  case Column of
    0: CellText := ItemData^.Caption;
    1: CellText := IntToStr(ItemData^.Value);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Reader: TReader;
  NodeData: PNodeData;
begin
  Reader := TReader.Create(Stream, 8096);
  try
    NodeData := Sender.GetNodeData(Node);
    with NodeData^, Reader do
    begin
      Caption := ReadWideString;
      Value := ReadInteger;
    end;
  finally
    FreeAndNil(Reader);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var
  NodeData: PNodeData;
  Dummy: Integer;
begin
  if Length(NewText) = 0 then
    Exit;
  NodeData := Sender.GetNodeData(Node);
  case Column of
    0: NodeData^.Caption := NewText;
    1: if TryStrToInt(NewText, Dummy) then
      NodeData^.Value := Dummy;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Writer: TWriter;
  NodeData: PNodeData;
begin
  Writer := TWriter.Create(Stream, 8096);
  try
    NodeData := Sender.GetNodeData(Node);
    with Writer, NodeData^ do
    begin
      WriteWideString(Caption);
      WriteInteger(Value);
    end;
  finally
    FreeAndNil(Writer);
  end;
end;

end.
