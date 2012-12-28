unit cards;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type Tcard_type=(N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,XP,XP4,NADD2);
type Tcard_color=(R,G,B,Y);

//Ułatwienie losowania
const cardtype_array: array[0..12] of Tcard_type=(N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,XP,XP4,NADD2);
const cardcolor_array: array[0..3] of Tcard_color=(R,G,B,Y);

type Tcard=record
  c: Tcard_color;
  t: Tcard_type;
end;

implementation


end.

