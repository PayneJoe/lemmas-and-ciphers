<details>
<summary>Table of Contents</summary>

## Table of Contents
- [Eigenvalues and Eigenvectors](#eigenvalues-and-eigenvectors)
  - [Invariant Subspaces](#invariant-subspaces)
    - [Eigenvalues](#eigenvalues)
    - [Polynomials Applies to Operators](#polynomials-applies-to-operators)
  - [The Minimal Polynomial](#the-minimal-polynomial)
    - [Eigenvalues on Odd-Dimensional Real Vector Spaces](#eigenvalues-on-odd-dimensional-real-vector-spaces)
  - [Upper-Triangular Matrices](#upper-triangular-matrices)
  - [Diagonalizable Operators](#diagonalizable-operators)
  - [Commuting Operators](#commuting-operators)
- [Inner Product Spaces](#inner-product-spaces)
  - [Inner Products and Norms](#inner-products-and-norms)
  - [Orthonormal Bases](#orthonormal-bases)
- [Operators on Inner Product Spaces](#operators-on-inner-product-spaces)
- [Multilinear Algebra and Determinants](#multilinear-algebra-and-determinants)

</details>

# Eigenvalues and Eigenvectors

## Invariant Subspaces

**Definition 5.1 - Invariant Subspace**{#definition-5-1 .definition anchor}

Let $T \in \mathcal{L}(V)$ be a (linear) operator on vector space $V$. When we restrict $T$ to a subspace $U \subseteq V$, we are not sure the corresponding vectors will still lie in $U$. If they do, we say that $U$ is an invariant subspace under $T$. We call $T|_U$ is an operator on $U$.

<br />

Considering one special invariant subspace, that is, one-dimensional invariant subspace, which is spanned by only one vector $v \in V$. If this one-dimensional subspace is invariant under $T$, then the linear map $T$ only depends on where the basis vector $v$ is mapped, which leads to the concept of eigenvalues and eigenvectors:
$$
T v = \lambda v
$$

<br />

### Eigenvalues

**Definition 5.2 - Eigenvalue and Eigenvector** {#definition-5-2 .definition anchor}

Let $T \in \mathcal{L}(V)$ be a (linear) operator on vector space $V$. A scalar $\lambda \in \mathbb{F}$ is called an eigenvalue of $T$ if there exists a non-zero vector $v \in V$ such that
$$
T v = \lambda v.
$$
The vector $v$ is called an eigenvector corresponding to the eigenvalue $\lambda$.

<br />

**Lemma 5.1 - Equivalence of Eigenvalue**{#lemma-5-1 .lemma anchor}

Suppose $V$ is a finite-dimensional vector space and $T \in \mathcal{L}(V)$, and $\lambda \in \mathbb{F}$. The following statements are equivalent:

1. $\lambda$ is an eigenvalue of $T$.

2. $T - \lambda I$ is not injective.

3. $T - \lambda I$ is not surjective.

4. $\det(T - \lambda I) = 0$.

<br />

<details>
<summary>Proof</summary>

Regarding $(1) \iff (2)$, by $T v = \lambda v$, we have $(T - \lambda I_V) v = 0$. Since by linearity of vector space of $\mathcal{L}(V)$, $T - \lambda I_V$ is also a operator on $V$, and its kernel is non-trivial as basis vector $v$ is non-zero. Completing the proof of $(1) \iff (2)$.

By the properties of invertible linear map of the same dimension 
$$
\text{injectivity} \iff \text{surjectivity} \iff \text{bijectivity}
$$
, we have $(2) \iff (3) \iff (4)$, completing the proof.

</details>

<br />

**Lemma 5.2 - Linearly Independent Eigenvectors**{#lemma-5-2 .lemma anchor}

Eigenvectors corresponding to distinct eigenvalues of a linear operator are linearly independent.

<br />

<details>
<summary>Proof</summary>

Suppose $v_1, v_2, \dots, v_k$ are eigenvectors corresponding to distinct eigenvalues $\lambda_1, \lambda_2, \dots, \lambda_k$ of a linear operator $T$. We prove the statement by induction on $k$.

For $k = 1$, the statement is trivial since a single non-zero vector is linearly independent.

Assume the statement holds for $k-1$ eigenvectors (i.e. if any linear combination of $k - 1$ distinct eigenvectors equals zero, then all coefficients are zeros). Consider $k$ eigenvectors $v_1, v_2, \dots, v_k$ corresponding to distinct eigenvalues $\lambda_1, \lambda_2, \dots, \lambda_k$. Suppose
$$
a_1 v_1 + a_2 v_2 + \dots + a_k v_k = 0.
$$
Applying $T$ to both sides, we get
$$
a_1 \lambda_1 v_1 + a_2 \lambda_2 v_2 + \dots + a_k \lambda_k v_k = 0.
$$
Multiplying the first equation by $\lambda_k$ and subtracting from the second equation, we obtain
$$
a_1 (\lambda_1 - \lambda_k) v_1 + a_2 (\lambda_2 - \lambda_k) v_2 + \dots + a_{k-1} (\lambda_{k-1} - \lambda_k) v_{k-1} = 0.
$$
By the induction hypothesis, since $\lambda_i \ne \lambda_j$ for all $i \ne j$, we have $a_1 = a_2 = \dots = a_{k-1} = 0$. Substituting back into the original equation, we get $a_k v_k = 0$, which implies $a_k = 0$ since $v_k \neq 0$.

Hence, $v_1, v_2, \dots, v_k$ are linearly independent.

</details>

<br />

**Lemma 5.3 - Maximum Number of Eigenvalues**{#lemma-5-3 .lemma anchor}

A linear operator on an $n$-dimensional vector space has at most $n$ distinct eigenvalues.

<br />

<details>
<summary>Proof</summary>

By lemma 5.2, eigenvectors corresponding to distinct eigenvalues are linearly independent. Since a linear operator on an $n$-dimensional vector space cannot have more than $n$ linearly independent vectors, it follows that the number of distinct eigenvalues is at most $n$.

</details>
<br />

### Polynomials Applies to Operators

Operators is more poppular than general linear maps, owe that the basis of domain and codomain are the same, thus invertibility is well-defined. Therefore, we can composite one operator many times, more in general we can apply any finite-degree polynomials to them directly.

<br />

**Definition 5.3 - Polynomial Evaluation on Operator**{#definition-5-3 .definition anchor}

Let $T$ be a linear operator on a vector space $V$, and let $p(x) = a_0 + a_1 x + \dots + a_m x^m$ be a polynomial. The polynomial evaluation of $p$ on $T$ is defined as
$$
p(T) = a_0 I + a_1 T + \dots + a_m T^m,
$$
where $I$ is the identity operator on $V$. For simplicity, we call $p(T)$ as polynomial operator on $T$.

<br />

**Lemma 5.4 - Properties of Polynomial Operators**{#lemma-5-4 .lemma anchor}

Due to the naive invertibility property of operators, the commutativity of operators with themselves ensures that polynomial evaluations on operators are well-defined and behave as expected. Suppose $p, q \in \mathcal{P}(\mathbb{F})$ are two polynomials, then we have
$$
\begin{aligned}
\text{(a) } &p(T) + q(T) = (p+q)(T), \\
\text{(b) } &p(T) q(T) = (pq)(T), \\
\text{(c) } &p(T) q(T) = q(T) p(T).
\end{aligned}
$$

<br />

**Lemma 5.5 - Invariant of Null Space and Range of Polynomial Operators**{#lemma-5-5 .lemma anchor}

Suppose $T$ is a linear operator on a vector space $V$, and $p(x)$ is a polynomial. Then the null space and range of $p(T)$ are invariant under $T$, i.e.,
$$
\begin{aligned}
\text{(a) } &T(\text{null}(p(T))) \subseteq \text{null}(p(T)) \\
\text{(b) } &T(\text{range}(p(T))) \subseteq \text{range}(p(T)).
\end{aligned}
$$

<details>
<summary>Proof</summary>

Regarding (a), it is suffices to show that $\forall x \in T(\text{null}(p(T))) \to x \in \text{null}(p(T))$, which is equivalent with $\forall x \in \text{null}(p(T)) \to T(x) \in \text{null}(p(T))$.

By $p(T) \in \mathcal{L}(V)$, we have $p(T)(x) = 0$. And $T \in \mathcal{L}(V)$, we have $T(x) \in V$, by the commutativity of polynomial operators, we have:
$$
p(T) \circ T(x) = (p(T) \circ T)(x) = (T \circ p(T))(x) = T(p(T)(x)) = T(0) = 0.
$$
Thus $T(x) \in \text{null}(p(T))$.

Regarding (b), it is suffices to show that $\forall y \in \text{range}(p(T)) \to T(y) \in \text{range}(p(T))$.

Let $y \in \text{range}(p(T))$, then there exists $x \in V$ such that $y = p(T)(x)$. By the commutativity of polynomial operators, we have:
$$
T(y) = T(p(T)(x)) = (T \circ p(T))(x) = (p(T) \circ T)(x) = p(T)(T(x)) \in \text{range}(p(T)).
$$

</details>

<br />

> [!Warning] Polynomial Operators and Eigenvalues
> What is the relationship between polynomial operators and eigenvalues?

## The Minimal Polynomial

**Lemma 5.6 - Existence of Eigenvalues**{#lemma-5-6 .lemma anchor}

Every operator on a finite-dimensional vector space over an **algebraically closed field** has at least one eigenvalue.

<details>
<summary>Proof</summary>

We will show the proof on the perspective of the characteristic polynomial of the operator. Since the field is algebraically closed, *the characteristic polynomial has at least one root, which corresponds to an eigenvalue of the operator*.

Suppose $V$ is a finite-dimensional complex vector space of dimension $n$, and let $T$ be a linear operator on $V$. Choose a non-zero vector $v \in V$. Then
$$
v, T v, T^2 v, \dots, T^{n} v,
$$
is a list of dependent vectors in $V$ since $V$ has dimension $n$. Thus, there exist scalars $a_0, a_1, \dots, a_n$, not all zero, such that  
$$
a_0 v + a_1 T v + a_2 T^2 v + \dots + a_n T^n v = p(T)(v) = 0.
$$
where $p(x)$ is a non-constant polynomial of **smallest degree** such that $p(T)(v) = 0$. "algebraically closed" ensures the characteristic polynomial has at least one root in the field $\lambda \in \mathbb{F}$ such that $p(x) = (x - \lambda) q(x) = 0$, "Smallest degee" ensures that the quotient polynomial $q(\lambda) \ne 0$, and therefore we have: 
$$
p(T) (v) = ((T - \lambda I) q(T))(v) = (T - \lambda I)(q(T)(v)) = 0.
$$
concequently, $T - \lambda I = 0$ which implies that $v$ is an eigenvector of $T$ corresponding to the eigenvalue $\lambda$.

</details>
<br />

**Definition 5.4 - Minimal Polynomial**{#definition-5-4 .definition anchor}

The minimal polynomial of a linear operator $T$ on a finite-dimensional vector space $V$ is the unique monic polynomial $p \in \mathcal{P}(\mathbb{F})$ of smallest degree such that $p(T) = 0$. Furthermore, $\deg p \le \dim V$.

<br />

> [!Warning] Algebraically Closed Fields
> What is the relationship between minimal polynomial and eigenvalues? Given a linear operator $T$, the minimal polynomial of it always exists and be unique. But by lemma 5.6, the existence of eigenvalues still depends on the field being algebraically closed. By comparison, $\mathbb{R}$ is not algebraically closed, while $\mathbb{C}$ is.

<br />

**Lemma 5.7 - Relationship Between Minimal Polynomial and Eigenvalues**{#lemma-5-7 .lemma anchor}

Suppose $V$ is finite-dimensional and $T \in \mathcal{L}(V)$. 

- (a) If the field $\mathbb{F}$ which vector space is defined over is not algebraically closed, for example $\mathbb{R}$, then the zeros of the minimal polynomial of $T$ are the eigenvalues of $T$ in $\mathbb{F}$, if any exist.
- (b) If the field $\mathbb{F}$ is algebraically closed, for example $\mathbb{C}$, then there are at least one zero of the minimal polynomial of $T$ in $\mathbb{F}$, which corresponds to an eigenvalue of $T$.

This lemma also implies that the number of distinct eigenvalues of $T$ in $\mathbb{F}$ is at most the degree of the minimal polynomial of $T$, which in turn is at most $\dim V$. For now, we have two ways to show that the number of distinct eigenvalues is bounded by the dimension of the vector space. One is using the minimal polynomial, and the other is using eigenvectors directly.

![bound-for-eigenvalues](./img/eigenvalues.png)

<br />

**Lemma 5.8 - Invertible of Linear Operators**{#lemma-5-8 .lemma anchor}

Suppose $V$ is finite-dimensional and $T \in \mathcal{L}(V)$. Then $T$ is invertible if and only if $0$ is not an eigenvalue of $T$, which is equivalent to the minimal polynomial of $T$ not having $0$ as a root.

<details>
<summary>Proof</summary>

$T$ is not invertible, implying not injective, which means 
$$
\exist u, v \in V, T(u) = T(v) \to u \ne v
$$
Thus $T(u) - T(v) = T(u - v) = 0 = 0 \cdot (u - v)$, which shows that $0$ is an eigenvalue of $T$ with eigenvector $u - v \ne 0$. By lemma 5.7, $0$ is a root of the minimal polynomial of $T$, implying that the constant term of the minimal polynomial is $0$.

</details>
<br />

### Eigenvalues on Odd-Dimensional Real Vector Spaces

By lemma 5.7, we have concluded that not every linear operator on a real vector space has eigenvalues. But in some special circumstances, such as when the vector space is odd-dimensional, we can guarantee the existence of eigenvalues.

<br />

## Upper-Triangular Matrices

For example, 
$$
\begin{pmatrix}
a_{11} & a_{12} & \cdots & a_{1n} \\
0 & a_{22} & \cdots & a_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
0 & 0 & \cdots & a_{nn}
\end{pmatrix}
$$
is an upper-triangular matrix.

<br />

Diagonal matrix is a special case of an upper-triangular matrix where all the entries above and below the main diagonal are zero.

Before we dive into diagonal matrix of linear operator, we first need to understand upper-triangular matrices, as they provide a stepping stone towards diagonalization.

<br />

**Lemma 5.9 - Conditions for Upper-Triangular Matrix**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$. Then the following conditions are equivalent:
- (a) The matrix of $T$ with respect to some basis $v_1, ..., v_n$ of $V$ is upper-triangular.
- (b) $\text{span}(v_1, ..., v_k)$ is invariant under $T$ for each $k = 1, ..., n$.

<details>
<summary>Proof</summary>

Since $\mathcal{M}(T)$ is an upper-triangular matrix with respect to the basis $v_1, ..., v_n$, by the definition of linear map matrix, we have $T(v_j) \in \text{span}(v_1, ..., v_j) \subseteq \text{span}(v_1, ..., v_k)$ for each $j = 1, ..., k$, so 
$$
T(c_1 v_1 + \cdots + c_k v_k) = c_1 T(v_1) + \cdots + c_k T(v_k) \in \text{span}(v_1, ..., v_k)
$$
. Completing the proof of the equivalence between (a) and (b).

</details>
<br />

**Lemma 5.10 - Linear Operator Equation**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$, and it has an upper-triangular matrix with diagonal entries $\lambda_1, ..., \lambda_n$. Then  
$$
(T - \lambda_1 I)(T - \lambda_2 I) \cdots (T - \lambda_n I) = 0
$$

<br />

**Lemma 5.11 - Determination of Eigenvalues from Upper-Triangular Matrix**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$, and it has an upper-triangular matrix with diagonal entries $\lambda_1, ..., \lambda_n$. Then the eigenvalues of $T$ are precisely $\lambda_1, ..., \lambda_n$.

<br />

Not every linear operator has an upper-triangular matrix representation with respect to some basis. Those that do are called triangularizable operators.

**Lemma 5.12 - Condition for Having Upper-Triangular Matrix**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$. Then $T$ has an upper-triangular matrix with respect to some basis of $V$ if and only if the minimal polynomial of $T$ equals  
$$
(x - \lambda_1) \cdots (x - \lambda_m)
$$
for some scalars $\lambda_1, ..., \lambda_m \in \mathbb{F}$, where $m \le n$. More specially, if the field $\mathbb{F}$ is algebraically closed, then every linear operator on a finite-dimensional vector space over $\mathbb{F}$ has an upper-triangular matrix with respect to some basis.

<br />

## Diagonalizable Operators

**Definition 5.5 - Eigenspace**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$, and $\lambda$ is an eigenvalue of $T$. The eigenspace corresponding to $\lambda$ is defined as
$$
E(\lambda, T) = \text{null}(T - \lambda I) = \{v \in V : T(v) = \lambda v\}.
$$

We see that each eigenspace is a subspace of $V$, meaning it is closed under vector addition and scalar multiplication, i.e.,
$$
v_1, v_2 \in E(\lambda, T), \alpha, \beta \in \mathbb{F} \implies \alpha v_1 + \beta v_2 \in E(\lambda, T).
$$

> [!Warning]
> Each eigenvalue corresponds to a eigenspace, so what is the relationship between these eigenspaces?

<br />

**Lemma 5.13 - Sum of Eigenspaces**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$, and $\lambda_1, ..., \lambda_m$ are distinct eigenvalues of $T$. Then the sum of the corresponding eigenspaces is direct, i.e.,
$$
E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T) \subseteq V.
$$
Furthermore, if $V$ is finite-dimensional, then the sum of the eigenspaces equals $V$, i.e.,
$$
\dim E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T) \le \dim V.
$$

<details>
<summary>Proof</summary>

(a) In order to show the direct-sum, it is suffices to show that : the only way to write the zero vector as a sum of vectors from each eigenspace is by taking each vector to be zero, i.e.,
$$
0 = v_1 + \cdots + v_m,
$$
where $v_i \in E(\lambda_i, T)$ for each $i = 1, ..., m$. We need to show that each $v_i = 0$.

Because each eigenvector $v_i$ corresponds to a distinct eigenvalue $\lambda_i$, they are linearly independent. Therefore, $v_i = 0$ for each $i = 1, ..., m$.

(b) Since the sum of the eigenspaces is direct, then we have 
$$
\dim (E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)) = \dim E(\lambda_1, T) + \cdots + \dim E(\lambda_m, T).
$$
and $E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T) \subseteq V$ implies 
$$
\dim (E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)) \le \dim V.
$$
Completing the proof.

</details>
<br />

**Lemma 5.14 - Euqivalent Conditions for Diagonalizability**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on a finite-dimensional vector space $V$. Let $\lambda_1, ..., \lambda_m$ be the distinct eigenvalues of $T$. Then the following are equivalent:

1. $T$ is diagonalizable.

2. $V$ has a basis consisting of eigenvectors of $T$.

3. The sum of the eigenspaces corresponding to $\lambda_1, ..., \lambda_m$ equals $V$, i.e.,
   $$
   E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T) = V.
   $$

4. $\dim E(\lambda_1, T) + \cdots + \dim E(\lambda_m, T) = \dim V.$

<br />

<details>
<summary>Proof</summary>

Suppose the diagonal matrix of linear operator $T$ with respect to some basis $\{v_1, ..., v_n\}$ of $V$ is 
$$
\text{diag}(\lambda_1, ..., \lambda_n),
$$
where $\lambda_j$ are the eigenvalues corresponding to the basis vectors $v_j$. Note that $m \le n$ implies that it is possible multiple eigenvectors share the same eigenvalue.

<br />

For $(1) \iff (2)$, recalling the upper-triangular matrix of linear operator, $T v_j \in \text{span}(v_1, ..., v_j)$ for each $j \le n$, where $\{v_1, ..., v_n\}$ is a basis of $V$. Diagonal matrix is more strict than upper-triangular matrix, as it only has diagonal entries. By the definition of linear map matrix, we have $T v_j = \lambda_j v_j$ for each $j$, which shows that each basis vector $v_j$ is an eigenvector corresponding to eigenvalue $\lambda_j$. Hence, $(1) \iff (2)$.

For $(2) \iff (3)$, $E(\lambda_j, T)$ is a subspace of $V$ for each $j = 1, ..., m$, thus $E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)$ is also a subspace of $V$. So in order to show $V = E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)$, it suffices to show that $V \subseteq E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)$. 

Since eigenvectors $v_1, ..., v_n$ form a basis of $V$, then 
$$
v = c_1 v_1 + \cdots + c_n v_n,
$$
Since $v_j \in E(\lambda_j, T)$ for each $j$, we have 
$$
v = c_1 v_1 + \cdots + c_n v_n \in E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T),
$$
which shows that the sum of the eigenspaces equals $V$. Hence, $(2) \iff (3)$.

For $(3) \iff (4)$, 
$$
\dim (E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)) = \dim E(\lambda_1, T) + \cdots + \dim E(\lambda_m, T).
$$
and $E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T) = V$ implies 
$$
\dim (E(\lambda_1, T) \oplus \cdots \oplus E(\lambda_m, T)) = \dim V.
$$

</details>
<br />

**Lemma 5.15 - Enough Eigenvalues for Diagonalizability**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on an $n$-dimensional vector space $V$, and it has $\dim V$ distinct eigenvalues. Then $T$ is diagonalizable.

<br />

<details>
<summary>Proof</summary>

By lemma 5.14, we observe that : $n$ distinct eigenvectors forming a basis of $V$ does not guarantee that they come from $n$ distinct eigenvalues, implying that some eigenvalues has mutiplicity than one. 

This lemma is a special case of lemma 5.14, where the number of distinct eigenvalues equals the dimension of the vector space. We just omit the proof here.

</details>
<br />

**Lemma 5.16 - Sufficient and Necessary Conditions for Diagonalizability**

Suppose $T \in \mathcal{L}(V)$ is a linear operator on an $n$-dimensional vector space $V$. Then $T$ is diagonalizable if and only if the minimal polynomial of $T$ equals  
$$
\prod_{i=1}^m (x - \lambda_i),
$$
where $\lambda_1, ..., \lambda_m$ are the distinct eigenvalues of $T$.

> [!Important] Criterias for Diagonalizability
> For now, we have four criterias for diagonalizability of a linear operator, where three of them come from lemma 5.14 and the fourth one comes from lemma 5.15. The difference is that :
> 1. lemma 5.15 is a **sufficient condition** for diagonalizability, but not **necessary condition**, which means there are other ways to achieve diagonalizability without having $\dim V$ distinct eigenvalues, for example the three conditions (2), (3), and (4) in lemma 5.14.
> 2. lemma 5.16 provides a **necessary and sufficient condition** for diagonalizability, which means it characterizes all diagonalizable operators through their minimal polynomials.

<br />

**Lemma 5.17 - Restriction of Diagonalizable Operators**

Suppose $T \in \mathcal{L}(V)$ is a diagonalizable linear operator on an $n$-dimensional vector space $V$, and $W$ is a $T$-invariant subspace of $V$. Then the restriction of $T$ to $W$, denoted by $T|_W$, is also diagonalizable.

<br />

> [!Important]
> In this section, we have learned that a linear operator is diagonalizable only when using some special basis consisting of its eigenvectors. The choice of such a basis is crucial for representing the operator in a diagonal form.

## Commuting Operators

If two operators are commuting, i.e., $AB = BA$, then they are said to commute with each other.

**Lemma 5.18 - Commuting Operators and Commuting Matrices**

Suppose $S$ and $T$ are two linear operators on a finite-dimensional vector space $V$, and $v_1, ..., v_n$ is a basis of $V$. Then $S$ and $T$ commute if and only if $\mathcal{M}(S, \{v_1, ..., v_n\})$ and $\mathcal{M}(T, \{v_1, ..., v_n\})$ commute.

<br />

**Lemma 5.19 - Eigenspace is invariant under commuting operator**

Suppose $S, T \in \mathcal{L}(V)$ are two commuting linear operators on a finite-dimensional vector space $V$ and $\lambda \in \mathbb{F}$. Then $E(\lambda, S)$, the eigenspace of $S$ corresponding to $\lambda$, is invariant under $T$.

<details>
<summary>Proof</summary>

To show the invariance of $E(\lambda, S)$ under $T$, it is sufficient to show :
$$
\forall v \in E(\lambda, S) \to T(v) \in E(\lambda, S) \iff S(T(v)) = \lambda \cdot T(v)
$$

Since $S, T$ commute, $S T = T S$, so we have $S(T(v)) = T(S(v)) = T(\lambda v) = \lambda T(v)$, which shows that $T(v) \in E(\lambda, S)$.

</details>
<br />

**Lemma 5.20 - Simultaneous Diagonalizability of Commuting Operators**

Two diagonalizable linear operators on a finite-dimensional vector space $V$ commute if and only if they are simultaneously diagonalizable, i.e., there exists a basis of $V$ consisting of eigenvectors common to both operators.

<br />

# Inner Product Spaces

So far, we have discussed 
- linear structure of vector spaces, 
- linear maps (operators) on them,
- and properties of these operators. 

Actually, there are also some geometric features (for example, lengths and angles) for vector spaces, which can be captured using the concept of an inner product. Similarly, we will then discuss linear operators on inner product spaces and their properties.

## Inner Products and Norms

**Definition 6.1 - Euclidean (Inner Product) Space**

An inner product on a vector space $V$ over the field $\mathbb{F}$ (where $\mathbb{F}$ is typically $\mathbb{R}$ or $\mathbb{C}$) is a function $\langle \cdot, \cdot \rangle : V \times V \to \mathbb{F}$ that satisfies the following properties for all $u, v, w \in V$ and all $\alpha \in \mathbb{F}$:

1. **Conjugate Symmetry**: $\langle u, v \rangle = \overline{\langle v, u \rangle}$
2. **Linearity in the First Argument**: $\langle \alpha u + v, w \rangle = \alpha \langle u, w \rangle + \langle v, w \rangle$
3. **Positive-Definiteness**: $\langle v, v \rangle \geq 0$ with equality if and only if $v = 0$

A vector space $V$ equipped with an inner product $\langle \cdot, \cdot \rangle$ is called an **inner product space** or **Euclidean space**.

<br />

**Definition 6.2 - Norm Induced by Inner Product**

For a vector $v \in V$, the norm induced by the inner product is defined as
$$
\|v\| = \sqrt{\langle v, v \rangle}.
$$
This norm satisfies the usual properties of a norm, including positivity, homogeneity, and the triangle inequality, that is,
$$
\|v\| \geq 0, \quad \|v\| = 0 \iff v = 0, \\
\quad \|\alpha v\| = |\alpha| \cdot \|v\|, \\
\quad \|u + v\| \leq \|u\| + \|v\|.
$$

<br />

**Definition 6.3 - Orthogonality**

Two vectors $u, v \in V$ are said to be **orthogonal** if their inner product is zero, i.e.,
$$
\langle u, v \rangle = 0.
$$

<br />

**Lemma 6.1 - Pythagorean Theorem for Inner Product Spaces**

If $u, v \in V$ are orthogonal, then
$$
\|u + v\|^2 = \|u\|^2 + \|v\|^2.
$$

<details>
<summary>Proof</summary>

If $u$ and $v$ are orthogonal, then $\langle u, v \rangle = \overline{\langle v, u \rangle} = 0$ implies $\langle v, u \rangle = 0$, thus 
$$
\|u + v\|^2 = \langle u + v, u + v \rangle = \langle u, u \rangle + \langle u, v \rangle + \langle v, u \rangle + \langle v, v \rangle = \|u\|^2 + \|v\|^2.
$$

</details >
<br />

**Lemma 6.4 - Cauchy-Schwarz Inequality**

For all vectors $u, v \in V$, the Cauchy-Schwarz inequality states that
$$
|\langle u, v \rangle| \leq \|u\| \cdot \|v\|.
$$
Equality holds if and only if $u$ and $v$ are linearly dependent.

<br />

**Lemma 6.5 - Triangle Inequality**

For all vectors $u, v \in V$, the triangle inequality states that
$$
\|u + v\| \leq \|u\| + \|v\|.
$$
Equality holds if and only if $u$ and $v$ are linearly dependent.

<br />

**Lemma 6.6 - Parallelogram Law**

For all vectors $u, v \in V$, the parallelogram law states that
$$
\|u + v\|^2 + \|u - v\|^2 = 2\|u\|^2 + 2\|v\|^2.
$$

<br />

## Orthonormal Bases

**Definition 6.4 - Orthonormal**

An orthonormal set of vectors in an inner product space $V$ is a set of vectors that are all unit vectors (norm equal to 1) and mutually orthogonal. Formally, a set $\{e_1, e_2, \dots, e_n\} \subseteq V$ is orthonormal if
$$
\langle e_i, e_j \rangle = \delta_{ij}, \quad \text{for all } i, j = 1, 2, \dots, n,
$$
where $\delta_{ij}$ is the Kronecker delta, which is 1 if $i = j$ and 0 otherwise.

<br />

We have two properties about orthonormal list of vectors :
1. $\|a_1 e_1 + ... + a_n e_n\|^2 = |a_1|^2 + ... + |a_n|^2$ for any scalars $a_1, \dots, a_n$.
2. Every orthonormal list of vectors is linearly independent.

<br />

**Lemma 6.7 - Bessel's Inequality**

Let $\{e_1, e_2, \dots, e_n\}$ be an orthonormal set of vectors in an inner product space $V$. For any vector $v \in V$, Bessel's inequality states that
$$
\sum_{i=1}^n |\langle v, e_i \rangle|^2 \leq \|v\|^2.
$$

> [!Note]
> $\langle v, e_i \rangle$ represents the inner product of the vector $v$ with the orthonormal basis vector $e_i$, which can be directly interpreted as the scalar projection (or coefficient) of $v$ onto $e_i$.

<br />

**Definition 6.5 - Orthonormal Basis**

An orthonormal basis of an inner product space $V$ is an orthonormal set of vectors that spans the entire space $V$. Formally, a set $\{e_1, e_2, \dots, e_n\} \subseteq V$ is an orthonormal basis if it is orthonormal and every vector $v \in V$ can be expressed as a linear combination of the basis vectors:
$$
v = \sum_{i=1}^n \langle v, e_i \rangle e_i.
$$

> [!Note]
> Orthonormal basis is a special kind of basis where all the basis vectors are orthonormal, meaning they are all unit vectors and mutually orthogonal. But how to find such a basis in practice? One common method is the Gram-Schmidt process, which takes a linearly independent set of vectors and constructs an orthonormal basis from them.

<br />

**Definition 6.6 - Orthogonal Decomposition**

Suppose $u, v \in V$, with $v \ne 0$. Set 
$$
w = \frac{\langle u, v \rangle}{\|v\|^2} v,
$$
then $u$ can be decomposed as
$$
u = w + (u - w),
$$
where $w$ is parallel to $v$ and $u - w$ is orthogonal to $v$.

> [!Note]
> It implies that any vector $u$ can be decomposed into a component parallel to another vector $v$ and a component orthogonal to $v$.

<br />

**Lemma 6.8 - Gram-Schmidt Procedure**

Suppose $v_1, ..., v_m$ is a linearly independent set of vectors in an inner product space $V$. The Gram-Schmidt procedure constructs an orthonormal set of vectors $e_1, ..., e_m$ as follows:
1. Let $f_1 = v_1$
2. For $k = 2, ..., m$ inductively define
   $$
   f_k = v_k - \sum_{i=1}^{k-1} \frac{\langle v_k, f_i \rangle}{\|f_i\|^2} f_i,
   $$
3. For each $k = 1, ..., m$, let
   $$
   e_k = \frac{f_k}{\|f_k\|}.
   $$
   Then $e_1, ..., e_m$ is an orthonormal set of vectors that spans the same subspace as $\{v_1, ..., v_m\}$, i.e., 
   $$
   \text{span}\{e_1, ..., e_m\} = \text{span}\{v_1, ..., v_m\}.
   $$

> [!Note]
> The general ideal is that, firstly by definition 6.6, we construct a set of orthonormal vectors $f_1, ..., f_m$ from the original linearly independent set $v_1, ..., v_m$. Secondly, normalize them to obtain the orthonormal set $e_1, ..., e_m$.

<br />

**Lemma 6.9 - Orthonormal List to Orthonormal Basis**

The length of any orthonormal list is not guarrenteed to be $\dim V$, but it can always be extended to form an orthonormal basis of $V$ by applying the Gram-Schmidt procedure to additional linearly independent vectors until the basis is complete.

<br />

**Lemma 6.10 - Upper-triangular Matrix with Respect to Orthonormal Basis**

By lemma 5.12, every linear operator on a finite-dimensional inner product space has an upper-triangular matrix with respect to **some** basis. It does not specify which basis, but in fact, it can be chosen to be an orthonormal basis.

Suppose $T \in \mathcal{L}(V)$, where $V$ is a finite-dimensional inner product space. Then $T$ has an upper-triangular matrix with respect to some orthonormal basis of $V$ if and only if the minimal polynomial of $T$ splits into linear factors over the field $\mathbb{F}$. That is,
$$
\text{minimal polynomial of } T = \prod_{i=1}^{m} (x - \lambda_i), \quad \lambda_i \in \mathbb{F}.
$$

<br />

**Definition 6.7 - Orthogonal Complement**

Given $U$ is a subset of $V$, the orthogonal complement of $U$, denoted by $U^\perp$, is defined as
$$
U^\perp = \{v \in V \mid \langle v, u \rangle = 0 \text{ for all } u \in U\}.
$$

Orthogonal complement has the following properties:
1. $U^\perp$ is a subspace of $V$.
2. $\{0\}^\perp = V$
3. $V^\perp = \{0\}$.
4. $U \cap U^\perp = \{0\}$.
5. if $G \subseteq H$, then $H^\perp \subseteq G^\perp$.

<br />

> [!Warning]
> We did not specify that $U$ is a subspace in the definition of orthogonal complement. Therefore, $U^\perp$ is always a subspace of $V$ regardless of whether $U$ itself is a subspace.

**Lemma 6.11 - Direct-sum Decomposition with Orthogonal Complement**

Suppose $U$ is a subspace of a finite-dimensional inner product space $V$. Then
$$
V = U \oplus U^\perp.
$$

In this case, we have :
$$
\begin{aligned}
&\text{(a) } \dim V = \dim U + \dim U^\perp \\
&\text{(b) } U = (U^\perp)^\perp \\

\end{aligned}
$$

<br />

**Definition 6.8 - Orthogonal Projection**

Suppose $U$ is a finite-dimensional subspace of a finite-dimensional inner product space $V$. The orthogonal projection of $V$ onto $U$ is the linear operator $P_U \in \mathcal{L}(V)$ defined as follows : For each $v \in V$, write $v = u + w$, where $u \in U$ and $w \in U^\perp$. Then
$$
P_U(v) = u.
$$

> [!Note]
> We know that, given a vector $v \in V$, there are many ways to decompose it $v = u + w$, where $u, w \in V$. However there is only one way to decompose it such that $u \in U$ and $w \in U^\perp$. This ensures that the orthogonal projection $P_U(v)$ is well-defined. The linear operator is also used to extract the component of $v$ that lies in $U$.

The properties of orthogonal projection include:
1. $P_U \in \mathcal{L}(V)$.
2. $P_U u = u$ for all $u \in U$.
3. $P_U w = 0$ for all $w \in U^\perp$.
4. $\text{range}(P_U) = U$.
5. $\text{null}(P_U) = U^\perp$.
6. $v - P_U(v) \in U^\perp$ for all $v \in V$.
7. $P_U^2 = P_U$ (idempotent property).
8. $\|P_U(v)\| \leq \|v\|$ for all $v \in V$.
9. if $e_1, ..., e_m$ is an orthonormal basis of $U$, then for all $v \in V$,
$$
P_U(v) = \sum_{i=1}^m \langle v, e_i \rangle e_i.
$$

<br />

**Lemma 6.12 - Minimizing Distance to a Subspace**

Suppose $U$ is a finite-dimensional subspace of a finite-dimensional inner product space $V$. For any $v \in V$, the distance from $v$ to $U$ is minimized by the orthogonal projection of $v$ onto $U$. In other words,
$$
\|v - P_U(v)\| = \min_{u \in U} \|v - u\|.
$$

<br />

# Operators on Inner Product Spaces

# Multilinear Algebra and Determinants