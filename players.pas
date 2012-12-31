unit players;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,cards;

type Tplayer=class
  private
    cards: array of Tcard;
  public
    name: string;
    id: word;
    constructor Create();
    procedure addCard(color: word; cardtype: word);
end;

implementation

procedure Tplayer.addCard(color: word; cardtype: word);
var
 tmpcard: Tcard;
begin
 setLength(cards,length(cards)+1);
 tmpcard.c:=color;
 tmpcard.t:=cardtype;
 cards[length(cards)]:=tmpcard;
end;

constructor TPlayer.Create();
begin

end;

end.

