unit main;

{$mode objfpc}{$H+}

{$X+} {Turn on extended syntax}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, choose, game,cardsform,main_definitions;

type

  { TMainWindow }

  TMainWindow = class(TmainWindowInterface)
    logo: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    newgame: TMenuItem;
    endgame: TMenuItem;

    procedure startGame override;
    procedure endgameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure newgameClick(Sender: TObject);
  private
    choose: TGameChoose;
    cards: TcardsWindow;
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
       logo.visible:=false;
       endgame.enabled:=true;
       newgame.enabled:=false;
       cards.show();
    end else
    begin
      logo.visible:=true;
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

end.

