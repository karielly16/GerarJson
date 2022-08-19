program GerarJson;

uses
  Vcl.Forms,
  arquivoJson in 'arquivoJson.pas' {ArquivJson};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TArquivJson, ArquivJson);
  Application.Run;
end.
