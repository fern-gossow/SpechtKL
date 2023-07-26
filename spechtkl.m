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

intrinsic MuCoefficient(v::GrpFPCoxElt, w::GrpFPCoxElt) -> RngIntElt
{Return the mu coefficient between Coxeter group elements}
    require Parent(v) eq Parent(w): "Permutations must be from the same group";
    l := Length(w) - Length(v);
    if l mod 2 eq 0 then
        return 0;
    else if l ge 0 then
        return Coefficient(KLPolynomial(v,w), Round((l-1)/2));
    else
        return Coefficient(KLPolynomial(w,v), Round((-l-1)/2));
    end if;
end intrinsic;

intrinsic MuCoefficientMatrix(elts::SeqEnum[GrpFPCox]) -> AlgMatElt
{Return matrix of mu coefficients between Coxeter group elements}
    M := ZeroMatrix(Integers(), #elts, #elts);
    for i in [1..#elts] do
        for j in [1..i-1] do
            mu := MuCoefficient(elts[i], elts[j]);
            M[i,j] := mu;
            M[j,i] := mu;
        end for;
    end for;
    return M;
end intrinsic;