program pixel;
{$I Include\Math.pas}
const
  MAX_X = 20;
  MAX_LINES = 100;
  MAX_POINTS = 200;

type
  TPoint = record
    x: Integer;
    y: Integer;
  end;
  TLine = record
    p1: TPoint;
    p2: TPoint;
  end;
  TLines = array[1..MAX_LINES] of TLine;

var
  lines: TLines;
  countP: Integer;
  minY, maxY: Integer;

function MinI(a, b: Integer): Integer;
begin if a <= b then result := a else result := b; end;

function MaxI(a, b: Integer): Integer;
begin if a >= b then result := a else result := b; end;

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
  x := x1;
  y := y1;
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

procedure NewPoly;
begin
  countP := 0;
end;

procedure StartLine(x, y: Integer; var line: TLine);
begin
  line.p1.x := x;
  line.p1.y := y;
end;

procedure EndLine(x, y: Integer; var line: TLine);
begin
  line.p2.x := x;
  line.p2.y := y;
  DrawLine(line.p1.x, line.p1.y, line.p2.x, line.p2.y);
  PlotLine(line.p1.x, line.p1.y, line.p2.x, line.p2.y);
end;

procedure AddPoint(x, y: Integer);
begin
  countP := countP + 1;

  if countP = 1
  then begin
         minY := y;
         maxY := y;
         StartLine(x, y, lines[countP]);
       end
  else begin
         minY := MinI(y, minY);
         maxY := MaxI(y, maxY);
         EndLine(x, y, lines[countP - 1]);
         StartLine(x, y, lines[countP]);
       end;
end;

{
Staviti seme na stek
Dokle stek nije prazan
  Uzeti piksel P sa steka
  Obojiti P
  Za svaki od 4 suseda piksela P
    Ako je piksel ivicni ili je vec obojen
      zanemariti ga
    inace
      staviti ga na stek

Problemi:
  - overflow steka
}

procedure PushIfOff(PX, PY: Integer);
begin
  if not IsOn(PX, PY) then
    begin
      Push(PX);
      Push(PY);
    end;
end;

procedure FillPoly(SeedX, SeedY: Integer);
var
  PX: Integer;
  PY: Integer;
begin
  EndLine(lines[1].p1.x, lines[1].p1.y, lines[countP]);

  Plot(SeedX, SeedY);
  Push(SeedX);
  Push(SeedY);

  while not IsEmpty() do
    begin
      Pop(PY);
      Pop(PX);
      Plot(PX, PY);
      PushIfOff(PX + 1, PY);
      PushIfOff(PX - 1, PY);
      PushIfOff(PX, PY + 1);
      PushIfOff(PX, PY - 1);
    end;
end;

begin
  NewPoly;
  SetColor('clGray');
  AddPoint(-13, -1);
  AddPoint(-13, -7);
  AddPoint(-6, -7);
  AddPoint(-6, -1);
  FillPoly(-9, -4);

  NewPoly;
  SetColor('clRed');
  AddPoint(-16, -7);
  AddPoint(-10, -13);
  AddPoint(-4, -7);
  FillPoly(-10, -10);

  NewPoly;
  SetColor('clMaroon');
  AddPoint(7, -1);
  AddPoint(7, -8);
  AddPoint(9, -8);
  AddPoint(9, -1);
  FillPoly(8, -4);

  NewPoly;
  SetColor('clGreen');
  AddPoint(7, -8);
  AddPoint(2, -11);
  AddPoint(5, -15);
  AddPoint(8, -17);
  AddPoint(12, -15);
  AddPoint(15, -11);
  AddPoint(10, -8);
  FillPoly(8, -12);
end.
