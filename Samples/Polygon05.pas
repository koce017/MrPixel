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
Koristi stek da oznaci redove, a ne piksele,
koje treba obojiti pa se stek ne koristi puno.

Stavimo seme na stek.

Dokle god stek nije prazan, uzmemo piksel P
sa steka i obojimo, pa onda i ceo red iduci
na levo i na desno dok ne naidjemo do ivice.

Iz redova iznad i ispod uzmemo po piksel u
svakom delu. Delovi su razdvojeni preprekama.
----o----xxxx----o----
}


procedure FillPoly(SeedX, SeedY: Integer);
var
  PX: Integer;
  PY: Integer;
  MinX: Integer;
  MaxX: Integer;
  TempX: Integer;
  FlagUp: Boolean;
  FlagDown: Boolean;
begin
  EndLine(lines[1].p1.x, lines[1].p1.y, lines[countP]);

  SetColor('clYellow');

  Push(SeedX);
  Push(SeedY);

  while not IsEmpty() do
    begin
    
      Pop(PY);
      Pop(PX);
      Plot(PX, PY);

      // bojimo na levo
      TempX := PX - 1;
      while not IsOn(TempX, PY) do
        begin
          Plot(TempX, PY);
          TempX := TempX - 1;
        end;
      MinX := TempX + 1;

      // bojimo na desno
      TempX := PX + 1;
      while not IsOn(TempX, PY) do
        begin
          Plot(TempX, PY);
          TempX := TempX + 1;
        end;
      MaxX := TempX - 1;
      
      FlagUp := True;
      FlagDown := True;
      
      for TempX := MinX to MaxX do
        begin
        
          // red iznad
          if not IsOn(TempX, PY - 1) then
            if FlagUp then
              begin
                Push(TempX);
                Push(PY - 1);
                FlagUp := False;
              end
          else
            FlagUp := True; // prepreka, mozda je pocetak novog dela
          
          // red ispod
          if not IsOn(TempX, PY + 1) then
            if FlagDown then
              begin
                Push(TempX);
                Push(PY + 1);
                FlagDown := False;
              end
          else
            FlagDown := True;
            
        end;
      
    end;

end;

begin
  NewPoly;
  SetColor('clBlue');
  AddPoint(0, 0);
  AddPoint(5, -5);
  AddPoint(10, 0);
  AddPoint(10, 15)
  AddPoint(7, 15);
  AddPoint(7, 10);
  AddPoint(3, 10);
  AddPoint(3, 15);
  AddPoint(0, 15);
  // prepreke
  PlotLine(5, -5, 5, 0);
  PlotLine(3, 7, 8, 7);
  PlotLine(2, 5, 8, 2);
  FillPoly(3, 3);
end.
