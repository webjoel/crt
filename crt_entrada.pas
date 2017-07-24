unit crt_entrada;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Gauges, ComCtrls, jpeg;

type
  Tentrada = class(TForm)
    Gauge1: TGauge;
    Timer1: TTimer;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  entrada: Tentrada;

implementation

uses crt_login, crt_calculo;

{$R *.dfm}

procedure Tentrada.Timer1Timer(Sender: TObject);
begin
  gauge1.AddProgress(1);
  if gauge1.PercentDone=100 then
  begin
  hide;
  login:=tlogin.create(self);
  timer1.Enabled:=false;
  login.ShowModal;
  login.Free;
  close;
  end;
end;

end.
