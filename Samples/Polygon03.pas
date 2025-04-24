program pixel;

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

procedure FillPoly;
var
  line: TLine;
  ir, ln, i, j, scanY, temp: Integer;
  interX: array[1..MAX_POINTS] of Integer;
begin
  EndLine(lines[1].p1.x, lines[1].p1.y, lines[countP]);
  
  for scanY := minY to maxY - 1
  do begin
       ir := 0;
       
       for ln := 1 to countP
       do begin
       
            line := lines[ln];
            
            if line.p1.y = line.p2.y
            then continue;
            
            if (scanY >= MinI(line.p1.y, line.p2.y)) and (scanY <= MaxI(line.p1.y, line.p2.y))
            then begin
                   
                   Inc(ir);
                   interX[ir] := Trunc(
                     (scanY + 0.5 - line.p1.y)
                     * (line.p2.x - line.p1.x)
                     / (line.p2.y - line.p1.y)
                     + line.p1.x
                   );
                   
                   for i := ir downto 2
                   do begin
                        if (interX[i] < interX[i - 1])
                        then begin
                               temp := interX[i];
                               interX[i] := interX[i - 1];
                               interX[i - 1] := temp;
                             end;
                      end; 
                 
                 end;       
       
          end;
         
       for i := 1 to ir div 2
       do begin
            for j := interX[i * 2 - 1] to interX[i * 2] - 1
            do begin
                 plot(j, scanY);
               end;
          end;
                    
   end
end;

begin
  NewPoly;
  AddPoint(2, 1);
  AddPoint(16, 1);
  AddPoint(16, 14);
  AddPoint(10, 6);
  AddPoint(2, 18);
  FillPoly;             
end.
