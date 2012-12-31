unit stack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,cards,Dialogs;

type Tstack=class
 private
   data: array of Tcard;
   i: integer;
 public
    procedure init;
    procedure push(card: Tcard);
    function pop() : Tcard;

end;

implementation

procedure Tstack.init;
begin
  //showmessage('c');
  //ssetLength(data,0);
  self.i:=0;
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

