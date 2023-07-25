// Package for the type SSYT including cactus actions etc.

// Attach("C:/Users/Martin/Coding/Github/SpechtKL/sst.m");

declare type SSTab;

declare attributes SSTab: Tab, Weight;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTab
{Create a SST with prescribed weight}
    nzelts := [x : x in &cat(elts) | x gt 0];
    require Max(nzelts) le n: "Weight must be more than maximum value";
    require n le #nzelts: "Weight must be less than number of boxes";
    
    T := New(SSTab);
    T`Tab := Tableau(elts);
    T`Weight := n;
    return T;
end intrinsic;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTab
{Create a SST with weight = number of boxes}
    nzelts := [x : x in &cat(elts) | x gt 0];
    return SST(elts, #nzelts);
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTab
{Create a SST with prescribed weight given its skew shape}
    nzelts := &cat(elts);
    require Max(nzelts) le n: "Weight must be more than maximum value";
    require n le #nzelts: "Weight must be less than number of boxes";
    
    T := New(SSTab);
    T`Tab := Tableau(skew, elts);
    T`Weight := n;
    return T;
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTab
{Create a SST given its skew shape with weight = number of boxes}
    return SST(skew, elts, #elts);
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
{Return the weight of the tableaux}
    return T`Weight;
end intrinsic;

