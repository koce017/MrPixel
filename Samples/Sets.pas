program pixel;
type
  TDays = (Mon, Tue, Wed, Thu, Fri, Sat, Sun);
var
  I: Integer;
  Weekend: Set of TDays;
  Days: Array[0..3] of TDays;
begin
  Weekend := [Sat, Sun];
  Days[0] := Mon;
  Days[1] := Sat;
  Days[2] := Thu;
  Days[3] := Sun;
  for I := 0 to 3 do
    if Days[I] in Weekend then
      WriteLn('Yaaaay!')
    else
      WriteLn('Naaaay!')
end.