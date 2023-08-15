// Find and test bijections up to l.o.t.

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