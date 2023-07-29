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
    // Require w to be a permutation
    for i in [1..#w] do
        if Seqset(w[1..i]) eq {1..i} then
            return i,1;
        elif Seqset(w[1..i]) eq {#w-i+1..#w} then
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

// function SeparableGraph(w);
//     if #w eq 1 then
//         // Return empty graph with a single
//         G := Digraph<{@<[i,i], "0">@} | >
//         return G, Vertices(G) ! <[i,i],"0">;
//     else
//         i, type := FindSeparableCut(w);
//         if i eq #w then
//             return Digraph<{@<[0],"x">@} | >;
//         // Noninversion cut, add + to graph
//         elif type eq 1 then
//             G1, u := SeparableGraph(w[1..i]);
//             G2, v := SeparableGraph(w[i+1..#w]);
//             G := Union(G1,G2);
//             AddVertex(~G, <[1,#w],"+">)
//             w := Vertices(G) ! <[1,#w], "+">;
//             AddEdge(~G, w, u);
//             AddEdge(~G, w, v);
//             return G, w;