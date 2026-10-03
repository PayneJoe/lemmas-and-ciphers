
In complexity theory, we say a problem is hard if it it hard for the worst-case instance; while in cryptography, a problem is deemed hard only if it is hard for the average-case instance (i.e., for all but a negligible fraction of instances).

# Basics

**Definition of a Lattice**

Let $\mathbb{R}^m$ be the $m$-dimensional Euclidean (inner product) space. A lattice in $\mathbb{R}^m$ is the set 
$$
\mathcal{L}(b_1, ..., b_n) = \left\{ \sum_{i=1}^{n} z_i b_i \mid z_i \in \mathbb{Z} \right\}
$$
of all integer linear combinations of the basis vectors $b_1, ..., b_n$, where $n \le m$ is the rank of the lattice, and $m$ is the dimension of the lattice.

> [!Note]
> Note that the vector (Euclidean) space is defined over field $\mathbb{R}$, but the lattice itself is defined over the integers $\mathbb{Z}$. I think this is a fundamental difference between lattice and general subspace. Because lattice is discrete, it is only restricted to "integer span" of the basis vectors, whereas subspace is defined over the entire field $\mathbb{R}$ and can take arbitrary linear combinations of the basis vectors.

<br />

There are many different ways to represent a lattice, depending on the choice of basis vectors.

For example, 
|               One Basis               |                  Another Basis                  |
| :-----------------------------------: | :---------------------------------------------: |
| ![A lattice](img/a-lattice-in-r2.png) | ![A different basis](img/a-different-basis.png) |