# SpechtKL
_A MAGMA package for computing with the Kazhdan-Lusztig basis of Specht modules. Early development and WIP._

## Introduction

`SpechtKL` is a package for the computer-algebra programming language [MAGMA](http://magma.maths.usyd.edu.au/magma/), which adds a number of features for working with semistandard tableaux, and provides more accessibility to studying Kazhdan-Lusztig theory in Type A. This allows for the computation of examples as appears in [a paper](https://arxiv.org/pdf/2306.08857.pdf) by Fern Gossow (myself) and Oded Yacobi.

## Mathematical Background

Chapter 5 of this paper concerns the Kazhdan-Lusztig basis of irreducible representations of the symmetric group. It is proven that certain permutations act nicely on this basis. More precisely, when $w\in S_n$ is a *separable permutation*, it acts on the Kazhdan-Lusztig basis of the Specht module $S^\lambda$ (indexed by standard tableaux) by a bijection up to lower-order terms with respect to some preorder. This bijection and preorder change with $w$.

The most important examples are when $w$ is the longest element of a parabolic subgroup $J$ of $S_n$. In this case, the bijection is given by the Schützenberger operator applied to the tableau crystal corresponding to $\lambda$ restricted to $J$, and the preorder is naturally described by the dominance order applied to the connected components of this same crystal. A major motivation for this package is to allow one to compute this bijection and preorder directly.

## File Structure

The `package` folder contains a working MAGMA package with the following files:
- `spec` which is the file which tells MAGMA to install the files inside `SpechtKL`.
- `sst.m` defines the new type SSTableau, which works very similar to the regular `Tableau`, which includes as an attribute the maximum value of the tableau. This is required when defining the evacuation operation.
- `spechtkl.m` allows one to convert tableaux to Coxeter elements, calculate mu coefficients and hence determine the symmetric group representation with a given basis of standard tableaux. All representations are assumed to be specialised to $q=1$.
- `bijlot.m` contains intrinsics for determining and finding bijections up to lower-order terms for actions on a vector space (as defined by square matrices). It also provides functions for sorting tableaux by their (restricted) crystal weight.

The `other` folder will contain currently in-development tools and MAGMA code for related computations.

## Installation

If you already have a user-package folder for MAGMA, copy the contents of `package` into this folder, and append the contents of `spec` to your spec file. Otherwise, copy the contents of the `package` folder into a new folder in your MAGMA directory. You will have to tell MAGMA to look for the spec file by creating/setting the system environment variable `MAMGA_USER_SPEC` to the location of this spec file. More information is available on the [MAGMA page](http://magma.maths.usyd.edu.au/magma/handbook/text/24).

## Overview

### Tableaux

The important new data type is `SSTableau`, which essentially seeks to overwrite the `Tableau` class of MAGMA. This tableau can be initiated by `SST(T)`, where `T` a `Tableau` object. By default, the new `Range` intrinsic is set to the number of boxes of `T`, but can be changed by initiating the tableau with `SST(T,n)` instead. Similarly, one can create `SSTableau` objects with the same syntax as tableau objects, optionally setting the range as the final parameter.

A number of statistics can be read from these new tableaux objects: try `Rows`, `Range`, `Shape`, `SkewShape`, `IsSkew`, `Conjugate` and `RowReadingWord`. The function `Weight` now returns the crystal weight (i.e. content), and `IsStandard` checks whether the tableaux is standard of nonskew shape and has range equal to the number of boxes.

Given two tableaux with matching skew shapes, the `+` operator can be used to compose them, as in the following example (note the shift in values):

$$\begin{matrix}
 & 1 & 2 & 2 \\
1 & 2 \\
3\end{matrix}\quad+\quad\begin{matrix}
 & & & & 1 \\
 & & 1 & 1 & 2 \\
 & 2\end{matrix}\quad=\quad\begin{matrix}
 & 1 & 2 & 2 & 4\\
1 & 2 & 4 & 4 & 5\\
3 & 5\end{matrix}$$

Note that the skew shape of the second tableau must equal the shape of the first tableau for them to be added together.

The operations `JeuDeTaquin` (specifying an inside box to slide into), `InverseJeuDeTaquin` (specifying an outside box) and `Rectify` are all provided. These return the box or boxes that are vacated during the slide. By giving a list of boxes, one can perform this sequence of slides to determine the `InverseRectify`. From this we obtain the comparison `IsDualEquivalent` and `DualEquivalenceClass`.

Most importantly, we are able to restrict tableau to skew tableaux. Given `Restrict(T,a,b)`, one determines the skew tableau $T\vert_{[a,b]}$ obtained by restricting `T` to the boxes in the interval $[a,b]$. Similarly, one can provide a composition of `n` (where $n$ is the number of boxes in $T$) in `Restrict(T,comp)` to obtain a list of skew tableaux split up according to the composition. Finally, given a subset `parabolic` of $\{1,\dots,n-1\}$, one can call `Restrict(T,parabolic)` to restrict `T` into parts according to the standard parabolic subgroup.

From this, one can perform `Evacuation` on each skew piece. Again, one can specify the endpoints of the interval, the composition, or the parabolic. Likewise `HighestWeight` gives the weight of the highest component connected to `T` in the restricted crystal, and `HighestWeightLoE`, gives a dominance-order comparison between the weights of two tableaux. We also have `SortByHighestWeight`, which is applied to a list of tableaux.

Finally, given a shape, one can generate `SetOfSYT` or `SetOfSSYT` (one can specify the range or content), which generates a set of `SSTableau` objects.

### Specht Module

The function `SymmetricGroupCoxeter(n)` returns the Coxeter group of type $\mathrm{A}_{n-1}$ isomorphic to $S_n$. Given a sequence `w` representing a permutation of ${1,...,n}$ and a Coxeter group `W\cong S_n` of the correct type, `PermutationToCoxeter(w, W)` returns the permutation as an element of `W`.

The `MuCoefficient` function determines the symmetrised coefficient $\mu[u,v]$ for two elements of the Coxeter group, and `MuCoefficientMatrix` gives the table of such coefficients given a list of elements. This allows one to define the Kazhdan-Lusztig basis action matrices in `KLRepresentationMatrices`. It is assumed that the given elements form a subrepresentation. Finally, `KLRepresentation` gives this as an element of the type `Map`, and one can call functions such as `Domain` and `Codomain`.

For the symmetric group, the irreducible representations are written in terms of tableaux. The function `TableauxToCoxeter` takes a sequence of `SSTableau` objects (all of which are standard) and returns Coxeter group elements representing them. Similarly, `KLRepresentation` outputs the map from the relevant symmetric group (as a Coxeter group) to the matrix representations.

The function `SpechtModule` provides a shortcut to this, where the map is list of tableaux is returned. For example, to calculate the action of the longest element on the Specht module $S^\lambda$ where $\lambda=[3,2]$.

```
Sp, tabs := SpechtModule([3,2]);
W := Domain(Sp);
w0 := Sp(LongestElement(W));
w0;
```

### Bijections up to lower-order terms

Given a matrix $M$, if $M=PR$ for some permutation matrix $P$ and an upper-triangular matrix $R$, then $P$ is unique. The function `LowerOrderBijection` returns this permutation if it exists, or `[]` otherwise. Similarly, `SearchLowerOrderBijection` tries all $n!$ rearrangements of the basis vectors to determine if the given matrix acts by a bijection up to lower-order terms on any rearrangement of this basis. This function is fairly slow on large matrices.

For example, with the above code, one should check that the longest element indeed acts by the evacuation operation.

```
p := LowerOrderBijection(w0);
ev := [Index(tabs, Evacuation(T)) : T in tabs];
p eq ev;
```

The above code should output `true`. Also check this with other shapes!

The permutation $s_1s_3s_2=[2,4,1,3,5]$ is not separable. One can check that this element does not act by bijection up to lower-order terms on any ordering of the KL basis.

```
w := W.1 * W.3 * W.2;
SearchLowerOrderBijection(Sp(w));
```

The above code should return `[], []`, meaning it did not find a bijection up to lower-order terms.

### Coming Soon

- Decompose a separable permutation into a product of longest elements
- $Z$-orderings, and hence testing the separability conjecture
- Add `CrystalUp` and `CrystalDown` operators to the `SSTableau` class
- Return the set of skew tableaux of a given shape (requires enumerating the Littlewood-Richardson tableaux)
- Given a matrix which acts by some bijection up to l.o.t., determine the partial order on the basis elements such that we get a bijection up to l.o.t. on any linearisation of this partial order (is there a minimal one?)