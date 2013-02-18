unit cards;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  N_N=2;
  N_BLACK=4;
  N_FUNCTION=8;
  N_TYPES=15;
  N0=1;
  N1=2;
  N2=3;
  N3=4;
  N4=5;
  N5=6;
  N6=7;
  N7=8;
  N8=9;
  N9=10;
  SKIP=11;
  DRAW2=12;
  REVERSE=13;
  DRAWFOURWIRD=14;
  WILD=15;
  CR=1;
  CG=2;
  CB=3;
  CY=4;

//Ułatwienie losowania

type Tcard=record
  c,t: word;
end;

type Tcards=array of Tcard;

type PCard=^TCard;

implementation


end.

