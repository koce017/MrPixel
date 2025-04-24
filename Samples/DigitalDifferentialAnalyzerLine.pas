program pixel;
{$I Include\Math.pas}
{$I Include\Graphics.pas}

procedure PlotLine(X1, Y1, X2, Y2: Integer);
var
  I: integer;
  Len: Double;
  X, Y: Double;
  DX, DY: Double;
  IncX, IncY: Double;
begin
  DrawLine(X1, Y1, X2, Y2);

  DX := X2 - X1;
  DY := Y2 - Y1;

  Len := MaxDbl(Abs(DX), Abs(DY));

  IncX := DX / Len;
  IncY := DY / Len;
  
  X := X1 + 0.5 * SignDbl(IncX);
  Y := Y1 + 0.5 * SignDbl(IncY);

  for I := 1 to Int(Len) do
    begin
      Plot(Int(X), Int(Y));
      X := X + IncX;
      Y := Y + IncY;
    end;
end;

begin
  SetRandomColor; PlotLine(0, 0, 15, 0);
  SetRandomColor; PlotLine(0, 0, 15, 6);
  SetRandomColor; PlotLine(0, 0, 12, 12);
  SetRandomColor; PlotLine(0, 0, 6, 15);
  SetRandomColor; PlotLine(0, 0, 0, 15);
  SetRandomColor; PlotLine(0, 0, -6, 15);
  SetRandomColor; PlotLine(0, 0, -12, 12);
  SetRandomColor; PlotLine(0, 0, -15, 6);
  SetRandomColor; PlotLine(0, 0, -15, 0);
  SetRandomColor; PlotLine(0, 0, -15, -6);
  SetRandomColor; PlotLine(0, 0, -12, -12);
  SetRandomColor; PlotLine(0, 0, -6, -15);
  SetRandomColor; PlotLine(0, 0, 0, -15);
  SetRandomColor; PlotLine(0, 0, 6, -15);
  SetRandomColor; PlotLine(0, 0, 12, -12);
  SetRandomColor; PlotLine(0, 0, 15, -6);
end.
