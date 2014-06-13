program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

type
  Pelem = ^Telem;
  Telem = record
    data: integer;
    next: Pelem;
  end;

var
  fin, fout: textfile;
  N, M, i, a, b, v, temp: integer;
  PARRAY: array of Pelem;
  Cycle, Stack, Degree: array of integer;
  EulerGraph: boolean;

//список на основе курсоров
function List_create(data: integer): Pelem;
var
  new_elem: Pelem;
begin
  new(new_elem);
  new_elem^.data := data;
  Result := new_elem;
end;
procedure List_insert(var head: Pelem; data: integer);
var
  new_elem: Pelem;
begin
  new(new_elem);
  new_elem^.data := data;
  new_elem^.next := head^.next;
  head^.next := new_elem;
end;
function List_delete(head: Pelem; data: integer): Pelem;
var
  prev, new_head: Pelem;
begin
  new_head := head;
  if head^.data = data then begin
    new_head := head^.next;
    dispose(head);
    Result := new_head;
    exit;
  end;
  while head^.data <> data do begin
    prev := head;
    head := head^.next;
    if head = nil then break;
  end;
  if head <> nil then begin
    prev^.next := head^.next;
    dispose(head);
  end;
  Result := new_head;
end;
procedure Show_list(i: integer);
var
  temp: Pelem;
begin
  if PARRAY[i] = nil then Exit;
  temp := PARRAY[i];
  while temp <> nil do begin
    write(temp^.data, ' --> ');
    temp := temp^.next;
  end;
  writeln;
end;

//стек на основе массива
procedure Stack_add(data: integer);
begin
  setLength(Stack, length(Stack)+1);
  Stack[high(Stack)] := data;
end;
procedure Stack_get(var a: integer);
begin
  a := Stack[high(Stack)];
end;
procedure Stack_del;
begin
  setLength(Stack, length(Stack)-1);
end;

procedure addNeighbour(u, v: integer);
begin
  if PARRAY[u] = nil then
    //если такой вершины не было, создаем
    PARRAY[u] := List_create(v)
  else
    //а если была, добавляем ей в список нового соседа
    List_insert(PARRAY[u], v);
  //степень
  inc(Degree[u]);
end;

begin
  assign(fin, 'input.txt');
  reset(fin);
  readln(fin, N, M);
  setLength(PARRAY, N+1);
  setLength(Degree, N+1);

  //инициализируем
  for i := 0 to N do
    Degree[i] := 0;
  for i := 1 to M do begin
    readln(fin, a, b);
    addNeighbour(a, b);
    addNeighbour(b, a);
  end;
  close(fin);
  Stack_add(1);
  //
  while length(Stack) <> 0 do begin
    Stack_get(v);
    if PARRAY[v] = nil then begin
      //бежим по вершинам
      setLength(Cycle, length(Cycle)+1);
      Cycle[high(Cycle)] := v;
      Stack_del;
    end else begin
      //добавляем вершину
      temp := PARRAY[v]^.data;
      PARRAY[v] := List_delete(PARRAY[v], PARRAY[v]^.data);
      PARRAY[temp] := List_delete(PARRAY[temp], v);
      Stack_add(temp);
    end;
  end;

  //предпологаем, что граф эйлеровый
  EulerGraph := True;
  for i := 0 to N do
    if Degree[i] and 1 = 1 then begin
      EulerGraph := False;
      break;
    end;

  assign(fout, 'output.txt');
  rewrite(fout);

  //если вернулись обратно и граф эйлеровый, то все хорошо
  if EulerGraph and (Cycle[high(Cycle)] = Cycle[0]) then
    for i := 0 to high(Cycle) do
      write(fout, Cycle[i], ' ')
  else
    write(fout, '-1');

  close(fout);
end.
