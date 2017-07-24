unit crt_resultado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, Buttons, DB, DBClient, ComCtrls, Mask,
  DBCtrls, RpDefine, RpBase, RpSystem, Grids, DBGrids;

type
  Tresultado = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    salvar: TBitBtn;
    excluir: TBitBtn;
    sair: TBitBtn;
    imprimir: TBitBtn;
    voltar: TBitBtn;
    avancar: TBitBtn;
    resultados: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    bd_crt: TClientDataSet;
    bd_crtnome: TStringField;
    bd_crtcpf: TStringField;
    bd_crttipo_demissao: TStringField;
    bd_crtult_salario: TFloatField;
    bd_crtsalario_base: TFloatField;
    bd_crtadmissao: TDateField;
    bd_crtdemissao: TDateField;
    bd_crtferias_venc: TIntegerField;
    bd_crtaviso_pre: TStringField;
    bd_crtseguro_desemp: TStringField;
    bd_crtadiantamento_perg: TStringField;
    bd_crtadiantamento_val: TFloatField;
    bd_crtres_aviso: TFloatField;
    bd_crtres_ferias_venc: TFloatField;
    bd_crtres_saldo_sal: TFloatField;
    bd_crtres_decimo: TFloatField;
    bd_crtres_ferias_prop: TFloatField;
    bd_crtres_grat_ferias: TFloatField;
    bd_crtres_fgts: TFloatField;
    bd_crtres_fgts_total: TFloatField;
    bd_crtres_multa_fgts: TFloatField;
    bd_crtres_total: TFloatField;
    bd_crtres_desc_inss_sal: TFloatField;
    bd_crtres_desc_inss_dec: TFloatField;
    bd_crtres_total_liq: TFloatField;
    DataSource1: TDataSource;
    Label2: TLabel;
    nome: TDBEdit;
    Label1: TLabel;
    codigo: TDBEdit;
    Label3: TLabel;
    cpf: TDBEdit;
    Label4: TLabel;
    tipo_demissao: TDBEdit;
    Label5: TLabel;
    ult_salario: TDBEdit;
    Label6: TLabel;
    sal_base: TDBEdit;
    Label7: TLabel;
    dat_admissao: TDBEdit;
    Label8: TLabel;
    dat_demissao: TDBEdit;
    Label9: TLabel;
    n_ferias_v: TDBEdit;
    bd_crtcodigo: TAutoIncField;
    Label10: TLabel;
    aviso_prev: TDBEdit;
    Label11: TLabel;
    seg_desemprego: TDBEdit;
    Label12: TLabel;
    rec_adiantamento: TDBEdit;
    Label13: TLabel;
    val_adiantamento: TDBEdit;
    Label14: TLabel;
    res_saldo_sal: TDBEdit;
    Label15: TLabel;
    res_dec: TDBEdit;
    Label16: TLabel;
    fgts_mes: TDBEdit;
    Label17: TLabel;
    aviso_p: TDBEdit;
    Label18: TLabel;
    ferias_venc: TDBEdit;
    Label19: TLabel;
    fgts_total: TDBEdit;
    Label20: TLabel;
    multa_fgts: TDBEdit;
    Label21: TLabel;
    total_bruto: TDBEdit;
    Label22: TLabel;
    desc_inss_sal: TDBEdit;
    Label23: TLabel;
    desc_inss_decimo: TDBEdit;
    Label24: TLabel;
    total_liq: TDBEdit;
    GroupBox2: TGroupBox;
    bd_crtnr_cotas: TIntegerField;
    bd_crtinicio_seguro: TDateField;
    bd_crtfinal_seguro: TDateField;
    bd_crtvalor_seguro: TFloatField;
    Label25: TLabel;
    nro_cotas: TDBEdit;
    Label26: TLabel;
    dat_inicio: TDBEdit;
    Label27: TLabel;
    dat_fim: TDBEdit;
    Label28: TLabel;
    val_seg: TDBEdit;
    bd_crtgratferias: TFloatField;
    Label29: TLabel;
    gratferias: TDBEdit;
    Button1: TButton;
    bd_crtferias_prop: TFloatField;
    Label30: TLabel;
    ferias_p: TDBEdit;
    imprimi: TRvSystem;
    procedure sairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure salvarClick(Sender: TObject);
    procedure excluirClick(Sender: TObject);
    procedure voltarClick(Sender: TObject);
    procedure avancarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure imprimirClick(Sender: TObject);
    procedure imprimiPrint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  resultado: Tresultado;

implementation

uses crt_calculo, crt_informacoes;

{$R *.dfm}

procedure Tresultado.sairClick(Sender: TObject);
begin
  close;
  calculo.Close;
end;

procedure Tresultado.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  IF MESSAGEDLG('Você salvou os resultados do cálculo?',MTCONFIRMATION,[MBYES,MBNO],0)=MRYES THEN
    CANCLOSE:=TRUE
  ELSE
    CANCLOSE:=FALSE;
end;

procedure Tresultado.salvarClick(Sender: TObject);
begin
  resultado.bd_crt.Post;
  resultado.salvar.Enabled:=false;
  resultado.excluir.Enabled:=true;
  resultado.voltar.Enabled:=true;
  resultado.avancar.Enabled:=true;
  resultado.imprimir.Enabled:=true;
end;

procedure Tresultado.excluirClick(Sender: TObject);
begin
  if bd_crt.RecordCount = 0 then
  begin
    excluir.Enabled:=false;
  end
  else
  bd_crt.Delete;
end;

procedure Tresultado.voltarClick(Sender: TObject);
begin
  if (bd_crt.RecordCount = 0) then
    begin
      resultado.voltar.Enabled:=false;
    end
  else
    resultado.bd_crt.Prior;
end;

procedure Tresultado.avancarClick(Sender: TObject);
begin
  if (bd_crt.RecordCount = 0) then
    begin
      resultado.avancar.Enabled:=false;
    end
  else
    resultado.bd_crt.Next;
end;

procedure Tresultado.Button1Click(Sender: TObject);
begin
  info:=tinfo.create(self);
  info.ShowModal;
  info.Free;
end;

procedure Tresultado.imprimirClick(Sender: TObject);
begin
  if (bd_crt.RecordCount = 0) then
    begin
      resultado.imprimir.Enabled:=false;
    end
  else
    imprimi.Execute;
end;

procedure Tresultado.imprimiPrint(Sender: TObject);
begin
  with imprimi.BaseReport do
  begin
    newline;
    newline;
    cleartabs;
    settab(1,pjCenter,5,0.5,BOXLINENONE,1);
    printtab('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    newline;
    settab(1,pjCenter,5,0.5,BOXLINENONE,1);
    printtab('RESULTADO DO CÁLCULO DE RESCISÃO TRABALHISTA');
    newline;
    settab(1,pjCenter,5,0.5,BOXLINENONE,1);
    printtab('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,5,0.5,BOXLINENONE,1);
    printtab('>> DADOS:');
    newline;
    settab(1,pjleft,5,0.5,BOXLINENONE,1);
    printtab('================================================================');
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,1,0.5,BOXLINENONE,1);
    settab(2,pjleft,7,0.5,BOXLINENONE,1);
    settab(6,pjleft,4,0.5,BOXLINENONE,1);
    printtab('Código: '+resultado.bd_crtcodigo.Text);
    printtab('Nome: '+resultado.bd_crtnome.Text);
    printtab('CPF: '+resultado.bd_crtcpf.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,9,0.5,BOXLINENONE,1);
    settab(4,pjleft,3,0.5,BOXLINENONE,1);
    settab(6,pjleft,3,0.5,BOXLINENONE,1);
    printtab('Tipo de demissão: '+resultado.bd_crttipo_demissao.Text);
    printtab('Último Salário: '+resultado.bd_crtult_salario.Text);
    printtab('Salário Base: '+resultado.bd_crtsalario_base.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,3,0.5,BOXLINENONE,1);
    settab(4,pjleft,3,0.5,BOXLINENONE,1);
    settab(6,pjleft,6,0.5,BOXLINENONE,1);
    printtab('Admissão: '+resultado.bd_crtadmissao.Text);
    printtab('Demissão: '+resultado.bd_crtdemissao.Text);
    printtab('Nº de Férias Venc.: '+resultado.bd_crtferias_venc.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,3,0.5,BOXLINENONE,1);
    settab(2.3,pjleft,4,0.5,BOXLINENONE,1);
    settab(4.1,pjleft,3,0.5,BOXLINENONE,1);
    settab(6,pjleft,5,0.5,BOXLINENONE,1);
    printtab('Aviso Prévio?: '+resultado.bd_crtaviso_pre.Text);
    printtab('Seg. Desemprego?: '+resultado.bd_crtseguro_desemp.Text);
    printtab('Adiantamento?: '+resultado.bd_crtadiantamento_perg.Text);
    printtab('Valor do Adiant.: '+resultado.bd_crtadiantamento_val.Text);
    newline;
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,5,0.5,BOXLINENONE,1);
    printtab('>> RESULTADOS:');
    newline;
    settab(1,pjleft,5,0.5,BOXLINENONE,1);
    printtab('================================================================');
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,3,0.5,BOXLINENONE,1);
    settab(3.5,pjleft,3,0.5,BOXLINENONE,1);
    settab(5.5,pjleft,5,0.5,BOXLINENONE,1);
    printtab('Saldo de Salários: '+resultado.bd_crtres_saldo_sal.Text);
    printtab('13º Salário: '+resultado.bd_crtres_decimo.Text);
    printtab('Aviso Prévio: '+resultado.bd_crtres_aviso.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,3,0.5,BOXLINENONE,1);
    settab(3.5,pjleft,4,0.5,BOXLINENONE,1);
    settab(5.5,pjleft,6,0.5,BOXLINENONE,1);
    printtab('Férias Vencidas: '+resultado.bd_crtres_ferias_venc.Text);
    printtab('Férias Proporcionais: '+resultado.bd_crtres_ferias_prop.Text);
    printtab('Gratificação de Férias: '+resultado.bd_crtres_grat_ferias.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,3,0.5,BOXLINENONE,1);
    settab(3.5,pjleft,4,0.5,BOXLINENONE,1);
    settab(5.5,pjleft,6,0.5,BOXLINENONE,1);
    printtab('FGTS do Mês: '+resultado.bd_crtres_fgts.Text);
    printtab('FGTS Total: '+resultado.bd_crtres_fgts_total.Text);
    printtab('Multa sobre FGTS: '+resultado.bd_crtres_multa_fgts.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,4,0.5,BOXLINENONE,1);
    settab(3.5,pjleft,5,0.5,BOXLINENONE,1);
    settab(5.5,pjleft,6,0.5,BOXLINENONE,1);
    printtab('Total Bruto: '+resultado.bd_crtres_total.Text);
    printtab('Desconto INSS(Salário): '+resultado.bd_crtres_desc_inss_sal.Text);
    printtab('Desconto INSS(13º Salário): '+resultado.bd_crtres_desc_inss_dec.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjcenter,5,0.5,BOXLINEALL,2);
    printtab('Total Líquido à Receber: '+resultado.bd_crtres_total_liq.Text);
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,6,0.5,BOXLINENONE,1);
    printtab('>> Seguro Desemprego:');
    newline;
    newline;
    cleartabs;
    settab(1,pjleft,4,0.5,BOXLINENONE,1);
    settab(2.3,pjleft,5,0.5,BOXLINENONE,1);
    settab(4,pjleft,5,0.5,BOXLINENONE,1);
    settab(5.5,pjleft,5,0.5,BOXLINENONE,1);
    printtab('Nº de Cotas: '+resultado.bd_crtnr_cotas.Text);
    printtab('Início do Pgto: '+resultado.bd_crtinicio_seguro.Text);
    printtab('Fim do Pgto: '+resultado.bd_crtfinal_seguro.Text);
    printtab('Valor do Pgto: '+resultado.bd_crtvalor_seguro.Text);
    newline;
    newline;
    newline;
    newline;
    cleartabs;
    settab(1,pjcenter,5,0.5,BOXLINEBOTTOM,2);
    printtab('CRT - Cálculo de Rescisão Trabalhista');
    newline;
    newline;
    cleartabs;
    settab(1,pjcenter,5,0.5,BOXLINEHORIZ,1);
    printtab('Desenvolvido por Joel da Rosa - webjoel@hotmail.com');
  end;
end;

procedure Tresultado.FormShow(Sender: TObject);
begin
  If bd_crt.RecordCount < 1 then
  begin
  voltar.Enabled:=false;
  avancar.Enabled:=false;
  imprimir.Enabled:=false;
  excluir.Enabled:=false;
  end
  else
  begin
  salvar.Enabled:=true;
  voltar.Enabled:=true;
  avancar.Enabled:=true;
  imprimir.Enabled:=true;
  excluir.Enabled:=true;
  end;
end;

end.
