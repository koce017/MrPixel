program pixel;
//{$DEFINE DARK}
var
  color: string;
  X, Y: integer;
begin
  {$IFNDEF DARK}
    color := 'clLime';
  {$ELSE}
    color := 'clBlack';
  {$ENDIF}

  for Y := -5 to 4 do
    for X := -5 to 4 do
      begin
        SetColor(color);
        Plot(X, Y);
      end;
end.
