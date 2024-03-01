unit RealSizeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, Generics.Collections;

type
  TRealSizeForm = class(TForm)
    RealSizePaintBox: TPaintBox;
    procedure FormShow(Sender: TObject);
    procedure RealSizePaintBoxPaint(Sender: TObject);
  private
    { Private declarations }
    function OffsetCoordinate(A: Integer): Integer;
  public
    { Public declarations }
  end;

var
  RealSizeForm: TRealSizeForm;

implementation

{$R *.dfm}

uses MainUnit;

procedure TRealSizeForm.FormShow(Sender: TObject);
begin
  ClientWidth := 2 * MainForm.FPixelsPerQuadrantSide + 1;
  ClientHeight := 2 * MainForm.FPixelsPerQuadrantSide + 1;
end;

procedure TRealSizeForm.RealSizePaintBoxPaint(Sender: TObject);
var
  InnerItem: TPair<Integer, TColor>;
  OuterItem: TPair<Integer, TDictionary<Integer, TColor>>;
begin
  // ** clearing canvas ** //
  RealSizePaintBox.Canvas.Pen.Style := psClear;
  RealSizePaintBox.Canvas.Brush.Color := MainUnit.BLANK_COLOR;
  RealSizePaintBox.Canvas.Rectangle(0, 0, RealSizePaintBox.Width, RealSizePaintBox.Height);
  RealSizePaintBox.Canvas.Pen.Style := psSolid;

  // ** filling pixels ** //
  for OuterItem in MainForm.FPixels do
    for InnerItem in OuterItem.Value do
       RealSizePaintBox.Canvas.Pixels[OffsetCoordinate(OuterItem.Key) + 1, OffsetCoordinate(InnerItem.Key) + 1] := InnerItem.Value;
end;

function TRealSizeForm.OffsetCoordinate(A: Integer): Integer;
begin
  Result := A;
  if MainForm.FCenterOrigin then
    Result := Result + RealSizePaintBox.Width div 2;
end;

end.
