unit game;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils,main_definitions,players,cards;

const
  n_cards=7;

type TGameStates=(idle,ai,multi,multi_net);

type TGameState=object
 private
    state_changed: boolean  ;
    state: TGameStates;
    _players: array of Tplayer;
    procedure randomCards(var p: Tplayer);
 public
    constructor Create();
    procedure addPlayer(name: string);
    function getState() : TGameStates;
    function stateChanged() : boolean;
    procedure setState(newstate: TGameStates);
end;

type PGameState=^TGameState;

implementation

constructor TGameState.Create();
begin
 self.state_changed:=false;
 self.state:=idle;
end;


procedure TGameState.setState(newstate: TGameStates)    ;
begin
 self.state:=newstate;
 self.state_changed:=true;
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
 t:=random(13);
 c:=random(4);
 tmpCard.t:=cardtype_array[t];
 tmpCard.c:=cardcolor_array[c];
 p.addCard(tmpCard.c,tmpCard.t);
 end;
end;

procedure TgameState.addPlayer(name: string);
var
  tmpPlayer: Tplayer;
begin
  tmpPlayer.name:=name;
  tmpPlayer.id:=length(_players);
  setLength(_players,length(_players)+1);
  self.randomCards(tmpPlayer);
end;

end.

