unit Routes.menu;

interface

procedure DefineMenuRoute;

implementation

uses
  FMX.ListView.Appearances

, FMXER.Navigator
, FMXER.ScaffoldForm
, FMXER.ListViewFrame
, FMXER.QRCodeFrame

, SubjectStand, FMX.Types, System.Types
;

procedure DefineMenuRoute;
begin
  Navigator.DefineRoute<TScaffoldForm>('menu'
  , procedure (AMenu: TScaffoldForm)
    begin
      AMenu.Title := 'Select an entry';

      AMenu.SetTitleDetailContentAsFrame<TQRCodeFrame>(
        procedure (AQR: TQRCodeFrame)
        begin
          AQR.Content := 'https://github.com/andrea-magni/FMXER';
          AQR.Align := TAlignLayout.Right;
          AQR.Width := AMenu.TitleLayout.Height;
          AQR.Margins.Rect := RectF(10, 10, 10, 10);
        end
      );

      AMenu.SetContentAsFrame<TListViewFrame>(
        procedure (AList: TListViewFrame)
        begin
          AList.ItemAppearance := 'ListItemRightDetail';

          AList.AddItem('Item spinner 1', '1 second', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('spinner', True);
              TDelayedAction.Execute(1000
              , procedure
                begin
                  Navigator.CloseRoute('spinner', True);
                end
              );
            end
          );

          AList.AddItem('Item spinner 2', '5 seconds', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('spinner', True);
              TDelayedAction.Execute(5000
              , procedure
                begin
                  Navigator.CloseRoute('spinner', True);
                end
              );
            end
          );

          AList.AddItem('Item spinner 3', '10 seconds', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('spinner', True);
              TDelayedAction.Execute(10000
              , procedure
                begin
                  Navigator.CloseRoute('spinner', True);
                end
              );
            end
          );

          AList.AddItem('Image', 'Tap to close', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('image');
            end
          );

          AList.AddItem('Animated Image', 'Tap to close', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('animatedImage');
            end
          );

          AList.AddItem('SVG Image', 'Tap to close', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('SVGImage');
            end
          );


          AList.AddItem('QR Code', 'Tap to close', -1
          , procedure (const AItem: TListViewItem)
            begin
              Navigator.RouteTo('QRCode');
            end
          );

        end
      );
    end
  );
end;

end.

