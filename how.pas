unit how;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Thowto }

  Thowto = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  howto: Thowto;

implementation

{$R *.lfm}

{ Thowto }

procedure Thowto.FormCreate(Sender: TObject);
begin
 Memo1.lines.loadfromfile('images/instrukcja.txt');
end;

procedure Thowto.Button1Click(Sender: TObject);
begin
  self.hide;
end;

end.

