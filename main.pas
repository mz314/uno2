unit main;

{$mode objfpc}{$H+}

{$X+} {Turn on extended syntax}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, ComCtrls,
  choose, game,cardsform,main_definitions,cards,players,layout,colorChoose,
      about,how;
type

  { TMainWindow }

  TMainWindow = class(TmainWindowInterface)
    currentCard: TImage;
    GroupBox1: TGroupBox;
    Gracze: TGroupBox;
    MenuItem5: TMenuItem;
    unotext: TLabel;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    players_list: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    newgame: TMenuItem;
    endgame: TMenuItem;
    aiTimer: TTimer;
    reqColorBox: TShape;
    StatusBar1: TStatusBar;
    procedure aiTimerTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure players_listSelectionChange(Sender: TObject; User: boolean);
    procedure startGame(player_name: string; players: word); override;
    procedure endgameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure newgameClick(Sender: TObject);
  private
    choose: TGameChoose;
    cards: TcardsWindow;
    colorChooseWindow: TColorChoose;
    procedure cleanForm;
    procedure uncleanForm;
    procedure showCards; //wyświetla i odświerza karty gracza
    procedure lockCards(unlock: boolean); //blokuje możliwość gry na czas gry AI
    function cardToImage(c: Tcard) : string; //Przyporządkowuje plik graficzny do karty
    procedure refreshCard; //odświerza kartę
    procedure showColorReq;
    procedure showPlayerList;
    procedure selectCurrent; //zaznacza bieżącego gracza
    { private declarations }
  public
        procedure nextMove;  override;
        procedure endCurrentGame; override;
    { public declarations }
  end;

var
  MainWindow: TMainWindow;
  gameState: TGameState;
  aboutWindow: TAbout;


implementation

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.showColorReq;
var
 lbl: string;
 c: integer;
begin
  c:=gameState.getColor;
  case c of

   CR: begin reqColorBox.visible:=true; reqColorBox.Brush.Color:=clRed; end;
   CG: begin reqColorBox.visible:=true; reqColorBox.Brush.Color:=clGreen; end;
   CB: begin reqColorBox.visible:=true; reqColorBox.Brush.Color:=clBlue; end;
   CY: begin reqColorBox.visible:=true; reqColorBox.Brush.Color:=clYellow; end
   else reqColorBox.visible:=false;
  end;
  //reqColor.caption:=lbl;
end;

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
 pcards: TCards;
 place: string;
begin
 a:=gameState.getPlayers();
 players_list.Clear;
 for i:=0 to length(a)-1 do
   begin
    pcards:=a[i].getCards;
    if length(pcards)>0 then
     players_list.AddItem(PChar(a[i].name)+' ma kart: '+inttostr(length(pcards)),nil)
    else
    begin
     if a[i].place=1 then
       place:='Wygral!'
     else
         place:=inttostr(a[i].place)+' miejsce';
     players_list.AddItem(PChar(a[i].name)+' '+place,nil)
    end;
   end;
end;

procedure TMainWindow.nextMove;
var
  current,human: TPlayer;
begin
  current:=gameState.getCurrentPlayer();
  human:=gameState.getHumanPlayer;
  if (length(human.cards)=0) or (gameState.getFinished) then
  begin
    if (human.place<=1) then
     showmessage('Wygrales!')
    else
     showmessage('Koniec gry.');
    gameState.setState(idle);
    endCurrentGame;
  end else
  begin
  showCards()  ;
  if current.ai then
  begin
   aiTimer.enabled:=true;
    lockCards(false);
  end else
  begin
   aiTimer.enabled:=false;
   lockCards(true);
  end;
  refreshCard;
  showColorReq;
  showPlayerList;
  selectCurrent;
  end;
end;

procedure TMainWindow.selectCurrent;
var
  current: TPlayer;
begin
 current:=gameState.getCurrentPlayer();
 players_list.ItemIndex:=current.id;
end;

function TMainWindow.cardToImage(c: Tcard) : string;
var
  fn: string;
begin
  if c.t<=13 then
  begin
  case c.c of
   CR: fn:='red-empty.jpg';
   CG: fn:='green-empty.jpg';
   CB: fn:='blue-empty.jpg';
   CY: fn:='yellow-empty.jpg';
  end;
  end else
  begin
    case c.t of
         WILD: fn:='xp.jpg';
         DRAWFOURWIRD: fn:='xp4.jpg';
    end;
  end;
  cardToImage:=images_dir+fn;
end;

procedure TMainWindow.newgameClick(Sender: TObject);
begin
    choose.showmodal();
end;

procedure TMainWindow.cleanForm;
begin
 groupbox1.visible:=false;
 gracze.visible:=false;
// cards.visible:=false;
unotext.show;
cards.hide;
end;

procedure TMainWindow.uncleanForm;
begin
   groupbox1.visible:=true;
   cards.visible:=true;
 gracze.visible:=true;
 unotext.hide;
end;

procedure TMainWindow.FormCreate(Sender: TObject);
var
  f: Pointer;
begin
  randomize;
  gameState.Create();
  choose:=TGameChoose.Create(self);
  colorChooseWindow:=TColorChoose.Create(self);
  choose.gameState:=@gameState;
  colorChooseWindow.gameState:=@gameState;
  cards:=TcardsWindow.Create(self);
  cards.gameState:=@gameState;
  cards.colorChooseWindow:=colorChooseWindow;
  aboutWindow:=Tabout.create(self);
 // cards.parent:=self;
  f:=self;
   choose.mainForm:=f;
   cards.mainForm:=f;
   gameState.mainForm:=f;
   aiTimer.Enabled:=false;
   cleanForm;
end;

procedure TMainWindow.FormPaint(Sender: TObject);
begin

end;

procedure TMainWindow.endCurrentGame;
var
f: Pointer;
begin
  aiTimer.Enabled:=false;
  cleanForm;
  gameState.reset;
    f:=self;
   choose.mainForm:=f;
   cards.mainForm:=f;
   gameState.mainForm:=f;
  newgame.enabled:=true;
end;

procedure TMainWindow.startGame(player_name: string; players: word);
var
  i: word;
begin
  if (gameState.getState<>idle) then
    begin

        uncleanForm;
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
      endgame.Enabled:=false;
       newgame.enabled:=true;
    end;

end;

procedure TMainWindow.FormClick(Sender: TObject);
begin

end;

procedure TMainWindow.MenuItem3Click(Sender: TObject);
begin
  close;
end;

procedure TMainWindow.MenuItem4Click(Sender: TObject);
begin
  aboutWindow.show;
end;

procedure TMainWindow.MenuItem5Click(Sender: TObject);
begin
  howto.show;
end;

procedure TMainWindow.players_listSelectionChange(Sender: TObject; User: boolean
  );
begin

end;

procedure TMainWindow.aiTimerTimer(Sender: TObject);
begin
  gameState.aiMove();
end;

procedure TMainWindow.FormActivate(Sender: TObject);
begin

end;

procedure TMainWindow.endgameClick(Sender: TObject);
begin
  gameState.setState(idle);
  endCurrentGame;

end;

procedure TMainWindow.lockCards(unlock: boolean);
var
  i,n: word;
begin
  n:=length(cards.glyphs);
  for i:=0 to n-1 do
  begin
     cards.glyphs[i].enabled:=unlock;
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
  cards.autoScroll:=false;
  if length(cards.glyphs)>0 then
   begin
   for i:=0 to length(cards.glyphs)-1 do
    begin
       cards.glyphs[i].visible:=false;
    end;
   end;
   current_player:=gameState.getHumanPlayer;
  player_cards:=current_player.getCards();
  cleft:=if_card_margin_left;
  for i:=0 to length(player_cards)-1 do
   begin
      setLength(cards.glyphs,length(cards.glyphs)+1);
      g:=length(cards.glyphs)-1;
      cards.glyphs[g]:=TImage.Create(nil);
      cards.glyphs[g].picture.LoadFromFile(cardToImage(player_cards[i]));
      cards.glyphs[g].width:=if_card_width;
      cards.glyphs[g].height:=if_card_height;
      cards.glyphs[g].top:=if_card_margin_top;
      cleft:=if_card_margin_left+i*(if_card_space+if_card_width);
      cards.glyphs[g].left:=cleft;
      cards.glyphs[g].parent:=cards;
     p:=@(player_cards[i]);
     player_cards[i]:=p^;
     cards.glyphs[g].Tag:=PtrInt(p);
     cards.glyphs[g].OnPaint:=@cards.drawNumber;
     cards.glyphs[g].enabled:=true;
     cards.glyphs[g].OnClick:=@cards.cardClicked;
   end;
   cards.autoScroll:=true;
end;

end.

