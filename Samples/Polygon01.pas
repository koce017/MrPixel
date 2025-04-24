program pixel;

const
  MAX_LINES = 100;

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
  startP, finishP: TPoint;

function MinI(a, b: Integer): Integer;
begin if (a <= b) then result := a else result := b; end;

function MaxI(a, b: Integer): Integer;
begin if (a >= b) then result := a else result := b; end;

function MinD(a, b: Double): Double;
begin if (a <= b) then result := a else result := b; end;

function MaxD(a, b: Double): Double;
begin if (a >= b) then result := a else result := b; end;

procedure NewPoly;
begin
  // broj duzi u ciklusu je jednak broju tacaka
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
  //DrawLine(line.p1.x, line.p1.y, line.p2.x, line.p2.y); 
end;

procedure AddPoint(x, y: Integer);
begin
  // Umesto da kasnije prolazimo kroz svih 40 redova i kolona,
  // odredicemo najmanji pravougaonik u koji staje cela figura.
  // Da bi izbegli dodatne provere, ogranicavamo da je pocetna
  // tacka sledece linije uvek krajnja tacka prethodne linije.
  
  countP := countP + 1;
      
  if countP = 1 then
    begin
      StartLine(x, y, lines[countP]);
            
      startP.x := x;
      startP.y := y;
      finishP.x := x;
      finishP.y := y;
    end
  else
    begin 
      EndLine(x, y, lines[countP - 1]);
      StartLine(x, y, lines[countP]);
            
      startP.x := MinI(x, startP.x);
      startP.y := MinI(y, startP.y);
      finishP.x := MaxI(x, finishP.x);
      finishP.y := MaxI(y, finishP.y);
    end;
end;

procedure MarkIntersect(line: TLine; scanY: Double);
var
  scanX: Double;
begin
  scanY := scanY + 0.5;
  // Ako se scan linija i duz seku, na osnovu jednacine prave racunamo x
  // koordinatu preseka. Scan linija i duz se seku ako se linija nalazi
  // vislje od nizeg i nize od visljeg temena duzi (izmedju dva temena).
  if (scanY >= MinD(line.p1.y, line.p2.y)) and (scanY <= MaxD(line.p1.y, line.p2.y)) then
    begin
      scanX := (scanY - line.p1.y) * (line.p2.x - line.p1.x) / (line.p2.y - line.p1.y) + line.p1.x;
      Plot(trunc(scanX), trunc(scanY));
    end;
end;

procedure FillPoly;
var
  scanY: Integer;
  i, x, y: Integer;
  isInside: Boolean;
begin
  EndLine(lines[1].p1.x, lines[1].p1.y, lines[countP]);

  scanY := startP.y;
  for scanY := startP.y to finishP.y do
    begin
      for i := 1 to countP do
        begin
          MarkIntersect(lines[i], scanY);
        end;  
    end;  
 
  // Kada prvi put kad naidjemo na bojen piksel to znaci da ulazimo u figuru,
  // a kada drugi put naidjemo na bojen piksel to znaci da izlazimo iz figure.
  isInside := False;
  for y := startP.y to finishP.y do
    begin
      for x := startP.x to finishP.x do
        begin
          
          if IsOn(x, y) then
            begin
              isInside := not isInside;
            end;
          
          if isInside then
            begin
              Plot(x, y);
            end;  
          
        end;
    end;
end;

begin
  // ne navoditi prvu tacku i na pocetku
  // i na kraju, ciklus se sam zatvara
  
  NewPoly;
  AddPoint(-13, -1);
  AddPoint(-13, -7);
  AddPoint(-6, -7);
  AddPoint(-6, -1);
  SetColor('clGray');
  FillPoly;
  
  NewPoly;
  AddPoint(-16, -7);
  AddPoint(-10, -13);
  AddPoint(-4, -7);
  SetColor('clRed');
  FillPoly;
  
  NewPoly;
  AddPoint(7, -1);
  AddPoint(7, -8);
  AddPoint(9, -8);
  AddPoint(9, -1);
  SetColor('clMaroon');
  FillPoly;
  
  NewPoly;
  AddPoint(7, -8);
  AddPoint(2, -11);
  AddPoint(5, -15);
  AddPoint(8, -17);
  AddPoint(12, -15);
  AddPoint(15, -11);
  AddPoint(10, -8);
  SetColor('clGreen');
  FillPoly;
end.
