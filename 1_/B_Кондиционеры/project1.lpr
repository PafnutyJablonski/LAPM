program project1;

{$mode objfpc}{$H+}{$R+}{$I+}{$Q+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const
  const_1000 = 1000;

var
  n: integer; // количество классов
  m: integer; // кол-во кондов
  i: integer;
  sum: integer;
  KlassPower: array of integer;
  CondPower, CondCost: integer;
  MinCost: array [1..const_1000] of integer;  // в i-той ячейке стоимость конда у которого мощность равна i
  AnswI: array [1..const_1000] of integer;   // в i-той ячейке хранит мин стоимость конда мощность которого >= i
  fin, fout: textfile;
begin
  for i := 1 to const_1000 do MinCost[i] := const_1000 + 1;

  assign(fin, 'cond.in');
  reset(fin);

  read(fin, n);
  setLength(KlassPower, n+1);

  for i := 1 to n do
    read(fin, KlassPower[i]);

  read(fin, m);
  CondPower := 0;
  CondCost := 0;

  for i := 1 to m do begin
    read(fin, CondPower, CondCost);
    if MinCost[CondPower] > CondCost then MinCost[CondPower] := CondCost;
  end;

  AnswI[const_1000] := MinCost[const_1000];
  for i := const_1000 - 1 downto 1 do
    if MinCost[i] < AnswI[i+1] then
      AnswI[i] := MinCost[i]
    else
      AnswI[i] := AnswI[i+1];

  sum := 0;
  for i := 1 to n do sum += AnswI[KlassPower[i]];

  close(fin);
  assign(fout, 'cond.out');
  rewrite(fout);
  writeln(fout, sum);
  close(fout);
end.

