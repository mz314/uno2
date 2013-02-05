unit cardsform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, game,
  ExtCtrls, StdCtrls, main_definitions, cards;

type

  { TcardsWindow }

  TcardsWindow = class(TcardsWindowInterface)
    drawButton: TButton;
    procedure drawButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);

  private

  public
    mainForm: Pointer;
    glyphs: array of TImage;
    gameState: PGameState;
    procedure drawNumber(Sender: TObject);
    procedure cardClicked(Sender: TObject);
  end;

var
  cardsWindow: TcardsWindow;

implementation

{$R *.lfm}

{ TcardsWindow }

procedure TCardsWindow.cardClicked(Sender: TObject);
var
 pc: PCard;
 c: TCard;
begin
  with (sender as TImage) do
  begin
    pc:=PCard(tag);
    c:=pc^;
    if gameState^.putCard(c) then
      gameState^.nextPlayer();
  end;

end;

procedure TCardsWindow.drawNumber(Sender: TObject);
var
  t: TImage;
  pc: PCard;
  c: TCard;
  ctype: integer;
begin
  t:=Sender as TImage;
  t.canvas.font.size:=24;
  pc:=PCard(t.tag);
 // if pc<>nil then
  c:=pc^;
//  showmessage(inttostr(c.t));
  if c.t<10 then
  begin
    t.canvas.textout(45,70,inttostr(c.t));
  end
  else
  begin {tymczasowo}
   case c.t of
    10: t.canvas.textout(45,70,'SKIP');
    11: t.canvas.textout(45,70,'+2');
    12: t.canvas.textout(45,70,'<-->');
    13: t.canvas.textout(45,70,'+4XP');
    14: t.canvas.textout(45,70,'XP');
   end;
  end;
end;

procedure TcardsWindow.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  self.visible:=true;
end;

procedure TcardsWindow.drawButtonClick(Sender: TObject);
begin
  gameState^.playerDraw(1);
  gameState^.nextPlayer;
end;

procedure TcardsWindow.FormHide(Sender: TObject);
begin
  self.visible:=true;
end;

end.

