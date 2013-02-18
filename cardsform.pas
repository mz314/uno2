unit cardsform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, game,
  ExtCtrls, StdCtrls, main_definitions, cards,colorChoose;

type

  { TcardsWindow }

  TcardsWindow = class(TcardsWindowInterface)
    drawButton: TButton;
    procedure drawButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);

  private

  public
    colorChooseWindow: TColorChoose;
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
showmessage(inttostr(c.c)+' '+inttostr(c.t));
    if gameState^.putCard(c) then
    begin
      if (c.t=WILD) or (c.t=DRAWFOURWIRD) then colorChooseWindow.Show
      else gameState^.nextPlayer;
    end;
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
  c:=pc^;
  if c.t<11 then
  begin
    t.canvas.textout(45,70,inttostr(c.t));
  end
  else
  begin {tymczasowo}
   case c.t of
    11: t.canvas.textout(45,70,'SKIP');
    12: t.canvas.textout(45,70,'+2');
    13: t.canvas.textout(45,70,'<-->');
    14: t.canvas.textout(45,70,'+4XP');
    15: t.canvas.textout(45,70,'XP');
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
 // self.autosize:=true;
  gameState^.playerDraw(1);
  gameState^.nextPlayer;
end;

procedure TcardsWindow.FormHide(Sender: TObject);
begin
  self.visible:=true;
end;

end.

