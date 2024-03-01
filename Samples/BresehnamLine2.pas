program pixel;
{$I Include\Math.pas}

procedure PlotLine(X1, Y1, X2, Y2: integer);
var
  I: integer;
  EN: Double;
  X, Y: Double;
  DX, DY: Double;
begin
  DrawLine(X1, Y1, X2, Y2);

  X := X1;
  Y := Y1;

  DX := X2 - X1;
  DY := Y2 - Y1;

  EN := 2 * DY - DX;
  
  for I := 1 to Int(DX) do
    begin
      plot(Int(X), Int(Y));
      if (En > 0) then
        begin
          Y := Y + 1;
          EN := EN - 2 * DX;
        end;
      X := X + 1;
      EN := EN + 2 * DY;
  end;
end;

begin
  PlotLine(0, 0, 15, 0);
  PlotLine(0, 0, 15, 6);
  PlotLine(0, 0, 12, 12);
end.
