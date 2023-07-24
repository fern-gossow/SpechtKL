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