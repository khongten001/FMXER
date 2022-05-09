unit FMXER.SVGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Skia, Skia.FMX;

type
  TOnTapHandler = reference to procedure(AImage: TObject; APoint: TPointF);

  TSVGFrame = class(TFrame)
    ContentSvg: TSkSvg;
    procedure ContentSvgTap(Sender: TObject; const Point: TPointF);
    procedure ContentSvgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FOnTapHandler: TOnTapHandler;
    function GetSVGSource: string;
    procedure SetSVGSource(const Value: string);
  public
    procedure LoadFromFile(const AFileName: string); overload;
    procedure LoadFromFile(const AFileName: string; const AEncoding: TEncoding); overload;
    property SVG: TSkSvg read ContentSVG;
    property SVGSource: string read GetSVGSource write SetSVGSource;
    property OnTapHandler: TOnTapHandler read FOnTapHandler write FOnTapHandler;
  end;

implementation

{$R *.fmx}

uses IOUtils;

{ TSVGFrame }

procedure TSVGFrame.ContentSvgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  {$IFDEF MSWINDOWS} // simulate OnTap on Windows
  ContentSvgTap(Sender, PointF(X, Y));
  {$ENDIF}
end;

procedure TSVGFrame.ContentSvgTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FOnTapHandler) then
    FOnTapHandler(ContentSvg, Point);
end;

function TSVGFrame.GetSVGSource: string;
begin
  Result := SVG.Svg.Source;
end;

procedure TSVGFrame.LoadFromFile(const AFileName: string);
begin
  SVG.Svg.Source := TFile.ReadAllText(AFileName);
end;

procedure TSVGFrame.LoadFromFile(const AFileName: string; const AEncoding: TEncoding);
begin
  SVGSource := TFile.ReadAllText(AFileName, AEncoding);
end;

procedure TSVGFrame.SetSVGSource(const Value: string);
begin
  SVG.Svg.Source := Value;
end;

end.
