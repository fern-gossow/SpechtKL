// A package for computing the KL matrices. This requires sst.m

intrinsic SymmetricGroupData(n::RngIntElt) -> GrpPerm, GrpFPCox, Map
{Return the symmetric group, it's Coxeter presentation, and a map between them}
    require n ge 2: "Size must be at least 2";
    S := SymmetricGroup(n);
    W := CoxeterGroup(GrpFPCox, "A" cat IntegerToString(n-1));
    if n eq 2 then
        k := hom<S -> W | [ W.1 ] >;
    else
        k := hom<S -> W | [Inverse(CoxeterElement(W)), W.1]>;
    end if;
    h := hom<S -> W | x :-> Inverse(k(x))>;
    return S,W,h;
end intrinsic;

//intrinsic PermutationsToCoxeter(SeqEnum[SeqEnum[RngIntElt]])

intrinsic bean(n::BoolElt)
{Checks for bean}
    if n then
        "bean";
    else
        "not bean";
    end if;
end intrinsic
