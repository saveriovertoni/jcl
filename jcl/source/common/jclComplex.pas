{******************************************************************************}
{                                                                              }
{ Project JEDI Code Library (JCL)                                              }
{                                                                              }
{ The contents of this file are subject to the Mozilla Public License Version  }
{ 1.0 (the "License"); you may not use this file except in compliance with the }
{ License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ The Original Code is JclComplex.pas.                                         }
{                                                                              }
{ The Initial Developer of the Original Code is documented in the accompanying }
{ help file JCL.chm. Portions created by these individuals are Copyright (C)   }
{ of these individuals.                                                        }
{                                                                              }
{ Last modified: November 29, 2000                                             }
{                                                                              }
{******************************************************************************}

unit JclComplex;

{$I JCL.INC}

interface

uses SysUtils,
     JclBase, JclMath, JclSysUtils, JclStrings, JclResources;

const
  TComplex_VERSION = 5.01;

type
  TComplexType = (crRectangular, crPolar);

  TCoords = record
    x: Float; // rectangular real
    y: Float; // rectangular imaginary
    r: Float; // polar 1
    theta: Float; // polar 2
  end;

  TRectCoord = record
    x: Float;
    y: Float;
  end;

  TJclComplex = class
  private {z = x + yi}
    fCoord: TCoords;
    fFracLen: Byte;
    function MiscalcSingle(X: Float): Float;
    procedure MiscalcComplex; // eliminates miscalculation
    procedure FillCoords(CompexType: TComplexType);
    function GetRectangularString: string;
    function GetPolarString: string;
    procedure SetRectangularString(StrToParse: string);
    procedure SetPolarString(StrToParse: string);
    procedure SetFracLen(X: Byte);
    function GetRadius: Float;
    function GetAngle: Float;
    function NormalizeAngle(Value: Float): Float;
  protected
    function Assign(Coord: TCoords; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CoreAdd(First, Second: TRectCoord): TRectCoord;
    function CoreDiv(First, Second: TRectCoord): TRectCoord;
    function CoreMul(First, Second: TRectCoord): TRectCoord;
    function CoreSub(First, Second: TRectCoord): TRectCoord;
    function CoreLn(LnValue: TRectCoord): TRectCoord;
    function CoreExp(ExpValue: TRectCoord): TRectCoord;
    function CorePwr(First, Second, Polar: TRectCoord): TRectCoord;
    function CoreIntPwr(First, Polar: TRectCoord; Pwr: Integer): TRectCoord;
    function CoreRealPwr(First, Polar: TRectCoord; Pwr: Float): TRectCoord;
    function CoreRoot(First, Polar: TRectCoord; K, N: Word): TRectCoord;
    function CoreCos(Value: TRectCoord): TRectCoord;
    function CoreSin(Value: TRectCoord): TRectCoord;
    function CoreTan(Value: TRectCoord): TRectCoord;
    function CoreCot(Value: TRectCoord): TRectCoord;
    function CoreSec(Value: TRectCoord): TRectCoord;
    function CoreCsc(Value: TRectCoord): TRectCoord;
    function CoreCosH(Value: TRectCoord): TRectCoord;
    function CoreSinH(Value: TRectCoord): TRectCoord;
    function CoreTanH(Value: TRectCoord): TRectCoord;
    function CoreCotH(Value: TRectCoord): TRectCoord;
    function CoreSecH(Value: TRectCoord): TRectCoord;
    function CoreCscH(Value: TRectCoord): TRectCoord;
    function CoreI0(Value: TRectCoord): TRectCoord;
    function CoreJ0(Value: TRectCoord): TRectCoord;
    function CoreApproxLnGamma(Value: TRectCoord): TRectCoord;
    function CoreLnGamma(Value: TRectCoord): TRectCoord;
    function CoreGamma(Value: TRectCoord): TRectCoord;
  public
    property FracLength: Byte read fFracLen write SetFracLen default 8;

    //----------- constructors
    constructor Create; overload;
    constructor Create(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}); overload;

    //----------- getting different parts of the number
    property RealPart: Float read fCoord.x;
    property ImaginaryPart: Float read fCoord.y;
    property Radius: Float read GetRadius;
    property Angle: Float read GetAngle;

    //----------- format output
    property AsString: string read GetRectangularString write SetRectangularString;
    property AsPolarString: string read GetPolarString write SetPolarString;

    //----------- complex numbers assignment routines
    function Assign(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function AssignZero: TJclComplex;
    function AssignOne: TJclComplex;
    function Duplicate: TJclComplex;

    //----------- arithmetics -- modify the object itself
    function CAdd(AddValue: TJclComplex): TJclComplex; overload;
    function CAdd(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CDiv(DivValue: TJclComplex): TJclComplex; overload;
    function CDiv(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CMul(MulValue: TJclComplex): TJclComplex; overload;
    function CMul(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CSub(SubValue: TJclComplex): TJclComplex; overload;
    function CSub(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNeg: TJclComplex;
    function CConjugate: TJclComplex;

    //----------- arithmetics -- creates new resulting object
    function CNewAdd(AddValue: TJclComplex): TJclComplex; overload;
    function CNewAdd(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNewDiv(DivValue: TJclComplex): TJclComplex; overload;
    function CNewDiv(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNewMul(MulValue: TJclComplex): TJclComplex; overload;
    function CNewMul(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNewSub(SubValue: TJclComplex): TJclComplex; overload;
    function CNewSub(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNewNeg: TJclComplex;
    function CNewConjugate: TJclComplex;

    //----------- natural log and exponential functions
    function CLn: TJclComplex;
    function CNewLn: TJclComplex;
    function CExp: TJclComplex;
    function CNewExp: TJclComplex;
    function CPwr(PwrValue: TJclComplex): TJclComplex; overload;
    function CPwr(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CNewPwr(PwrValue: TJclComplex): TJclComplex; overload;
    function CNewPwr(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex; overload;
    function CIntPwr(Pwr: Integer): TJclComplex; overload;
    function CNewIntPwr(Pwr: Integer): TJclComplex; overload;
    function CRealPwr(Pwr: Float): TJclComplex; overload;
    function CNewRealPwr(Pwr: Float): TJclComplex; overload;
    function CRoot(K, N: Word): TJclComplex; overload;
    function CNewRoot(K, N: Word): TJclComplex; overload;
    function CSqrt: TJclComplex; overload;
    function CNewSqrt: TJclComplex; overload;

    //----------- trigonometric functions
    function CCos: TJclComplex;
    function CNewCos: TJclComplex;
    function CSin: TJclComplex;
    function CNewSin: TJclComplex;
    function CTan: TJclComplex;
    function CNewTan: TJclComplex;
    function CCot: TJclComplex;
    function CNewCot: TJclComplex;
    function CSec: TJclComplex;
    function CNewSec: TJclComplex;
    function CCsc: TJclComplex;
    function CNewCsc: TJclComplex;

    //----------- complex hyperbolic functions
    function CCosH: TJclComplex;
    function CNewCosH: TJclComplex;
    function CSinH: TJclComplex;
    function CNewSinH: TJclComplex;
    function CTanH: TJclComplex;
    function CNewTanH: TJclComplex;
    function CCotH: TJclComplex;
    function CNewCotH: TJclComplex;
    function CSecH: TJclComplex;
    function CNewSecH: TJclComplex;
    function CCscH: TJclComplex;
    function CNewCscH: TJclComplex;

    //----------- complex Bessel functions of order zero
    function CI0: TJclComplex;
    function CNewI0: TJclComplex;
    function CJ0: TJclComplex;
    function CNewJ0: TJclComplex;

    function CApproxLnGamma: TJclComplex;
    function CNewApproxLnGamma: TJclComplex;
    function CLnGamma: TJclComplex;
    function CNewLnGamma: TJclComplex;
    function CGamma: TJclComplex;
    function CNewGamma: TJclComplex;

    //----------- miscellaneous routines
    function AbsoluteValue: Float; overload;
    function AbsoluteValue(Coord: TRectCoord): Float; overload;
    function AbsoluteValueSqr: Float; overload;
    function AbsoluteValueSqr(Coord: TRectCoord): Float; overload;
    function FormatExtended(X: Float): string;
  end;

var
  RectZero,
    RectOne,
    RectInfinity: TRectCoord;

var
  ComplexPrecision: Float = 1E-14;

const
  MaxTerm: Byte = 35;
  EpsilonSqr: Float = 1E-20;

implementation

//------------------------------------------------------------------------------

function Coordinates(cX, cY: Float; CoordType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TCoords;
begin
  case CoordType of
    crRectangular:
      begin
        Result.x := cX;
        Result.y := cY;
        Result.r := 0;
        Result.theta := 0;
      end;
    crPolar:
      begin
        Result.x := 0;
        Result.y := 0;
        Result.r := cX;
        Result.theta := cY;
      end;
  end;
end;

//------------------------------------------------------------------------------

function RectCoord(X, Y: Float): TRectCoord; overload;
begin
  Result.x := X;
  Result.y := Y;
end;

//------------------------------------------------------------------------------

function RectCoord(Value: TJclComplex): TRectCoord; overload;
begin
  Result.x := Value.fCoord.x;
  Result.y := Value.fCoord.y;
end;

//------------------------------------------------------------------------------

constructor TJclComplex.Create;
begin
  inherited Create;
  AssignZero;
  fFracLen := 18;
end;

//------------------------------------------------------------------------------

constructor TJclComplex.Create(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF});
begin
  inherited Create;
  Assign(X, Y, ComplexType);
  fFracLen := 18;
end;

//------------------------------------------------------------------------------

procedure TJclComplex.FillCoords(CompexType: TComplexType);
begin
  MiscalcComplex;
  case CompexType of
    crPolar:
      begin
        fCoord.x := fCoord.r * Cos(fCoord.theta);
        fCoord.y := fCoord.r * Sin(fCoord.theta);
      end;
    crRectangular:
      begin
        if fCoord.x = 0 then
        begin
          fCoord.r := Abs(fCoord.y);
          fCoord.theta := PiOn2 * Sgn(fCoord.y);
        end
        else
        begin
          fCoord.r := AbsoluteValue;
          fCoord.theta := System.ArcTan(fCoord.y / fCoord.x);
          if fCoord.x < 0 then
            fCoord.theta := fCoord.theta + Pi * Sgn(fCoord.y);
        end;
      end;
  end;
  MiscalcComplex;
end;

//------------------------------------------------------------------------------

function TJclComplex.MiscalcSingle(X: Float): Float;
begin
  Result := X;
  if Abs(Result) < ComplexPrecision then
    Result := 0;
end;

//------------------------------------------------------------------------------

procedure TJclComplex.MiscalcComplex; // eliminates miscalculation
begin
  fCoord.x := MiscalcSingle(fCoord.x);
  fCoord.y := MiscalcSingle(fCoord.y);
  fCoord.r := MiscalcSingle(fCoord.r);
  if fCoord.r = 0 then
    fCoord.theta := 0
  else
    fCoord.theta := MiscalcSingle(fCoord.theta);
end;

//------------------------------------------------------------------------------

function TJclComplex.Assign(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
begin
  Result := Assign(Coordinates(X, Y, ComplexType), ComplexType);
end;

//------------------------------------------------------------------------------

function TJclComplex.Assign(Coord: TCoords; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
begin
  fCoord := Coord;
  FillCoords(ComplexType);
  MiscalcComplex;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.AssignZero: TJclComplex;
begin
  Result := Assign(0, 0, crRectangular);
end;

//------------------------------------------------------------------------------

function TJclComplex.AssignOne: TJclComplex;
begin
  Result := Assign(1, 0, crRectangular);
end;

//------------------------------------------------------------------------------

function TJclComplex.GetRectangularString: string;
begin
  MiscalcComplex;
  if (fCoord.x = 0) and (fCoord.y = 0) then
    Result := '0'
  else
    if fCoord.x <> 0 then
    begin
      Result := FormatExtended(fCoord.x);
      if fCoord.y > 0 then
        Result := Result + '+'
      else
        if fCoord.y < 0 then
          Result := Result + '-';
      if fCoord.y <> 0 then
        Result := Result + FormatExtended(Abs(fCoord.y)) + 'i';
    end
    else
      Result := FormatExtended(fCoord.y) + 'i';
end;

//------------------------------------------------------------------------------

function TJclComplex.GetPolarString: string;
begin
  FillCoords(crRectangular);
  Result := FormatExtended(fCoord.r) + '*CIS(' + FormatExtended(fCoord.theta) + ')';
end;

//------------------------------------------------------------------------------

procedure TJclComplex.SetRectangularString(StrToParse: string);
var
  SignPos: Integer;
  RealPart, ImagPart: Float;
begin
  StrToParse := StrRemoveChars(StrToParse, [' ']);
  SignPos := StrFind('+', StrToParse, 2);
  if SignPos = 0 then
    SignPos := StrFind('-', StrToParse, 2);
  if SignPos > 0 then
  begin
    try
      RealPart := StrToFloat(Copy(StrToParse, 1, SignPos - 1));
    except
      raise EJclMathError.CreateResRec(@RsComplexInvalidString);
    end;
    try
      ImagPart := StrToFloat(Copy(StrToParse, SignPos, Length(StrToParse) - SignPos));
    except
      raise EJclMathError.CreateResRec(@RsComplexInvalidString);
    end;
  end
  else
  begin
    if (StrRight(StrToParse, 1) = 'i') or (StrRight(StrToParse, 1) = 'I') then
    begin
      RealPart := 0;
      try
        ImagPart := StrToFloat(Copy(StrToParse, 1, Length(StrToParse) - 1));
      except
        raise EJclMathError.CreateResRec(@RsComplexInvalidString);
      end;
    end
    else
    begin
      try
        RealPart := StrToFloat(StrToParse);
      except
        raise EJclMathError.CreateResRec(@RsComplexInvalidString);
      end;
      ImagPart := 0;
    end;
  end;
  Assign(RealPart, ImagPart);
end;

//------------------------------------------------------------------------------

procedure TJclComplex.SetPolarString(StrToParse: string);
var
  AstPos: Integer;
  Radius, Angle: Float;
begin
  StrToParse := AnsiUpperCase(StrRemoveChars(StrToParse, [' ']));
  AstPos := Pos('*', StrToParse);
  if AstPos = 0 then
    raise EJclMathError.CreateResRec(@RsComplexInvalidString);
  try
    Radius := StrToFloat(StrLeft(StrToParse, AstPos - 1));
  except
    raise EJclMathError.CreateResRec(@RsComplexInvalidString);
  end;
  AstPos := Pos('(', StrToParse);
  if AstPos = 0 then
    raise EJclMathError.CreateResRec(@RsComplexInvalidString);
  try
    Angle := StrToFloat(Copy(StrToParse, AstPos + 1, Length(StrToParse) - AstPos - 1));
  except
    raise EJclMathError.CreateResRec(@RsComplexInvalidString);
  end;
  Assign(Radius, Angle, crPolar);
end;

//------------------------------------------------------------------------------

function TJclComplex.Duplicate: TJclComplex;
begin
  Result := TJclComplex.Create(fcoord.x, fcoord.y);
  Result.fFracLen := fFracLen;
end;

//==============================================================================
// arithmetics
//==============================================================================

function TJclComplex.CoreAdd(First, Second: TRectCoord): TRectCoord;
begin
  Result.x := First.x + Second.x;
  Result.y := First.y + Second.y;
end;

function TJclComplex.CAdd(AddValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreAdd(RectCoord(Self), RectCoord(AddValue));
  fCoord.x := ResCoord.x;
  fCoord.y := ResCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CAdd(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CAdd(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewAdd(AddValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreAdd(RectCoord(Self), RectCoord(AddValue));
  Result := TJclComplex.Create(ResCoord.x, ResCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewAdd(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CNewAdd(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreDiv(First, Second: TRectCoord): TRectCoord;
var
  Denom: Float;
begin
  Denom := Sqr(Second.x) + Sqr(Second.y);
  Result.x := (First.x * Second.x + First.y * Second.y) / Denom;
  Result.y := (First.y * Second.x - First.x * Second.y) / Denom;
end;

//------------------------------------------------------------------------------

function TJclComplex.CDiv(DivValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreDiv(RectCoord(Self), RectCoord(DivValue));
  fCoord.x := ResCoord.x;
  fCoord.y := ResCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CDiv(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CDiv(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewDiv(DivValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreDiv(RectCoord(Self), RectCoord(DivValue));
  Result := TJclComplex.Create(ResCoord.x, ResCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewDiv(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CNewDiv(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreMul(First, Second: TRectCoord): TRectCoord;
begin
  Result.x := First.x * Second.x - First.y * Second.y;
  Result.y := First.x * Second.y + First.y * Second.x;
end;

//------------------------------------------------------------------------------

function TJclComplex.CMul(MulValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreMul(RectCoord(Self), RectCoord(MulValue));
  fCoord.x := ResCoord.x;
  fCoord.y := ResCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CMul(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CMul(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewMul(MulValue: TJclComplex): TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreMul(RectCoord(Self), RectCoord(MulValue));
  Result := TJclComplex.Create(ResCoord.x, ResCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewMul(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CNewMul(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreSub(First, Second: TRectCoord): TRectCoord;
begin
  Result.x := First.x - Second.x;
  Result.y := First.y - Second.y;
end;

//------------------------------------------------------------------------------

function TJclComplex.CSub(SubValue: TJclComplex): TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSub(RectCoord(Self), RectCoord(SubValue));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CSub(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CSub(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSub(SubValue: TJclComplex): TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSub(RectCoord(Self), RectCoord(SubValue));
  Result := TJclComplex.Create(ResValue.x, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSub(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CNewSub(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNeg;
begin
  fCoord.x := -fCoord.x;
  fCoord.y := -fCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewNeg;
begin
  Result := TJclComplex.Create(-fCoord.x, -fCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CConjugate;
begin
  fCoord.y := -fCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewConjugate;
begin
  Result := TJclComplex.Create(fCoord.x, -fCoord.y);
  Result.fFracLen := fFracLen;
end;

//==============================================================================
// natural log and exponential functions
//==============================================================================

function TJclComplex.CoreLn(LnValue: TRectCoord): TRectCoord;
begin
  Result.x := Ln(LnValue.x);
  Result.y := NormalizeAngle(LnValue.y);
end;

//------------------------------------------------------------------------------

function TJclComplex.CLn: TJclComplex;
var
  ResCoord: TRectCoord;
begin
  FillCoords(crRectangular);
  ResCoord := CoreLn(RectCoord(fCoord.r, fCoord.theta));
  fCoord.x := ResCoord.x;
  fCoord.y := ResCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewLn: TJclComplex;
var
  ResCoord: TRectCoord;
begin
  FillCoords(crRectangular);
  ResCoord := CoreLn(RectCoord(fCoord.r, fCoord.theta));
  Result := TJclComplex.Create(ResCoord.x, ResCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreExp(ExpValue: TRectCoord): TRectCoord;
var
  ExpX: Float;
begin
  ExpX := Exp(ExpValue.x);
  Result.x := ExpX * Cos(ExpValue.y);
  Result.y := ExpX * Sin(ExpValue.y);
end;

//------------------------------------------------------------------------------

function TJclComplex.CExp: TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreExp(RectCoord(fCoord.x, fCoord.y));
  fCoord.x := ResCoord.x;
  fCoord.y := ResCoord.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewExp: TJclComplex;
var
  ResCoord: TRectCoord;
begin
  ResCoord := CoreExp(RectCoord(fCoord.x, fCoord.y));
  Result := TJclComplex.Create(ResCoord.x, ResCoord.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CorePwr(First, Second, Polar: TRectCoord): TRectCoord;
begin
  MiscalcSingle(First.x);
  MiscalcSingle(First.y);
  MiscalcSingle(Second.x);
  MiscalcSingle(Second.y);
  if AbsoluteValueSqr(First) = 0 then
    if AbsoluteValueSqr(Second) = 0 then
      Result := RectOne
    else
      Result := RectZero
  else
  begin
    Result := CoreExp(CoreMul(Second, CoreLn(Polar)));
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CPwr(PwrValue: TJclComplex): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CorePwr(RectCoord(Self), RectCoord(PwrValue), RectCoord(fCoord.r, fCoord.theta));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CPwr(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CPwr(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewPwr(PwrValue: TJclComplex): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CorePwr(RectCoord(Self), RectCoord(PwrValue), RectCoord(fCoord.r, fCoord.theta));
  Result := TJclComplex.Create(ResValue.x, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewPwr(X, Y: Float; ComplexType: TComplexType{$IFDEF SUPPORTS_DEFAULTPARAMS} = crRectangular{$ENDIF}): TJclComplex;
var
  NewComplex: TJclComplex;
begin
  NewComplex := TJclComplex.Create(X, Y, ComplexType);
  try
    Result := CNewPwr(NewComplex);
  finally
    NewComplex.Free;
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreIntPwr(First, Polar: TRectCoord; Pwr: Integer): TRectCoord;
begin
  MiscalcSingle(First.x);
  MiscalcSingle(First.y);
  if AbsoluteValueSqr(First) = 0 then
    if Pwr = 0 then
      Result := RectOne
    else
      Result := RectZero
  else
    Result := RectCoord(PowerInt(Polar.x, Pwr), NormalizeAngle(Pwr * Polar.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CIntPwr(Pwr: Integer): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreIntPwr(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), Pwr);
  fCoord.r := ResValue.x;
  fCoord.theta := ResValue.y;
  FillCoords(crPolar);
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewIntPwr(Pwr: Integer): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreIntPwr(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), Pwr);
  Result := TJclComplex.Create(ResValue.x, ResValue.y, crPolar);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreRealPwr(First, Polar: TRectCoord; Pwr: Float): TRectCoord;
begin
  MiscalcSingle(First.x);
  MiscalcSingle(First.y);
  if AbsoluteValueSqr(First) = 0 then
    if MiscalcSingle(Pwr) = 0 then
      Result := RectOne
    else
      Result := RectZero
  else
    Result := RectCoord(Power(Polar.x, Pwr), NormalizeAngle(Pwr * Polar.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CRealPwr(Pwr: Float): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreRealPwr(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), Pwr);
  fCoord.r := ResValue.x;
  fCoord.theta := ResValue.y;
  FillCoords(crPolar);
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewRealPwr(Pwr: Float): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreRealPwr(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), Pwr);
  Result := TJclComplex.Create(ResValue.x, ResValue.y, crPolar);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreRoot(First, Polar: TRectCoord; K, N: Word): TRectCoord;
begin
  MiscalcSingle(First.x);
  MiscalcSingle(First.y);
  if AbsoluteValue(First) = 0 then
    Result := RectZero
  else
    Result := RectCoord(Power(Polar.x, 1 / N), NormalizeAngle((Polar.y + K * TwoPi) / N));
end;

//------------------------------------------------------------------------------

function TJclComplex.CRoot(K, N: Word): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreRoot(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), K, N);
  fCoord.r := ResValue.x;
  fCoord.theta := ResValue.y;
  FillCoords(crPolar);
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewRoot(K, N: Word): TJclComplex;
var
  ResValue: TRectCoord;
begin
  FillCoords(crRectangular);
  ResValue := CoreRoot(RectCoord(Self), RectCoord(fCoord.r, fCoord.theta), K, N);
  Result := TJclComplex.Create(ResValue.x, ResValue.y, crPolar);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CSqrt: TJclComplex;
begin
  Result := CRoot(0, 2);
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSqrt: TJclComplex;
begin
  Result := CNewRoot(0, 2);
end;

//------------------------------------------------------------------------------
// trigonometric functions
//------------------------------------------------------------------------------

function TJclComplex.CoreCos(Value: TRectCoord): TRectCoord;
begin
  Result := RectCoord(Cos(fCoord.x) * CosH(fCoord.y), -Sin(fCoord.x) * SinH(fCoord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CCos: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCos(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCos: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCos(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreSin(Value: TRectCoord): TRectCoord;
begin
  Result := RectCoord(Sin(fCoord.x) * CosH(fCoord.y), Cos(fCoord.x) * SinH(fCoord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CSin: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSin(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSin: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSin(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreTan(Value: TRectCoord): TRectCoord;
var
  TempValue: Float;
begin
  TempValue := Cos(2 * Value.x) + CosH(2 * Value.y);
  if MiscalcSingle(TempValue) <> 0 then
  begin
    Result := RectCoord(Sin(2 * Value.x) / TempValue, SinH(2 * Value.y) / TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CTan: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreTan(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewTan: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreTan(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreCot(Value: TRectCoord): TRectCoord;
var
  TempValue: Float;
begin
  TempValue := Cosh(2 * Value.y) - Cos(2 * Value.x);
  if MiscalcSingle(TempValue) <> 0 then
  begin
    Result := RectCoord(Sin(2 * Value.x) / TempValue, -SinH(2 * Value.y) / TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CCot: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCot(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCot: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCot(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreSec(Value: TRectCoord): TRectCoord;
var
  TempValue: TRectCoord;
begin
  TempValue := CoreCos(Value);
  if MiscalcSingle(AbsoluteValue(TempValue)) <> 0 then
  begin
    Result := CoreDiv(RectOne, TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CSec: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSec(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSec: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSec(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreCsc(Value: TRectCoord): TRectCoord;
var
  TempValue: TRectCoord;
begin
  TempValue := CoreSin(Value);
  if MiscalcSingle(AbsoluteValue(TempValue)) <> 0 then
  begin
    Result := CoreDiv(RectOne, TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CCsc: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCsc(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCsc: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCsc(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//==============================================================================
// hyperbolic functions
//==============================================================================

function TJclComplex.CoreCosH(Value: TRectCoord): TRectCoord;
begin
  Result := RectCoord(CosH(fCoord.x) * Cos(fCoord.y), SinH(fCoord.x) * Sin(fCoord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CCosH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCosH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCosH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCosH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreSinH(Value: TRectCoord): TRectCoord;
begin
  Result := RectCoord(SinH(fCoord.x) * Cos(fCoord.y), CosH(fCoord.x) * Sin(fCoord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.CSinH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSinH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSinH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSinH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreTanH(Value: TRectCoord): TRectCoord;
var
  TempValue: Float;
begin
  TempValue := CosH(2 * Value.x) + Cos(2 * Value.y);
  if MiscalcSingle(TempValue) <> 0 then
  begin
    Result := RectCoord(SinH(2 * Value.x) / TempValue, Sin(2 * Value.y) / TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CTanH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreTanH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewTanH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreTanH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreCotH(Value: TRectCoord): TRectCoord;
var
  TempValue: Float;
begin
  TempValue := Cosh(2 * Value.x) - Cos(2 * Value.y);
  if MiscalcSingle(TempValue) <> 0 then
  begin
    Result := RectCoord(SinH(2 * Value.x) / TempValue, -Sin(2 * Value.y) / TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CCotH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCotH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCotH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCotH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreSecH(Value: TRectCoord): TRectCoord;
var
  TempValue: TRectCoord;
begin
  TempValue := CoreCosH(Value);
  if MiscalcSingle(AbsoluteValue(TempValue)) <> 0 then
  begin
    Result := CoreDiv(RectOne, TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CSecH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSecH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewSecH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreSecH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreCscH(Value: TRectCoord): TRectCoord;
var
  TempValue: TRectCoord;
begin
  TempValue := CoreSinH(Value);
  if MiscalcSingle(AbsoluteValue(TempValue)) <> 0 then
  begin
    Result := CoreDiv(RectOne, TempValue);
  end
  else
    Result := RectInfinity;
end;

//------------------------------------------------------------------------------

function TJclComplex.CCscH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCscH(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewCscH: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreCscH(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//==============================================================================
// complex Bessel functions of order zero
//==============================================================================

function TJclComplex.CoreI0(Value: TRectCoord): TRectCoord;
var
  zSQR25, term: TRectCoord;
  i: Integer;
  SizeSqr: Float;
begin
  Result := RectOne;
  zSQR25 := CoreMul(Value, Value);
  zSQR25 := RectCoord(0.25 * zSQR25.x, 0.25 * zSQR25.y);
  term := zSQR25;
  Result := CoreAdd(Result, zSQR25);
  i := 1;
  repeat
    term := CoreMul(zSQR25, term);
    Inc(i);
    term := RectCoord(term.x / Sqr(i), term.y / Sqr(i));
    Result := CoreAdd(Result, term);
    SizeSqr := Sqr(term.x) + Sqr(term.y);
  until (i > MaxTerm) or (SizeSqr < EpsilonSqr)
end;

//------------------------------------------------------------------------------

function TJclComplex.CI0: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreI0(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewI0: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreI0(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreJ0(Value: TRectCoord): TRectCoord;
var
  zSQR25, term: TRectCoord;
  i: Integer;
  SizeSqr: Float;
  addFlag: Boolean;
begin
  Result := RectOne;
  zSQR25 := CoreMul(Value, Value);
  zSQR25 := RectCoord(0.25 * zSQR25.x, 0.25 * zSQR25.y);
  term := zSQR25;
  Result := CoreSub(Result, zSQR25);
  addFlag := False;
  i := 1;
  repeat
    term := CoreMul(zSQR25, term);
    Inc(i);
    addFlag := not addFlag;
    term := RectCoord(term.x / Sqr(i), term.y / Sqr(i));
    if addFlag then
      Result := CoreAdd(Result, term)
    else
      Result := CoreSub(Result, term);
    SizeSqr := Sqr(term.x) + Sqr(term.y);
  until (i > MaxTerm) or (SizeSqr < EpsilonSqr)
end;

//------------------------------------------------------------------------------

function TJclComplex.CJ0: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreJ0(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewJ0: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreJ0(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreApproxLnGamma(Value: TRectCoord): TRectCoord;
const
  c: array[1..8] of Float =
  (1 / 12, -1 / 360, 1 / 1260, -1 / 1680, 1 / 1188, -691 / 360360, 1 / 156, -3617 / 122400);
var
  i: Integer;
  Powers: array[1..8] of TRectCoord;
  temp1, temp2: TRectCoord;
begin
  temp1 := CoreLn(Value);
  temp2 := RectCoord(Value.x - 0.5, Value.y);
  Result := CoreAdd(temp1, temp2);
  Result := CoreSub(Result, Value);
  Result.x := Result.x + hLn2PI;

  temp1 := RectOne;
  Powers[1] := CoreDiv(temp1, Value);
  temp2 := CoreMul(powers[1], powers[1]);
  for i := 2 to 8 do
    Powers[i] := CoreMul(powers[i - 1], temp2);
  for i := 8 downto 1 do
  begin
    temp1 := RectCoord(c[i] * Powers[i].x, c[i] * Powers[i].y);
    Result := CoreAdd(Result, temp1);
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CApproxLnGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreApproxLnGamma(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewApproxLnGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreApproxLnGamma(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreLnGamma(Value: TRectCoord): TRectCoord;
var
  lna, temp: TRectCoord;
begin
  if (Value.x <= 0) and (MiscalcSingle(Value.y) = 0) then
    if MiscalcSingle(Int(Value.x - 1E-8) - Value.x) = 0 then
    begin
      Result := RectInfinity;
      Exit;
    end;

  if Value.y < 0 then
  begin
    Value := RectCoord(Value.x, -Value.y);
    Result := CoreLnGamma(Value);
    Result := RectCoord(Result.x, -Result.y);
  end
  else
  begin
    if Value.x < 9.0 then
    begin
      lna := CoreLn(Value);
      Value := RectCoord(Value.x + 1, Value.y);
      temp := CoreLnGamma(Value);
      Result := CoreSub(temp, lna);
    end
    else
      CoreApproxLnGamma(Value);
  end;
end;

//------------------------------------------------------------------------------

function TJclComplex.CLnGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreLnGamma(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewLnGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreLnGamma(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//------------------------------------------------------------------------------

function TJclComplex.CoreGamma(Value: TRectCoord): TRectCoord;
var
  lnz: TRectCoord;
begin
  lnz := CoreLnGamma(Value);
  if lnz.x > 75 then
    Result := RectInfinity
  else
    if lnz.x < -200 then
      Result := RectZero
    else
      Result := CoreExp(lnz);
end;

//------------------------------------------------------------------------------

function TJclComplex.CGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreGamma(RectCoord(Self));
  fCoord.x := ResValue.x;
  fCoord.y := ResValue.y;
  Result := Self;
end;

//------------------------------------------------------------------------------

function TJclComplex.CNewGamma: TJclComplex;
var
  ResValue: TRectCoord;
begin
  ResValue := CoreGamma(RectCoord(Self));
  Result := TJclComplex.Create(ResValue.X, ResValue.y);
  Result.fFracLen := fFracLen;
end;

//==============================================================================
// miscellaneous
//==============================================================================

function TJclComplex.AbsoluteValue: Float;
begin
  Result := Sqrt(Sqr(fCoord.x) + Sqr(fCoord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.AbsoluteValue(Coord: TRectCoord): Float;
begin
  Result := Sqrt(Sqr(Coord.x) + Sqr(Coord.y));
end;

//------------------------------------------------------------------------------

function TJclComplex.AbsoluteValueSqr: Float;
begin
  Result := Sqr(fCoord.x) + Sqr(fCoord.y);
end;

//------------------------------------------------------------------------------

function TJclComplex.AbsoluteValueSqr(Coord: TRectCoord): Float;
begin
  Result := Sqr(Coord.x) + Sqr(Coord.y);
end;

//------------------------------------------------------------------------------

function TJclComplex.FormatExtended(X: Float): string;
begin
  Result := FloatToStrF(X, ffFixed, fFracLen, fFracLen);
end;

//------------------------------------------------------------------------------

procedure TJclComplex.SetFracLen(X: Byte);
begin
  if X > 18 then
    fFracLen := 18
  else
    fFracLen := X;
end;

//------------------------------------------------------------------------------

function TJclComplex.GetRadius: Float;
begin
  FillCoords(crRectangular);
  Result := fCoord.r;
end;

//------------------------------------------------------------------------------

function TJclComplex.GetAngle: Float;
begin
  FillCoords(crRectangular);
  Result := fCoord.theta;
end;

//------------------------------------------------------------------------------

function TJclComplex.NormalizeAngle(Value: Float): Float;
begin
  FillCoords(crRectangular);
  while Value > Pi do
    Value := Value - TwoPi;
  while Value < -Pi do
    Value := Value + TwoPi;
  MiscalcSingle(Value);
  Result := Value;
end;

initialization
  RectZero := RectCoord(0, 0);
  RectOne := RectCoord(1, 0);
  RectInfinity := RectCoord(Infinity, Infinity);

end.

