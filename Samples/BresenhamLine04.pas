program pixel;
{$I Include\Math.pas}

function IfThenI(c: boolean; a, b: integer): integer;
begin if (c) then result := a else result := b; end;

function IfThenD(c: boolean; a, b: double): double;
begin if (c) then result := a else result := b; end;

procedure PlotLine(x1, y1, x2, y2: integer);
var
  i: integer;
  xdominant: boolean;
  x, y, sx, sy, en, dy, dx, len: double;
begin
  DrawLine(x1, y1, x2, y2);

  // podrzavamo i kretanje u levo, pa bez
  // problema uzimamo x1 kao pocetnu tacku
  x := x1;
  y := y1;
  
  // sx odredjuje smer kretanja:
  //  +1 ako idemo desno (x1 < x2, x2 - x1 > 0)
  //  -1 ako idemo levo (x2 < x1, x2 - x1 < 0)
  sx := SignDbl(x2 - x1);
  sy := SignDbl(y2 - y1);
  
  dx := abs(x2 - x1);
  dy := abs(y2 - y1);  
  
  xdominant := dx >= dy;
  len := IfThenD(xdominant, dx, dy);
  en := IfThenD(xdominant, 2 * dy - dx, 2 * dx - dy);
  
  for i := 1 to Trunc(len) do
  begin
    
    plot(int(x), int(y));
    
    if (en > 0) then
    begin
      if (xdominant) then
      begin
        y := y + sy;
        en := en - 2 * dx;
      end
      else
      begin
        x := x + sx;
        en := en - 2 * dy;
      end;
    end;

    if (xdominant) then
    begin
      x := x + sx;
      en := en + 2 * dy;
    end
    else
    begin
      y := y + sy;
      en := en + 2 * dx;
    end;
    
  end;
  
end;

begin
  PlotLine(0, 0, 15, 0);
  PlotLine(0, 0, 15, 6);
  PlotLine(0, 0, 12, 12);
  PlotLine(0, 0, 6, 15);
  PlotLine(0, 0, 0, 15);
  PlotLine(0, 0, -6, 15);
  PlotLine(0, 0, -12, 12);
  PlotLine(0, 0, -15, 6);
  PlotLine(0, 0, -15, 0);
  PlotLine(0, 0, -15, -6);
  PlotLine(0, 0, -12, -12);
  PlotLine(0, 0, -6, -15);
  PlotLine(0, 0, 0, -15);
  PlotLine(0, 0, 6, -15);
  PlotLine(0, 0, 12, -12);
  PlotLine(0, 0, 15, -6);
end.
