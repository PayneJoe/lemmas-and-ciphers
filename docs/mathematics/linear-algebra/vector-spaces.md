## Table of Contents
- [Ch01 - Vector Spaces](#ch01---vector-spaces)
  - [Subspace](#subspace)
    - [Sum of Subspaces](#sum-of-subspaces)
    - [Direct Sums](#direct-sums)
- [Ch02 - Finite-Dimensional](#ch02---finite-dimensional)
  - [Span and Linear Independence](#span-and-linear-independence)
    - [Linear combinations and span](#linear-combinations-and-span)
    - [Linear independence](#linear-independence)
  - [Bases](#bases)
  - [Dimension](#dimension)
- [Ch03 - Linear Maps](#ch03---linear-maps)
  - [Vector space of linear maps](#vector-space-of-linear-maps)
  - [Null Space and Ranges](#null-space-and-ranges)
  - [Matrices](#matrices)
    - [Matrix of a linear map](#matrix-of-a-linear-map)
    - [Column-row factoring](#column-row-factoring)
  - [Invertibility and Isomorphisms](#invertibility-and-isomorphisms)
    - [Isomorphic Vector Spaces](#isomorphic-vector-spaces)

# Ch01 - Vector Spaces

## Subspace

### Sum of Subspaces 

**Definition 1.1 - Sum of two subspaces** 

Given two subspaces $U$ and $V$ of some (any) vector space, their sum $U + V$ is defined as the set of all vectors that can be written as the sum of a vector from $U$ and a vector from $V$, that is
$$
U + V = \{ u + v \mid u \in U, v \in V \}.
$$

<br />

> [!Note] 
> Sum of subspaces $U$ and $V$ is the smallest subspace that contains both $U$ and $V$, which is analogous to the union of sets in set theory but within the context of vector spaces.

<br />

**Definition 1.2 - Sum of a family of subspaces** 

Given a family of subspaces $\{U_i\}$ of a vector space, their sum $\sum_i U_i$ is defined as the set of all vectors that can be written as the sum of vectors from each $U_i$, that is
$$
\sum_i U_i = \left\{ \sum_i u_i \mid u_i \in U_i \right\}.
$$

<br />

> [!Important] 
> Is the representation of any element of sum of subspaces unique or not? In the following section we will focus on this question.

### Direct Sums

**Definition 1.3 - Direct sum of two subspaces** 

Given two subspaces $U$ and $V$ of a vector space, their direct sum $U \oplus V$ is defined as the set of all vectors that can be **uniquely** written as the sum of a vector from $U$ and a vector from $V$, that is
$$
U \oplus V = \{ u + v \mid u \in U, v \in V \text{ and this representation is unique} \}.
$$

<br />

**Definition 1.4 - Direct sum of a family subspaces** 

Given a family of subspaces $\{U_i\}$ of a vector space, their direct sum $\oplus_i U_i$ is defined as the set of all vectors that can be **uniquely** written as the sum of vectors from each $\{U_i\}$, that is
$$
\bigoplus_i U_i = \left\{ \sum_i u_i \mid u_i \in U_i \text{ and this representation is unique} \right\}.
$$

> [!Note]
> Direct-sum is a stronger condition than the ordinary sum of subspaces, as it requires the representation of each vector as a sum of vectors from the subspaces to be **unique**.

<br />

> [!Important] Direct Sum Criterion
How can we determine if a given family of subspaces forms a direct sum? Do we have to check the uniqueness of the representation for every vector individually? 

<br />

**Proposition 1.1 - Criterion for Direct Sum of a Family of Subspaces:** 

The direct sum of a family of subspaces $\{U_i\}$ holds if and only if the only way to represent the zero vector as a sum of vectors from each $U_i$ is by taking all vectors to be zero.

<details>
<summary><strong>Proof Logic </strong> (click to expand)</summary>

This is a $\textcolor{red}{iff}$ problem, meaning we need to show both directions:  
1. **If direction:** Assume the direct sum holds. Show that the only way to represent the zero vector as a sum of vectors from each $U_i$ is by taking all vectors to be zero.  
2. **Only if direction:** Assume the only way to represent the zero vector as a sum of vectors from each $U_i$ is by taking all vectors to be zero. Show that this implies the representation of any vector as a sum of vectors from each $U_i$ is unique.

Regarding the forward direction, it trivially holds $0 = 0 + ... + 0$ is unique representation of zero vector. 

Regarding the backward direction, suppose $v \in V$ has two representations  
$$
v = v_1 + ... + v_n = u_1 + ... + u_n
$$
, then we have
$$
0 = (v_1 - u_1) + ... + (v_n - u_n)
$$
By assumption $0 = 0 + ... + 0$, we have $v_i = u_i$ for all $i$, proving the uniqueness of direct sum.

</details>

<br />

**Proposition 1.2 - Criterion for Direct Sum of Two Subspaces:** 

The direct sum $U \oplus V$ holds if and only if the intersection of sets $U$ and $V$ is $\{0\}$.

$$
U \cap V = \{0\}.
$$

<details>
<summary><strong>Proof Logic </strong> (click to expand)</summary>

This is also a $\textcolor{red}{iff}$ problem, meaning we need to show both directions:  
1. **If direction:** Assume $U \oplus V$ holds. Show that $U \cap V = \{0\}$.  
2. **Only if direction:** Assume $U \cap V = \{0\}$. Show that this implies the representation of any vector in $U + V$ as a sum of vectors from $U$ and $V$ is unique.

Regarding the forward direction, by $\textcolor{red}{contradiction}$ we suppose $U \cap V = \{0, x\}$ for some non-zero vector $x$, then element $x$ has at least two representations which is contradict with the uniqueness of the direct sum.

Regarding the backward direction, the proof is similar to that of Proposition 1.1.

</details>

<br />

# Ch02 - Finite-Dimensional

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

<br />

# Ch03 - Linear Maps

Linear maps is also a vector space. Specifically, if `V` and `W` are vector spaces over the same field `F`, then the set of all linear maps from `V` to `W`, denoted by `Hom(V, W)`, forms a vector space over `F` with pointwise addition and scalar multiplication. In the following section we will discuss this topic in more detail.

## Vector space of linear maps

**Linear Map and Homomorphism**
Linear map of vector spaces is a homomorphism from one vector space to another, preserving addition and multiplication by scalars, where both vector spaces are defined over the same field.

<br />

*Definition : A linear map (or linear transformation) `f` from a vector space `V` to a vector space `W` over the same field `F` is a function `f : V → W` that satisfies*
- Additivity 
    $$
    f(v_1 + v_2) = f(v_1) + f(v_2), \quad \forall v_1, v_2 \in V,
    $$
- Homogeneity 
    $$
    f(a \cdot v) = a \cdot f(v), \quad \forall a \in F, v \in V.
    $$

<br />

*Linear map lemma : Suppose $v_1, ..., v_n$ is a basis of $V$ and $w_1, ..., w_n \in W$. Then there exists a unique linear map $f : V → W$ such that $f(v_i) = w_i$ for all $i = 1, ..., n$.*

**Proof logic**  
We have to show two things : 
1. the existence of a linear map $f : V → W$ such that $f(v_i) = w_i$ for all $i = 1, ..., n$, 
2. the uniqueness of such a linear map.

Regarding 1), it is a $\textcolor{red}{existence}$ statement, we need to $\textcolor{red}{find}$ a proper function of type $f : V \to W$ : 
$$
f (c_1 v_1 + ... + c_n v_n) = c_1 w_1 + ... + c_n w_n
$$
such that it implies $f(v_i) = w_i$ for all $i = 1, ..., n$. Then we need to show that this function satisfies the two properties of linear map: additivity and homogeneity. In this case, we can say that the function $f$ defined above is indeed a linear map from $V$ to $W$.

In terms of 2), it is a $\textcolor{red}{uniqueness}$ statement. In general, two functions are $\textcolor{red}{equal}$ if and only if they agree on any element of the input domain.
So we need to show that if there exists another function $g : V \to W$ such that $g(v_i) = w_i$ for all $i = 1, ..., n$, then $g = f$. This can be done by noting that *any* vector $v \in V$ can be uniquely expressed as a linear combination of the basis vectors $v_1, ..., v_n$, and both $f$ and $g$ must map $v = c_1 v_1 + ... + c_n v_n$ to the same linear combination of $w_1, ..., w_n$.

<br />

**Linear maps as vector space**

*Definition : The set of all linear maps from a vector space $V$ to a vector space $W$ over the same field $F$, denoted by $\text{Hom}(V, W)$, forms a vector space over $F$ with the following operations*:
- **Addition**: For $f, g \in \text{Hom}(V, W)$, define $(f + g)(v) = f(v) + g(v)$ for all $v \in V$.
- **Scalar multiplication**: For $a \in F$ and $f \in \text{Hom}(V, W)$, define $(a \cdot f)(v) = a \cdot f(v)$ for all $v \in V$.

<br />

**Composition (multiplication) of linear maps**

*Definition : The composition (or multiplication) of two linear maps $f : U \to V$ and $g : V \to W$ is the linear map $g \circ f : U \to W$ defined by $(g \circ f)(u) = g(f(u))$ for all $u \in U$.*

Properties of composition of linear maps:
- **Associativity**: If $f : U \to V$, $g : V \to W$, and $h : W \to X$ are linear maps, then $h \circ (g \circ f) = (h \circ g) \circ f$.
- **Identity**: For any vector space $V$, the identity map $\text{id}_V : V \to V$ defined by $\text{id}_V(v) = v$ for all $v \in V$ satisfies $\text{id}_V \circ f = f$ and $g \circ \text{id}_V = g$ for any linear maps $f : U \to V$ and $g : V \to W$.
- **Distributivity**: For linear maps $f, g : U \to V$ and $h : V \to W$, we have $h \circ (f + g) = h \circ f + h \circ g$ and $(f + g) \circ h = f \circ h + g \circ h$.

Note that the composition of linear maps is not commutative in general, i.e., $g \circ f$ may not be equal to $f \circ g$.

<br />

In the following section, let us take a closer look at two special subspace: 
1.  null space (or kernel), of a linear map.
2.  range (or image), of a linear map.
where null space is usually closed related with injectivity of the linear map, and range is usually closely related with surjectivity of the linear map.

## Null Space and Ranges 

*Definition : Let $f : V \to W$ be a linear map. The **null space** (or **kernel**) of $f$ is the set of all vectors in $V$ that are mapped to the zero vector in $W$, denoted by $\text{null}(f)$ or $\ker(f)$:*
$$
\text{null}(f) = \ker(f) = \{ v \in V \mid f(v) = 0 \}.
$$

*Lemma : The null space of a linear map $f : V \to W$ is a subspace of $V$.*

Proof logic: To show a linear map is a subspace, by the definition of subspace, we need to verify three conditions:

1. The existence of identity element: The zero vector $0 \in V$ is in the null space since $f(0) = 0$.
2. Closed under addition: If $u, v \in \text{null}(f)$, then $f(u + v) = f(u) + f(v) = 0 + 0 = 0$, so $u + v \in \text{null}(f)$.
3. Closed under scalar multiplication: If $v \in \text{null}(f)$ and $c \in F$, then $f(c \cdot v) = c \cdot f(v) = c \cdot 0 = 0$, so $c \cdot v \in \text{null}(f)$.

<br />

*Definition : A function $f : V \to W$ is said to be injective (or one-to-one) if for all $u, v \in V$, $f(u) = f(v)$ implies $u = v$.*

*Lemma : A linear map $f : V \to W$ is injective if and only if its null space is $\{0\}$.*

Proof logic: This is a iff $\iff$ statement, so we need to prove both directions:

- **If direction**: Assume $f$ is injective. Then for any $v \in V$, if $f(v) = 0$, we must have $v = 0$. Hence, the null space of $f$ is $\{0\}$.
- **Only if direction**: Assume the null space of $f$ is $\{0\}$. If $f(u) = f(v)$ for some $u, v \in V$, then $f(u) - f(v) = 0$, which implies $f(u - v) = 0$. Since the null space is $\{0\}$, we have $u - v = 0$, and thus $u = v$. Therefore, $f$ is injective.

<br />

*Definition : 
Let $f : V \to W$ be a linear map. The **range** (or **image**) of $f$ is the set of all vectors in $W$ that are mapped from vectors in $V$, denoted by $\text{range}(f)$ or $\text{im}(f)$:*
$$
\text{range}(f) = \text{im}(f) = \{ w \in W \mid w = f(v) \text{ for some } v \in V \}.
$$

<br />

*Lemma : The range of a linear map $f : V \to W$ is a subspace of $W$.*

Proof logic: To show the range is a subspace, we need to verify three conditions:

1. The existence of identity element: The zero vector $0 \in W$ is in the range since $f(0) = 0$ as $0 \in V$.
2. Closed under addition: If $w_1, w_2 \in \text{range}(f)$, then $w_1 = f(v_1)$ and $w_2 = f(v_2)$ for some $v_1, v_2 \in V$. Hence, $w_1 + w_2 = f(v_1) + f(v_2) = f(v_1 + v_2) \in \text{range}(f)$ as $v_1 + v_2 \in V$.
3. Closed under scalar multiplication: If $w \in \text{range}(f)$ and $c \in F$, then $w = f(v)$ for some $v \in V$, and $c \cdot w = c \cdot f(v) = f(c \cdot v) \in \text{range}(f)$ as $c \cdot v \in V$.

<br />

*Definition : 
A linear map $f : V \to W$ is said to be surjective (or onto) if its range is the entire codomain $W$, i.e., $\text{range}(f) = W$.*

<br />

*The **Fundamental Theorem of Linear Maps** states that for any linear map $f : V \to W$, the dimension of the domain $V$ is equal to the sum of the dimensions of the null space and the range of $f$.*
Let $f : V \to W$ be a linear map. Then
$$
\dim V = \dim \text{null}(f) + \dim \text{range}(f).
$$

Proof logic : The statement does not explicit show the dimensions of these three vector spaces, but we can assume that :
1. $u_1, u_2, \dots, u_m$ be a basis for $\text{null}(f)$, where $m = \dim \text{null}(f)$.
2. Since $u_1, ..., u_m$ are independent, we can extend this set to a basis for $V$ by incrementally adding independent vectors $v_1, v_2, \dots, v_n$ such that $u_1, ..., u_m , v_1, ..., v_n$ spans the entire space $V$, where $n = \dim V - m$. Thus, $\{u_1, \dots, u_m, v_1, \dots, v_n\}$ is a basis for $V$.

Now we only need to show that $\dim range(f) = n$, in other words, there $\color{red}{exists}$ a set of $n$ vectors in $\text{range}(f)$ that forms a basis for $\text{range}(f)$. So $\textcolor{red}{finding}$ a proper basis for $\text{range}(f)$ will complete the proof.

Considering the set $\{f(v_1), f(v_2), \dots, f(v_n)\}$. We claim that this set forms a basis for $\text{range}(f)$, by the definition of basis we need to show two things: spanning and linear independence.

1. **Spanning**: Any vector $w \in \text{range}(f)$ can be written as $w = f(v)$ for some $v \in V$. Since $\{u_1, \dots, u_m, v_1, \dots, v_n\}$ is a basis for $V$, we can write $v = a_1 u_1 + \dots + a_m u_m + b_1 v_1 + \dots + b_n v_n$. Applying $f$, we get $w = f(v) = a_1 f(u_1) + \dots + a_m f(u_m) + b_1 f(v_1) + \dots + b_n f(v_n)$. But $f(u_i) = 0$ for all $i$, so $w = b_1 f(v_1) + \dots + b_n f(v_n)$, showing that $\{f(v_1), \dots, f(v_n)\}$ spans $\text{range}(f)$.
2. **Linear independence**: Suppose $c_1 f(v_1) + \dots + c_n f(v_n) = 0$, we only need to show that $c_1 = \dots = c_n = 0$. Then $f(c_1 v_1 + \dots + c_n v_n) = 0$, which means $c_1 v_1 + \dots + c_n v_n \in \text{null}(f)$. Since $\{u_1, \dots, u_m, v_1, \dots, v_n\}$ is a basis for $V$, the vectors $v_1, \dots, v_n$ are independent of the null space basis vectors $u_1, \dots, u_m$. Therefore, $c_1 = \dots = c_n = 0$, proving linear independence.

Hence, $\{f(v_1), \dots, f(v_n)\}$ is a basis for $\text{range}(f)$, and $\dim \text{range}(f) = n$. This completes the proof.

<br />

*Lemma : Linear map to a lower-dimensional space is not injective.*

Proof logic : By $\text{injective} \iff \dim null(f) > 0$, so we only need to show that $\dim null(f) > 0$ for a linear map to a lower-dimensional space.

By the **Fundamental Theorem of Linear Maps**, we have
$$
\dim V = \dim \text{null}(f) + \dim \text{range}(f).
$$
If $f$ maps to a lower-dimensional space, then $\dim \text{range}(f) < \dim V$. Therefore,
$$
\dim \text{null}(f) = \dim V - \dim \text{range}(f) > 0,
$$
which shows that $\dim \text{null}(f) > 0$, proving that $f$ is not injective.

<br />

*Lemma : Linear map to a higher-dimensional space is not surjective.*

Proof logic : By $\text{surjective} \iff \text{range}(f) = W$, again since $\text{range}(f)$ is a subspace of $W$, its dimension cannot exceed that of $W$, so we only need to show that $\dim \text{range}(f) < \dim W$ for a linear map to a higher-dimensional space.

By the **Fundamental Theorem of Linear Maps**, we have
$$
\dim V = \dim \text{null}(f) + \dim \text{range}(f).
$$
If $f$ maps to a higher-dimensional space, then $\dim W > \dim V \ge \dim \text{range}(f)$. Therefore,
$$
\dim \text{range}(f) < \dim W,
$$
which shows that $f$ is not surjective.

<br />

*Lemma : A homogeneous system of linear equations with more variables than equations has a non-zero solution.*

Mark that "homogeneous" means all the constant terms on the right-hand side of the equations are zero.

Proof logic :  
Consider the linear map $f: \mathbb{F}^n \to \mathbb{F}^m$ corresponding to the homogeneous system of linear equations, where $n$ is the number of variables and $m$ is the number of equations. Since $n > m$, we have $\dim \mathbb{F}^n = n > m \ge \dim \text{range}(f)$. By the **Fundamental Theorem of Linear Maps**, 
$$
\dim \mathbb{F}^n = \dim \text{null}(f) + \dim \text{range}(f),
$$
which implies $\dim \text{null}(f) = n - \dim \text{range}(f) > 0$. Therefore, there exists a non-zero vector in the null space of $f$, which corresponds to a non-zero solution of the homogeneous system.

<br />

*Lemma : A system of linear equations with more equations than variables has no non-zero solution.*

Proof logic :  By $\text{Surjective} \iff \text{range}(f) = W$, that is 
$$
\forall y \in \text{range}(f), \exists x \in \mathbb{F}^n \text{ such that } f(x) = y.
$$

By the $\textcolor{red}{contrapositve}$ way, if $f$ is not surjective, then :
$$
\exists y \notin \text{range}(f), \forall x \in \mathbb{F}^n, f(x) \neq y.
$$
So original problem "A system of linear equations with more equations than variables has no non-zero solution" can be reduced to "$f$ is not surjective", which means $\dim \text{range}(f) < \dim W = m$. 

By the **Fundamental Theorem of Linear Maps**, we have
$$
\dim V = \dim \text{null}(f) + \dim \text{range}(f),
$$
which implies $\dim \text{range}(f) = \dim V - \dim \text{null}(f) \le \dim V = n$, by assumption $n < m$, we have $\dim \text{range}(f) < \dim W = m$, proved the the non-surjective of $f$. Therefore, the homogeneous system has no non-zero solution.

<br />

## Matrices

### Matrix of a linear map

![matrix-of-linear-map](./img/matrix_of_linear_map.png)

**Definition :** Given a linear map $T: \mathcal{L}(V, W)$ and bases $\{v_1, \dots, v_n\}$ for $V$ and $\{w_1, \dots, w_m\}$ for $W$, the matrix of $T$ with respect to these bases is a $m \times n$ matrix $A$ whose $(i,j)$-th entry $A_{ij}$ is defined by
$$
T(v_j) = \sum_{i=1}^m A_{ij} w_i.
$$
where the $j$-th column $A_{.,j}$ of $A$ corresponds to the coordinates of $T(v_j)$ with respect to the basis $\{w_1, \dots, w_m\}$ of $W$. Formally, we call the matrix of a specific linear map $T$ with respect to the bases $\{v_1, \dots, v_n\}$ and $\{w_1, \dots, w_m\}$ as $\mathcal{M}(T)$.

<br />

> [!Note]
> $\mathbb{F}^{m, n}$ means the set of all $m \times n$ matrices with entries from the field $\mathbb{F}$. It also represents the vector space of linear map from $\mathbb{F}^n$ to $\mathbb{F}^m$.

Specially, matrix $A$ maps the standard basis vectors of $\mathbb{F}^n$ to the coordinates of their images under $f$ in the basis $\{w_1, \dots, w_m\}$ of $W$. For example, let $T : \mathbb{F}^2 \to \mathbb{F}^3$ is defined by
$$
T(x, y) = (x + 3y, 2x + 5y, 7x + 9y)
$$
Then $T(1, 0) = (1, 2, 7)$ and $T(0, 1) = (3, 5, 9)$. Therefore, the matrix of $T$ with respect to the standard bases of $\mathbb{F}^2$ and $\mathbb{F}^3$ is
$$
\begin{bmatrix}
1 & 3 \\
2 & 5 \\
7 & 9
\end{bmatrix}
$$

<br />

*Proposition : $\dim \mathbb{F}^{m, n} = mn$.*

<br />

*Definition : The matrix of the composition of two linear maps $f: U \to V$ and $g: V \to W$ with respect to bases $\{u_1, \dots, u_p\}$ for $U$, $\{v_1, \dots, v_n\}$ for $V$, and $\{w_1, \dots, w_m\}$ for $W$ is the product of the matrices of $f$ and $g$ with respect to these bases.*
$$
\mathcal{M}(g \circ f) = \mathcal{M}(g) \cdot \mathcal{M}(f).
$$

<br />

Proposition : Matrix multiplication as linear combination of column or rows. Given $C$ is a $m \times c$ matrix and $R$ is a $c \times n$ matrix. That is
-  The $k$-th column of $CR$ is a linear combination of the columns of $C$ with coefficients from the $k$-th column of $R$.
-  The $k$-th row of $CR$ is a linear combination of the rows of $R$ with coefficients from the $k$-th row of $C$.

<br />

### Column-row factoring 

*Definition : Given $A$ is an $m \times n$ matrix, the column rank of $A$ is the dimension of the span of the columns of $A$ in $\mathbb{F}^{m, 1}$. The row rank of $A$ is the dimension of the span of the rows of $A$ in $\mathbb{F}^{1, n}$.*

*Proposition : The column rank and the row rank are at most $min(m, n)$.*

Proof logic : Take column rank of $A$. Since the dimension of the vector space of $span(\text{columns of } A)$ is at most $n$, we have the column rank of $A$ is at most $n$. And the vector space of $span(\text{columns of } A)$ is a subspace of $\mathbb{F}^{m}$, so the dimension of it cannot exceed $\dim \mathbb{F}^{m} = m$. Therefore the dimension of the span of the columns of $A$ is at most $min(m, n)$. Similarly, the row rank of $A$ is at most $n$. Therefore, the column rank and the row rank are at most $\min(m, n)$.

<br />

*Proposition : Any $m \times n$ matrix $A$ of rank $r$ can be factored as $A = C R$, where $C$ is an $m \times r$ matrix, and $R$ is an $r \times n$ matrix.*

Proof logic : Assume the column rank of $A$ is $r \le min(m, n)$. Then the columns of $A$ can be reduced to a basis of span the columns of $A$ with length $r$. So every element including all columnns of $A$ can be represented as a linear combination of these $r$ basis columns which represented as matrix $C$. The $k$-th column of $R$ is the coordinate of $k$-th column $A$ with respect to this basis matrix $C$. Similarly, the row-wise can also be proved.

<br />

*Lemma : Column rank equals row rank.*

Proof logic : In general, the $\textcolor{red}{equivalence}$ problem of $a = b$ can be reduced to a pair of $\textcolor{red}{less-symmetric}$ problem: 
1. $a \le b$, 
2. $b \le a$ 

In this case, we need to show:
1. The column rank of $A$ is at most the row rank of $A$.
2. The row rank of $A$ is at most the column rank of $A$.

Regarding the second point, the rows of $R$ spans the rows of $A$, so the dimension of span space of rows of $A$ is at most the number of $R$ rows, which equals the column rank of $A$.

Regarding the first point, 
$$
\text{column rank of } A = \text{row rank of } A^t
\le \text{column rank of } A^t
= \text{row rank of } A
$$

<br />

## Invertibility and Isomorphisms

*Definition : A linear map $T \in \mathcal{L}(V, W)$ is called invertible if there exists a linear map $S \in \mathcal{L}(W, V)$ such that $S \circ T = \text{id}_V$ and $T \circ S = \text{id}_W$.*

<br />

**Uniqueness of Inverse of Linear Map**

*Proposition : If a linear map $T \in \mathcal{L}(V, W)$ is invertible, then its inverse $S \in \mathcal{L}(W, V)$ is also unique.*

Proof Logic : This is a $\textcolor{red}{uniqueness}$ argument, the solution to this is to suppose there are two inverses $S_1$ and $S_2$ of $T$, then show that $S_1 = S_2$.
1. both $S_1$ and $S_2$ are inverses of $T$, i.e.,
    $$
        S_1 \circ T = \text{id}_V, \quad T \circ S_1 = \text{id}_W \\
        S_2 \circ T = \text{id}_V, \quad T \circ S_2 = \text{id}_W
    $$
2. introducing multiplication by identity, then apply hypothese in 1)
    $$
    S_1 = S_1 \circ \text{id}_W = S_1 \circ (T \circ S_2) = (S_1 \circ T) \circ S_2 = \text{id}_V \circ S_2 = S_2
    $$
Hence, the inverse of $T$ is unique.

<br />

**Invertibility of Linear Map $\iff$ Bijective**

*Proposition : A linear map is invertible if and only if it is both injective and surjective.*

Proof Logic : Firstly, it is a $\textcolor{red}{iff}$ (biconditional) argument, so we need to prove both directions:
1. Forward direction, if a linear map is invertible, then it is both injective and surjective.
2. Backward direction, if a linear map is both injective and surjective, then it is invertible.

More in-depth, let $T \in \mathcal{L}(V, W)$ be an invertible linear map, regarding the forward direction:
1. Injectivity. Injectivity of linear map $T$ means  
    $$
        T(v_1) = T(v_2) \implies v_1 = v_2 \quad \forall v_1, v_2 \in V.
    $$
    Since $T$ is invertible, there exists $S \in \mathcal{L}(W, V)$ such that $S \circ T = \text{id}_V$. Applying $S$ to both sides of $T(v_1) = T(v_2)$ gives 
    $$
        S(T(v_1)) = S(T(v_2)) \implies \text{id}_V(v_1) = \text{id}_V(v_2) \implies v_1 = v_2.
    $$
    Hence, $T$ is injective.
2. Surjective. Surjectivity of linear map $T$ means 
    $$
        \forall w \in W, \exists v \in V \text{ such that } T(v) = w.
    $$
    Since $T$ is invertible, there exists $S \in \mathcal{L}(W, V)$ such that $S \circ T = \text{id}_V$ and $T \circ S = \text{id}_W$. For any $w \in W$, let $v = S(w) \in V$. Then 
    $$
        T(v) = T(S(w)) = (T \circ S)(w) = \text{id}_W(w) = w.
    $$
    Hence, $T$ is surjective.

Regarding the backward direction : 
1. Since $T$ is injective, for any $v_1, v_2 \in V$, $T(v_1) = T(v_2) \implies v_1 = v_2$. 
2. Since $T$ is surjective, for any $w \in W$, there exists $v \in V$ such that $T(v) = w$. 
3. Define a function (or map) $S : W \to V$ by assigning $S(w) = v$, where $v$ is the unique element in $V$ such that $T(v) = w$. The uniqueness of $v$ is guaranteed by the injectivity of $T$. In order to prove $S$ is the inverse of $T$, we need to show that :
    - 3.1. $S \circ T = \text{id}_V$
    - 3.2. $T \circ S = \text{id}_W$
    - 3.3. $S$ is a well-defined linear map of type $W \to V$, that is :
       - a. additivity: $S(w_1 + w_2) = S(w_1) + S(w_2) \quad \forall w_1, w_2 \in W$
       - b. homogeneity: $S(\alpha w) = \alpha S(w) \quad \forall w \in W, \forall \alpha \in \mathbb{F}$

We omit the detailed proof here.

<br />

**Special Case of Invertible Linear Map**

*Proposition : If both $V$ and $W$ are finite-dimensional vector spaces of the same dimension, then a linear map $T \in \mathcal{L}(V, W)$ is invertible if and only if it is either injective or surjective. That is*
$$
T \text{ is invertible } \iff T \text{ is injective } \iff T \text{ is surjective }, \text{ when } \dim V = \dim W
$$

Proof Logic: 
We have shown that 
$$
T \text{ is invertible } \iff T \text{ is both injective and surjective }.
$$
so we only need to show that 
$$
T \text{ is injective } \iff T \text{ is surjective }
$$

By the fundamental theorem of linear maps :
$$
\dim V = \dim \text{null } T + \dim \text{range } T
$$
- For the forward direction (injective implies surjective), assume $T$ is injective. Then $\dim \text{null } T = 0$, so 
    $$
        \dim V = 0 + \dim \text{range } T \implies \dim \text{range } T = \dim V.
    $$
  Since $\dim V = \dim W$, we have $\dim \text{range } T = \dim W$, which implies $T$ is surjective.
- For the backward direction (surjective implies injective), assume $T$ is surjective. Then $\dim \text{range } T = \dim W = \dim V$, so 
    $$
        \dim V = \dim \text{null } T + \dim \text{range } T = \dim \text{null } T + \dim V \implies \dim \text{null } T = 0.
    $$
  Hence, $T$ is injective.

<br />

*Proposition : If $V$ and $W$ are finite-dimensional vector spaces of the same dimension, let $T \in \mathcal{L}(V, W)$, $S \in \mathcal{L}(W, V)$  be two linear maps. Then $S \circ T = \text{id}_V$ if and only if $T \circ S = \text{id}_W$.*

Proof Logic : Intuitively $S \circ T = \text{id}_V$ and $T \circ S = \text{id}_W$ has no direct connection. However, it would be different if $T$ is invertible, because in that case $S = T^{-1}$ and the two conditions are equivalent. So we need to show that $T$ is indeed invertible under the given conditions.

As we have shown that invertibility of linear map is equivalent with being injective or surjective for finite-dimensional vector spaces of the same dimension, it suffices to show that $T$ is either injective or surjective under the given conditions. Let us take the injective, $T$ is injective means $\ker T = \{0\}$.

For any $v \in V$, such that $T(v) = 0$, then
$$
v = \text{id}_V (v) = (S \circ T)(v) = S(T(v)) = S(0) = 0.
$$
Hence, $\ker T = \{0\}$, which shows that $T$ is injective, further invertible, and the forward direction is established.

Similarly with the backward direction, we omit the detailed proof here.

<br />

### Isomorphic Vector Spaces

*Definition : Two vector spaces $V$ and $W$ are said to be isomorphic, denoted by $V \cong W$, if there exists an invertible linear map $T \in \mathcal{L}(V, W)$.*

**Motivation of Isomorphism**

Isomorphism preserves the vector space structure, meaning that if $V \cong W$, then the operations of vector addition and scalar multiplication in $V$ correspond exactly to those in $W$ under the isomorphism. **The topic of whether two objects have the same structure is central of abtract algebra, and isomorphisms provide a precise way to capture this notion.** But how, if the object is a vector space? Do we need to check every operation and element individually, or is there a more efficient way to determine if two vector spaces are essentially the same?

One efficient way to determine if two vector spaces are essentially the same is to compare their dimensions. 

<br />

*Proposition : Two finite-dimensional vector spaces $V$ and $W$ are isomorphic if and only if $\dim V = \dim W$.*

Proof Logic : This is a $\textcolor{red}{iff}$ problem, so we need to prove both directions.

- Forward direction ($\Rightarrow$): Assume $V \cong W$. Then there exists an invertible linear map $T \in \mathcal{L}(V, W)$. Since $T$ is invertible, it is both injective and surjective. By the rank-nullity theorem, $\dim V = \dim W$.
- Backward direction ($\Leftarrow$): Assume $\dim V = \dim W$. Since $\text{invertible} \iff \text{bijective}$, so we only need to show that  $T$ is bijective. Let $\{v_1, \dots, v_n\}$ be a basis of $V$ and $\{w_1, \dots, w_n\}$ be a basis of $W$. Define a linear map $T \in \mathcal{L}(V, W)$ by : 
    $$
        T (c_1 v_1 + \dots + c_n v_n) = c_1 w_1 + \dots + c_n w_n
    $$
    we see that $\text{span}(w_1, \dots, w_n) = W \le \text{range}(T)$. Therefore, $T$ is surjective. Since $\dim V = \dim W$, by the rank-nullity theorem, $T$ is also injective. Hence, $T$ is bijective, and thus invertible. This completes the proof of the backward direction.

<br />

We know that $\mathcal{L}(V, W)$ is a vector space of linear maps from $V$ to $W$, and if $T \in \mathcal{L}(V, W)$, then we have $\mathcal{M}(T) \in \mathbb{F}^{n, m}$, where $\mathcal{M}(T)$ denotes the matrix representation of $T$ with respect to chosen bases of $V$ and $W$.

*Proposition : There is a isomorphism between vector space $\mathcal{L}(V, W)$ and $\mathbb{F}^{n, m}$.* 

Proof Logic : Define a function $\mathcal{M} : \mathcal{L}(V, W) \to \mathbb{F}^{n, m}$ by $\mathcal{M}(T) \in \mathbb{F}^{n, m}$ the matrix representation of linear map $T \in \mathcal{L}(V, W)$ with respect to the chosen bases of $V$ and $W$. We need to show that $\mathcal{M}$ is a linear map and bijective, which would establish the isomorphism.
- Linearity (additivity and homogeneity): For any $T_1, T_2 \in \mathcal{L}(V, W)$ and scalar $c \in \mathbb{F}$, by the linearity of the matrix representation $\mathbb{F}^{n, m}$, we have
    $$
        \mathcal{M}(T_1 + T_2) = \mathcal{M}(T_1) + \mathcal{M}(T_2), \quad \mathcal{M}(c T_1) = c \mathcal{M}(T_1).
    $$
    Hence, $\mathcal{M}$ is linear.
- Bijectivity: 
    - Injectivity: If $\mathcal{M}(T) = 0$, then $T$ maps all basis vectors of $V$ to $0$ in $W$, which implies $T = 0$. Hence, $\mathcal{M}$ is injective.
    - Surjectivity: For any matrix $A \in \mathbb{F}^{n, m}$, we can define a linear map $T \in \mathcal{L}(V, W)$ such that $\mathcal{M}(T) = A$. Hence, $\mathcal{M}$ is surjective.

Therefore, $\mathcal{M}$ is a linear bijection, establishing the isomorphism between $\mathcal{L}(V, W)$ and $\mathbb{F}^{n, m}$.

<br />

*Proposition : The dimension of the vector space $\mathcal{L}(V, W)$ is equal to the product of the dimensions of $V$ and $W$, i.e., $\dim \mathcal{L}(V, W) = (\dim V)(\dim W)$.*