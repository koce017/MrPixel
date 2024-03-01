program pixel;
//{$DEFINE DARK}
var
  X, Y: Integer;
begin
  for Y := -5 to 5 do
    for X := -5 to 5 do
      begin
        SetColor({$IFNDEF DARK}'clLime'{$ELSE}'clBlack'{$ENDIF});
        Plot(X, Y);
      end;
end.
