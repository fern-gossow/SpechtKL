// Decompose a separable permutation

// Check whether w is a permutation
function IsPermutation(w)
    return Seqset(w) eq {1..#w};
end function;

// Find all inversion and noninversion cuts
function FindSeparableCuts(w)
    // Require w to be a permutation
    cuts := [0 : x in [1..#w-1]];
    for i in [1..#cuts] do
        // noninversion cut
        if Seqset(w[1..i]) eq {1..i} then cuts[i] := 1;
        // inversion cut
        elif Seqset(w[1..i]) eq {#w-i+1..#w} then cuts[i] := -1;
        end if;
    end for;
    return cuts;
end function;

// Find the first inversion or noninversion cut
function FindSeparableCut(w)
    // Require w to be a permutation on [a..b]
    for i in [1..#w] do
        if Seqset(w[1..i]) eq {Minimum(w)..Minimum(w)+i-1} then
            return i,1;
        elif Seqset(w[1..i]) eq {Maximum(w)-i+1..Maximum(w)} then
            return i,-1;
        end if;
    end for;
end function;

// Add brackets if the length is >1
function AddBrackets(s)
    if #s eq 1 then
        return s;
    else
        return "(" cat s cat ")";
    end if;
end function;

// Returns a separable string for w
function SeparableString(w)
    // If w is not separable
    if #w eq 1 then
        return "1";
    else
        i, type := FindSeparableCut(w);
        // No cut
        if i eq #w then
            return "x";
        // Noninvertible cut
        elif type eq 1 then
            s := SeparableString(w[1..i]);
            t := SeparableString([x-i : x in w[i+1..#w]]);
            return AddBrackets(s) cat "+" cat AddBrackets(t);
        // Invertible cut
        else
            s := SeparableString([x-#w+i : x in w[1..i]]);
            t := SeparableString(w[i+1..#w]);
            return AddBrackets(s) cat "-" cat AddBrackets(t);
        end if;
    end if;
end function;

// Recursion function for determining chain of longest elements
procedure SeparableChainRec(~chain, ~sep, w)
    if #w gt 1 then
        i, type := FindSeparableCut(w);
        // No separable cut
        if i eq #w then
            sep := false;
        // Noninversion .. split and recurse
        elif type eq 1 then
            SeparableChainRec(~chain,~sep,w[1..i]);
            SeparableChainRec(~chain,~sep,w[i+1..#w]);
        // Inversion .. apply long element and then
        else
            // Add elements to first possible place
            elts := {x : x in {Minimum(w)..Maximum(w)-1}};
            disjoint := [j : j in [1..#chain] | elts notsubset chain[j]];
            if #disjoint eq 0 then
                chain cat:= [elts];
            else
                chain[Min(disjoint)] join:= elts;
            end if; 
            Reverse(~w);
            SeparableChainRec(~chain,~sep,w[1..#w-i]);
            SeparableChainRec(~chain,~sep,w[#w-i+1..#w]);
        end if;
    end if;
end procedure;

function SeparableChain(w)
    chain := [];
    sep := true;
    SeparableChainRec(~chain,~sep,w);
    if sep eq true then
        return chain;
    else
        return [];
    end if;
end function;