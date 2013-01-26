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
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    newgame: TMenuItem;
    endgame: TMenuItem;

    procedure startGame; override;
    procedure endgameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure newgameClick(Sender: TObject);
  private
    choose: TGameChoose;
    cards: TcardsWindow;
    procedure showCards();
    { private declarations }
  public
    { public declarations }
  end;

var
  MainWindow: TMainWindow;
  gameState: TGameState;

implementation

{$R *.lfm}

{ TMainWindow }



procedure TMainWindow.newgameClick(Sender: TObject);
begin
    choose.showmodal();
end;

procedure TMainWindow.FormCreate(Sender: TObject);
var
  f: Pointer;
begin
  gameState.Create();
  choose:=TGameChoose.Create(self);
  choose.gameState:=@gameState;
  cards:=TcardsWindow.Create(self);
  cards.gameState:=@gameState;
   f:=self;
   choose.mainForm:=f;
   //p:=@self.startGame;
end;

procedure TMainWindow.FormPaint(Sender: TObject);
begin

end;

procedure TMainWindow.startGame;
begin
  if (gameState.getState<>idle) then
    begin
       //logo.visible:=false;
       endgame.enabled:=true;
       newgame.enabled:=false;
       gameState.addPlayer('testplayer');
       cards.show();
       showCards();
    end else
    begin
     // logo.visible:=true;
      endgame.Enabled:=false;
       newgame.enabled:=true;
    end;

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

procedure TMainWindow.showCards;
var
  i,g: word;
  cleft: integer;
  player_cards: Tcards;
  current_player: Tplayer;
begin
  //showmessage(inttostr(length(cards.glyphs)));
  if length(cards.glyphs)>0 then
  for i:=0 to length(cards.glyphs) do
   cards.glyphs[i].Destroy();
  current_player:=gameState.getCurrentPlayer;
  player_cards:=current_player.getCards();
  cleft:=if_card_margin_left;
  for i:=1 to length(player_cards) do
   begin
      setLength(cards.glyphs,length(cards.glyphs)+1);
      g:=length(cards.glyphs)-1;
      cards.glyphs[g]:=TImage.Create(cards);
      cards.glyphs[g].picture.LoadFromFile('images/red-empty.jpg');
      cards.glyphs[g].width:=if_card_width;
      cards.glyphs[g].height:=if_card_height;
      cards.glyphs[g].top:=if_card_margin_top;
      cleft:=if_card_margin_left+(i-1)*(if_card_space+if_card_width);
      cards.glyphs[g].left:=cleft;
      cards.glyphs[g].parent:=cards;

   end;

end;

end.

