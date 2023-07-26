# SpechtKL
_A MAGMA package for computing with the Kazhdan-Lusztig basis of Specht modules._

## Introduction

`SpechtKL` is a package for the computer-algebra programming language MAGMA, which adds a number of additional features for working with semistandard tableaux, and provides more accessibility to studying Kazhdan-Lusztig theory in Type A. The features provided in this package run parallel to results obtained in [a paper](https://arxiv.org/pdf/2306.08857.pdf) by Fern Gossow (myself) and Oded Yacobi.

Chapter 5 of this paper concerns the Kazhdan-Lusztig basis of irreducible representations of the symmetric group. It is proven that certain permutations act nicely on this basis. More precisely, when $w\in S_n$ is a *separable permutation*, it acts on the Kazhdan-Lusztig basis of the Specht module $S^\lambda$ (indexed by standard tableaux) by a bijection up to lower-order terms with respect to some preorder. This bijection and preorder change with $w$.

The most important examples are when $w$ is the longest element of a parabolic subgroup $J$ of $S_n$. In this case, the bijection is given by the Schützenberger operator applied to the tableau crystal corresponding to $\lambda$ restricted to $J$, and the preorder is naturally described by the dominance order applied to the connected components of this same crystal. A major motivation for this package is to allow one to compute this bijection and preorder directly.
