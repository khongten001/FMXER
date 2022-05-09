unit Routes.image;

interface

uses System.Classes, System.SysUtils, System.Types;

procedure DefineImageRoute;
procedure DefineAnimatedImageRoute;
procedure DefineSVGImageRoute;
procedure DefineQRCodeRoute;

implementation

uses
  System.Threading
, FMXER.Navigator
, FMXER.ScaffoldForm
, FMXER.ImageFrame
, FMXER.AnimatedImageFrame
, FMXER.SVGFrame
, FMXER.BackgroundForm
, FMXER.BackgroundFrame
, FMXER.QRCodeFrame
, FMXER.UI.Consts

, System.UITypes
, Skia, QRCode.Render
;

procedure DefineImageRoute;
begin
  Navigator.DefineRoute<TScaffoldForm>('image'
  , procedure (S: TScaffoldForm)
    begin
      S.Title := 'Image (PNG)';

      S.SetContentAsFrame<TImageFrame>(
        procedure (ImgF: TImageFrame)
        begin
          ImgF.ContentImage.Bitmap.LoadFromFile('C:\Sviluppo\Librerie\FMXER\media\FMXER_256.png');
          ImgF.OnTapHandler :=
            procedure (AImg: TObject; APoint: TPointF)
            begin
              if TPointF.PointInCircle(APoint, PointF(ImgF.ContentImage.Width/2, ImgF.ContentImage.Height/2), 100) then
                Navigator.CloseRoute('image');

            end;
        end
      );
    end
  );
end;

procedure DefineAnimatedImageRoute;
begin
  Navigator.DefineRoute<TScaffoldForm>('animatedImage'
  , procedure (S: TScaffoldForm)
    begin
      S.Title := 'Animated image (Lottie)';

      S.SetContentAsFrame<TAnimatedImageFrame>(
        procedure (ImgF: TAnimatedImageFrame)
        begin
          ImgF.Image.LoadFromFile('C:\Sviluppo\Librerie\FMXER\media\lottie_bubbles_MATERIAL_AMBER_800.json');
          ImgF.OnTapHandler :=
            procedure (AImg: TObject; APoint: TPointF)
            begin
              if TPointF.PointInCircle(APoint, PointF(ImgF.Image.Width/2, ImgF.Image.Height/2), 100) then
                Navigator.CloseRoute('animatedImage');

            end;
        end
      );

    end
  );
end;


procedure DefineSVGImageRoute;
begin
  Navigator.DefineRoute<TScaffoldForm>('SVGImage'
  , procedure (S: TScaffoldForm)
    begin
      S.Title := 'SVG image';

      S.SetContentAsFrame<TSVGFrame>(
        procedure (ImgF: TSVGFrame)
        begin
          ImgF.LoadFromFile('C:\Sviluppo\Librerie\FMXER\media\Tesla.svg');
          ImgF.OnTapHandler :=
            procedure (AImg: TObject; APoint: TPointF)
            begin
              if TPointF.PointInCircle(APoint, PointF(ImgF.SVG.Width/2, ImgF.SVG.Height/2), 100) then
                Navigator.CloseRoute('SVGImage');
            end;
        end
      );

    end
  );
end;




procedure DefineQRCodeRoute;
begin
  Navigator.DefineRoute<TScaffoldForm>('QRCode'
  , procedure (S: TScaffoldForm)
    begin
      S.Title := 'QRCode';

      S.SetContentAsFrame<TBackgroundFrame>(
        procedure (B: TBackgroundFrame)
        begin
          B.Fill.Color := TAlphaColorRec.Aliceblue;
          B.SetContentAsFrame<TQRCodeFrame>(
            procedure (QRF: TQRCodeFrame)
            begin
              QRF.Margins.Rect := RectF(25, 25, 25, 25);
              QRF.HitTest := True; // prevents click-through

              QRF.Content := 'Current date time is ' + DateTimeToStr(Now);
              QRF.RadiusFactor := 0.1;

              QRF.QRCodeLogo.LoadFromFile('C:\Sviluppo\Librerie\FMXER\media\FMXER_R_256.png');
              QRF.QRCodeLogo.Width := 64;
              QRF.QRCodeLogo.Height := 64;
              QRF.QRCodeLogo.Visible := True;


              TTask.Run(
                procedure
                begin
                  while True do
                  begin
                    Sleep(750);
                    if not (TNavigator.Initialized and Navigator.IsRouteActive('QRCode')) then
                      Break;

                    TThread.Synchronize(nil
                    , procedure
                      begin
                        if not Navigator.IsRouteActive('QRCode') then
                          Exit;
                        QRF.Content := 'Time: ' + TimeToStr(Now);
                        S.Title := 'QRCode ' + QRF.Content;
                      end
                    );
                  end;
                end
              );

              QRF.OnBeforePaint :=
                procedure (APaint: ISkPaint; AModules: T2DBooleanArray)
                begin
                  APaint.Shader := TSkShader.MakeGradientLinear(
                    PointF(6, Length(AModules) - 6), PointF(Length(AModules) - 6, 6)
                  , TAppColors.MATERIAL_ORANGE_800
                  , TAppColors.MATERIAL_AMBER_800
                  , TSkTileMode.Clamp);
                end;

              QRF.OnTapHandler :=
                procedure (AC: TObject; APoint: TPointF)
                begin
                  if TPointF.PointInCircle(APoint, PointF(QRF.QRCode.Width/2, QRF.QRCode.Height/2), 100) then
                    Navigator.CloseRoute('QRCode');
                end;
            end
          );
        end
      );

    end
  );

end;




end.
