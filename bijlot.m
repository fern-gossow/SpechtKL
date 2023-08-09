// Find and test bijections up to lower-order terms (LOB)
// Currently don't test for coefficient, but can add this

// Determine if M acts by l.o.t. on the standard basis, return the perm
function IsLowerOrderBijection(M)
    // Take columns, add buffer value
    R := [Eltseq(r) cat [1] : r in Rows(M)];
    nonzero := [Minimum([i : i in [1..#R+1] | r[i] ne 0]) : r in R];
    if {x : x in nonzero} eq {1..#R} then
        // Return the inverse permutation of nonzero entries
        return [Index(nonzero,i) : i in [1..#nonzero]];
    else
        // If no such bijection, return an empty list
        return [];
    end if;
end function;

// Determine if M acts by l.o.t. for any ordering of the standard basis
function HasLowerOrderBijection(M)
    S := SymmetricGroup(NumberOfRows(M));
    // This is possible in exponential time
    for x in Permutations({1..NumberOfRows(M)}) do
        p := S ! x;
        P := PermutationMatrix(Integers(), p);
        Q := PermutationMatrix(Integers(), Inverse(S ! p));
        bij := IsLowerOrderBijection(P * M * Q);
        if #bij gt 0 then
            return Eltseq(p * (S ! bij) * Inverse(p)), Eltseq(p);
        end if;
    end for;
    // If no bijections are found
    return [], [];
end function;