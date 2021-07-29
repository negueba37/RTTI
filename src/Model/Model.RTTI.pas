unit Model.RTTI;

interface

uses System.RTTI, System.Generics.Collections, System.Classes, System.SysUtils;

type
  TEnumChave = (PK,FK,Ignore);
  TEnumField = (tpInteger,tpString,tpCurrency,tpDate,tpBoolean);

  TDateORM = class
    private
    FTpField: TEnumField;
    FNomeCampo: string;
    FChave: TEnumChave;
    FValorCampo: Variant;
    procedure SetChave(const Value: TEnumChave);
    procedure SetNomeCampo(const Value: string);
    procedure SetTpField(const Value: TEnumField);
    procedure SetValorCampo(const Value: Variant);
    public
    property Chave:TEnumChave read FChave write SetChave;
    property TpField:TEnumField read FTpField write SetTpField;
    property NomeCampo:string read FNomeCampo write SetNomeCampo;
    property ValorCampo:Variant read FValorCampo write SetValorCampo;
    constructor Create;
    destructor Destroy;override;
  end;
  TableName = class(TCustomAttribute)
  private
    FTable: string;
    procedure SetTable(const Value: string);
  published
    constructor Create(aValue:string);
    destructor Destroy;override;
    property Table:string read FTable write SetTable;
  end;

  SetORM = class(TCustomAttribute)
    private
    FTpField: TEnumField;
    FCampo: string;
    FChave: TEnumChave;
    procedure SetCampo(const Value: string);
    procedure SetChave(const Value: TEnumChave);
    procedure SetTpField(const Value: TEnumField);
    public
    constructor Create(Chave:TEnumChave = Ignore;TpField:TEnumField = tpString;NomeCampo:string = '');
    destructor Destroy;override;
    property Chave:TEnumChave read FChave write SetChave;
    property TpField:TEnumField read FTpField write SetTpField;
    property Campo:string read FCampo write SetCampo;
  end;

  TRTTI = class
  private
  public

    class function GetInsert<T :class>(aValue: T): String;
    class function GetDelete<T :class>(aValue: T): String;
    class function GetUpdate<T :class>(aValue: T): String;
  end;

implementation

class function TRTTI.GetDelete<T>(aValue: T): String;
var
  LContextoRTTI :TRttiContext;
  LTypeRTTI : TRttiType;
  LAttributes:TCustomAttribute;
  LProperty:TRttiProperty;
  LSQL,LTable:string;
  LListFileds:TList<string>;
  LListDateORM:TObjectList<TDateORM>;
  LDateORM:TDateORM;
begin
  LContextoRTTI := TRttiContext.Create;
  LListFileds := TList<string>.Create;
  LListDateORM := TObjectList<TDateORM>.Create();
  LSQL := 'Delete from ';
  try
    LTypeRTTI := LContextoRTTI.GetType(aValue.ClassInfo);
    for LAttributes in LTypeRTTI.GetAttributes do
    begin
      if LAttributes is TableName then
      begin
        LSQL := LSQL + TableName(LAttributes).Table;
      end;
    end;

    for LProperty in LTypeRTTI.GetProperties do
    begin
      for LAttributes in LProperty.GetAttributes do
      begin
        if LAttributes is SetORM then
        begin
          LDateORM := TDateORM.Create;

          LDateORM.Chave := SetORM(LAttributes).Chave;
          LDateORM.TpField := SetORM(LAttributes).FTpField;

          case SetORM(LAttributes).FTpField of
            tpInteger: LDateORM.ValorCampo := IntToStr(LProperty.GetValue(Pointer(aValue)).AsInteger);
            tpString: LDateORM.ValorCampo := QuotedStr(LProperty.GetValue(Pointer(aValue)).AsString);
            tpCurrency: LDateORM.ValorCampo := CurrToStr((LProperty.GetValue(Pointer(aValue)).AsCurrency));
            tpDate: LDateORM.ValorCampo := LProperty.GetValue(Pointer(aValue)).AsString;
            tpBoolean: LDateORM.ValorCampo := BoolToStr(LProperty.GetValue(Pointer(aValue)).AsBoolean);
          end;

          LDateORM.NomeCampo := SetORM(LAttributes).FCampo;
          if (Trim(SetORM(LAttributes).FCampo) = '') then
            LDateORM.NomeCampo := LProperty.Name;

          LListDateORM.Add(LDateORM);
        end
      end;
    end;

    LSQL := LSQL + ' Where 1=1 ';
    for LDateORM in LListDateORM do
    begin
      if LDateORM.FChave = PK then
        LSQL := LSQL + 'And ' + LDateORM.FNomeCampo+' = '+LDateORM.ValorCampo;
    end;

    Result := UpperCase(LSQL);
  finally
    LListFileds.Free;
    LContextoRTTI.Free;
    LListDateORM.Free;
  end;
end;

class function TRTTI.GetInsert<T>(aValue: T): String;
var
  LContextoRTTI :TRttiContext;
  LTypeRTTI : TRttiType;
  LAttributes:TCustomAttribute;
  LProperty:TRttiProperty;
  LSQL,LTable:string;
  LListFileds:TList<string>;
  LListDateORM:TObjectList<TDateORM>;
  LDateORM:TDateORM;
begin
  LContextoRTTI := TRttiContext.Create;
  LListFileds := TList<string>.Create;
  LListDateORM := TObjectList<TDateORM>.Create();
  LSQL := 'INSERT INTO ';
  try
    LTypeRTTI := LContextoRTTI.GetType(aValue.ClassInfo);
    for LAttributes in LTypeRTTI.GetAttributes do
    begin
      if LAttributes is TableName then
      begin
        LSQL := LSQL + TableName(LAttributes).Table;
      end;
    end;

    LSQL := LSQL + ' (';

    for LProperty in LTypeRTTI.GetProperties do
    begin
      for LAttributes in LProperty.GetAttributes do
      begin
        if LAttributes is SetORM then
        begin
          LDateORM := TDateORM.Create;

          LDateORM.Chave := SetORM(LAttributes).Chave;
          LDateORM.TpField := SetORM(LAttributes).FTpField;

          case SetORM(LAttributes).FTpField of
            tpInteger: LDateORM.ValorCampo := IntToStr(LProperty.GetValue(Pointer(aValue)).AsInteger);
            tpString: LDateORM.ValorCampo := QuotedStr(LProperty.GetValue(Pointer(aValue)).AsString);
            tpCurrency: LDateORM.ValorCampo := CurrToStr((LProperty.GetValue(Pointer(aValue)).AsCurrency));
            tpDate: LDateORM.ValorCampo := LProperty.GetValue(Pointer(aValue)).AsString;
            tpBoolean: LDateORM.ValorCampo := BoolToStr(LProperty.GetValue(Pointer(aValue)).AsBoolean);
          end;

          LDateORM.NomeCampo := SetORM(LAttributes).FCampo;
          if (Trim(SetORM(LAttributes).FCampo) = '') then
            LDateORM.NomeCampo := LProperty.Name;

          LListDateORM.Add(LDateORM);
        end
      end;
    end;

    for LDateORM in LListDateORM do
    begin
      LSQL := LSQL + LDateORM.FNomeCampo+',';
    end;
    LSQL := Copy(LSQL,1,LSQL.Length - 1);
    LSQL := LSQL +') Values(';
    for LDateORM in LListDateORM do
    begin
      LSQL := LSQL + LDateORM.FValorCampo+',';
    end;
    LSQL := Copy(LSQL,1,LSQL.Length - 1);
    LSQL := LSQL +')';


    Result := UpperCase(LSQL);
  finally
    LListFileds.Free;
    LContextoRTTI.Free;
    LListDateORM.Free;
  end;
end;


class function TRTTI.GetUpdate<T>(aValue: T): String;
var
  LContextoRTTI :TRttiContext;
  LTypeRTTI : TRttiType;
  LAttributes:TCustomAttribute;
  LProperty:TRttiProperty;
  LSQL,LTable:string;
  LListFileds:TList<string>;
  LListDateORM:TObjectList<TDateORM>;
  LDateORM:TDateORM;
begin
  LContextoRTTI := TRttiContext.Create;
  LListFileds := TList<string>.Create;
  LListDateORM := TObjectList<TDateORM>.Create();
  LSQL := 'update ';
  try
    LTypeRTTI := LContextoRTTI.GetType(aValue.ClassInfo);
    for LAttributes in LTypeRTTI.GetAttributes do
    begin
      if LAttributes is TableName then
      begin
        LSQL := LSQL + TableName(LAttributes).Table;
      end;
    end;

    for LProperty in LTypeRTTI.GetProperties do
    begin
      for LAttributes in LProperty.GetAttributes do
      begin
        if LAttributes is SetORM then
        begin
          LDateORM := TDateORM.Create;

          LDateORM.Chave := SetORM(LAttributes).Chave;
          LDateORM.TpField := SetORM(LAttributes).FTpField;

          case SetORM(LAttributes).FTpField of
            tpInteger: LDateORM.ValorCampo := IntToStr(LProperty.GetValue(Pointer(aValue)).AsInteger);
            tpString: LDateORM.ValorCampo := QuotedStr(LProperty.GetValue(Pointer(aValue)).AsString);
            tpCurrency: LDateORM.ValorCampo := CurrToStr((LProperty.GetValue(Pointer(aValue)).AsCurrency));
            tpDate: LDateORM.ValorCampo := LProperty.GetValue(Pointer(aValue)).AsString;
            tpBoolean: LDateORM.ValorCampo := BoolToStr(LProperty.GetValue(Pointer(aValue)).AsBoolean);
          end;

          LDateORM.NomeCampo := SetORM(LAttributes).FCampo;
          if (Trim(SetORM(LAttributes).FCampo) = '') then
            LDateORM.NomeCampo := LProperty.Name;

          LListDateORM.Add(LDateORM);
        end
      end;
    end;

    for LDateORM in LListDateORM do
    begin
      if LDateORM.FValorCampo <> '' then
        LSQL := LSQL + 'SET ' + LDateORM.FNomeCampo+' = '+LDateORM.ValorCampo +',';
    end;
    LSQL := Copy(LSQL,1,LSQL.Length - 1);
    LSQL := LSQL + 'WHERE 1=1';
    for LDateORM in LListDateORM do
    begin
      if LDateORM.FChave = PK then
        LSQL := LSQL + ' AND ' + LDateORM.FNomeCampo+' = '+LDateORM.ValorCampo;
    end;

    Result := UpperCase(LSQL);
  finally
    LListFileds.Free;
    LContextoRTTI.Free;
    LListDateORM.Free;
  end;
end;

{ TableName }

constructor TableName.Create(aValue: string);
begin
  FTable := aValue;
end;

destructor TableName.Destroy;
begin

  inherited;
end;

procedure TableName.SetTable(const Value: string);
begin
  FTable := Value;
end;

{ FieldName }

constructor SetORM.Create(Chave:TEnumChave = Ignore;TpField:TEnumField = tpString;NomeCampo:string = '');
begin
  Self.Chave := Chave;
  Self.TpField := TpField;
  Self.Campo := NomeCampo;
end;

destructor SetORM.Destroy;
begin

  inherited;
end;


procedure SetORM.SetCampo(const Value: string);
begin
  FCampo := Value;
end;

procedure SetORM.SetChave(const Value: TEnumChave);
begin
  FChave := Value;
end;

procedure SetORM.SetTpField(const Value: TEnumField);
begin
  FTpField := Value;
end;

{ TDateORM }

constructor TDateORM.Create;
begin

end;

destructor TDateORM.Destroy;
begin

  inherited;
end;

procedure TDateORM.SetChave(const Value: TEnumChave);
begin
  FChave := Value;
end;

procedure TDateORM.SetNomeCampo(const Value: string);
begin
  FNomeCampo := Value;
end;

procedure TDateORM.SetTpField(const Value: TEnumField);
begin
  FTpField := Value;
end;

procedure TDateORM.SetValorCampo(const Value: Variant);
begin
  FValorCampo := Value;
end;

end.
