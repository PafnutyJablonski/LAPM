program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const
  size = 1000000;

var
  A: array [0..size] of integer;
  fin, fout: textfile;
  temp, i: integer;

procedure swap(var a, b: integer);
var
  c: integer;
begin
  c := a;
  a := b;
  b := c;
end;


//procedure fs_sort_merge (var A: array of integer);
//var
//  B: array of integer;
//
//  procedure merge_sort(l, r: integer);
//  var
//    i, j, k, q: integer;
//  begin
//    if(l >= r) then exit;
//    q := (l + r) div 2;
//    merge_sort(l, q);
//    merge_sort(q + 1, r);
//
//    k := l;
//    i := l;
//    j := q + 1;
//
//    while(i <= q) or (j <= r) do begin
//      if (j > r) or (i <= q) and (A[i] <= A[j]) then
//      begin
//        B[k] := A[i]; inc(i);
//      end else begin
//        B[k] := A[j]; inc(j);
//      end;
//      inc(k);
//    end;
//    for i:=l to r do A[i] := B[i];
//  end;
//
//begin
//  setLength(B, high(A));
//  Merge_sort(low(A), high(A));
//end;


procedure QS(L, R: integer);
var
  pivot, j, i: integer;
begin
  if L >= R then
    exit;
  pivot := A[random(R - L) + L];
  i := L;
  j := R;
  repeat
    while A[i] < pivot do
      Inc(i);
    while A[j] > pivot do
      Dec(j);
    if (i > j) then
      break;
    swap(A[i], A[j]);
    Inc(i);
    Dec(j);
  until i > j;
  if L < j then QS(L, j);
  if i < R then QS(i, R);
end;

function hash(k, count: integer): dword;
begin
  Result := (k * 7 + 3 * count * count + 5 * count) mod size;
end;

procedure insert(var A: array of integer; k: integer);
var
  count, i: dword;
begin
  count := 0;
  i := hash(k, count);
  while A[i] <> 0 do begin
    if A[i] = k then exit;
    inc(count);
    i := hash(k, count);
  end;
  A[i] := k;
end;

procedure delete(var A: array of integer; k: integer);
var
  count, j, i: dword;
begin
  count := 0;
  i := hash(k, count);
  while (A[i] <> k) and (A[i] <> 0) do begin
    inc(count);
    i := hash(k, count);
  end;
  //если сразу добежали до нуля
  if A[i] = 0 then exit;
  A[i] := -1;
end;

begin
  for temp := 0 to size do A[temp] := 0;

  assign(fin, 'input.txt');
  reset(fin);
  temp := -1;
  while temp <> 0 do begin
    read(fin, temp);
    if temp = 0 then break;
    if temp > 0 then insert(A, temp);
    if temp < 0 then delete(A, -temp);
  end;
  close(fin);

  QS(low(A),high(A));

  assign(fout, 'output.txt');
  rewrite(fout);

  for i := 0 to size do begin
    if (A[i] <> 0) and (A[i] <> -1) then write(fout, A[i], ' ');
  end;

  close(fout);
end.

