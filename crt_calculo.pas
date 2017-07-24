unit crt_calculo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, ImgList, ComCtrls, StdCtrls, Buttons, Mask,
  XPMan;

type
  Tcalculo = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    calcular: TBitBtn;
    limpar: TBitBtn;
    sair: TBitBtn;
    nome2: TStaticText;
    cpf2: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    tipodemissao: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    admissao: TDateTimePicker;
    demissao: TDateTimePicker;
    Label8: TLabel;
    feriasv: TComboBox;
    avisop: TRadioGroup;
    segurod: TRadioGroup;
    usalario: TEdit;
    salariob: TEdit;
    Label9: TLabel;
    adiantamento: TEdit;
    adiantament: TRadioGroup;
    b_abrir: TBitBtn;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure sairClick(Sender: TObject);
    procedure calcularClick(Sender: TObject);
    procedure limparClick(Sender: TObject);
    procedure tipodemissaoEnter(Sender: TObject);
    procedure usalarioEnter(Sender: TObject);
    procedure salariobEnter(Sender: TObject);
    procedure admissaoEnter(Sender: TObject);
    procedure demissaoEnter(Sender: TObject);
    procedure feriasvEnter(Sender: TObject);
    procedure tipodemissaoExit(Sender: TObject);
    procedure usalarioExit(Sender: TObject);
    procedure salariobExit(Sender: TObject);
    procedure admissaoExit(Sender: TObject);
    procedure demissaoExit(Sender: TObject);
    procedure feriasvExit(Sender: TObject);
    procedure adiantamentoEnter(Sender: TObject);
    procedure adiantamentoExit(Sender: TObject);
    procedure adiantamentClick(Sender: TObject);
    procedure b_abrirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  calculo: Tcalculo;

implementation

uses crt_login, crt_resultado, DateUtils;

{$R *.dfm}

procedure Tcalculo.FormShow(Sender: TObject);
begin
  nome2.Caption:=uppercase(login.nome.text);
  cpf2.Caption:=login.cpf.text;
  admissao.Date:=Now;
  demissao.Date:=Now;
end;

procedure Tcalculo.sairClick(Sender: TObject);
begin
  close;
end;

procedure Tcalculo.calcularClick(Sender: TObject);
var salreceb,cpf3:string;

begin
  if tipodemissao.ItemIndex<1 then
  begin
  MessageDlg('Tipo de demissão deve ser selecionada!',mtwarning,[mbok],0);
  tipodemissao.SetFocus;
  exit;
  end;
  if strtofloatdef(usalario.Text,-1)=-1 then
  begin
  MessageDlg('Entre com um número neste campo!',mtwarning,[mbok],0);
  usalario.SetFocus;
  exit;
  end;
  if strtointdef(usalario.Text,0)<=0 then
  begin
  MessageDlg('Último salário deve ser maior que zero!',mtwarning,[mbok],0);
  usalario.SetFocus;
  exit;
  end;
  if strtofloatdef(salariob.Text,-1)=-1 then
  begin
  MessageDlg('Entre com um número neste campo!',mtwarning,[mbok],0);
  salariob.SetFocus;
  exit;
  end;
  if strtointdef(salariob.Text,0)<=0 then
  begin
  MessageDlg('Salário base deve ser maior que zero!',mtwarning,[mbok],0);
  salariob.SetFocus;
  exit;
  end;
  if admissao.Date>demissao.Date then
  begin
  MessageDlg('Data de admissão não pode ser menor que a data de demissão!',mtwarning,[mbok],0);
  admissao.SetFocus;
  exit;
  end;
  if demissao.Date<admissao.Date then
  begin
  MessageDlg('Data de demissão não pode ser maior que a data de admissão!',mtwarning,[mbok],0);
  demissao.SetFocus;
  exit;
  end;
  resultado:=tresultado.create(self);
  if tipodemissao.ItemIndex=1 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*DayOfTheMonth(demissao.date));
      resultado.bd_crtres_decimo.asstring:=formatfloat('0.00',strtofloat(usalario.Text)/12*MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:='0';
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:='0';
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if (strtofloat(salariob.Text)*2+strtofloat(resultado.bd_crtres_saldo_sal.Text)/3>825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:='0';
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;

      if tipodemissao.ItemIndex=2 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:='0';
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:=formatfloat('0.00',strtofloat(usalario.text));
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*strtofloat(salreceb));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:=formatfloat('0.00',strtofloat(resultado.fgts_mes.Text)+strtofloat(resultado.fgts_total.Text)*1.4);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:=formatfloat('0.00',strtofloat(usalario.text));
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;

  if tipodemissao.ItemIndex=3 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:='0';
      resultado.bd_crtres_fgts.AsString:='0';
      resultado.bd_crtres_fgts_total.AsString:='0';
      resultado.bd_crtres_multa_fgts.AsString:='0';
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:='0';
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:='0';
      resultado.bd_crtres_desc_inss_dec.AsString:='0';
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*strtofloat(salreceb));
      resultado.bd_crtres_decimo.AsString:='0';
      resultado.bd_crtres_fgts.AsString:='0';
      resultado.bd_crtres_fgts_total.AsString:='0';
      resultado.bd_crtres_multa_fgts.AsString:='0';
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;
      if tipodemissao.ItemIndex=4 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:='0';
      resultado.bd_crtres_fgts_total.AsString:='0';
      resultado.bd_crtres_multa_fgts.AsString:='0';
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:='0';
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*strtofloat(salreceb));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:='0';
      resultado.bd_crtres_fgts_total.AsString:='0';
      resultado.bd_crtres_multa_fgts.AsString:='0';
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;
      if tipodemissao.ItemIndex=5 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:='0';
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:=formatfloat('0.00',strtofloat(resultado.fgts_mes.Text)+strtofloat(resultado.fgts_total.Text)*1.3);
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*strtofloat(salreceb));
      resultado.bd_crtres_decimo.AsString:='0';
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:=formatfloat('0.00',strtofloat(resultado.fgts_mes.Text)+strtofloat(resultado.fgts_total.Text)*1.3);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;
      if tipodemissao.ItemIndex=6 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:=formatfloat('0.00',strtofloat(resultado.fgts_mes.Text)+strtofloat(resultado.fgts_total.Text)*1.4);
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:=formatfloat('0.00',strtofloat(usalario.Text));
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*strtofloat(salreceb));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:=formatfloat('0.00',strtofloat(resultado.fgts_mes.Text)+strtofloat(resultado.fgts_total.Text)*1.4);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:=formatfloat('0.00',strtofloat(usalario.Text));
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;
      if tipodemissao.ItemIndex=7 then
  begin
    if MonthsBetween(demissao.Date,admissao.Date)<12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:='0';
      resultado.bd_crtres_ferias_venc.AsString:='0';
      resultado.bd_crtferias_prop.AsString:='0';
      resultado.bd_crtgratferias.AsString:='0';
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;

      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end;
    end
    else
    begin
       if MonthsBetween(demissao.Date,admissao.Date)>=12 then
    begin
      resultado.bd_crt.Insert;
      resultado.bd_crtnome.AsString := nome2.Caption;
      cpf3:=cpf2.Caption;
      delete(cpf3,4,1);
      delete(cpf3,7,1);
      delete(cpf3,10,1);
      resultado.bd_crtcpf.AsString:= cpf3;
      case tipodemissao.ItemIndex of
      1 : resultado.bd_crttipo_demissao.AsString:='Falecimento';
      2 : resultado.bd_crttipo_demissao.AsString:='Fechamento da empresa';
      3 : resultado.bd_crttipo_demissao.AsString:='Dispensa por justa causa';
      4 : resultado.bd_crttipo_demissao.AsString:='Pedido de demissão';
      5 : resultado.bd_crttipo_demissao.AsString:='Culpa recíproca';
      6 : resultado.bd_crttipo_demissao.AsString:='Dispensa sem justa causa';
      7 : resultado.bd_crttipo_demissao.AsString:='Acordo';
      end;
      resultado.bd_crtult_salario.AsString:=usalario.Text;
      resultado.bd_crtsalario_base.AsString:=salariob.Text;
      resultado.bd_crtadmissao.AsString:=datetostr(admissao.Date);
      resultado.bd_crtdemissao.AsString:=datetostr(demissao.Date);
      case feriasv.ItemIndex of
      0 : resultado.bd_crtferias_venc.AsString:='0';
      1 : resultado.bd_crtferias_venc.AsString:='1';
      2 : resultado.bd_crtferias_venc.AsString:='2';
      3 : resultado.bd_crtferias_venc.AsString:='3';
      4 : resultado.bd_crtferias_venc.AsString:='4';
      end;
      if avisop.ItemIndex = 0 then
      resultado.bd_crtaviso_pre.AsString:='Sim'
      else
      resultado.bd_crtaviso_pre.AsString:='Não';
      if segurod.ItemIndex = 0 then
      resultado.bd_crtseguro_desemp.AsString:='Sim'
      else
      resultado.bd_crtseguro_desemp.AsString:='Não';
      if adiantament.ItemIndex=0 then
      resultado.bd_crtadiantamento_perg.AsString:='Sim'
      else
      resultado.bd_crtadiantamento_perg.AsString:='Não';
      resultado.bd_crtadiantamento_val.AsString:=adiantamento.Text;
      salreceb:=inttostr((MonthsBetween(demissao.Date,admissao.Date))+1);
      resultado.bd_crtres_saldo_sal.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/30*(DayOfTheMonth(demissao.date)));
      resultado.bd_crtres_decimo.AsString:=formatfloat('0.00',strtofloat(usalario.Text)/12* MonthOf(demissao.date));
      resultado.bd_crtres_fgts.AsString:=formatfloat('0.00',(strtofloat(usalario.Text)*8)/100);
      resultado.bd_crtres_fgts_total.AsString:=formatfloat('0.00',((strtofloat(salariob.Text)*8/100)*strtoint(salreceb)));
      resultado.bd_crtres_multa_fgts.AsString:='0';
      case feriasv.ItemIndex of
      0 : resultado.bd_crtres_ferias_venc.AsString:='0';
      1 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',strtofloat(salariob.Text));
      2 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*3));
      3 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*4));
      4 : resultado.bd_crtres_ferias_venc.AsString:=formatfloat('0.00',(strtofloat(salariob.Text)*5));
      end;
      resultado.bd_crtferias_prop.AsString:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1));
      if strtofloat(resultado.ferias_p.Text)<0 then
      resultado.bd_crtferias_prop.Text:=formatfloat('0.00',strtofloat(salariob.Text)/12* ((MonthOf(demissao.Date) - MonthOf(admissao.date))+1)*-1);
      resultado.bd_crtgratferias.AsString:=formatfloat('0.00',(strtofloat(resultado.ferias_venc.Text)+strtofloat(resultado.bd_crtferias_prop.Text))/3);
      resultado.bd_crtres_aviso.AsString:='0';
      resultado.bd_crtres_total.AsString:=formatfloat('0.00',
                                   strtofloat(resultado.res_saldo_sal.Text)+
                                   strtofloat(resultado.res_dec.Text)+
                                   strtofloat(resultado.fgts_mes.Text)+
                                   strtofloat(resultado.fgts_total.Text));
      resultado.bd_crtres_desc_inss_sal.AsString:=formatfloat('0.00',((strtofloat(usalario.Text)*9/100)));
      resultado.bd_crtres_desc_inss_dec.AsString:=formatfloat('0.00',((strtofloat(resultado.res_dec.Text)*9/100)));
      resultado.bd_crtres_total_liq.AsString:=formatfloat('0.00',
                                  strtofloat(resultado.total_bruto.Text)-
                                  strtofloat(resultado.desc_inss_sal.Text)-
                                  strtofloat(resultado.desc_inss_decimo.Text)-
                                  strtofloat(adiantamento.Text));
      if segurod.ItemIndex=0 then
      begin
      if (MonthsBetween(demissao.Date,admissao.Date)>=6) and (MonthsBetween(demissao.Date,admissao.Date)<12) then
      begin
      resultado.bd_crtnr_cotas.AsString:='3';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+90);
      end;
      if (MonthsBetween(demissao.Date,admissao.Date)>=12) and (MonthsBetween(demissao.Date,admissao.Date)<24) then
      begin
      resultado.bd_crtnr_cotas.AsString:='4';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+120);
      end;
      if MonthsBetween(demissao.Date,admissao.Date)>=24 then
      begin
      resultado.bd_crtnr_cotas.AsString:='5';
      resultado.bd_crtinicio_seguro.AsString:=datetostr((demissao.date)+30);
      resultado.bd_crtfinal_seguro.AsString:=datetostr((demissao.Date)+150);
      end;
      if strtofloat(salariob.Text)<=495.23 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',strtoint(salariob.Text)*0.8);

      if (strtofloat(salariob.Text)>=495.23) and (strtofloat(salariob.Text)<=825.46) then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',((strtoint(salariob.Text)-495.23)*0.5)+396.18);

      if strtoint(salariob.Text)>825.46 then
      resultado.bd_crtvalor_seguro.AsString:=formatfloat('0.00',561.30);
      end
      else
      begin
      resultado.bd_crtnr_cotas.AsString:='';
      resultado.bd_crtinicio_seguro.AsString:='';
      resultado.bd_crtfinal_seguro.AsString:='';
      resultado.bd_crtvalor_seguro.AsString:='';
      end;
    end;
    end;
  end;
  resultado.ShowModal;
  resultado.Free;
end;

procedure Tcalculo.limparClick(Sender: TObject);
begin
  tipodemissao.ItemIndex:=0;
  usalario.Text:='0';
  salariob.Text:='0';
  admissao.Date:=Now;
  demissao.Date:=Now;
  feriasv.ItemIndex:=0;
  avisop.ItemIndex:=0;
  segurod.ItemIndex:=0;
  adiantamento.Text:='0';
  feriasv.Enabled:=true;
  segurod.Enabled:=true;
  b_abrir.Enabled:=true;
  tipodemissao.SetFocus;
end;

procedure Tcalculo.tipodemissaoEnter(Sender: TObject);
begin
  tipodemissao.Color:=cllime;
end;

procedure Tcalculo.usalarioEnter(Sender: TObject);
begin
  usalario.Color:=cllime;
end;

procedure Tcalculo.salariobEnter(Sender: TObject);
begin
  salariob.Color:=cllime;
end;

procedure Tcalculo.admissaoEnter(Sender: TObject);
begin
  admissao.Color:=cllime;
end;

procedure Tcalculo.demissaoEnter(Sender: TObject);
begin
  demissao.Color:=cllime;
end;

procedure Tcalculo.feriasvEnter(Sender: TObject);
begin
  feriasv.Color:=cllime;
end;

procedure Tcalculo.tipodemissaoExit(Sender: TObject);
begin
  tipodemissao.Color:=clwhite;
end;

procedure Tcalculo.usalarioExit(Sender: TObject);
begin
  usalario.Color:=clwhite;
end;

procedure Tcalculo.salariobExit(Sender: TObject);
begin
  salariob.Color:=clwhite;
end;

procedure Tcalculo.admissaoExit(Sender: TObject);
begin
  admissao.Color:=clwhite;
end;

procedure Tcalculo.demissaoExit(Sender: TObject);
begin
  demissao.Color:=clwhite;
  if MonthsBetween(demissao.Date,admissao.Date)<6 then
  begin
  segurod.ItemIndex:=1;
  segurod.Enabled:=false;
  end;
  if MonthsBetween(demissao.Date,admissao.Date)<12 then
  begin
  feriasv.ItemIndex:=0;
  feriasv.Enabled:=false;
  end;
end;

procedure Tcalculo.feriasvExit(Sender: TObject);
begin
  feriasv.Color:=clwhite;
end;

procedure Tcalculo.adiantamentoEnter(Sender: TObject);
begin
  adiantamento.Color:=cllime;
end;

procedure Tcalculo.adiantamentoExit(Sender: TObject);
begin
  adiantamento.Color:=clwhite;
  if strtofloatdef(adiantamento.Text,-1)=-1 then
  begin
  MessageDlg('Entre com um número neste campo!',mtwarning,[mbok],0);
  adiantamento.SetFocus;
  end;
end;

procedure Tcalculo.adiantamentClick(Sender: TObject);
begin
  if adiantament.ItemIndex=0 then
    adiantamento.Enabled:=true
  else
  begin
    adiantamento.Enabled:=false;
    adiantamento.Text:='0';
  end;
end;

procedure Tcalculo.b_abrirClick(Sender: TObject);
begin
  if (resultado.bd_crt.RecordCount = 0) then
    begin
      ShowMessage('Não existem dados salvos!');
      b_abrir.Enabled:=false;
      tipodemissao.SetFocus;
    end
  else
    begin
      resultado.ShowModal;
      resultado.Free;
    end;
end;

end.
