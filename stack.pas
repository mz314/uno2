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
    procedure clear;

end;

type PStack=^TStack;

implementation

procedure Tstack.clear;
begin
 setLength(data,0);
end;

function Tstack.stackCount : word;
begin
 stackCount:=length(data);
end;

procedure Tstack.shuffle;
var
 tmp: Tcard;
 n,ri: integer;
begin
 for n:=0 to length(data)-1 do
  begin
    if(data[n].t=0) and (data[n].c=0) then
     showmessage('Bląd w stosie!');
   ri:=random(length(data)-1);
   tmp:=data[ri];
   data[ri]:=data[n];
   data[n]:=tmp;
  end;
end;

constructor Tstack.create;
begin
  setLength(data,0);
  i:=0;
end;

procedure Tstack.push(card: Tcard);
begin

 setLength(data,length(data)+1);
 data[length(data)-1]:=card;
end;

function Tstack.pop() : Tcard;
begin
 if(length(data)>0) then
 begin
    i:=i-1;
  pop:=data[length(data)-1];
  setLength(data,length(data)-1);
 end;
end;

end.

