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
    current_player,human_player,off_players: word;
    current_card: Tcard;
    cards_stack: Tstack;
    forward_dir: boolean;
    reqSkip: boolean;
    reqColor,reqCount: integer; // -1 dla braku
    lastput: TCard; //ostatnio polożona karta
    procedure randomCards(p: word; debug: boolean);
    procedure initStack();
 public
    mainForm: Pointer;
    constructor Create();
    procedure addPlayer(name: string; ai: boolean);
    procedure nextPlayer;
    procedure iteratePlayer;  // powiększa licznik do następnego gracza
    function getSkip : boolean;  // sprawdza czy poprzednia karta nie opuszcza gracza
    function getColor : integer; // sprawdza, czy poprzedni gracz nie wybral koloru
    procedure setColor(i: integer); // ustawia kolor
    function drawCard() : Tcard;
    procedure incrementCards(n: integer);
    function peekCard() : Pcard;
    procedure setCard(card: Tcard);  //ustawia aktualną kartę
    function putCard(card: TCard) : boolean; //gdy gracz kładzie wyrzuca kartę na stos; false gdy karta jest zła
    procedure playerDraw(n: integer);
    function getCurrentPlayer() : Tplayer;
    function peekNextPlayer : integer;
    function getHumanPlayer() : Tplayer;
    function getState() : TGameStates;
    procedure aiMove;
    function getPlayers() : Aplayer;
    function stateChanged() : boolean;
    procedure setState(newstate: TGameStates);
end;

type PGameState=^TGameState;

implementation

procedure TGameState.setColor(i: integer);
begin
 reqColor:=i;
end;

function TgameState.getSkip : boolean;
begin
 getSkip:=reqSkip;
 reqSkip:=false;
end;

function TGameState.getColor : integer;
begin
 getColor:=reqColor;
 //reqColor:=-1;
end;

procedure TGameState.aiMove;
var
  aiplayer: TPlayer;
  cards: TCards;
  i,n: integer;
begin
 aiplayer:=_players[current_player];
 i:=0;
 cards:=_players[current_player].getCards;
 n:=length(cards);
 while (i<n) and (not putCard(cards[i]))   do
  inc(i);
 if i=n then
 begin
   playerDraw(1);
 end else
 begin
  if (lastput.t=WILD) or (lastput.t=DRAWFOURWIRD) then
    begin setColor(1+random(3)); end
 end;
 nextPlayer;
end;

procedure TGameState.playerDraw(n: integer);
var
  i: integer;
  c: TCard;
begin
 if reqCount=0 then
 begin
  for i:=1 to n do
  begin
   c:=cards_stack.pop();
   _players[current_player].addCard(c.c,c.t);
  end;
 end else
 begin
  incrementCards(reqCount);
  reqCount:=0;
 end;
end;

function TGameState.peekNextPlayer : integer;
var
  tmp_current,save_current: integer;
begin
 save_current:=current_player;
 iteratePlayer;
 tmp_current:=current_player;
 current_player:=save_current;
 peekNextPlayer:=tmp_current;
end;

procedure TGameState.incrementCards(n: integer);
var
  i: integer;
  tmpcard: TCard;
begin
 for i:=1 to n do
 begin
    tmpcard:=cards_stack.pop;
   _players[peekNextPlayer].addCard(tmpcard.c,tmpcard.t);
 end;
end;

function TGameState.putCard(card: TCard) : boolean;
var
  color_ok: boolean;
  tmpcard,before: TCard;
begin
 color_ok:=false;
 if (reqcolor<1) and (current_card.c=card.c) then color_ok:=true
 else begin
 if card.c=reqColor then color_ok:=true;
end;
  {if (reqCount>0) and ((card.t<>DRAWFOURWIRD) or (card.t<>DRAW2))then
   begin
    // reqFour:=false;
     reqCount:=0;
     incrementCards(reqCount);
   end else }
 if ((card.t=current_card.t) or (color_ok) or (card.t=WILD) or
    (card.t=DRAWFOURWIRD)) and ((reqCount=0) or (current_card.t=DRAW2) or (current_card.t=DRAWFOURWIRD)) then
 begin
   lastput:=card;
 //  before=current_card;
   current_card:=card;
   _players[current_player].removeCard(card.c,card.t,@cards_stack);
   cards_stack.push(card);
   cards_stack.shuffle;

   //if card.t=DRAWFOURWIRD then
   // reqFour:=true
   //else reqFour:=false;
   if card.t=REVERSE then
    forward_dir:=not forward_dir;
   if current_card.t=DRAWFOURWIRD then
   begin
    showmessage('+4');
    reqCount:=reqCount+4;
   end;
   if current_card.t=DRAW2 then     //trzeba sprawdzać, czy następny nie ma +2
   begin
    { tmpcard:=cards_stack.pop;
     _players[peekNextPlayer].addCard(tmpcard.c,tmpcard.t);
     tmpcard:=cards_stack.pop;
     _players[peekNextPlayer].addCard(tmpcard.c,tmpcard.t) ;}
   showmessage('+2');
   reqCount:=reqCount+2;
   end;
   if card.t=SKIP then
    reqSkip:=true;
   putCard:=true;
   if (reqColor>0) then
    reqColor:=-1;
 end else putCard:=false;
end;

procedure TGameState.setCard(card: Tcard);
begin
  current_card:=card;
end;

procedure TGameState.iteratePlayer;
begin
 if off_players<length(_players)-1 then
 begin
 if forward_dir then
 begin
 if current_player<length(_players)-1 then
  inc(current_player)
  else current_player:=0;
 end else
 begin
   if current_player>0 then
    dec(current_player)
   else
    current_player:=length(_players)-1;
 end;
 if _players[current_player].off then iteratePlayer;
 end;
end;

procedure TGameState.nextPlayer;
var
   f: TmainWindowInterface;
begin
 f:=TmainWindowInterface(mainForm);
 if _players[current_player].countCards=0 then
 begin
  _players[current_player].off:=true;
  inc(off_players);
 end;
 iteratePlayer;
 if getSkip then
 begin
   iteratePlayer;
 end;
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
var
 ok: boolean;
begin
 off_players:=0;
 current_player:=0;
 self.state_changed:=false;
 self.state:=idle;
 self.cards_stack.create();
 self.initStack();
 forward_dir:=true;
 ok:=true;
 repeat
  current_card:=cards_stack.pop;
  if (current_card.t=WILD) or (current_card.t=DRAWFOURWIRD) or (current_card.t=SKIP) or (current_card.t=DRAW2) then
  begin
   ok:=false;
   cards_stack.push(current_card);
   cards_stack.shuffle;
  end else ok:=true;
 until ok;
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

procedure TgameState.randomCards(p: word; debug: boolean);
var
 tmpCard: Tcard;
 t,c,i: word;
begin
 for i:=1 to n_cards do
 begin
  tmpCard:=cards_stack.pop();
  //if(not _players[p].ai) then
  // showmessage(inttostr(tmpCard.t));
  _players[p].addCard(tmpCard.c,tmpCard.t);
 end;
end;

procedure TgameState.addPlayer(name: string; ai: boolean);
var
  tmpPlayer: Tplayer;
begin
  tmpPlayer.Create;
  tmpPlayer.name:=name;
  tmpPlayer.id:=length(_players);
  tmpPlayer.ai:=ai;
  if not ai then human_player:=tmpPlayer.id;
  setLength(_players,length(_players)+1);
  _players[length(_players)-1]:=tmpPlayer;
{  if length(_players)=5 then
   self.randomCards(length(_players)-1,true)
  else} self.randomCards(length(_players)-1,false);

end;

end.

