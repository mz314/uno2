program uno;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, choose, game, cardsform, unogame, stack, layout, colorChoose;

  { you can add units after this }

{$R *.res}


begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainWindow, MainWindow);
  Application.CreateForm(TForm1, Form1);
 // Application.CreateForm(TForm2, Form2);
 // Application.CreateForm(Tabout, aboutWindow);
 // Application.CreateForm(TcolorChoose, colorChooseWindow);
  //Application.CreateForm(TcardsWindow, cardsWindow);
 // Application.MainForm:=MainWindow;
  //Application.CreateForm(TGameChoose, GameChoose);
  Application.Run;
end.

