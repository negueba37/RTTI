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
    procedure Button1Click(Sender: TObject);
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
begin
  Produto := TModelEntitiesProduto.Create;
  try
    Memo1.Lines.Add(TRTTI.GetInsert<TModelEntitiesProduto>(Produto))
  finally
    Produto.Free;
  end;
end;

end.
