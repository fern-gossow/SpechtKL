// Package for the type SSYT including cactus actions etc.

// Attach("C:/Users/**/Coding/Github/SpechtKL/sst.m");

declare type SSTab;

declare attributes SSTab: Tab, Weight;

// Initialisation and basic attributes
intrinsic SST(T::Tbl, n::RngIntElt) -> SSTab
{Create a semistandard tableau with designated weight}
    require Parent(T) eq TableauIntegerMonoid(): "Tableau must be over the positive integers";
    elts := &cat(Eltseq(T));
    require Max(elts) le n: "Weight must be more than maximum value";
    require n le #elts: "Weight must be less than number of boxes";
    X := New(SSTab);
    X`Tab := T;
    X`Weight := n;
    return X;
end intrinsic;

intrinsic SST(T::Tbl) -> SSTab
{Create a semistandard tableau with designated weight}
    return SST(T,Weight(T));
end intrinsic;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTab
{Create a SST with prescribed weight}
    return SST(Tableau(elts), n);
end intrinsic;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTab
{Create a SST with weight = number of boxes}
    T := Tableau(elts);
    return SST(T, Weight(T));
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTab
{Create a SST with prescribed weight given its skew shape}
    return SST(Tableau(skew, elts), n);
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTab
{Create a SST given its skew shape with weight = number of boxes}
    T := Tableau(skew, elts);
    return SST(T, Weight(T));
end intrinsic;

intrinsic Print(T::SSTab)
{Print T}
    printf"%o", T`Tab;
end intrinsic;

intrinsic '+'(P::SSTab, Q::SSTab) -> SSTab
{Compose two skew tableaux by joining them together}
    require [x : x in SkewShape(Q`Tab) | x gt 0] eq Shape(P`Tab): "Skew shapes must match";
    rowsP := Eltseq(P`Tab);
    rowsQ := [[x + P`Weight : x in row] : row in Eltseq(Q`Tab)];
    elts := [rowsP[r] cat rowsQ[r] : r in [1..#rowsP]] cat rowsQ[#rowsP+1..#rowsQ];
    return SST(SkewShape(P`Tab), elts, P`Weight+Q`Weight);
end intrinsic;

intrinsic Weight(T::SSTab) -> RngIntElt
{Return the weight of T}
    return T`Weight;
end intrinsic;

intrinsic Shape(T::SSTab) -> SeqEnum[RngIntElt]
{Return the shape of T}
    return T`Shape;
end intrinsic;

// Actions on SST

