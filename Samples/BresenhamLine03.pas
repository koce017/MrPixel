program pixel;

function IfThenI(c: boolean; a, b: integer): integer;
begin if (c) then result := a else result := b; end;

function IfThenD(c: boolean; a, b: double): double;
begin if (c) then result := a else result := b; end;

procedure PlotLine(x1, y1, x2, y2: integer);
var
  i: integer;
  xdominant: boolean;
  x, y, en, dy, dx, len: double;
begin
  DrawLine(x1, y1, x2, y2);

  // algoritam je napravljen da radi pod pretpostavkom
  // da idemo sa desna na levo. zato stavimo da pocetna
  // tacka bude ona sa manjom koordinatom
  x := IfThenI(x1 <= x2, x1, x2);
  y := IfThenI(y1 <= y2, y1, y2);
  
  // stavljamo abs jer nema vise
  // pretpostavke da je x1 < x2
  dx := abs(x2 - x1);
  dy := abs(y2 - y1);
  
  // drugi oktant
  // x i y menjaju mesta: y je dominantno i povecava
  // se za 1 u svakom koraku, a x se povecava po potrebi
  xdominant := dx >= dy;
  len := IfThenD(xdominant, dx, dy);
  en := IfThenD(xdominant, 2 * dy - dx, 2 * dx - dy);
  
  for i := 1 to Trunc(len) do
  begin
    
    plot(Trunc(x), Trunc(y));
    
    if (en > 0) then
    begin
       if (xdominant) then
       begin
          y := y + 1;
          en := en - 2 * dx;
       end
       else
       begin
          x := x + 1;
          en := en - 2 * dy;
       end;
    end;

    if (xdominant) then
    begin
       x := x + 1;
       en := en + 2 * dy;
    end
    else
    begin
       y := y + 1;
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
end.
