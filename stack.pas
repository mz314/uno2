unit stack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,cards,Dialogs;

type Tstack=object
 private
   data: array of Tcard;

 public
   i: integer;
constructor create;
    procedure push(card: Tcard);
    procedure shuffle; //miesza karty
    function pop() : Tcard;
    function stackCount : word;

end;

implementation

function Tstack.stackCount : word;
begin
 stackCount:=length(data);
end;

procedure Tstack.shuffle;
var
 tmp: Tcard;
 n,ri: integer;
begin
  for n:=0 to length(data) do
  begin
   ri:=random(length(data));
   tmp:=data[ri];
   data[ri]:=data[n];
   data[n]:=tmp;
  end;
end;

constructor Tstack.create;
begin
  //showmessage('c');
  setLength(data,0);
  i:=0;
end;

procedure Tstack.push(card: Tcard);
begin
 setLength(data,i+1);
 data[i]:=card;
 inc(i);
end;

function Tstack.pop() : Tcard;
begin
 if(length(data)>0) then
 begin
  pop:=data[length(data)-1];
  setLength(data,length(data)-1);
 end;
end;

end.

