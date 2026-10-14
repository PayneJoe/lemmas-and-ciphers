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
    then the basis $[a, b]$ is strictly reduced, and they are in the same direction, return $[a, b]$.

2. For the rest of lines, it is the case of $\| a - b \| \lt \| b \|$, there are two subcases to consider:

   - (2.1) for the line-4, $\| a \| \le \| a - b \| \lt \| b \|$, then basis $[a, b]$ is a typical well-ordered basis, and they are in the same direction.

   - (2.2) for line-5 and line-6, $\| a - b \| \le \| a \| \le \| b \|$, then there are two subcases to consider : 

      - (2.2.1) for the line-5, $\| a - b \| \le \| a \| = \| b \|$, this is a very special case, $\|a \| = \| b \|$ and $\| a - b \| \le \| a \|$ ensure that vectors $a - b$ and $a$ are in the same direction, in this case, $\| a \| = \| b \| \le \| 2a - b \|$. Since $\| (a - b) - a \| = \| b \|$, thus the basis $[a - b, a]$ is reduced, and they are in the same direction, return $[a - b, a]$.

      - (2.2.2) from line-6, $\| a - b \| \le \| a \| < \| b \|$, we do not know the whether $a - b$ and $a$ are in the same direction or not, but $\| a \| \le \| b \|$ and $\| a - b \| \le \| a \|$ ensures that vectors $b - a$ and $a$ are in the same direction, so $\| b - a \| \le \| (b - a) - a \| \le \| a \|$. Therefore, the basis $[b - a, a]$ is well-ordered basis. 

The remaining problem is how to find the reduced basis through well-ordered basis in the loop :

1. Since $[a, b]$ is a well-ordered basis, there are other lattice vectors that can be fit between $[\| a \|, \| b \|]$, what we need to do is finding the smallest one. This is achieved by find the integer $\mu$ such that $\| b - \mu a \|$ is minimal, then replace $b$ with $b - \mu a$.

2. Now we can check that if the updated basis $[a, b]$ is reduced, not that before checking we need to make sure that $\| a \| \le \| b \|$, if not, swap $a$ and $b$.

3. repeat the above steps until the basis $[a, b]$ is reduced.

</details>
<br />

*Lemma 2.3 - Let $a, b$ be two vectors such that $\| b - a \| < \| b \|$. Then, one can efficiently find an integer $\mu$ such that $\| b - \mu a \|$ is minimal. Moreover, $\mu$ satisfies $1 \le \mu \le \lceil 2\frac{\| b \|}{\| a \|} \rceil$.*

![Gauss Algorithm 1](./img/gauss-algorithm-1.png)

<details>
<summary>Explanation</summary>

Note that, in Gauss algorithm, before entering the loop, we have ensured that the basis $[a, b]$ is well-ordered, i.e., $\| a \| \le \| b \|$ and $\| a \| \le \| a - b \| \le \| b \|$. But, this theorem does only mentioned last-half condition of well-ordered basis, i.e., $\| a - b \| \le \| b \|$. So this is a more general setting than the well-ordered basis condition.

<br />

For better understanding Gauss algorithm, we will specially consider the l2 norm, and explain why we are able to find a reduced basis from well-ordered basis with geometric intuition. 

Condition $\| a \| \le \| a - b \| < \| b \|$  implies :
- vectors $a, b$ are in the same direction.
- projection scalar of $b$ onto $a$, i.e., $\frac{\langle a, b \rangle}{\| a \|^2} > 1/2$. 
- the minimal distance between $b$ and $a$ is $\| b - \frac{\langle a, b \rangle}{\| a \|^2} a \|$.

Two cases involved in finding the optimal integer $\mu$ are:
1. If $\frac{1}{2} < \frac{\langle a, b \rangle}{\| a \|^2} \le 1$, then $\| b - \mu a \|, u \in \mathbb{N}$ increases as $\mu$ moves away from the minimal value $\frac{\langle a, b \rangle}{\| a \|^2}$. In this case, $\mu = 1$ is the optimal integer choice.
2. If $\frac{\langle a, b \rangle}{\| a \|^2} > 1$, then $\| b - \mu a \|, u \in \mathbb{N}$ increases in the range $[1, \frac{\langle a, b \rangle}{\| a \|^2})$, and decreases in the range $(\frac{\langle a, b \rangle}{\| a \|^2}, \infty)$. In this case, the optimal integer choice must come from either $\lfloor \frac{\langle a, b \rangle}{\| a \|^2} \rfloor$ or $\lceil \frac{\langle a, b \rangle}{\| a \|^2} \rceil$.

----

Additionally, we will simply explain why $\frac{\langle a, b \rangle}{\| a \|^2} > 1/2$ in the contex of well-ordered basis with one diagraph below.

![Well Ordered Basis](./img/well-ordered-basis.png)

</details>
<br />

## Running Time Analysis

<br />

# Approximating SVP in Dimension n

<br />

# Approximating CVP in Dimension n

<br />
