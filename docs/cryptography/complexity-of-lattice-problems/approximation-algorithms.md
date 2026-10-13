# Solving SVP in Dimension 2

## Reduced Basis

Definition 2.1 - Let $[a, b]$ be a lattice basis. The basis is reduced if 
$$
|\| a \|, \| b \| \le \| a + b \|, \| a - b \|
$$

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

<br />

## Running Time Analysis

<br />

# Approximating SVP in Dimension n

<br />

# Approximating CVP in Dimension n

<br />
