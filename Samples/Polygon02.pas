program pixel;

const
  MAX_X = 20;
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
         StartLine(x, y, lines[countP]);
       end
  else begin 
         EndLine(x, y, lines[countP - 1]);
         StartLine(x, y, lines[countP]);
       end;
end;

procedure FillPoly;
var
  koef: Double;
  x1, y1, x2, y2: Integer;
  i, x, y, begx: Integer;
begin
  EndLine(lines[1].p1.x, lines[1].p1.y, lines[countP]);

  for i := 1 to countP
  do begin
       // invertuje se desno od ivica
       // horizontalne linije ignorisemo
       if lines[i].p1.y = lines[i].p2.y
       then continue;
         
       if lines[i].p1.y < lines[i].p2.y
       then begin
              x1 := lines[i].p1.x;
              y1 := lines[i].p1.y;
              x2 := lines[i].p2.x;
              y2 := lines[i].p2.y;
            end
       else begin
              x1 := lines[i].p2.x;
              y1 := lines[i].p2.y;
              x2 := lines[i].p1.x;
              y2 := lines[i].p1.y;
            end;
            
       koef := Double(x2 - x1) / (y2 - y1);
                       
       for y := y1 to y2 - 1
       do begin
            begx := Trunc((y - y1) * koef + x1);
            for x := begx to MAX_X
            do begin
                 Invert(x, y);
               end;
          end;
          
     end;
end;
   
begin
  NewPoly;
  AddPoint(13, -19);
  AddPoint(15, -19);
  AddPoint(15, -15);
  AddPoint(19, -15);
  AddPoint(15, -13);
  AddPoint(19, -9);
  AddPoint(14, -11);
  AddPoint(9, -9);
  AddPoint(13, -13);
  AddPoint(9, -15);
  AddPoint(13, -15)
  SetColor('clYellow');
  FillPoly;
  
  NewPoly;
  AddPoint(7, 4);
  AddPoint(13, -3);
  AddPoint(18, 4);
  SetColor('clRed');
  FillPoly;

  NewPoly;
  AddPoint(7, 4);
  AddPoint(18, 4);
  AddPoint(18, 6);
  AddPoint(14, 6);
  AddPoint(14, 9);
  AddPoint(11, 9);
  AddPoint(11, 6);
  AddPoint(7, 6);
  SetColor('clLime');
  FillPoly;
end.
