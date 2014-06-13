program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

var
  Left, Right: array of integer;
  fin, fout: textfile;
  n, i, temp: integer;

procedure swap (var a, b: integer);
var
  c: integer;
begin
  c := a;
  a := b;
  b := c;
end;

{ где i индекс эл-та на котором нарушается ОСК }
procedure heapify(var Heap: array of integer; i: integer);
var
  Largest, L, R: integer;
begin
  Largest := i;
  while i*2 <= Heap[0] do begin
    L := i*2;
    R := i*2 + 1;
    Largest := i;
    if (L <= Heap[0]) and (Heap[L] > Heap[Largest]) then
      Largest := L;
    if (R <= Heap[0]) and (Heap[R] > Heap[Largest]) then
      Largest := R;
    if Largest = i then break;
    swap(Heap[i], Heap[Largest]);
    i := Largest;
  end;
end;

procedure AddToHeap(var Heap: array of integer; data: integer);
var
  temp: integer;
begin
  inc(Heap[0]);
  Heap[Heap[0]] := data;
  temp := Heap[0];
  while (temp > 1) and (Heap[temp] > Heap[temp div 2]) do begin
    swap(Heap[temp], Heap[temp div 2]);
    temp := temp div 2;
  end;
end;

procedure DelFromHeap(var Heap: array of integer; i: integer);
begin
  swap(Heap[Heap[0]], Heap[i]);
  dec(Heap[0]);
  heapify(Heap, i);
end;

procedure HeapBalancing();
begin
  if abs(Left[0] - Right[0]) < 2 then exit;
  if Left[0] > Right[0] then begin
    AddToHeap(Right, -Left[1]);
    DelFromHeap(Left, 1);
  end else begin
    AddToHeap(Left, -Right[1]);
    DelFromHeap(Right, 1);
  end;
end;

begin
  assign(fin, 'input.txt');
  assign(fout, 'output.txt');
  reset(fin);
  rewrite(fout);
  read(fin, n);
  setLength(Left, n+2);
  setLength(Right, n+2);
  //will store size of heap in the head of array
  Left[0] := 0;
  Right[0] := 0;

  read(fin, temp);
  AddToHeap(Left, temp);
  write(fout, Left[1], ' ');

  for i := 2 to n do begin
    read(fin, temp);
    if temp <= Left[1] then AddToHeap(Left, temp) else
      AddToHeap(Right, -temp);
    HeapBalancing();
    if Left[0] >= Right[0] then
      write(fout, Left[1], ' ')
    else
      write(fout, -Right[1], ' ');
  end;
  close(fin);
  close(fout);

  ////////////////////
  //writeln;
  //for i := 1 to Right[0] do write(Right[i], ' ');
  //writeln;
  //for i := 1 to Left[0] do write(Left[i], ' ');
  //readln;
  ////////////////////

end.

