unit FMXER.PaintBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Skia, Skia.FMX;

type
  TOnTapHandler = reference to procedure(APaintBox: TObject; APoint: TPointF);

  TPaintBoxFrame = class(TFrame)
    PaintBox: TSkPaintBox;
    procedure PaintBoxTap(Sender: TObject; const Point: TPointF);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FOnTapHandler: TOnTapHandler;
  public
    property OnTapHandler: TOnTapHandler read FOnTapHandler write FOnTapHandler;
  end;

implementation

{$R *.fmx}

procedure TPaintBoxFrame.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  {$IFDEF MSWINDOWS} // simulate OnTap on Windows
  PaintBoxTap(Sender, PointF(X, Y));
  {$ENDIF}
end;

procedure TPaintBoxFrame.PaintBoxTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FOnTapHandler) then
    FOnTapHandler(PaintBox, Point);
end;

end.
