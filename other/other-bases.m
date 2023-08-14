// Test whether other representations of the symmetric group have bijections up to l.o.t.

procedure LowerOrderBijections(sh)
    S := Sym(&+sh);
    JK := {w : w in Permutations({1..&+sh}) | #SearchLowerOrderBijection(SymmetricRepresentation(sh, S ! w : Al := "JamesKerber")) eq 0};
    Sp := {w : w in Permutations({1..&+sh}) | #SearchLowerOrderBijection(SymmetricRepresentation(sh, S ! w : Al := "Specht")) eq 0};
    Bo := {w : w in Permutations({1..&+sh}) | #SearchLowerOrderBijection(SymmetricRepresentation(sh, S ! w : Al := "Boerner")) eq 0};

    JK, Sp, Bo;
end procedure;


function findBijection(sh, w, Al)
    bij := SearchLowerOrderBijection(SymmetricRepresentation(sh, Sym(#w) ! w : Al := Al));
    return bij;
end function;

for w in Permutations({1..4}) do
    w;
    bij := SearchLowerOrderBijection(SymmetricRepresentationSeminormal([3,1], Sym(#w) ! w));
    bij;
    "";
end for;