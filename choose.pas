unit choose;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls,game,main_definitions;







type

  { TGameChoose }

  TGameChoose = class(TForm)
    Button1: TButton;
    Button2: TButton;
    player_name: TEdit;
    GroupBox2: TGroupBox;
    pcount: TEdit;
    GroupBox1: TGroupBox;
    UpDown1: TUpDown;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

    { private declarations }
  public
    gameState: PGameState;
    mainForm: Pointer;
  end;

type PGameChoose=^TGameChoose;

type PForm=^TCustomForm;
implementation

{$R *.lfm}

{ TGameChoose }

procedure TGameChoose.Button1Click(Sender: TObject);
begin
 self.close;
end;

procedure TGameChoose.Button2Click(Sender: TObject);
var
  f: TmainWindowInterface;
begin
  if player_name.text='' then
   player_name.text:='Gracz';
 gameState^.setState(multi); //potem wycofam

  f:=TmainWindowInterface(mainForm);

  f.startGame(player_name.text,4);
 // f.FormActivate(self);
  self.close;
end;

procedure TGameChoose.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

end.

