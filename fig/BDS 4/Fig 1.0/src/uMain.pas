{
  Пример № 1 - Инициализация данных.
  Пример иллюстрирует заполнение дерева узлами и отображение данных.
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, XPMan;

type
  TfrmMain = class(TForm)
    VT: TVirtualStringTree;
    BtnLoad: TButton;
    BtnClear: TButton;
    LblCopy: TLabel;
    procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Names: array[0..4] of WideString = (
    'Вася',
    'Петя',
    'Маша',
    'Костя',
    'Дима'
  );

  Phones: array[0..4] of WideString = (
    '433-56-49',
    '545-67-79',
    '777-50-50',
    '911-03-05',
    '02'
  );

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
procedure TfrmMain.BtnClearClick(Sender: TObject);
begin
  Vt.Clear;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.BtnLoadClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Length(Names) - 1 do
    VT.AddChild(nil);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    // Используем остаток от деления. Массив может неожиданно кончиться
    // после нескольких нажатий BtnLoad подряд без очистки.
    // Спасибо OverLord за это исправление (the__teacher@mail.ru).
    // Текст для колонки имени
    0: CellText := Names[(Integer(Node.Index)) mod (Length(Names))];
    // Текст для колонки телефонного номера
    1: CellText := Phones[(Integer(Node.Index)) mod (Length(Phones))];
  end;
end;

end.
