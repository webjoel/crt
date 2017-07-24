; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=CRT - C�lculo de Rescis�o Trabalhista
AppVerName=CRT 1.0
AppPublisher=By Joel da Rosa
AppPublisherURL=http://www.webjoel.pop.com.br
AppSupportURL=http://www.webjoel.pop.com.br
AppUpdatesURL=http://www.webjoel.pop.com.br
DefaultDirName={pf}\CRT
DefaultGroupName=CRT - C�lculo de Rescis�o Trabalhista
LicenseFile=C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\licenca.txt
InfoBeforeFile=C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\info.txt
InfoAfterFile=C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\info2.txt
OutputDir=C:\
OutputBaseFilename=setup_crt
SetupIconFile=C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\Imagens\instalar.ICO
Compression=lzma
SolidCompression=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\crt.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\dbexpint.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Joel\Meus documentos\Joel da Rosa\Projetos\CRT\midas.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\CRT - C�lculo de Rescis�o Trabalhista"; Filename: "{app}\crt.exe"
Name: "{group}\{cm:UninstallProgram,CRT - C�lculo de Rescis�o Trabalhista}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\CRT - C�lculo de Rescis�o Trabalhista"; Filename: "{app}\crt.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\crt.exe"; Description: "{cm:LaunchProgram,CRT - C�lculo de Rescis�o Trabalhista}"; Flags: nowait postinstall skipifsilent
