program pixel;
{$I Include\Math.pas}

procedure PlotLine(x1, y1, x2, y2: integer);
var
  i: integer;
  en: Double;
  x, y: Double;
  dx, dy: Double;
begin
  DrawLine(x1, y1, x2, y2);

  x := x1;
  y := y1;

  dx := x2 - x1;
  dy := y2 - y1;

  // e = dy / dx - 1 / 2 -- pomnozimo sa 2dx
  // 2dxe = 2dx * dy / dx - 2dx * 1 / 2
  // 2dxe = 2dy - dx
  // oznacimo:
  // en = 2dxe
  // e = en / 2dx  
  en := 2 * dy - dx;
  
  for i := 1 to trunc(dx) do
  begin
    plot(int(x), int(y));
    if (en > 0) then
    begin
       y := y + 1;
       // e = e - 1
       // en / 2dx = en / 2dx - 1 -- pomnozimo sa 2dx
       // en = en - 2dx
       en := en - 2 * dx;
    end;
    x := x + 1;
    // e = e + dy / dx
    // en / 2dx = en / 2dx + dy / dx -- pomnozimo sa 2dx
    // en = en + 2dy
    en := en + 2 * dy;
  end;
end;

begin
  PlotLine(0, 0, 15, 0);
  PlotLine(0, 0, 15, 6);
  PlotLine(0, 0, 12, 12);
end.
