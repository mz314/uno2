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
    current_player: word;
    current_card: Tcard;
    cards_stack: Tstack;
    procedure randomCards(var p: Tplayer);
    procedure initStack();
 public
    constructor Create();
    procedure addPlayer(name: string);
    function drawCard() : Tcard;
    function peekCard() : Tcard;
    function getCurrentPlayer() : Tplayer;
    function getState() : TGameStates;
    function stateChanged() : boolean;
    procedure setState(newstate: TGameStates);
end;

type PGameState=^TGameState;

implementation

function TGameState.peekCard() : Tcard;
begin
 peekCard:=current_card;
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
  inc(current_player);
end;

constructor TGameState.Create();
begin
 current_player:=0;
 self.state_changed:=false;
 self.state:=idle;
 self.cards_stack.create();
 self.initStack();
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

procedure TgameState.addPlayer(name: string);
var
  tmpPlayer: Tplayer;
begin
 // showmessage('randomCards');
 tmpPlayer.name:=name;
  tmpPlayer.id:=length(_players);
  setLength(_players,length(_players)+1);
  self.randomCards(tmpPlayer);
  _players[length(_players)-1]:=tmpPlayer;
end;

end.

