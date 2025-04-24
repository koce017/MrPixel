program pixel;

procedure ChooseD(var x, y, d: integer);
begin
  x := x + 1;
  y := y - 1;
  d := d + 2 * (x - y + 1);
end;

procedure ChooseH(var x, y, d: integer);
begin
  x := x + 1;
  y := y ;
  d := d + 2 * x + 1;
end;

procedure ChooseV(var x, y, d: integer);
begin
  x := x;
  y := y - 1;
  d := d - 2 * y + 1;
end;

procedure PlotCircle(r: integer);
var
  x, y, d: integer;
begin
  x := 0;
  y := r;
  d := 2 * (1 - r);
  
  while y >= 0 do
  begin
    plot(x, y);
    
    if d = 0 then
      ChooseD(x, y, d)
    else
      if d < 0 then
        if (2 * d + 2 * y - 1 > 0) then
          ChooseD(x, y, d)
        else
          ChooseH(x, y, d)
      else
        if (2 * d - 2 * x - 1 > 0) then
          ChooseV(x, y, d)
        else
          ChooseD(x, y, d)
  end;
  
end;

begin
  PlotCircle(5);
  PlotCircle(10);
end.