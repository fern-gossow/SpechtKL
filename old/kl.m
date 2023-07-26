// Computing mu values and permutation actions on KL basis

load "SpechtKL/tableaux.m";

// Return symmetric and coxeter groups of order n!
SymmetricGroup := function( n )
    S := SymmetricGroup( n );
    W := CoxeterGroup( GrpFPCox, "A" cat IntegerToString(n-1) );
    if n eq 2 then
        h := hom< S -> W | [ W.1 ] >;
    else
        h := hom< S -> W | [ Inverse(CoxeterElement(W)), W.1 ]>;
    end if;
    k := hom< S -> W | x :-> Inverse( h(x) ) >;
    return S,W,k;
end function;

// Convert list of permutations to Coxeter elements
PermutationsToCoxeter := function( perms )
    // Check all have equal length
    n := #perms[1];
    assert &and([ #v eq n : v in perms ]);
    S,W,k := SymmetricGroup(n);
    return [k(S ! v) : v in perms], W;
end function;

// List of SYT to permutations (using column-strict tableau)
TableauxToPermutations := function( tabs )
    return [ TabColWord( T ) : T in tabs ];
end function;

//---CALCULATE GENERATORS OF KL ACTION---//

// Find mu coefficient between permutations
MuCoefficient := function(v,w)
    l := Length(w) - Length(v);
    if l mod 2 eq 0 then
        return 0;
    end if;
    if l ge 0 then
        return Coefficient(KLPolynomial(v,w), Round((l-1)/2));
    else
        return Coefficient(KLPolynomial(w,v), Round((-l-1)/2));
    end if;
end function;

// Return table of mu values
MuCoefficientTable := function( cox )
    M := ZeroMatrix( Integers(), #cox, #cox );
    for i in [1..#cox] do
        for j in [1..i-1] do
            mu := MuCoefficient( cox[i], cox[j] );
            M[i,j] := mu;
            M[j,i] := mu;
        end for;
    end for;
    return M;
end function;

// Generator matrices of KL representation for the permutations
KLRepresentationMatrices := function( perms )
    cox, W := PermutationsToCoxeter( perms );
    M := MuCoefficientTable( cox );
    // initialise generator matrices
    S := [ZeroMatrix( Integers(), #cox, #cox ) : k in [1..#Generators(W)] ];
    for i in [1..#cox] do
        for j in [1..#cox] do
            // Calculate coeff of C_w in s_k . C_v
            v := cox[i];
            w := cox[j];
            // If v = w
            if v eq w then
                for k in LeftDescentSet( W, v ) do
                    S[k][j,i] := -1;
                end for;
                for k in {1 .. #Generators(W)} diff LeftDescentSet( W, v ) do
                    S[k][j,i] := 1;
                end for;
            // v != w
            else
                mu := M[i,j];
                for k in ( {1..#Generators(W)} diff LeftDescentSet(W,v) ) meet LeftDescentSet(W,w) do
                    S[k][j,i] := mu;
                end for;
            end if;
        end for;
    end for;
    return S;
end function;

// Give KL representation over SYT(lambda)
SpechtModule := function( sh )
    tabs := SetToSequence( StandardTableaux(sh) );
    perms := TableauxToPermutations( tabs );
    return KLRepresentationMatrices( perms ), tabs;
end function;

// Give KL representation over SYT(lambda/mu)
SkewSpechtModule := function( sk, sh );
    tabs := SetToSequence( SkewTableaux(sk, sh) );
    perms := TableauxToPermutations( tabs );
    return KLRepresentationMatrices( perms ), tabs;
end function;


