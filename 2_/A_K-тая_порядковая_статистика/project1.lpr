program project1;

{$mode objfpc}{$H+}{$R+}{$I+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

type
  TArray = array of integer;
var
  fin, fout: textfile;
  Q, V: integer;
  P, N, K: integer;
  A: array of integer;
  i: integer;

procedure swap(var a, b: integer);
var
  temp: integer;
begin
  temp := a;
  a := b;
  b := temp;
end;

function partition(var Z: TArray; P, R: integer): integer;
var
  i, j, x: integer;
begin
  swap(Z[(R+P) div 2], Z[R]);
  i := P - 1;
  x := Z[R];
  for j := P to R-1 do
    if Z[j] <= x then begin
     inc(i);
     swap(Z[i], Z[j]);
    end;
  swap(Z[i+1], Z[R]);
  Result := i+1;
end;

function select(var A: TArray; P, R, i: integer): integer;
var
  q: integer;
begin
  if P = R then begin
    Result := A[P];
    exit;
  end;
  q := partition(A, P, R);
  if q = i then Result := A[i]
    else if i < q then Result := select(A, P, q-1, i)
      else Result := select(A, q+1, R, i);
end;

begin
  assign(fin, 'input.txt');
  reset(fin);
  read(fin, Q, V, P, N, K);
  close(fin);

  SetLength(A, N);
  A[0] := P;
  for i := 1 to N-1 do
   A[i] := (A[i-1] * Q) mod V;

  ////////////////////
  //for i := 0 to N-1 do
  //  write(A[i], ' ');  writeln;

  assign(fout, 'output.txt');
  rewrite(fout);
  writeln(fout, select(A, 0, N-1, K-1));
  close(fout);

  ////////////////////
  //for i := 0 to N-1 do
  //  write(A[i], ' '); writeln;
  //writeln(select2(0, N-1, K));
  //readln;
end.

