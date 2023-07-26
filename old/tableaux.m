// Actions, orders and constructions on standard (skew) Young tableaux


// ACTIONS

// Perform jdt and record the vacated cell.
JeuDeTaquinCell := function(T, i, j)
    shT := Shape(T);
    R := JeuDeTaquin(T, i, j);
    shR := Shape(R) cat [0];
    // Row with difference between Shape(R) and Shape(T)
    row := Index([shT[x] - shR[x] : x in [1 .. #shT]], 1);
    return R, row, shT[row];
end function;

// Perform inverse jdt and record the vacated cell.
InverseJeuDeTaquinCell := function(T, i, j)
    skT := SkewShape(T) cat [0];
    R := InverseJeuDeTaquin(T, i, j);
    skR := SkewShape(R);
    // Row with difference between SkewShape(R) and SkewShape(T)
    row := Index([skR[x] - skT[x] : x in [1 .. #skR]], 1);
    return R, row, skR[row];
end function;

// Rectify T and record the path of removed cells
RectifyPath := function(T);
    R := T;
    vacrows := [];
    vaccols := [];
    while IsSkew(R) do
        // Find largest possible cell to slide into
        i := Max([x : x in [1..#SkewShape(R)] | SkewShape(R)[x] gt 0]);
        j := SkewShape(R)[i];
        R, r, c := JeuDeTaquinCell(R, i, j);
        Append(~vacrows, r);
        Append(~vaccols, c);
    end while;
    return R, vacrows, vaccols;
end function;

// Unrectify T along a path of outside cells
InverseRectifyPath := function(T, rows, cols);
    assert #rows eq #cols;
    R := T;
    for j in [1..#rows] do
        R := InverseJeuDeTaquin(R, rows[j], cols[j]);
    end for;
    return R;
end function;

// Evacuate a nonskew tableau by rotating and rectifying
Evacuate := function(T : n := Weight(T));
    assert not IsSkew(T);
    r := Shape(T)[1];
    padding := Reverse([r - Shape(T)[i] : i in [1..#Shape(T)]]);
    rows := [Eltseq(x) : x in Rows(T)];
    X := Tableau(padding, Reverse([Reverse([n - y + 1 : y in x]) : x in rows]));
    return Rectify(X);
end function;

// Evacuate a skew tableaux preserving dual equivalence, also called reversal
SkewEvacuate := function(T : n := Weight(T));
    assert IsStandard(T);
    X, vr, vc := RectifyPath(T);
    return InverseRectifyPath(Evacuate(X : n := n),Reverse(vr),Reverse(vc));
end function;

// Create a skew tableau by restricting T to the values between a and b
RestrictTableau := function(T,a,b);
    assert 1 le a and a le b and b le Weight(T);
    rows := [Eltseq(x) : x in Rows(T)];
    // Find skew shape of new tableaux
    sk := [SkewShape(T)[x] + #[y : y in rows[x] | y lt a] : x in [1..#rows]];
    for j in [1..#rows] do
        rows[j] := [x-a+1 : x in rows[j] | x ge a and x le b];
    end for;
    return Tableau(sk, rows);
end function;

// Compose the two skew tableaux
ComposeTableau := function (P, Q : n := Weight(P))
    assert [x : x in SkewShape(Q) | x gt 0] eq Shape(P);
    rowsP := Eltseq(P);
    rowsQ := [[x + n : x in row] : row in Eltseq(Q)];
    elts := [rowsP[r] cat rowsQ[r] : r in [1..#rowsP]] cat rowsQ[#rowsP+1..#rowsQ];
    return Tableau(SkewShape(P), elts);
end function;

// Compose list of tableaux
ComposeTableaux := function(tablist)
    assert #tablist ge 1;
    T := tablist[1];
    for X in tablist[2 .. #tablist] do
        T := TabCompose( T, X );
    end for;
    return T;
end function;

// Write tableau as a list of skew tableaux given by alpha
DecomposeTableau := function(T, comp)
    assert &+comp eq Weight(T);
    comp := [0] cat comp;
    return [TabRestrict(T, &+comp[1..i]+1, &+comp[1..i+1]) : i in [1 .. #comp-1]];
end function;

// Cactus group action indexed by the interval I = [a,b]
CactusInvolution := function(T, a, b)
    assert 1 le a and a le b and b le Weight(T);
    decomp := TabDecompose( T, [a-1, b-a+1, Weight(T)-b]);
    // Evacuate the middle component
    decomp[2] := SkewEvacuate(decomp[2] : n := b-a+1);
    return ComposeTableaux(decomp);
end function;

    //---CONSTRUCTION---//

// 1 .. n placed row-by-row into a Young tableau
RowReadingTab := function( p )
    rows := &cat[ [[ &+p[1..x]+1 .. &+p[1..x+1] ]] : x in [0 .. #p-1] ];
    return Tableau( rows );
end function;

// 1 .. n placed column-by-column into a Young tableau
ColumnReadingTab := function( p )
    return Conjugate( RowReadingTab(ConjugatePartition(p)) );
end function;

// Inverse RSK with column reading tableau
TabToPerm := function( T )
    w := InverseRSKCorrespondenceSingleWord( T, ColumnReadingTab( Shape(T) ) );
    return w;
end function;

    //---STATISTICS---//

// Give row and column of k
TabLocate := function( T, k )
    assert k ge 1 and k le Weight(T);
    c, r := Maximum([ Index(row, k) : row in Eltseq(T) ]);
    return <r, c + SkewShape(T)[r]>;
end function;

// Return the set of descents of T
TabDescent := function( T )
    row_with := [ TabLocate( T, k )[1] : k in [1..Weight(T)]];
    return { k : k in [1..Weight(T)-1] | row_with[k] lt row_with[k+1] };
end function;

// Return the row reading word of T (left-to-right, bottom-to-top)
TabRowWord := function( T )
    return &cat( Reverse( Eltseq(T) ) );
end function;

// This will be the inverse RSK correspondence with Q = ColumnReadingTab
TabColWord := function( T )
    return Reverse( TabRowWord( Conjugate(T) ) );
end function;

    //---ACTIONS---//

// Compose the two skew tableaux
TabCompose := function ( P, Q )
    assert [x : x in SkewShape(Q) | x gt 0] eq Shape(P);
    rowsP := Eltseq(P);
    rowsQ := [ [ x + Weight(P) : x in row ] : row in Eltseq(Q) ];
    elts := [ rowsP[r] cat rowsQ[r] : r in [1..#rowsP] ] cat rowsQ[#rowsP+1..#rowsQ];
    return Tableau( SkewShape(P), elts );
end function;

// Compose list of tableaux
TabComposeList := function ( tabs )
    T := tabs[1];
    for X in tabs[2 .. #tabs] do
        T := TabCompose( T, X );
    end for;
    return T;
end function;

// Return the skew tableau of elements between a and b
TabRestrict := function( T, a, b )
    elts := Eltseq( T );
    // Find skew shape after deletion
    sk := [ SkewShape(T)[r] + #[x : x in elts[r] | x lt a] : r in [1..#elts] ];
    // Remaining elements
    rows := [ [ x-a+1 : x in row | x ge a and x le b ] : row in elts ];
    ChangeUniverse(~rows, Universe([[1]])); // Avoid MAGMA complaining about empty sequence being in an arbitrary universe
    return Tableau(sk, rows);
end function;

// Take the alpha-decomposition of a tableau into a list of skews
TabDecompose := function( T, alpha )
    assert &+alpha eq &+Shape(T);
    alpha := [0] cat alpha;
    return [ TabRestrict( T, &+alpha[1..i]+1, &+alpha[1..i+1] ) : i in [1 .. #alpha-1] ];
end function;

// Perform jeu-de-taquin in either direction, record vacated cell
jdt := function ( T, cell )
    // Check inside corner
    if cell[1] le #SkewShape(T) and cell[2] le SkewShape(T)[cell[1]] then
        R := JeuDeTaquin( T, cell[1], cell[2] );
        m,r := Max([Shape(T)[r] - (Shape(R) cat [0])[r] : r in [1..#Shape(T)]]);
        vac := [ r, Shape(T)[r] ];
    else
        R := InverseJeuDeTaquin( T, cell[1], cell[2] );
        m,r := Max([SkewShape(R)[r] - (SkewShape(T) cat [0])[r] : r in [1..#SkewShape(R)]]);
        vac := [ r, SkewShape(R)[r] ];
    end if;
    return R,vac;
end function;

// Rectify and return list of removed cells
rect := function( T )
    R := T;
    vac := [];
    while &+SkewShape(R) gt 0 do
        // Find bottom row with empty cells
        r := Max([ i : i in [1..#SkewShape(R)] | SkewShape(R)[i] gt 0 ]);
        // Take end of this column
        c := SkewShape(R)[r];
        R,v := jdt( R, <r,c> );
        vac := vac cat [v];
    end while;
    return R, vac;
end function;

// Give list of cells to unrectify along
unrect := function( T, vac )
    for v in vac do
        T := jdt( T, v );
    end for;
    return T;
end function;

// Evacuate tableau to get same shape
ev := function( T )
    R := T;
    E := [[] : row in Eltseq(T) ];
    while Weight(R) gt 0 do
        nbox := TabLocate( R, 1 );
        R, v := jdt( TabRestrict(R, 2, Weight(R)), nbox );
        // Append n-k+1 of removed box to E
        E[v[1]] := [ Weight(R)+1 ] cat E[v[1]];
    end while;
    return Tableau( SkewShape(T), E );
end function;

// Rectify, evacuate, unrectify
skev := function( T )
    R, vac := rect( T );
    return unrect( ev(R), Reverse(vac) );
end function;

// Promotion
pr := function( T )
    nbox := TabLocate( T, Weight(T) );
    R,v := jdt( TabRestrict( T, 1, Weight(T) - 1), nbox );
    b := [ChangeUniverse([], Universe([1])) : r in [1..v[1]-1]] cat [[1]];
    box := Tableau( SkewShape(T), b );
    return TabCompose( box, R );
end function;

// ith Bender-Knuth involution on T
bk := function ( T, i )
    x := TabLocate( T, i );
    y := TabLocate( T, i+1 );
    if x[1] eq y[1] or x[2] eq y[2] then
        return T;
    else
        elts := Eltseq( T );
        elts[x[1]][x[2] - SkewShape(T)[x[1]]] := i+1;
        elts[y[1]][y[2] - SkewShape(T)[y[1]]] := i;
        return Tableau( SkewShape(T), elts );
    end if;
end function;

// Cactus group action indexed by the interval I = [a,b]
cact := function( T, a, b )
    decomp := TabDecompose( T, [a-1, b-a+1, Weight(T)-b]);
    // evacuate middle component
    decomp[2] := skev( decomp[2] );
    return TabComposeList( decomp );
end function;

// Generate all skew tableaux of given shape, this can take a while
SkewTableaux := function ( sk, sh )
    return {TabRestrict(T,1+(&+sk),&+sh) : T in StandardTableaux( sh ) | TabRestrict(T,1,&+sk) eq RowReadingTab(sk)};
end function;

    //---ORDERS---//

// Dominance Order on Partitions
PDomLoE := function( p, q )
    // Pad q with necessary zeros
    q := q cat &cat[ [0] : x in [1..Max( 0, #p - #q )] ];
    return &and([ &+p[1..i] le &+q[1..i] : i in [1 .. #p] ]);
end function;

// Dominance Order on Tableaux
TabDomLoE := function( R, T : except := {} )
    assert Weight(R) eq Weight(T);
    return &and[PDomLoE(Shape(TabRestrict(R, 1, k)), Shape(TabRestrict(T, 1, k))) : k in [1..Weight(R)] | k in except eq false ];
end function;

// Check dual equivalence of skew tableaux
TabDualEquivalent := function( R, T )
    S, v1 := rect( R );
    S, v2 := rect( T );
    return Shape( R ) eq Shape( T ) and v1 eq v2;
end function;

// Ordering of skew tableaux from
SkewLoE := function( P, Q )
    sh1 := Shape( rect(P) );
    sh2 := Shape( rect(Q) );
    if sh1 eq sh2 then
        return TabDualEquivalent( P, Q );
    else
        return PDomLoE( sh1, sh2 );
    end if;
end function;

// Ordering of tableaux by testing each skew tableaux
DecompLoE := function( P, Q, alpha );
    assert Shape( P ) eq Shape( Q );
    Pd := TabDecompose( P, alpha );
    Qd := TabDecompose( Q, alpha );
    Pwt := [ Shape(rect(X)) : X in Pd ];
    Qwt := [ Shape(rect(X)) : X in Qd ];

    if Pwt eq Qwt then
      return &and[ TabDualEquivalent( Pd[j], Qd[j] ) : j in [1..#alpha] ];
    else
      return &and[ PDomLoE( Pwt[j], Qwt[j] ) : j in [1..#alpha] ];
    end if;
end function;

    //---SUBGROUPS OF TABLEAUX PERMUTATIONS---//

// Find the subgroup of cactus involutions in Sym(SYT(sh))
CactusSubgroup := function( sh )
    SYT := StandardTableaux( sh );
    G := Sym( SYT );
    elts := { G ! 1 };
    for x in [<a,b> : a in [1..&+sh], b in [1..&+sh] | b ge a+2 ] do
        elts := elts join {G ! [cact( T, x[1], x[2] ) : T in SYT ]};
    end for;
    return sub< G | elts >, G;
end function;

// Calculate the Berenstein-Kirillov subgroup generaed by bk involutions
BKSubgroup := function( sh )
    SYT := StandardTableaux( sh );
    G := Sym( SYT );
    elts := { G ! 1 };
    for x in [1..&+sh-1] do
        elts := elts join {G ! [bk( T, x ) : T in SYT ]};
    end for;
    return sub< G | elts >, G;
end function;
