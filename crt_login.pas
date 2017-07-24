unit crt_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, StrUtils, jpeg;

type
  Tlogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    nome: TLabeledEdit;
    entrar: TBitBtn;
    limpar: TBitBtn;
    cpf: TMaskEdit;
    cpf_label: TLabel;
    Image1: TImage;
    procedure limparClick(Sender: TObject);
    procedure entrarClick(Sender: TObject);
    procedure nomeEnter(Sender: TObject);
    procedure nomeExit(Sender: TObject);
    procedure cpfEnter(Sender: TObject);
    procedure cpfExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  login: Tlogin;

implementation

uses crt_calculo;

{$R *.dfm}

procedure Tlogin.limparClick(Sender: TObject);
begin
  nome.Text:='';
  cpf.Text:='';
  nome.SetFocus;
end;

function testacpf(num: string): boolean;
  var
  n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
  d1,d2: integer;
  digitado, calculado: string;
  begin
    n1:=StrToInt(num[1]);
    n2:=StrToInt(num[2]);
    n3:=StrToInt(num[3]);
    n4:=StrToInt(num[4]);
    n5:=StrToInt(num[5]);
    n6:=StrToInt(num[6]);
    n7:=StrToInt(num[7]);
    n8:=StrToInt(num[8]);
    n9:=StrToInt(num[9]);
    d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
    d1:=11-(d1 mod 11);
    if d1>=10 then d1:=0;
    d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
    d2:=11-(d2 mod 11);
    if d2>=10 then d2:=0;
    calculado:=inttostr(d1)+inttostr(d2);
    digitado:=num[10]+num[11];
    if calculado=digitado then
    testacpf:=true
    else
    testacpf:=false;
  end;

procedure Tlogin.entrarClick(Sender: TObject);
begin
  if nome.Text='' then
  begin
  showmessage('Você precisa digitar seu nome!');
  nome.setfocus;
  exit;
  end;
  if length(trim(cpf.Text))<>14 then
  begin
  showmessage('Você precisa digitar seu CPF!');
  cpf.SetFocus;
  exit;
  end;
  if testacpf(AnsiReplaceStr(AnsiReplaceStr(cpf.Text,'.',''),'-','')) then
  begin
  hide;
  calculo:=tcalculo.create(self);
  calculo.ShowModal;
  calculo.Free;
  Close;
  end
  else
  showmessage('Você digitou um CPF inválido!');
end;

procedure Tlogin.nomeEnter(Sender: TObject);
begin
  nome.Color:=cllime;
end;

procedure Tlogin.nomeExit(Sender: TObject);
begin
  nome.Color:=clwhite;
end;

procedure Tlogin.cpfEnter(Sender: TObject);
begin
  cpf.color:=cllime;
end;

procedure Tlogin.cpfExit(Sender: TObject);
begin
  cpf.color:=clwhite;
end;

end.
