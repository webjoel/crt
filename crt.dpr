program crt;

uses
  Forms,
  crt_entrada in 'crt_entrada.pas' {entrada},
  crt_login in 'crt_login.pas' {login},
  crt_calculo in 'crt_calculo.pas' {calculo},
  crt_resultado in 'crt_resultado.pas' {resultado},
  crt_informacoes in 'crt_informacoes.pas' {info};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Cálculo de Rescisão Trabalhista';
  Application.CreateForm(Tentrada, entrada);
  Application.CreateForm(Tresultado, resultado);
  Application.Run;
end.
