unit crt_informacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ShellApi, Buttons;

type
  Tinfo = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    BitBtn1: TBitBtn;
    Label10: TLabel;
    procedure Label3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  info: Tinfo;

implementation

{$R *.dfm}

procedure Tinfo.Label3Click(Sender: TObject);
begin
  ShellExecute(handle, 'open','mailto:webjoel@hotmail.com','','',1); 
end;

procedure Tinfo.BitBtn1Click(Sender: TObject);
begin
  close;
end;

end.
