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

<br />

## Linear Maps

Linear maps is also a vector space. Specifically, if `V` and `W` are vector spaces over the same field `F`, then the set of all linear maps from `V` to `W`, denoted by `Hom(V, W)`, forms a vector space over `F` with pointwise addition and scalar multiplication. In the following section we will discuss this topic in more detail.

### Vector space of linear maps

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

### Null Space and Ranges 

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

### Matrices

**Matrix of a linear map**

Given a linear map $f: V \to W$ and bases $\{v_1, \dots, v_n\}$ for $V$ and $\{w_1, \dots, w_m\}$ for $W$, the **matrix of $f$** with respect to these bases is the $m \times n$ matrix $A$ whose $(i,j)$-th entry $a_{ij}$ is defined by
$$
f(v_j) = \sum_{i=1}^m a_{ij} w_i.
$$
where the $j$-th column of $A$ corresponds to the coordinates of $f(v_j)$ in the basis $\{w_1, \dots, w_m\}$ of $W$.

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

*Definition : $\mathbb{F}^{m, n}$ means the set of all $m \times n$ matrices with entries from the field $\mathbb{F}$. It also represents the vector space of linear map from $\mathbb{F}^n$ to $\mathbb{F}^m$.*

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