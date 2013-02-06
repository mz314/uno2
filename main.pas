unit main;

{$mode objfpc}{$H+}

{$X+} {Turn on extended syntax}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls,
  choose, game,cardsform,main_definitions,cards,players,layout;

type

  { TMainWindow }

  TMainWindow = class(TmainWindowInterface)
    currentCard: TImage;
    GroupBox1: TGroupBox;
    Gracze: TGroupBox;
    players_list: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    newgame: TMenuItem;
    endgame: TMenuItem;
    aiTimer: TTimer;
    procedure aiTimerTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure startGame(player_name: string; players: word); override;
    procedure endgameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure newgameClick(Sender: TObject);
  private
    choose: TGameChoose;
    cards: TcardsWindow;
    procedure showCards; //wyświetla i odświerza karty gracza
    procedure lockCards; //blokuje możliwość gry na czas gry AI
    function cardToImage(c: Tcard) : string; //Przyporządkowuje plik graficzny do karty
    procedure refreshCard; //odświerza kartę

    procedure showPlayerList;
    procedure selectCurrent; //zaznacza bieżącego gracza
    { private declarations }
  public
        procedure nextMove;  override;
    { public declarations }
  end;

var
  MainWindow: TMainWindow;
  gameState: TGameState;

implementation

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.refreshCard;
var
 c: TCard;
 pc: PCard;
begin
   currentCard.picture.loadFromFile(cardToImage(gameState.peekCard^));
   currentCard.tag:=PtrInt(gameState.peekCard);
   currentCard.OnPaint:=@cards.drawNumber;
end;

procedure TMainWindow.showPlayerList;
var
 i,n: integer;
 a: APlayer;
begin
 a:=gameState.getPlayers();
  for i:=0 to length(a) do
   players_list.AddItem(PChar(a[i].name),nil);

end;

procedure TMainWindow.nextMove;
var
  current: TPlayer;
begin
  current:=gameState.getCurrentPlayer();
  //gameState.drawCard();
  //if not current.ai then  //ale będzie problem, jeżeli gra zaczyna się od AI
   showCards()  ;
  if current.ai then
  begin
   aiTimer.enabled:=true;
  end;
  // lockCards;
 // lockCards;
  selectCurrent;
  refreshCard;

end;

procedure TMainWindow.selectCurrent;
var
  current: TPlayer;
begin
 current:=gameState.getCurrentPlayer();
  //current:=gameState.getCurrentPlayer();
 players_list.ItemIndex:=current.id;
end;

function TMainWindow.cardToImage(c: Tcard) : string;
var
  fn: string;
begin
  case c.c of
   CR: fn:='red-empty.jpg';
   CG: fn:='green-empty.jpg';
   CB: fn:='blue-empty.jpg';
   CY: fn:='yellow-empty.jpg';
   else fn:='1-red.jpg';
  end;
  cardToImage:=images_dir+fn;
end;

procedure TMainWindow.newgameClick(Sender: TObject);
begin
    choose.showmodal();
end;

procedure TMainWindow.FormCreate(Sender: TObject);
var
  f: Pointer;
begin
  randomize;
  gameState.Create();
  choose:=TGameChoose.Create(self);
  choose.gameState:=@gameState;
  cards:=TcardsWindow.Create(self);
  cards.gameState:=@gameState;
   f:=self;
   choose.mainForm:=f;
   cards.mainForm:=f;
   gameState.mainForm:=f;
   //p:=@self.startGame;
   aiTimer.Enabled:=false;
end;

procedure TMainWindow.FormPaint(Sender: TObject);
begin

end;

procedure TMainWindow.startGame(player_name: string; players: word);
var
  i: word;
begin
  if (gameState.getState<>idle) then
    begin
        cards.show();
       endgame.enabled:=true;
       newgame.enabled:=false;
       gameState.addPlayer(player_name,false);
       for i:=1 to players do
        begin
         gameState.addPlayer('KOMPUTER_'+inttostr(i),True);

        end;
       showPlayerList;
       nextMove();

    end else
    begin
     // logo.visible:=true;
      endgame.Enabled:=false;
       newgame.enabled:=true;
    end;

end;

procedure TMainWindow.FormClick(Sender: TObject);
begin

end;

procedure TMainWindow.aiTimerTimer(Sender: TObject);
begin
  showmessage('test');
end;

procedure TMainWindow.FormActivate(Sender: TObject);
begin
  //showmessage('test');
 //self.startGame();
end;

procedure TMainWindow.endgameClick(Sender: TObject);
begin
  gameState.setState(idle);
  self.FormActivate(Sender);
end;

procedure TMainWindow.lockCards;
var
  i,n: word;
begin
  n:=length(cards.glyphs);
  for i:=0 to n-1 do
  begin
     cards.glyphs[i].enabled:=false;
  end;
end;

procedure TMainWindow.showCards;
var
  i,g: word;
  cleft: integer;
  player_cards: Tcards;
  current_player: Tplayer;
  p: Pcard;
begin
  {Karty gracza}
  if length(cards.glyphs)>0 then
   begin
   for i:=0 to length(cards.glyphs)-1 do
    begin
     cards.glyphs[i].Destroy();
    end;
   end;
   current_player:=gameState.getHumanPlayer;
//  showmessage(current_player.name);
  player_cards:=current_player.getCards();
  cleft:=if_card_margin_left;
  for i:=0 to length(player_cards)-1 do
   begin
      setLength(cards.glyphs,length(cards.glyphs)+1);
      g:=length(cards.glyphs)-1;
      cards.glyphs[g]:=TImage.Create(cards);
      cards.glyphs[g].picture.LoadFromFile(cardToImage(player_cards[i]));
      cards.glyphs[g].width:=if_card_width;
      cards.glyphs[g].height:=if_card_height;
      cards.glyphs[g].top:=if_card_margin_top;
      cleft:=if_card_margin_left+i*(if_card_space+if_card_width);
      cards.glyphs[g].left:=cleft;
      cards.glyphs[g].parent:=cards;
     p:=@(player_cards[i]);
     player_cards[i]:=p^;
     //if p=nil then showmessage('nil');

     cards.glyphs[g].Tag:=PtrInt(p);
         cards.glyphs[g].OnPaint:=@cards.drawNumber;
      cards.glyphs[g].enabled:=true;
      cards.glyphs[g].OnClick:=@cards.cardClicked;
   end;
end;

end.

