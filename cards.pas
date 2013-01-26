unit cards;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  N_N=2;
  N_BLACK=4;
  N_FUNCTION=8;
  N_TYPES=16;
  N0=0;
  N1=1;
  N2=2;
  N3=3;
  N4=4;
  N5=5;
  N6=6;
  N7=7;
  N8=8;
  N9=9;
  //SKIP=10;
  DRAW2=11;
  SKIP=12;
  REVERSE=13;
  DRAWFOURWIRD=14;
  WILD=15;
  CR=1;
  CG=2;
  CB=3;
  CY=4;
  CX=0;

//Ułatwienie losowania

type Tcard=record
  c,t: word;
end;

type Tcards=array of Tcard;

implementation


end.

