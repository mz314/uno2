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
    pcount: TEdit;
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
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
  case RadioGroup1.ItemIndex of
   0: showmessage('Nie zaimplementowano');
   1: gameState^.setState(multi);
   2: showMessage('Nie zaimplementowano');
  end;

  f:=TmainWindowInterface(mainForm);
  f.startGame();
 // f.FormActivate(self);
  self.close;
end;

procedure TGameChoose.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

end.

