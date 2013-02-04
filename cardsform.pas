unit cardsform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,game,ExtCtrls,main_definitions;

type

  { TcardsWindow }

  TcardsWindow = class(TcardsWindowInterface)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);

  private

  public

    glyphs: array of TImage;
    gameState: PGameState;
     procedure drawNumber(Sender: TObject);
  end;

var
  cardsWindow: TcardsWindow;

implementation

{$R *.lfm}

{ TcardsWindow }

procedure TCardsWindow.drawNumber(Sender: TObject);
var
  t: TImage;
begin
  t:=Sender as TImage;
  t.canvas.font.size:=24;
  if t.tag<10 then
  begin
    t.canvas.textout(45,70,inttostr(t.tag));
  end
  else
  begin {tymczasowo}
   case t.tag of
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

procedure TcardsWindow.FormHide(Sender: TObject);
begin
  self.visible:=true;
end;

end.

