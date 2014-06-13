program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

// Задача Иосифа

var
  n, q, Nq: qword;
  f, fout: textfile;

begin
  assign(f, 'input.txt');
  reset(f);
  read(f, n);
  read(f, q);
  close(f);

  assign(fout, 'output.txt');
  rewrite(fout);

  Nq := n*q;
  while(Nq > n) do Nq := Nq - n + (Nq - n - 1) div (q-1);

  writeln(fout, Nq);
  close(fout);

end.

