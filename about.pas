unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tabout }

  Tabout = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  aboutWindow: Tabout;

implementation

{$R *.lfm}

{ Tabout }

procedure Tabout.FormCreate(Sender: TObject);
begin

end;

procedure Tabout.Button1Click(Sender: TObject);
begin
    self.hide;
end;

end.

