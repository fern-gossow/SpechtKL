// Package for the type SSYT including cactus actions etc.

// Attach("C:/Users/**/Coding/Github/SpechtKL/sst.m");

declare type SSTab;

declare attributes SSTab: Tab, Weight;

// INITIALISATION

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

// BASIC ATTRIBUTES

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
    return Shape(T`Tab);
end intrinsic;

intrinsic SkewShape(T::SSTab) -> SeqEnum[RngIntElt]
{Return the skew shape of T}
    return SkewShape(T`Tab);
end intrinsic;

intrinsic IsSkew(T::SSTab) -> Bool
{Return whether T is a skew tableau}
    return IsSkew(T`Tab);
end intrinsic;

// ACTIONS

intrinsic JeuDeTaquin(T::SSTab, i::RngIntElt, j::RngIntElt) -> SSTab, RngIntElt, RngIntElt
{Perform jdt, and record the vacated cell}
    shT := Shape(T`Tab);
    R := JeuDeTaquin(T`Tab, i, j);
    shR := Shape(R) cat [0];
    // Row with difference between Shape(R) and Shape(T)
    row := Index([shT[x] - shR[x] : x in [1 .. #shT]], 1);
    return SST(R,T`Weight), row, shT[row];
end intrinsic;

intrinsic InverseJeuDeTaquin(T::SSTab, i::RngIntElt, j::RngIntElt) -> SSTab, RngIntElt, RngIntElt
{Perform inverse jdt, and record the vacated cell}
    skT := SkewShape(T`Tab) cat [0];
    R := InverseJeuDeTaquin(T`Tab, i, j);
    skR := SkewShape(R);
    // Row with difference between SkewShape(R) and SkewShape(T)
    row := Index([skR[x] - skT[x] : x in [1 .. #skR]], 1);
    return SST(R,T`Weight), row, skR[row];
end intrinsic;

intrinsic Rectify(T::SSTab) -> SSTab, SeqEnum[RngIntElt], SeqEnum[RngIntElt]
{Rectify T, and record the vacated rows and columns}
    R := T;
    vacrows := [];
    vaccols := [];
    while IsSkew(R) do
        // Find largest possible cell to slide into
        i := Max([x : x in [1..#SkewShape(R)] | SkewShape(R)[x] gt 0]);
        j := SkewShape(R)[i];
        R, r, c := JeuDeTaquin(R, i, j);
        Append(~vacrows, r);
        Append(~vaccols, c);
    end while;
    return R, vacrows, vaccols;
end intrinsic;

intrinsic InverseRectify(T::SSTab, rows::SeqEnum[RngIntElt], cols::SeqEnum[RngIntElt]) -> SSTab
{Unrectify T along a path}
    require #rows eq #cols: "Length of rows and columns must be the same";
    R := T;
    for j in [1..#rows] do
        R := InverseJeuDeTaquin(R, rows[j], cols[j]);
    end for;
    return R;
end intrinsic;

intrinsic Evacuate(T::SSTab) -> SSTab
{Perform usual evacuation for tableaux, and reversal for skew tableaux}
    if not IsSkew(T) then
        r := Shape(T)[1];
        padding := Reverse([r - Shape(T)[i] : i in [1..#Shape(T)]]);
        rows := [Eltseq(x) : x in Rows(T`Tab)];
        // Calculate rows after rotating and reversing values
        elts := Reverse([Reverse([T`Weight - x + 1 : x in row]) : row in rows]);
        X := Rectify(SST(padding,elts,T`Weight));
        return X;
    else
        X, vr, vc := Rectify(T);
        return InverseRectify(Evacuate(X), Reverse(vr), Reverse(vc));
    end if;
end intrinsic;

