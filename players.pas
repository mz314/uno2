unit players;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,cards;

type Tplayer=object   //WARNING: Object -> dobrze, Class -> SIGSEGV
  private
    cards: Tcards;
  public
    name: string;
    id: word;
    constructor Create();
    procedure addCard(color: word; cardtype: word);
    function getCards() :  Tcards;
end;

implementation

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
 tmpcard.t:=cardtype;
 cards[length(cards)-1]:=tmpcard;
end;

constructor TPlayer.Create();
begin

end;

end.

