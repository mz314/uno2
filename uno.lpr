program uno;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, choose, game, cardsform, unogame, stack;
  { you can add units after this }

{$R *.res}


begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainWindow, MainWindow);
  Application.CreateForm(TForm1, Form1);
  //Application.CreateForm(TcardsWindow, cardsWindow);
 // Application.MainForm:=MainWindow;
  //Application.CreateForm(TGameChoose, GameChoose);
  Application.Run;
end.

