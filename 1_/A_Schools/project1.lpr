program project1;

{$mode objfpc}{$H+}{$R+}{$Q+}{$I+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

var
  fin, fout: textfile;
  NMB, ANSW: array of string;
  m, i, j, k, count, totalcounter: integer;
  s, tempstring: string;

procedure swap(var a, b: string);
  var
    temp: string;
  begin
    temp := a;
    a := b;
    b := temp;
  end;

procedure QS(L, R: integer);
  var
    pivot: string;
    j, i: integer;
  begin
    if (L >= R) then
      exit;
    pivot := NMB[random(R - L) + L];
    i := L;
    j := R;
    repeat
      while NMB[i] < pivot do
        Inc(i);
      while NMB[j] > pivot do
        Dec(j);
      if (i > j) then
        break;
      swap(NMB[i], NMB[j]);
      Inc(i);
      Dec(j);
    until i > j;
    if l < j then QS(L, j);
    if i < r then QS(i, R);
  end;

begin
  assign(fin, 'schools.in');
  reset(fin);

  readln(fin, m);
  setLength(NMB, m);

  for k := 0 to m-1 do begin
    readln(fin, s);
    j := 0;

    // Бежим по считанной строке
    for i := 1 to length(s) do begin
      if((s[i] < '0') or (s[i] > '9')) then continue;
      j := i;
      break;
    end;

    tempstring := '';
    while (j <= length(s)) and ((s[j] >= '0') and (s[j] <= '9')) do begin
      tempstring += s[j];
      inc(j);
    end;
    NMB[k] := tempstring;
  end;

  k := m - 1;
  close(fin);
  QS(0, k);

  assign(fout, 'schools.out');
  rewrite(fout);

  count := 0;
  totalcounter := 0;
  setLength(ANSW, m+1);
  for i := 0 to k-1 do begin
    if(NMB[i] <> NMB[i+1]) then begin
      if(count < 5) then begin
          totalcounter += 1;
          ANSW[totalcounter] := NMB[i];
        end;
        count := 0;
    end else count += 1;
  end;

  if(count < 5) then begin
    totalcounter += 1;
    ANSW[totalcounter] := NMB[k];
  end;

  writeln(fout, totalcounter);
  for i := 1 to totalcounter do writeln(fout, ANSW[i]);

  close(fout);
end.
