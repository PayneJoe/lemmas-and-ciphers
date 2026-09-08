# Vector Spaces

## Definition 

TODO

## Subspace

**Sum of subspaces** 

*Definition : Given two subspaces `U` and `V` of a vector space, their sum `U + V` is defined as the set of all vectors that can be written as the sum of a vector from `U` and a vector from `V`*
$$
U + V = \{ u + v \mid u \in U, v \in V \}.
$$

Sum of subspaces is the smallest subspace of the vector space that contains both `U` and `V`, which is analogous to the union of sets in set theory but within the context of vector spaces.

<br />

**Direct-sum of family of subspaces**

*Definition : Given a family of subspaces `{U_i}` of a vector space, their direct sum `⊕ U_i` is defined as the set of all vectors that can be uniquely written as the sum of vectors from each `U_i`*

$$
\bigoplus_i U_i = \left\{ \sum_i u_i \mid u_i \in U_i \text{ and this representation is unique} \right\}.
$$

Note that direct-sum is a stronger condition than the ordinary sum of subspaces, as it requires the representation of each vector as a sum of vectors from the subspaces to be unique.

<br />

The natural question arises: how can we determine if a given family of subspaces forms a direct sum? Do we need to check the uniqueness of the representation for every vector individually? The answer is provided by the following criterion.

*Criterion : The direct sum of a family of subspaces `{U_i}` holds if and only if the only way to represent the zero vector as a sum of vectors from each `U_i` is by taking all vectors to be zero.*

Proof : TODO

<br />

**Direct-sum of two subspaces**

*Definition : Given two subspaces `U` and `V` of a vector space, their direct sum `U ⊕ V` is defined as the set of all vectors that can be uniquely written as the sum of a vector from `U` and a vector from `V`*
$$
U \oplus V = \{ u + v \mid u \in U, v \in V \text{ and this representation is unique} \}.
$$

*Criterion : The direct sum `U ⊕ V` holds if and only if the intersection of `U` and `V` is `{0}`.*

$$
U \cap V = \{0\}.
$$

Proof : TODO

<br />

# Finite-dimensional

## Span and Linear Independence

### Linear combinations and span

**Span**

*Definition : The span of a set of vectors `S` in a vector space `V` is the set of all linear combinations of the vectors in `S`*
$$
\text{span}(S) = \left\{ \sum_{v \in S} a_v v \mid a_v \in F \right\}.
$$

Properties of span:
1. $\text{span}(S)$ is a subspace of the vector space `V`.
2. $\text{span}(S)$ is the smallest subspace containing the set `S`.

Proof: TODO

<br />

The following natural question arises: how large can the span of a set of vectors be in a vector space?

**Span of vector space**

*Definition : A vector space `V` is said to be spanned by a set of vectors `S` if every vector in `V` can be written as a linear combination of the vectors in `S`*
$$
V = \text{span}(S).
$$

If a vector space is spanned by a (finite) set of vectors `S` in it, then we say this vector space is finite-dimensional.

<br />

The following natural question arises : is there a unique way to represent every vector in a vector space `V` as a linear combination of a given set of vectors `S`?

### Linear independence

**Linear Independence**

*Definition : A set of vectors `S` in a vector space `V` is said to be linearly independent if the only way to represent the zero vector as a linear combination of the vectors in `S` is by taking all coefficients to be zero.*
$$
\sum_{v \in S} a_v v = 0 \Leftrightarrow a_v = 0 \text{ for all } v \in S.
$$

<br />

**Linear dependence**

*Definition : A set of vectors `S` in a vector space `V` is said to be linearly dependent if it is not linearly independent, i.e., there exists a non-trivial linear combination of the vectors in `S` that equals the zero vector.*
$$
\sum_{v \in S} a_v v = 0 \text{ with some } a_v \neq 0.
$$

<br />

**Linear dependence lemma**

*Lemma : Suppose `v1, v2, ..., vm` is linearly dependent vectors in vector space `V`, then there exists a vector `v_k` that can be written as a linear combination of the preceding vectors.*
$$
v_k \in \text{span}\{v_1, v_2, \ldots, v_{k-1}\} \text{ for some } k \in \{1, 2, \ldots, m\}.
$$
*Furthermore, if `v_k` is removed from the set `{v_1, v_2, \ldots, v_m}`, the remaining set still spans the same subspace as the original set. That is*
$$
\text{span}\{v_1, v_2, \ldots, v_m\} = \text{span}\{v_1, v_2, \ldots, v_{k-1}, v_{k+1}, \ldots, v_m\}.
$$

Proof: TODO

<br />

**Finite-dimensional subspace**

*Lemma : Every subspace of a finite-dimensional vector space is finite-dimensional.*

Proof: TODO

<br />

The relationship between linear independence and span of vector space can be summarized as follows:

1. The length of a linearly independent set of vectors in a vector space `V` cannot exceed the length of a spanning set of `V`.
2. The bridge between linearly independent set and spanning set is bases.

## Bases

**Basis**

*Definition : A set of vectors `B` in a vector space `V` is called a basis of `V` if `B` is linearly independent and `V` is spanned by `B`.*
$$
V = \text{span}(B), \quad B \text{ is linearly independent}.
$$

*Criterion : A set of vectors `B` in a vector space `V` is a basis of `V` if and only if every vector in `V` can be uniquely represented as a linear combination of the vectors in `B`.*
$$
v = \sum_{b_i \in B} a_i \cdot b_i \quad \text{with unique coefficients } a_i \in \mathbb{F}.
$$

Proof : TODO

*Lemma : Every spanning set of a vector space `V` contains a basis of `V`.*

Proof : TODO

*Lemma : Every finite-dimensional vector space `V` has a basis.*

Proof : TODO

*Lemma : Every linearly independent set of vectors in a vector space `V` can be extended to a basis of `V`.*

Proof : TODO

*Lemma : Every subspace of `V` is part of a direct-sum equals `V`. That is, if `U` is a subspace of `V`, then there exists a subspace `W` of `V` such that*
$$
V = U \oplus W.
$$

Proof : TODO

<br />

The natural question arises: Given a vector space `V`, there are many bases, what is the common property (or invariant) of all bases? The interesting fact is that all bases of a vector space have the same number of elements. This number is called the dimension of `V`.

## Dimension

*Lemma : Any two bases of a finite-dimensional vector space `V` have the same number of elements.*

Proof : TODO

*Definition : The dimension of a finite-dimensional vector space `V` is the number of elements in any basis of `V`.*
$$
\dim(V) = \text{number of elements in any basis of } V.
$$

<br />

*Lemma : The dimension of a subspace `U` of a finite-dimensional vector space `V` satisfies*
$$
\dim(U) \leq \dim(V).
$$

Proof : TODO

<br />

*Lemma : Every linearly independent set of vectors in a finite-dimensional vector space `V` of length `dim V` is a basis of `V`.*

Proof : TODO

*Lemma : Subspace of finite-dimensional vector space `V` of length `dim V` is equal to `V`.*

Proof : TODO

*Lemma : Spanning set of a finite-dimensional vector space `V` of length `dim V` is a basis of `V`.*

Proof : TODO

<br />

If `V1` and `V2` are finite-dimensional vector spaces, then the dimension of their sum satisfies
$$
\dim(V1 + V2) = \dim(V1) + \dim(V2) - \dim(V1 \cap V2).
$$
more specially, if `V1 \cap V2 = \{0\}`, then
$$
\dim(V1 + V2) = \dim(V1) + \dim(V2).
$$


Proof : TODO