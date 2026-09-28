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

<br />

## Diagonalizable Operators

<br />

## Commuting Operators

<br />

# Inner Product Spaces

# Operators on Inner Product Spaces

# Multilinear Algebra and Determinants