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
  end;

var
  cardsWindow: TcardsWindow;

implementation

{$R *.lfm}

{ TcardsWindow }

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

