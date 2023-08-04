// A package for computing the KL matrices specialised to v=q=1. 

// Requires sst.m

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
    return S, W, h;
end intrinsic;

intrinsic MuCoefficient(v::GrpFPCoxElt, w::GrpFPCoxElt) -> RngIntElt
{Return the mu coefficient between Coxeter group elements}
    require Parent(v) eq Parent(w): "Permutations must be from the same group";
    l := Length(w) - Length(v);
    if l mod 2 eq 0 then
        return 0;
    elif l ge 0 then
        return Coefficient(KLPolynomial(v,w), Round((l-1)/2));
    else
        return Coefficient(KLPolynomial(w,v), Round((-l-1)/2));
    end if;
end intrinsic;

intrinsic MuCoefficientMatrix(elts::SeqEnum[GrpFPCoxElt]) -> AlgMatElt
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

intrinsic KLRepresentationMatrices(elts::SeqEnum[GrpFPCoxElt]) -> SeqEnum[AlgMatElt]
{Generator matrices of KL representation for an ordered list of Coxeter elements}
    W := Parent(elts[1]);
    require &and[Parent(elt) eq W : elt in elts]: "All elements must be from the same group";
    M := MuCoefficientMatrix(elts);
    // Initialise generator matrices
    S := [ZeroMatrix(Integers(), #elts, #elts) : k in [1..#Generators(W)]];
    for i in [1..#elts] do
        for j in [1..#elts] do
            // Calculate coeff of C_w in s_k . C_v
            v := elts[i];
            w := elts[j];
            if v eq w then
                for k in LeftDescentSet(W, v) do
                    S[k][j,i] := -1;
                end for;
                for k in {1 .. #Generators(W)} diff LeftDescentSet(W, v) do
                    S[k][j,i] := 1;
                end for;
            else
                mu := M[i,j];
                for k in ({1..#Generators(W)} diff LeftDescentSet(W,v)) meet LeftDescentSet(W,w) do
                    S[k][j,i] := mu;
                end for;
            end if;
        end for;
    end for;
    return S;
end intrinsic;

intrinsic KLRepresentation(elts::SeqEnum[GrpFPCoxElt]) -> SeqEnum[AlgMatElt]
{Representation given by the KL basis}
    W := Parent(elts[1]);
    return Representation(GModule(W, KLRepresentationMatrices(elts)));
end intrinsic;

intrinsic TableauxToCoxeter(tabs::SeqEnum[SSTab]) -> SeqEnum[GrpFPCoxELt]
{Turn a sequence of tableaux into a sequence of Coxeter elements with a given Q}
    n := &+Weight(tabs[1]);
    sh := Shape(tabs[1]);
    require &and[Shape(T) eq sh : T in tabs]: "All tableaux must be the same shape";
    require &and[IsStandard(T) : T in tabs]: "All tableaux must be standard and nonskew";
    S, W, h := SymmetricGroupData(n);
    perms := [&cat[Reverse(x) : x in Rows(Conjugate(T))] : T in tabs];
    elts := [h(S ! w) : w in perms];
    return elts, S, W, h;
end intrinsic;