program project1;

{$mode objfpc}{$H+}{$R+}{$I+}{$M+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

type
  IntArr = array of integer;

function kmp_prefix(P: string): IntArr;
var
  m, k, q: integer;
  pref: IntArr;
begin
  m := length(P);
  setLength(pref, m+1);
  pref[1] := 0;
  k := 0;
  for q := 2 to m do begin
    while (k > 0) and (P[k+1] <> P[q]) do
      k := pref[k];
    if (P[k+1] = P[q]) then inc(k);
    pref[q] := k;
  end;
  Result := pref;
end;

function kmp(T,P: string): integer;
var
  m, n, q, i: integer;
  pref: IntArr;
begin
  n := length(T);
  m := length(P);
  pref := kmp_prefix(P);
  q := 0;
  for i := 1 to n do begin
    while (q > 0) and (P[q+1] <> T[i]) do
      q := pref[q];
    if P[q+1] = T[i] then inc(q);
    if q = m then begin
      writeln('Sdvig = ', i - m);
      q := pref[q];
    end;
  end;
  Result := q;
end;


procedure swap(var a, b: char);
var t: char;
begin
  t := b; b := a; a := t;
end;

function reverse(str: string): string;
var
  i, L: integer;
begin
  L := length(str);
  for i := 1 to L div 2 do
    swap(str[i], str[L-i+1]);
  Result := str;
end;

function isPal(P: string): boolean;
var
  i, L: integer;
begin
  L := length(P);
  for i := 1 to L div 2 do
    if P[i] <> P[L-i+1] then begin
      Result := False;
      exit;
    end;
  Result := True;
end;

var
  T, P: string;
  q: integer;
  fin, fout: textfile;

begin
  assign(fin, 'input.txt');
  assign(fout, 'output.txt');
  reset(fin);
  rewrite(fout);

  readln(fin, T);
  if isPal(T) then begin
    writeln(fout, '');
    exit;
  end;

  P := reverse(T);
  q := kmp(T, P);
  T := copy(P, q+1, length(P)-q);

  writeln(fout, T);
  close(fin);
  close(fout);
end.

