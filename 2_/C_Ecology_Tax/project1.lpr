program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes { you can add units after this };

var
  N, L, current, best, answer, j, i: integer;
  fin, fout: textfile;
  A: array [0..30000] of integer;

begin
  assign(fin, 'input.txt');
  reset(fin);
  read(fin, N, L);

  for j := 1 to N do
  begin
    read(fin, i);
    inc(A[i mod L]);
    current += i mod L;
  end;
  close(fin);

  answer := 0;
  best := current;
  for j := 1 to L-1 do
  begin
    current += N - L * A[L - j];
    if current < best then
    begin
      answer := j;
      best := current;
    end;
  end;

  assign(fout, 'output.txt');
  rewrite(fout);
  writeln(fout, answer);
  close(fout);
end.

