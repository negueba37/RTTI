unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Model.RTTI,
  Model.Entities.Produto;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Produto:TModelEntitiesProduto;
  i: Integer;
  RTTI:TRTTI;
begin
  RTTI := TRTTI.Create;
  Produto := TModelEntitiesProduto.Create;
  Produto.Codigo := 10;
  Produto.Nome := 'Teste';
  Produto.Preco := 1000;
  Produto.DataValidade := DateToStr(date);
  try
    Memo1.Lines.Add(RTTI.GetInsert<TModelEntitiesProduto>(Produto))
  finally
    Produto.Free;
    RTTI.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Produto:TModelEntitiesProduto;
  i: Integer;
  RTTI:TRTTI;
begin
  RTTI := TRTTI.Create;
  Produto := TModelEntitiesProduto.Create;
  Produto.Codigo := 10;
  try
    Memo1.Lines.Add(RTTI.GetDelete<TModelEntitiesProduto>(Produto))
  finally
    Produto.Free;
    RTTI.Free;
  end;

end;

end.
