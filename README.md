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

The `other` folder will contain currently in-development tools and MAGMA code for related computations.

## Installation

If you already have a user-package folder for MAGMA, copy the contents of `package` into this folder, and append the contents of `spec` to your spec file. Otherwise, copy the contents of the `package` folder into a new folder in your MAGMA directory. You will have to tell MAGMA to look for the spec file by creating/setting the system environment variable `MAMGA_USER_SPEC` to the location of this spec file. More information is available on the [MAGMA page](http://magma.maths.usyd.edu.au/magma/handbook/text/24).
