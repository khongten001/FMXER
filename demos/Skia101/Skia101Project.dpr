program Skia101Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.Spinner in 'Frames.Spinner.pas' {SpinnerFrame: TFrame},
  Routes.home in 'Routes.home.pas',
  Routes.menu in 'Routes.menu.pas',
  Routes.spinner in 'Routes.spinner.pas',
  Routes.image in 'Routes.image.pas',
  QRCode.Utils in '..\..\source\QRCode.Utils.pas',
  FMXER.QRCodeFrame in '..\..\source\FMXER.QRCodeFrame.pas' {QRCodeFrame: TFrame};

{$R *.res}

begin
  GlobalUseSkia := True;
  GlobalUseSkiaRasterWhenAvailable := False;

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
