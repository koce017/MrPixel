program pixel;
{$I Include\Math.pas}

procedure PlotLine(X1, Y1, X2, Y2: Integer);
var
  I: Integer;
  E: Double;
  X, Y: Double;
  DX, DY: Double;
begin
  DrawLine(X1, Y1, X2, Y2);

  X := X1;
  Y := Y1;

  DX := X2 - X1;
  DY := Y2 - Y1;

  E := DY / DX - 0.5;
  
  for I := 1 to Int(DX) do
    begin
      Plot(Int(X), Int(Y));
      if (E > 0) then
        begin
          Y := Y + 1;
          E := E - 1;
        end;
      X := X + 1;
      E := E + DY / DX;
    end;
end;

begin
  PlotLine(0, 0, 15, 0);
  PlotLine(0, 0, 15, 6);
  PlotLine(0, 0, 12, 12);
end.
