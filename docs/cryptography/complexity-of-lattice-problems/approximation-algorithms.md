# Solving SVP in Dimension 2

## Reduced Basis

Definition 2.1 - Let $[a, b]$ be a lattice basis. The basis is reduced if 
$$
|\| a \|, \| b \| \le \| a + b \|, \| a - b \|
$$

> [!Note] Intuition Behind
> Consider constructing a triangle with known two edges $a$ and $b$, the third edge is unknown. If $[a, b]$ is reduced, by definition, we can say that $a, b$ are the shortest two edges of the triangle.

----
<br />

Lemma 2.1 - Consider three vectors on a line, $x, x + y, x + ay$, where $a \in \mathbb{R}$. Then if $\| x \| \le \| x + y \|$ then $\| x + y \| \le \| x + ay \|$, moreover $\| x + y \| \le \| x + ay \|$.

![Reduced Basis 1](./img/reduced-basis-1.png)

<details>
<summary>Explanation</summary>

Intutively, given $x, x + y$, if $\| x \| \le \| x + y \|$, then we are clear that both $x$ and $y$ are pointing in roughly the same direction, and adding any multiple of $y$ to $x + y$ will only increase the norm.

Similarly, if $\| x \| \le \| y - x \|$, then $y$ and $x$ are pointing in roughly the contradictory direction, furthermore, $\| x \| \le \| y - x \| \le \| ay - x \|$.

</details>
<br />

> [!Important]
> So what is the relationship between reduced basis and the successive minima of the lattice?

Theorem 2.2 - Let $[a, b]$ be a lattice basis, and let $\lambda_1$ and $\lambda_2$ be the successive minima of the lattice. If the basis is reduced, then $\| a \| = \lambda_1$ and $\| b \| = \lambda_2$.

![Reduced Basis 2](./img/reduced-basis-2.png)

<details>
<summary>Explanation</summary>

From the definition of reduced basis, we know that whether $a$ and $b$ have the same direction or not, we need to ensure that either of $a$ or $b$ is the shortest vector in the lattice. Without loss of generality, we assume $\| a \| \le \| b \|$ :
- if $a, b$ have the same direction, then $\| b \| \le \| a + b \|$.
- if $a, b$ have the opposite direction, then $\| b \| \le \| a - b \|$.
put them together, we need to ensure $\| b \| \le \min \{ \| a + b \|, \| a - b \| \}$. Therefore,  
$$
\| a \| \le \| b \| \le \min \{ \| a + b \|, \| a - b \| \}
$$
In general, we have  
$$
\| a \|, \| b \| \le \| a + b \|, \| a - b \|
$$
namely, basis $[a, b]$ is reduced.

</details>
<br />

## Gauss Algorithm

Definition 2.2 - For a lattice basis $[a, b]$, without loss of generality, we assume $\| a \| \le \| b \|$, if $\| a \| \le \| a - b \| \le \| b \|$, then we call the basis $[a, b]$ a well-ordered basis.

<br />

**Algorithm**

![Gauss Algorithm](./img/gauss-algorithm.png)

<details>
<summary>Explanation</summary>

For the line-1 and line-2, we are trying to ensure 
- lattice vector $a$ is the smaller one, i.e., $\| a \| \le \| b \|$ 
- both lattice vectors $a$ and $b$ are in the same direction, i.e., $\| a - b \| \le \| a + b \|$.

----

After then we will consider following cases :

1. For the line-3, it is the simplest case where $\| b \| \le \min \{ \| a + b \|, \| a - b \| \} = \| a -  b \|$, in this case, we must have :
    $$
    |\| a \| \le \| b \| \le \| a - b \| \le \| a + b \|
    $$
    then the basis $[a, b]$ is strictly reduced, return $[a, b]$.

2. For the line-4, it is the case of $\| a - b \| \le \| b \|$, there are two subcases to consider:
   - (2.1) $\| a \| \le \| a - b \|$, then basis $[a, b]$ is a typical well-ordered basis.
   - (2.2) $\| a - b \| \le \| a \| \le \| b \|$, then there are two subcases to consider : 
      - (2.2.1) $\| a - b \| \le \| a \| = \| b \|$, this is a very special case, $\|a \| = \| b \|$ and $\| a - b \| \le \| a \|$ ensure that vectors $a - b$ and $a$ are in the same direction, in this case, $\| a \| = \| b \| \le \| 2a - b \|$. Since $\| (a - b) - a \| = \| b \|$, thus the basis $[a - b, a]$ is reduced, return $[a - b, a]$.
      - (2.2.2) $\| a - b \| \le \| a \| < \| b \|$, we do not know the whether $a - b$ and $a$ are in the same direction or not, but $\| a \| \le \| b \|$ and $\| a - b \| \le \| a \|$ ensures that vectors $b - a$ and $a$ are in the same direction, so $\| b - a \| \le \| (b - a) - a \| \le \| a \|$. Therefore, the basis $[b - a, a]$ is well-ordered basis. 

</details>
<br />

## Running Time Analysis

<br />

# Approximating SVP in Dimension n

<br />

# Approximating CVP in Dimension n

<br />
