program pixel;

procedure ChooseD(var X, Y, D: Integer);
begin
  X := X + 1;
  Y := Y - 1;
  D := D + 2 * (X - Y + 1);
end;

procedure ChooseH(var X, Y, D: Integer);
begin
  X := X + 1;
  Y := Y;
  D := D + 2 * X + 1;
end;

procedure ChooseV(var X, Y, D: Integer);
begin
  X := X;
  Y := Y - 1;
  D := D - 2 * Y + 1;
end;

procedure PlotCircle(CX, CY, R: Integer);
var
  X, Y, D: Integer;
begin
  X := 0;
  Y := R;
  D := 2 * (1 - R);
  
  while Y >= 0 do
  begin
    Plot(X + CX, Y + CY);
    Plot(-X + CX, Y + CY);
    Plot(-X + CX, -Y + CY);
    Plot(X + CX, -Y + CY);
    
    if D = 0 then
      ChooseD(X, Y, D)
    else
      if D < 0 then
        if (2 * D + 2 * Y - 1 > 0) then
          ChooseD(X, Y, D)
        else
          ChooseH(X, Y, D)
      else
        if (2 * D - 2 * X - 1 > 0) then
          ChooseV(X, Y, D)
        else
          ChooseD(X, Y, D)
  end;
  
end;

begin
  PlotCircle(-10, -5, 5);
  PlotCircle(10, 5, 10);
end.