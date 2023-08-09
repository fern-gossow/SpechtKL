// A package for computing the KL matrices specialised to v=q=1. 

// Requires sst.m

intrinsic SymmetricGroupCoxeter(n::RngIntElt) -> GrpFPCox
{Return the Coxeter group of type A(n-1), i.e. the symmetric group}
    require n ge 2: "Size must be at least 2";
    W := CoxeterGroup(GrpFPCox, "A" cat IntegerToString(n-1));
    return W;
end intrinsic;

intrinsic PermutationToCoxeter(perm::SeqEnum[RngIntElt], W::GrpFPCox) -> GrpFPCoxElt
{Rewrite a permutation (in sequence form) to a Coxeter element}
    require #perm eq #Generators(W)+1: "Size must equal rank of W+1";
    require Sort(perm) eq [1..#perm]: "Must be a permutation";
    prm := perm;
    elt := W.0;
    while not prm eq [1..#perm] do
        i := Minimum([j : j in [1..#prm-1] | prm[j] gt prm[j+1]]);
        // Swap prm[i] and prm[i+1]
        k := prm[i];
        prm[i] := prm[i+1];
        prm[i+1] := k;
        // Multiply the elt by W.i on the left
        elt := W.i*elt;
    end while;
    return elt;
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

intrinsic KLRepresentation(elts::SeqEnum[GrpFPCoxElt]) -> Map
{Representation given by the KL basis}
    W := Parent(elts[1]);
    return Representation(GModule(W, KLRepresentationMatrices(elts)));
end intrinsic;

intrinsic TableauxToCoxeter(tabs::SeqEnum[SSTab]) -> SeqEnum[GrpFPCoxElt]
{Turn a sequence of tableaux into a sequence of Coxeter elements with a given Q}
    n := &+Weight(tabs[1]);
    sh := Shape(tabs[1]);
    require &and[Shape(T) eq sh : T in tabs]: "All tableaux must be the same shape";
    require &and[IsStandard(T) : T in tabs]: "All tableaux must be standard and nonskew";
    // Create the parent group
    W := SymmetricGroupCoxeter(n);
    // This assumes w = InverseRSK(T, Q) with Q the column-reading word
    perms := [&cat[Reverse(x) : x in Rows(Conjugate(T))] : T in tabs];
    elts := [PermutationToCoxeter(w, W) : w in perms];
    return elts;
end intrinsic;

intrinsic KLRepresentation(tabs::SeqEnum[SSTab]) -> Map
{Representation given by the KL basis on a sequence of tableaux}
    elts := TableauxToCoxeter(tabs);
    return KLRepresentation(elts);
end intrinsic;

intrinsic SpechtModule(sh::SeqEnum[RngIntElt]) -> Map, SeqEnum[SSTab]
{Given a shape, return the Specht module with KL basis}
    tabs := [T : T in SetOfSYT(sh)];
    return KLRepresentation(tabs), tabs;
end intrinsic;
