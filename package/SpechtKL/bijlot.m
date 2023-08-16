// Find and test bijections up to l.o.t.

// BIJECTIONS UP TO LOWER-ORDER TERMS

intrinsic LowerOrderBijection(M::AlgMatElt) -> SeqEnum[RngIntElt]
{If M acts by a bijection up to l.o.t., return the permutation, else return []}
    require NumberOfRows(M) eq NumberOfColumns(M): "Matrix must be square";
    n := NumberOfRows(M);
    pivots := [Min([i : i in [1..n] | row[i] ne 0] cat [n+1]) : row in Rows(M)];
    if Sort(pivots) eq [1..n] and &and[IsUnit(M[i,pivots[i]]) : i in [1..n]] then
        // Return the inverse permutation of nonzero entries
        return [Index(pivots,i) : i in [1..n]];
    else
        return [];
    end if;
end intrinsic;

intrinsic PermuteRowsAndColumns(M::AlgMatElt, p::SeqEnum[RngIntElt]) -> AlgMatElt
{Rewrite M after applying a permutation to the standard basis}
    require NumberOfRows(M) eq NumberOfColumns(M): "Matrix must be square";
    require Sort(p) eq [1..NumberOfRows(M)]: "If M is an n x n matrix, p must be a permutation of 1..n";
    q := [Index(p, i) : i in [1..#p]]; // Inverse permutation
    return PermutationMatrix(Integers(), p) * M * PermutationMatrix(Integers(), q);
end intrinsic;

intrinsic SearchLowerOrderBijection(M::AlgMatElt) -> SeqEnum[RngIntElt], SeqEnum[RngIntElt]
{If M acts by a bijection up to l.o.t., return the bijection and the ordering of the basis}
    n := NumberOfRows(M);
    for x in Permutations({1..n}) do
        bij := LowerOrderBijection(PermuteRowsAndColumns(M ,x));
        if #bij gt 0 then
            S := SymmetricGroup(n);
            return Eltseq((S ! x) * (S ! bij) * Inverse(S ! x)), x;
        end if;
    end for;
    // If no permutation of the standard basis gives a bijection up to l.o.t.
    return [], [];
end intrinsic;

// SORTING TABLEAUX BY HIGHEST WEIGHT

// Assign a unique integer to each partition for the purposes of sorting
function PartitionCompare(p, q)
    assert IsPartition(p) and IsPartition(q);
    assert #p eq #q;
    for i in [1..#p] do
        if p[i] ne q[i] then
            return p[i] - q[i];
        end if;
    end for;
    return 0;
end function;

intrinsic SortByHighestWeight(tabs::SeqEnum[SSTableau]) -> SeqEnum[SSTableau]
{Sort tableaux by their highest weight}
    return Sort(tabs, func< R,T | PartitionCompare(HighestWeight(R), HighestWeight(T)) >);
end intrinsic;

intrinsic SortByHighestWeight(tabs::SeqEnum[SSTableau], a::RngIntElt, b::RngIntElt) -> SeqEnum[SSTableau]
{Sort tableaux by their highest weight with respect to the interval [a,b]}
    return Sort(tabs, func< R,T | PartitionCompare(HighestWeight(R, a, b), HighestWeight(T, a, b))>);
end intrinsic;

intrinsic SortByHighestWeight(tabs::SeqEnum[SSTableau], comp::SeqEnum[RngIntElt]) -> SeqEnum[SSTableau]
{Sort tableaux by their highest weight with respect to a composition}
    return Sort(tabs, func< R,T | PartitionCompare(HighestWeight(R, comp), HighestWeight(T, comp))>);
end intrinsic;

intrinsic SortByHighestWeight(tabs::SeqEnum[SSTableau], parabolic::SetEnum[RngIntElt]) -> SeqEnum[SSTableau]
{Sort tableaux by their highest weight with respect to a composition}
    return Sort(tabs, func< R,T | PartitionCompare(HighestWeight(R, parabolic), HighestWeight(T, parabolic))>);
end intrinsic;

// DECOMPOSING SEPARABLE PERMUTATIONS

// Recursive function for computing the chain decomposition of the inverse of w
function SeparableDecompositionRec(w)
    if #w le 1 then
        return true, [];
    else
        for i in [1..#w-1] do
            // Non-inversion cut
            if Sort(w[1..i]) eq [Min(w)..Min(w)+i-1] then
                sep1, chain1 := $$(w[1..i]);
                sep2, chain2 := $$(w[i+1..#w]);
                if sep1 and sep2 then
                    return true, chain1 cat chain2;
                else
                    return false, [];
                end if;
            // Inversion cut
            elif Sort(w[1..i]) eq [Max(w)-i+1..Max(w)] then
                sep1, chain1 := $$(Reverse(w)[1..#w-i]);
                sep2, chain2 := $$(Reverse(w)[#w-i+1..#w]);
                if sep1 and sep2 then
                    return true, [[Min(w),Max(w)]] cat chain1 cat chain2;
                else
                    return false, [];
                end if;
            end if;
        end for;
        return false, [];
    end if;
end function;

intrinsic IsSeparable(w::SeqEnum[RngIntElt]) -> BoolElt, SeqEnum[SeqEnum[RngIntElt]]
{Determine whether w is separable, and if so, give the chain of longest elements (described by intervals) whose composition is w}
    require Sort(w) eq [1..#w]: "w must be a permutation";
    // Take the inverse and call the recursive function
    return SeparableDecompositionRec([Index(w,i) : i in [1..#w]]);
end intrinsic;

intrinsic SeparableElementAction(T::SSTableau, w::SeqEnum[RngIntElt]) -> SSTableau
{Act on a tableau T by the chain of evacuation elements corresponding to w}
    require Sort(w) eq [1..Range(T)]: "w must be a permutation of [1..Range(T)]";
    is_sep, chain := IsSeparable(w);
    require is_sep: "w must be a separable permutation";
    R := T;
    for interval in Reverse(chain) do
        R := Evacuation(R, interval[1], interval[2]);
    end for;
    return R;
end intrinsic;