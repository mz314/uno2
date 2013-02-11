unit colorChoose;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,game,cards;

type

  { TcolorChoose }

  TcolorChoose = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure enterColor(c: word);
  public
     gameState: ^TGameState;
  end;

var
  colorChooseWindow: TcolorChoose;

implementation

{$R *.lfm}

{ TcolorChoose }

procedure TColorChoose.enterColor(c: word);
begin
  gameState^.setColor(c);
  gameState^.nextPlayer;
  self.visible:=false;
end;

procedure TcolorChoose.Button1Click(Sender: TObject);
begin
  enterColor(CR);
end;

procedure TcolorChoose.Button2Click(Sender: TObject);
begin
  enterColor(CG);
end;

procedure TcolorChoose.Button3Click(Sender: TObject);
begin
  enterColor(CB);
end;

procedure TcolorChoose.Button4Click(Sender: TObject);
begin
  enterColor(CY);
end;

end.

