unit players;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,cards, Dialogs;

type Tplayer=object   //WARNING: Object -> dobrze, Class -> SIGSEGV
  private

  public
    cards: Tcards;
    name: string;
    id: word;
    ai,off: boolean;

    constructor Create();
    procedure addCard(color: word; cardtype: word);
    procedure removeCard(c: integer;t: integer); //wyszukuje i usuwa kartę
    function getCards() :  Tcards;
    function countCards : integer;
end;

type APlayer=array of Tplayer;

implementation

function TPlayer.countCards : integer;
begin
 countCards:=length(cards);
end;

procedure TPlayer.removeCard(c: integer; t: integer);
var
 i,n: integer;
begin
 i:=0;
 while (cards[i].c<>c) or (cards[i].t<>t)  do
  inc(i);
 for n:=i+1 to length(cards)-1 do
  cards[n-1]:=cards[n];
 setLength(cards,length(cards)-1);
 //karta powinna wracać na stos
end;

function Tplayer.getCards() : Tcards;
begin
 getCards:=cards;
end;

procedure Tplayer.addCard(color: word; cardtype: word);
var
 tmpcard: Tcard;
begin
 setLength(cards,length(cards)+1);
 tmpcard.c:=color;
 //tmpcard.c:=CY;
 tmpcard.t:=cardtype;
 cards[length(cards)-1]:=tmpcard;
end;

constructor TPlayer.Create();
begin
 off:=false;
end;

end.

