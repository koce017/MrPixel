function Int(X: Double): Integer;
begin
    Result := Trunc(X);
end;

function Ceil(X: Double): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) > 0 then
    Inc(Result);
end;

function Floor(X: Double): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) < 0 then
    Dec(Result);
end;

function IfThenInt(AValue: Boolean; ATrue: Integer; AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThenDbl(AValue: Boolean; ATrue: Double; AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function MinInt(A, B: Integer): Integer;
begin
  Result := IfThenInt(A < B, A, B);
end;

function MinDbl(A, B: Double): Double;
begin
  Result := IfThenDbl(A < B, A, B);
end;

function MaxInt(A, B: Integer): Integer;
begin
  Result := IfThenInt(A > B, A, B);
end;

function MaxDbl(A, B: Double): Double;
begin
  Result := IfThenDbl(A > B, A, B);
end;

function SignInt(AValue: Integer): Integer;
begin
  Result := 0;
  if AValue < 0 then
    Result := -1
  else if AValue > 0 then
    Result := 1;
end;

function SignDbl(AValue: Double): Integer;
begin
  Result := 0;
  if AValue < 0 then
    Result := -1
  else if AValue > 0 then
    Result := 1;
end;

procedure SwapInt(var A, B: Integer);
var
  T: Integer;
begin
  T := A;
  A := B;
  B := T;
end;

procedure SwapDbl(var A, B: Double);
var
  T: Double;
begin
  T := A;
  A := B;
  B := T;
end;

function InRangeInt(AValue, AMin, AMax: Integer): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

function InRangeDbl(AValue, AMin, AMax: Double): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

function EnsureRangeInt(AValue, AMin, AMax: Integer): Integer;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function EnsureRangeDbl(AValue, AMin, AMax: Double): Double;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function MinElemInt(Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function MinElemDbl(Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function MaxElemInt(Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function MaxElemDbl(Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

// A = B  -> True
// A <> B -> False
function SameValue(const A, B: Double): Boolean;
var
  Epsilon: Double;
  FUZZ_FACTOR: Integer;
  DOUBLE_RESOLUTION: Double;
begin
  FUZZ_FACTOR := 1000;
  DOUBLE_RESOLUTION := 1E-15 * FUZZ_FACTOR;
  Epsilon := MaxDbl(MinDbl(Abs(A), Abs(B)) * DOUBLE_RESOLUTION, DOUBLE_RESOLUTION);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

// A < B -> -1
// A = B ->  0
// A > B ->  1
function CompareValue(const A, B: Double): Integer;
begin
  if SameValue(A, B) then
    Result := 0
  else if A < B then
    Result := -1
  else
    Result := 1;
end;