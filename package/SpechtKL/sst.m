// Package for the type SSTableau (extending Tableau) which includes cactus actions and dual equivalence.

// INTERVALS AND PARABOLICS HELPERS

function CompositionToIntervals(comp)
    // Turn a composition into a list of intervals
    comp := [0] cat comp;
    return [<&+comp[1..i]+1, &+comp[1..i+1]> : i in [1..#comp-1]];
end function;

function ParabolicToIntervals(parabolic, n)
    // Turn a subset {i1,...,ik} c {1,...,n-1} into a list of intervals
    missing := [0] cat [i : i in [1..n-1] | not i in parabolic] cat [n];
    comp := [missing[j+1] - missing[j] : j in [1..#missing-1]];
    return CompositionToIntervals(comp);
end function;

// SEMISTANDARD TABLEAUX TYPE

declare type SSTableau;

declare attributes SSTableau: Tab, Range;

// CREATION

intrinsic SST(T::Tbl, n::RngIntElt) -> SSTableau
{Create a semistandard tableau with designated range}
    require Parent(T) eq TableauIntegerMonoid(): "Tableau must be over the positive integers";
    elts := &cat(Eltseq(T));
    require Max(elts cat [0]) le n: "Range must be more than maximum value";
    X := New(SSTableau);
    X`Tab := T;
    X`Range := n;
    return X;
end intrinsic;

intrinsic SST(T::Tbl) -> SSTableau
{Create a semistandard tableau with range = number of boxes}
    return SST(T, Weight(T));
end intrinsic;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTableau
{Create a SST with prescribed range}
    return SST(Tableau(elts), n);
end intrinsic;

intrinsic SST(elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTableau
{Create a SST with range = number of boxes}
    T := Tableau(elts);
    return SST(T, Weight(T));
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]], n::RngIntElt) -> SSTableau
{Create a SST with prescribed range given its skew shape}
    return SST(Tableau(skew, elts), n);
end intrinsic;

intrinsic SST(skew::SeqEnum[RngIntElt], elts::SeqEnum[SeqEnum[RngIntElt]]) -> SSTableau
{Create a SST given its skew shape with range = number of boxes}
    T := Tableau(skew, elts);
    return SST(T, Weight(T));
end intrinsic;

// CREATION OF SPECIAL TABLEAUX

intrinsic RowReadingTableau(sh::SeqEnum[RngIntElt]) -> SSTableau
{Return the row reading tableau of given shape}
    require IsPartition(sh): "Shape must be a partition";
    elts := &cat[[[&+sh[1..x]+1..&+sh[1..x+1]]] : x in [0 .. #sh-1]];
    return SST(elts);
end intrinsic;

intrinsic ColumnReadingTableau(sh::SeqEnum[RngIntElt]) -> SSTableau
{Return the column reading tableau of given shape}
    require IsPartition(sh): "Shape must be a partition";
    return Conjugate(RowReadingTableau(ConjugatePartition(sh)));
end intrinsic;

// BASIC ATTRIBUTES

intrinsic Rows(T::SSTableau) -> SeqEnum[SeqEnum[RngIntElt]]
{Return the rows of T}
    return [Eltseq(x) : x in Rows(T`Tab)];
end intrinsic;

intrinsic Range(T::SSTableau) -> RngIntElt
{Return the range of T}
    return T`Range;
end intrinsic;

intrinsic Shape(T::SSTableau) -> SeqEnum[RngIntElt]
{Return the shape of T}
    return Shape(T`Tab);
end intrinsic;

intrinsic SkewShape(T::SSTableau) -> SeqEnum[RngIntElt]
{Return the skew shape of T}
    return SkewShape(T`Tab);
end intrinsic;

intrinsic IsSkew(T::SSTableau) -> BoolElt
{Return whether T is a skew tableau}
    return IsSkew(T`Tab);
end intrinsic;

intrinsic Weight(T::SSTableau) -> SeqEnum[RngIntElt]
{Return the crystal weight, i.e. content of T}
    elts := &cat(Rows(T));
    return [#[x : x in elts | x eq k] : k in [1..T`Range]];
end intrinsic;

intrinsic IsStandard(T::SSTableau) -> BoolElt
{Return whether the tableau is standard, nonskew, and has the correct range}
    return T`Range gt 0 and Weight(T) eq [1 : x in [1..T`Range]] and not IsSkew(T`Tab);
end intrinsic;

intrinsic Conjugate(T::SSTableau) -> SSTableau
{Return the conjugate of the tableau}
    require IsStandard(T`Tab): "Tableau must be standard";
    return SST(Conjugate(T`Tab), T`Range);
end intrinsic;

intrinsic RowReadingWord(T::SSTableau) -> SeqEnum[RngIntElt]
{Return the row-reading word of T, from bottom-to-top and left-to-right}
    return &cat(Reverse(Rows(T)));
end intrinsic;

intrinsic 'eq'(R::SSTableau, T::SSTableau) -> BoolElt
{Check equality. Tableaux must have same range to be equal}
    return R`Tab eq T`Tab and R`Range eq T`Range;
end intrinsic;

intrinsic Print(T::SSTableau, L::MonStgElt)
{Print T at level L}
    rows := Rows(T);
    // Gap required between entries
    n := 1 + #IntegerToString(T`Range);
    // Create a string which prints the elements of the tableau"
    tabstring := "";
    for r in [1..#SkewShape(T`Tab)] do
        // Add "-" for any skew elements
        tabstring cat:= &cat([""] cat ["-" cat &cat[" " : y in [1..n-1]] : x in [1..SkewShape(T`Tab)[r]]]);
        // Add the tableau elements
        tabstring cat:= &cat([""] cat [IntegerToString(i) cat &cat[" " : y in [1..n-#IntegerToString(i)]] : i in rows[r]]);
        tabstring := Substring(tabstring,1,#tabstring-1) cat "\n";
    end for;
    // If maximal, print the shape and range
    if L eq "Maximal" then
        if IsSkew(T) then
            printf "Tableau with shape %o / %o and range %o.\n%o", Shape(T`Tab), SkewShape(T`Tab), T`Range, tabstring;
        else
            printf "Tableau with shape %o and range %o.\n%o", Shape(T`Tab), T`Range, tabstring;
        end if;
    // Otherwise, just print the elements of the tableau
    else
        printf"%o", tabstring;
    end if;
end intrinsic;

intrinsic '+'(P::SSTableau, Q::SSTableau) -> SSTableau
{Compose two skew tableaux by joining them together}
    require [x : x in SkewShape(Q`Tab) | x gt 0] eq Shape(P`Tab): "Shapes must match for composition";
    rowsP := Eltseq(P`Tab);
    rowsQ := [[x + P`Range : x in row] : row in Eltseq(Q`Tab)];
    elts := [rowsP[r] cat rowsQ[r] : r in [1..#rowsP]] cat rowsQ[#rowsP+1..#rowsQ];
    return SST(SkewShape(P`Tab), elts, P`Range + Q`Range);
end intrinsic;

// ACTIONS

intrinsic JeuDeTaquin(T::SSTableau, i::RngIntElt, j::RngIntElt) -> SSTableau, RngIntElt, RngIntElt
{Perform jdt, and record the vacated cell}
    shT := Shape(T`Tab);
    R := JeuDeTaquin(T`Tab, i, j);
    shR := Shape(R) cat [0];
    // Row with difference between Shape(R) and Shape(T)
    row := Index([shT[x] - shR[x] : x in [1 .. #shT]], 1);
    return SST(R,T`Range), row, shT[row];
end intrinsic;

intrinsic InverseJeuDeTaquin(T::SSTableau, i::RngIntElt, j::RngIntElt) -> SSTableau, RngIntElt, RngIntElt
{Perform inverse jdt, and record the vacated cell}
    skT := SkewShape(T`Tab) cat [0];
    R := InverseJeuDeTaquin(T`Tab, i, j);
    skR := SkewShape(R);
    // Row with difference between SkewShape(R) and SkewShape(T)
    row := Index([skR[x] - skT[x] : x in [1 .. #skR]], 1);
    return SST(R,T`Range), row, skR[row];
end intrinsic;

intrinsic Rectify(T::SSTableau) -> SSTableau, SeqEnum[RngIntElt], SeqEnum[RngIntElt]
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

intrinsic InverseRectify(T::SSTableau, rows::SeqEnum[RngIntElt], cols::SeqEnum[RngIntElt]) -> SSTableau
{Unrectify T along a given path}
    require #rows eq #cols: "Length of rows and columns must be the same";
    R := T;
    for j in [1..#rows] do
        R := InverseJeuDeTaquin(R, rows[j], cols[j]);
    end for;
    return R;
end intrinsic;

intrinsic Evacuation(T::SSTableau) -> SSTableau
{Perform usual evacuation for tableaux, and reversal for skew tableaux}
    if not IsSkew(T) then
        r := Shape(T)[1];
        padding := Reverse([r - Shape(T)[i] : i in [1..#Shape(T)]]);
        // Calculate rows after rotating and reversing values
        elts := Reverse([Reverse([T`Range - x + 1 : x in row]) : row in Rows(T)]);
        X := Rectify(SST(padding,elts,T`Range));
        return X;
    else
        //Rectify, evacuate, unrecity along the same path
        X, vr, vc := Rectify(T);
        return InverseRectify(Evacuation(X), Reverse(vr), Reverse(vc));
    end if;
end intrinsic;

intrinsic Restrict(T::SSTableau, a::RngIntElt, b::RngIntElt) -> SSTableau
{Restrict T to the boxes a,..,b}
    require 1 le a and b le Range(T): "Values must be between 0 and the range of the tableau";
    rows := Rows(T);
    // Find skew shape of new tableaux
    sk := [SkewShape(T)[row] + #[y : y in rows[row] | y lt a] : row in [1..#rows]];
    for row in [1..#rows] do
        rows[row] := [x-a+1 : x in rows[row] | x ge a and x le b];
    end for;
    return SST(sk, rows, b-a+1);
end intrinsic;

intrinsic Restrict(T::SSTableau, comp::SeqEnum[RngIntElt]) -> SeqEnum[SSTableau]
{Decompose T into skew parts according to a composition}
    require &and[x ge 0 : x in comp]: "Composition must be nonnegative";
    require &+comp eq Range(T): "Sum of parts in composition must be range of tableau";
    intervals := CompositionToIntervals(comp);
    return [Restrict(T, x[1], x[2]) : x in intervals];
end intrinsic;

intrinsic Restrict(T::SSTableau, parabolic::SetEnum[RngIntElt]) -> SeqEnum[SSTableau]
{Decompose T into skew parts according to a subset of generators}
    require parabolic subset {1..T`Range}: "Generators must be between 1 and Range(T)-1";
    intervals := ParabolicToIntervals(parabolic, T`Range);
    return [Restrict(T, x[1], x[2]) : x in intervals];
end intrinsic;

intrinsic Evacuation(T::SSTableau, a::RngIntElt, b::RngIntElt) -> SSTableau
{Act on T by the cactus involution corresponding to I=[a,b]}
    require 1 le a and a le b and b le Range(T): "Values must be between 1 and the range of the tableau";
    decomp := Restrict(T, [a-1, b-a+1, Range(T)-b]);
    // Evacuate middle component and recombine
    return decomp[1] + Evacuation(decomp[2]) + decomp[3];
end intrinsic;

intrinsic Evacuation(T::SSTableau, comp::SeqEnum[RngIntElt]) -> SSTableau
{Act on T by the cactus involution corresponding to a composition}
    require &and[x ge 0 : x in comp]: "Composition must be nonnegative";
    require &+comp eq Range(T): "Sum of parts in composition must be range of tableau";
    intervals := CompositionToIntervals(comp);
    R := T;
    for x in intervals do
        R := Evacuation(R, x[1], x[2]);
    end for;
    return R;
end intrinsic;

intrinsic Evacuation(T::SSTableau, parabolic::SetEnum[RngIntElt]) -> SSTableau
{Act on T by the cactus involution corresponding to a parabolic}
    require parabolic subset {1..T`Range}: "Generators must be between 1 and Range(T)-1";
    intervals := ParabolicToIntervals(parabolic, T`range);
    R := T;
    for x in intervals do
        R := Evacuation(R, x[1], x[2]);
    end for;
    return R;
end intrinsic;

intrinsic Promotion(T::SSTableau) -> SSTableau
{Calculate the Scchützenberger promotion of T}
    require not IsSkew(T): "Promotion only applies to nonskew tableaux";
    return Evacuation(Evacuation(T, 1, Range(T)-1));
end intrinsic;

intrinsic NestedEvacuation(T::SSTableau) -> SSTableau
{Calculate the nested evacuation of T}
    require not IsSkew(T): "Nested evacuation only applies to nonskew tableaux";
    R := T;
    for j in [1..Range(T)] do
        R := Evacuation(R, 1, j);
    end for;
    return R;
end intrinsic;

// CRYSTAL STATISTICS AND DUAL EQUIVALENCE

intrinsic IsKnuthEquivalent(R::SSTableau, T::SSTableau) -> BoolElt
{Determine whether two tableaux are Knuth equivalent, i.e. slides get from one to the other}
    require R`Range eq T`Range: "Tableaux must have the same range";
    return Rectify(R) eq Rectify(T);
end intrinsic;

intrinsic IsDualEquivalent(R::SSTableau, T::SSTableau) -> BoolElt
{Determine whether two tableaux are dual equivalent, i.e. connected in their tableau crystal}
    require R`Range eq T`Range: "Tableaux must have the same range";
    if Shape(R`Tab) eq Shape(T`Tab) then
        X, Rvacrow, Rvaccol := Rectify(R);
        Y, Tvacrow, Tvaccol := Rectify(T);
        return Rvacrow eq Tvacrow and Rvaccol eq Tvaccol;
    else
        return false;
    end if;
end intrinsic;

intrinsic HighestWeight(T::SSTableau) -> SeqEnum[RngIntElt]
{Return the highest weight of the crystal component connected to T}
    sh := Shape(Rectify(T));
    return sh cat [0 : x in [1..Range(T)-#sh]];
end intrinsic;

intrinsic HighestWeight(T::SSTableau, a::RngIntElt, b::RngIntElt) -> SeqEnum[RngIntElt]
{Return the highest weight of the component connected to T of the crystal restricted to [a,b]}
    require 1 le a and a le b and b le Range(T): "Values must be between 1 and the range of the tableau";
    return HighestWeight(Restrict(T,a,b));
end intrinsic;

intrinsic HighestWeight(T::SSTableau, comp::SeqEnum[RngIntElt]) -> SeqEnum[SeqEnum[RngIntElt]]
{Return the list of highest weights for connected components of T corresponding to a composition}
    require &and[x ge 0 : x in comp]: "Composition must be nonnegative";
    require &+comp eq Range(T): "Sum of parts in composition must be range of tableau";
    intervals := CompositionToIntervals(comp);
    return [HighestWeight(T,x[1],x[2]) : x in intervals];
end intrinsic;

intrinsic HighestWeight(T::SSTableau, parabolic::SetEnum[RngIntElt]) -> SeqEnum[SeqEnum[RngIntElt]]
{Return the list of highest weights for connected components of T corresponding to a parabolic}
    require parabolic subset {1..T`Range}: "Generators must be between 1 and Range(T)-1";
    intervals := ParabolicToIntervals(parabolic, T`Range);
    return [HighestWeight(T,x[1],x[2]) : x in intervals];
end intrinsic;

intrinsic PartitionDominanceLoE(p::SeqEnum[RngIntElt], q::SeqEnum[RngIntElt]) -> BoolElt
{Determine dominance order on two partitions}
    require IsPartition(p) and IsPartition(q): "Sequences must be partitions";
    require #p eq #q: "Partitions must have same length";
    return &and([&+p[1..i] le &+q[1..i] : i in [1 .. #p]]);
end intrinsic;

intrinsic HighestWeightLoE(R::SSTableau, T::SSTableau) -> BoolElt
{Check dominance order for tableaux weights}
    require R`Range eq T`Range: "Tableaux must have same range";
    return PartitionDominanceLoE(HighestWeight(R), HighestWeight(T));
end intrinsic;

intrinsic HighestWeightLoE(R::SSTableau, T::SSTableau, a::RngIntElt, b::RngIntElt) -> BoolElt
{Check dominance order for tableaux weights with respect to the interval [a,b]}
    return PartitionDominanceLoE(HighestWeight(R, a, b), HighestWeight(T, a, b));
end intrinsic;

intrinsic HighestWeightLoE(R::SSTableau, T::SSTableau, comp::SeqEnum[RngIntElt]) -> BoolElt
{Check dominance order for tableaux weights with respect to a composition}
    hwR := HighestWeight(R, comp);
    hwT := HighestWeight(T, comp);
    return &and[PartitionDominanceLoE(hwR[i], hwT[i]) : i in [1..#hwR]];
end intrinsic;

intrinsic HighestWeightLoE(R::SSTableau, T::SSTableau, parabolic::SetEnum[RngIntElt]) -> BoolElt
{Check dominance order for tableaux weights with respect to a parabolic}
    hwR := HighestWeight(R, parabolic);
    hwT := HighestWeight(T, parabolic);
    return &and[PartitionDominanceLoE(hwR[i], hwT[i]) : i in [1..#hwR]];
end intrinsic;

// MISC FUNCTIONS

intrinsic InverseRSK(P::SSTableau, Q::SSTableau) -> SeqEnum[RngIntElt]
{Compute the permutation which gives this pair under RSK}
    require IsStandard(P) and IsStandard(Q): "Tableaux must be standard";
    return Eltseq(InverseRSKCorrespondenceSingleWord(P`Tab, Q`Tab));
end intrinsic;

// CLASSES OF TABLEAUX

intrinsic SetOfSYT(shape::SeqEnum[RngIntElt]) -> SetEnum[SSTableau]
{Create the set of standard tableaux with given shape}
    return {SST(T, Weight(T)) : T in StandardTableaux(shape)};
end intrinsic;

intrinsic SetOfSSYT(shape::SeqEnum[RngIntElt], range::RngIntElt) -> SetEnum[SSTableau]
{Create the set of semistandard tableaux with given shape and range}
    require IsPartition(shape): "Shape must be a partition";
    require range ge #shape: "Range must be at least the number of rows";
    return {SST(T, range) : T in TableauxOfShape(shape, range)};
end intrinsic;

intrinsic SetOfSSYT(shape::SeqEnum[RngIntElt], content::SeqEnum[RngIntElt]) -> SetEnum[SSTableau]
{Create the set of semistandard tableaux with given shape and content}
    require IsPartition(shape): "Shape must be a partition";
    require #content ge #shape: "Number of labels must be at least the number of rows";
    require &+content eq &+shape: "Sum of contents must equal size of shape";
    return {SST(T, #content) : T in TableauxOnShapeWithContent(shape, content)};
end intrinsic;

intrinsic DualEquivalenceClass(T::SSTableau) -> SetEnum[SSTableau]
{Return the set of tableaux dual equivalent to T}
    R, vacrow, vaccol := Rectify(T);
    return {InverseRectify(X, Reverse(vacrow), Reverse(vaccol)) : X in SetOfSSYT(Shape(R), Range(R))};
end intrinsic;

intrinsic DualEquivalenceClassStandard(T::SSTableau) -> SetEnum[SSTableau]
{Return the set of standard skew tableaux dual equivalent to T}
    R, vacrow, vaccol := Rectify(T);
    return {InverseRectify(X, Reverse(vacrow), Reverse(vaccol)) : X in SetOfSYT(Shape(R))};
end intrinsic;
