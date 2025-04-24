program pixel;
{$I Include\Math.pas}
const
  COLOR_COUNT = 8;

var
  ci: integer;
  colors: array[0 .. COLOR_COUNT - 1] of string;

procedure initcolors;
begin
  ci := -1;
  colors[0] := 'clBlack';
  colors[1] := 'clBlue';
  colors[2] := 'clRed';  
  colors[3] := 'clGreen';
  colors[4] := 'clLime'; 
  colors[5] := 'clYellow';
  colors[6] := 'clGray'; 
  colors[7] := 'clMaroon';
end;

// naizmenicno menja boje
procedure NextColor;
begin
  ci := (ci + 1) mod COLOR_COUNT;  
  setcolor(colors[ci]);
end;


function IfThenI(c: boolean; a, b: integer): integer;
begin if (c) then result := a else result := b; end;

function IfThenD(c: boolean; a, b: double): double;
begin if (c) then result := a else result := b; end;

procedure PlotLine(X1, Y1, X2, Y2: integer);
var
  I: Integer;
  X, Y: Double;
  SX, SY: Double;
  DX, DY: Double;
  EN, Len: Double;
  XDominant: Boolean;
begin
  DrawLine(x1, y1, x2, y2);

  X := X1;
  Y := Y1;
  
  SX := SignDbl(X2 - X1);
  SY := SignDbl(Y2 - Y1);
  
  DX := Abs(x2 - x1);
  DY := Abs(y2 - y1);
  
  XDominant := DX >= DY;
  Len := IfThenDbl(XDominant, DX, DY);
  EN := IfThenDbl(XDominant, 2 * DY - DX, 2 * DX - DY);
  
  for i := 1 to Int(Len) do
  begin
    
    plot(trunc(x), trunc(y));
    
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
  initcolors;
  nextcolor; PlotLine(0, 0, 15, 0);    
  nextcolor; PlotLine(0, 0, 15, 6);     
  nextcolor; PlotLine(0, 0, 12, 12);     
  nextcolor; PlotLine(0, 0, 6, 15);     
  nextcolor; PlotLine(0, 0, 0, 15);     
  nextcolor; PlotLine(0, 0, -6, 15);     
  nextcolor; PlotLine(0, 0, -12, 12);
  nextcolor; PlotLine(0, 0, -15, 6);     
  nextcolor; PlotLine(0, 0, -15, 0);     
  nextcolor; PlotLine(0, 0, -15, -6);     
  nextcolor; PlotLine(0, 0, -12, -12);     
  nextcolor; PlotLine(0, 0, -6, -15);     
  nextcolor; PlotLine(0, 0, 0, -15);     
  nextcolor; PlotLine(0, 0, 6, -15);     
  nextcolor; PlotLine(0, 0, 12, -12);     
  nextcolor; PlotLine(0, 0, 15, -6);    
end.
