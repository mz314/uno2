{
 Klasy abstrakcyjne. Umożliwiają użycie formularzy dwukierunkowo.
}
unit main_definitions;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
StdCtrls, ExtCtrls;

type TmainWindowInterface=class abstract(TForm)
 public
  procedure startGame(player_name: string; players: word); virtual; Abstract;
  procedure nextMove; virtual; Abstract;
end;

type TcardsWindowInterface=class abstract(TForm)

end;

implementation
end.

