program LoadingDialog;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  UPrincipal in 'UPrincipal.pas' {FrmPrincipal};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
