unit Model.Entities.Produto;

interface

uses Model.RTTI;
  type
    [TableName('Produto')]
  TModelEntitiesProduto = class
  private
    FPreco: Currency;
    FCodigo: Integer;
    FNome: string;
    FDataValidade: string;
    procedure SetCodigo(const Value: Integer);
    procedure SetDataValidade(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetPreco(const Value: Currency);
    function  GetCodigo:Integer;
    function  GetDataValidade:string;
    function  GetNome:string;
    function  GetPreco:Currency;

  public
    constructor Create;
    destructor Destroy; override;

    [SetORM(PK,tpInteger)]
    property Codigo:Integer read GetCodigo write SetCodigo;

    [SetORM(Ignore,tpString,'NOME_PRODUTO')]
    property Nome:string read GetNome write SetNome;

    [SetORM(Ignore,tpCurrency,'PRECO_VENDA')]
    property Preco:Currency read GetPreco write SetPreco;

    [SetORM(Ignore,tpDate,'DT_VALIDADE')]
    property DataValidade:string read GetDataValidade write SetDataValidade;
  end;
implementation

{ TModelEntitiesProduto }

constructor TModelEntitiesProduto.Create;
begin

end;

destructor TModelEntitiesProduto.Destroy;
begin

  inherited;
end;

function TModelEntitiesProduto.GetCodigo: Integer;
begin
  Result := FCodigo;
end;

function TModelEntitiesProduto.GetDataValidade: string;
begin
  Result := FDataValidade;
end;

function TModelEntitiesProduto.GetNome: string;
begin
  Result := FNome;
end;

function TModelEntitiesProduto.GetPreco: Currency;
begin
  Result := FPreco;
end;

procedure TModelEntitiesProduto.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TModelEntitiesProduto.SetDataValidade(const Value: string);
begin
  FDataValidade := Value;
end;

procedure TModelEntitiesProduto.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TModelEntitiesProduto.SetPreco(const Value: Currency);
begin
  FPreco := Value;
end;

end.
