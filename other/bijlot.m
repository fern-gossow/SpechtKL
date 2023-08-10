// Find and test bijections up to lower-order terms (LOB)

// Determine if M acts by l.o.t. on the standard basis, return the perm
function LowerOrderBijection(M)
    // Take rows, add buffer value
    n := NumberOfRows(M);
    pivots := [Min([i : i in [1..n] | row[i] ne 0] cat [n+1]) : row in Rows(M)];
    if Sort(pivots) eq [1..n] and &and[IsUnit(M[i,pivots[i]]) : i in [1..n]] then
        // Return the inverse permutation of nonzero entries
        return [Index(pivots,i) : i in [1..n]];
    else
        // If no such bijection, return an empty list
        return [];
    end if;
end function;

// Rewrite M after applying apermutation to the standard basis
function PermuteRowsAndColumns(M, p)
    assert Sort(p) eq [1..NumberOfRows(M)];
    // Calculate the inverse permutation
    q := [Index(p, i) : i in [1..#p]];
    return PermutationMatrix(Integers(), p) * M * PermutationMatrix(Integers(), q);
end function;

// Determine if M acts by l.o.t. for any ordering of the standard basis
function SearchLowerOrderBijection(M)
    n := NumberOfRows(M);
    // This is possible in exponential time
    for x in Permutations({1..n}) do
        bij := LowerOrderBijection(PermuteRowsAndColumns(M ,x));
        if #bij gt 0 then
            S := SymmetricGroup(n);
            return Eltseq((S ! x) * (S ! bij) * Inverse(S ! x)), x;
        end if;
    end for;
    // If no bijections are found
    return [], [];
end function;

// Recursive function to determine whether a permutation string is separable
function IsSeparable(x)
    if #x eq 1 then
        return true;
    end if;
    for i in [1..#x-1] do
        // Non-inversion cut
        if SequenceToSet(x[1..i]) eq {1..i} then
            return $$(x[1..i]) and $$([y-i : y in x[i+1..#x]]);
        elif SequenceToSet(x[1..i]) eq {#x-i+1..#x} then
            return $$([y-#x+i : y in x[1..i]]) and $$(x[i+1..#x]);
        end if;
    end for;
    return false;
end function;

// Test whether only separable elements act by bijection up to l.o.t.
procedure TestSeparableConjecture(sh)
    <"Testing", sh>;
    Sp := SpechtModule(sh);
    W := Domain(Sp);
    for x in Permutations({1..&+sh}) do
        w := PermutationToCoxeter(x, W);
        p := SearchLowerOrderBijection(Sp(w));
        LOB := (#p gt 0); // Has lower order bijection
        sep := IsSeparable(x); // Is separable

        if (not sep) and LOB then
            <x, "LoB, but not separable">;
        elif sep and (not LOB) then
            <x, "Separble, but no LoB">;
        end if;
    end for;
end procedure;

// SORTING HELPERS

// Convert boolean to integer for sorting
SortHelper := function( x, y, comp )
    is_le := 0;
    is_ge := 0; 
    if comp( x, y ) then is_le := 1; end if;
    if comp( y, x ) then is_ge := 1; end if;
    return is_ge - is_le;
end function;

// Return set of equivalence classes for an ordering
EquivalenceClasses := function( X, LoE )
    equivs := [];
    for x in X do
        found := false;
        j := 1;
        while j le #equivs do
            if LoE( x, equivs[j][1] ) and LoE( equivs[j][1], x ) then
                equivs[j] := equivs[j] cat [x];
                j := #equivs;
                found := true;
            end if;
            j := j + 1;
        end while;
        if found eq false then
            equivs[j] := [x];
        end if;
    end for;
    return equivs;
end function;

// Sort equivalence classes
SortedEquivalenceClasses := function( X, LoE )
    equivs := EquivalenceClasses( X, LoE );
    Sort( ~equivs, func<x,y | SortHelper(x[1],y[1], LoE)> );
    return equivs;
end function;

// Sort by a preorder
SortByLoE := function( X, LoE : output := false )
    equivs := SortedEquivalenceClasses( X, LoE );
    if output then
        barrier := &cat["-" : x in [1..40]];
        barrier; barrier;
        for class in equivs do
            for x in class do
                x;
            end for;
            barrier;
        end for;
        barrier;
    end if;
    return &cat(equivs);
end function;