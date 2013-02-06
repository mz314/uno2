unit game;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils,main_definitions,players,cards,stack, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls;

const
  n_cards=7;
  all_cards=N_N*10+N_FUNCTION+N_BLACK;

type TGameStates=(idle,ai,multi,multi_net);

type TGameState=object
 private
    state_changed: boolean  ;
    state: TGameStates;
    _players: array of Tplayer;
    current_player,human_player: word;
    current_card: Tcard;
    cards_stack: Tstack;
    procedure randomCards(var p: Tplayer);
    procedure initStack();
 public
    mainForm: Pointer;
    constructor Create();
    procedure addPlayer(name: string; ai: boolean);
    procedure nextPlayer;
    function drawCard() : Tcard;
    function peekCard() : Pcard;
    procedure setCard(card: Tcard);  //ustawia aktualną kartę
    function putCard(card: TCard) : boolean; //gdy gracz kładzie wyrzuca kartę na stos; false gdy karta jest zła
    procedure playerDraw(n: integer);
    function getCurrentPlayer() : Tplayer;
    function getHumanPlayer() : Tplayer;
    function getState() : TGameStates;
    procedure aiMove;
    function getPlayers() : Aplayer;
    function stateChanged() : boolean;
    procedure setState(newstate: TGameStates);
end;

type PGameState=^TGameState;

implementation

procedure TGameState.aiMove;
var
  aiplayer: TPlayer;
  cards: TCards;
  i: integer;
begin
 aiplayer:=_players[current_player];
 i:=0;
 while (i<length(cards)) and (not putCard(cards[i]))   do
  inc(i);
 if i=length(cards) then playerDraw(1);
 nextPlayer;
end;

procedure TGameState.playerDraw(n: integer);
var
  i: integer;
  c: TCard;
begin
 for i:=1 to n do
 begin
//  showmessage(inttostr(current_player));
  c:=cards_stack.pop();
  _players[current_player].addCard(c.c,c.t);
 end;
end;

function TGameState.putCard(card: TCard) : boolean;
begin
 if (card.t=current_card.t) or (card.c=current_card.c) then
 begin
   current_card:=card;
   //showmessage(_players[current_player].name);
   _players[current_player].removeCard(card.c,card.t);
   putCard:=true;
 end else putCard:=false;
end;

procedure TGameState.setCard(card: Tcard);
begin
  current_card:=card;
end;

procedure TGameState.nextPlayer;
var
   f: TmainWindowInterface;
begin
 f:=TmainWindowInterface(mainForm);
 if current_player<length(_players)-1 then
  inc(current_player)
  else current_player:=0;
 f.nextMove;
end;

function TGameState.getPlayers() : Aplayer;
begin
 getPlayers:=_players;
end;

function TGameState.peekCard() : Pcard;
begin
 peekCard:=@current_card;
end;

function TGameState.drawCard() : Tcard;
begin
 current_card:=cards_stack.pop();
 drawCard:=current_card;
end;

procedure TGameState.initStack();
var
 i,c: word;
 tmpcard: Tcard;
begin
 for c:=1 to 4 do
 begin
  for i:=1 to N_TYPES do
  begin
   tmpcard.t:=i;
   tmpcard.c:=c;
   cards_stack.push(tmpcard);
  end;
 end;
 cards_stack.shuffle;
end;

function TGameState.getCurrentPlayer() : Tplayer;
begin
  getCurrentPlayer:=_players[current_player];
  //inc(current_player);
end;

function TGameState.getHumanPlayer() : Tplayer;
begin
 getHumanPlayer:=_players[human_player];
end;

constructor TGameState.Create();
begin
 current_player:=0;
 self.state_changed:=false;
 self.state:=idle;
 self.cards_stack.create();
 self.initStack();
 current_card:=cards_stack.pop;
end;


procedure TGameState.setState(newstate: TGameStates)    ;
begin
 self.state:=newstate;
 self.state_changed:=true;
 if newstate<>idle then
 begin
   current_player:=0;
 end;

end;

function TGameState.stateChanged() : boolean;
begin
  stateChanged:=self.state_changed;
  self.state_changed:=False;
end;

function TGameState.getState() : TGameStates;
begin
  getState:=self.state;
end;

procedure TgameState.randomCards(var p: Tplayer);
var
 tmpCard: Tcard;
 t,c,i: word;
begin

 for i:=1 to n_cards do
 begin
  tmpCard:=cards_stack.pop();

 //tmpCard.t:=cardtype_array[t];
// tmpCard.c:=CG;
 p.addCard(tmpCard.c,tmpCard.t);
 end;
end;

procedure TgameState.addPlayer(name: string; ai: boolean);
var
  tmpPlayer: Tplayer;
begin
 // showmessage('randomCards');
 tmpPlayer.name:=name;
  tmpPlayer.id:=length(_players);
  tmpPlayer.ai:=ai;
  if not ai then human_player:=tmpPlayer.id;
  setLength(_players,length(_players)+1);
  self.randomCards(tmpPlayer);
  _players[length(_players)-1]:=tmpPlayer;
end;

end.

