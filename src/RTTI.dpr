program RTTI;

uses
  Vcl.Forms,
  View.Principal in 'View\View.Principal.pas' {Form1},
  Model.RTTI in 'Model\Model.RTTI.pas',
  Model.Entities.Produto in 'Model\Entities\Model.Entities.Produto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
