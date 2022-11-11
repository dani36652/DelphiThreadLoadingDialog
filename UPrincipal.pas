unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, Skia, Skia.FMX;

type
  TFrmPrincipal = class(TForm)
    MainLayout: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    btnThreadProcess: TButton;
    btnNoThreadProcess: TButton;
    LoadingDlgBackGround: TRectangle;
    rectLoadingDialog: TRectangle;
    Label2: TLabel;
    LYLoading: TLayout;
    LYLoading2: TLayout;
    SKIndicador: TSkAnimatedImage;
    lblDescripcionProceso: TLabel;
    procedure btnThreadProcessClick(Sender: TObject);
    procedure btnNoThreadProcessClick(Sender: TObject);
  private
    { Private declarations }
    //Evento que se dispara cuando termina el Hilo
    procedure ThreadOnTerminate(Sender:TObject);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.btnNoThreadProcessClick(Sender: TObject);
begin
 //Verá que el aplicativo se quedará "congelado" ya que el proceso
 //pesado lo estamos ejecutando sobre el hilo principal
 //Ejecutar procesos pesados en un Hilo sincronizando sus objetos visuales
 //dentro de éste brinda una mejor sensación de optimización al usuario.
 Self.Caption:='Cargando...';
 SKIndicador.Animation.Enabled:= True;
 LoadingDlgBackGround.Visible:= True;
 Sleep(9000);
 LoadingDlgBackGround.Visible:= False;
 SKIndicador.Animation.Enabled:= False;
 Self.Caption:= 'Fin del Proceso';
end;

procedure TFrmPrincipal.btnThreadProcessClick(Sender: TObject);
var Thrd: TThread;
begin
//Antes de iniciar el hilo mostramos el loading Dialog
 SKIndicador.Animation.Enabled:= True;
 LoadingDlgBackGround.Visible:= True;
 Self.Caption:='Cargando...';

 Thrd:= TThread.CreateAnonymousThread(
 procedure
 begin
  //El loading dialog se mostrará por 9 segundos
  Sleep(9000);
 end);

 Thrd.FreeOnTerminate:= True;
 //Asignamos el evento al hilo
 Thrd.OnTerminate:= ThreadOnTerminate;
 Thrd.Start;
end;

procedure TFrmPrincipal.ThreadOnTerminate(Sender: TObject);
begin
 //Recuerde meter dentro de una sincronización solo cambios a componentes visuales
 //como cambio de texto a memo, label, información del stringGrid, etc.
 TThread.Synchronize(nil,
 procedure
 begin
  //Desaparece el loading Dialog al terminar el hilo
  LoadingDlgBackGround.Visible:= False;
  SKIndicador.Animation.Enabled:= False;
  Self.Caption:='Fin del Proceso';
 end);
end;

end.
