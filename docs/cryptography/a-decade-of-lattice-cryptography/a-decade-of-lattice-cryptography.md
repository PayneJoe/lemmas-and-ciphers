## Early Results

1. Why do we need worse-case to average-case reductions in lattice-based cryptography?

    *Lattice hard problems are believed to be difficult to solve in the worst case. But not every instance of these problems is hard, and some instances may be easy to solve, for example when we use orthogonal basis vectors. In cryptography, we need to ensure **almost all** instances of the problem are hard, or average-case hard, to guarantee the security of cryptographic schemes. So we rely on worst-case to average-case reductions to construct cryptographic primitives whose security is based on the hardness of worst-case lattice problems.*

<br />

2. Why hyperplane ?

    It translate the closeness between a inner product and an integer into a geometric condition, specifically the distance from a point to a hyperplane defined by the lattice vectors.

    Given a secret vector $s$, define the hyperplane associated with an integer $j$ by :
    $$
        H_{s, j} = \{ x \in \mathbb{R}^n : \langle s, x \rangle = j \}
    $$
    where $x$ are vectors whose projection on $s$ is fixed value $j / \| s \|$, so the collect of $x$ forms a hyperplane which is **perpendicular** to $s$. Different $j$ corresponds to parallel hyperplanes at different distances along the direction of $s$. *These hyperplane has been embeded important geometric information, distance and direction.*

    If we want to know how close between $\langle s, x \rangle$ and an integer $j$, we can measure the distance from $x$ to the hyperplane $H_{s, j}$:
    $$
        \text{dist}(y, H_{s, j}) = \frac{|\langle s, y \rangle - j|}{\| s \|}
    $$

<br />

## Modern Foundations

### SIS Problem 

**Definition of SIS problem**

Given a matrix $A \in \mathbb{Z}_q^{n \times m}$ and a positive integer $\beta$, the Short Integer Solution (SIS) problem asks to find a non-zero integer vector $z \in \mathbb{Z}^m$ such that:
$$
    A z \equiv 0 \pmod{q} \quad \text{and} \quad \| z \| \le \beta.
$$

----

A few observations about the SIS problem :
1. If no constraint on $\| z \| \le \beta$, then it is easy to find a solution via Gauss elimination. Furthermore, in order to ensure the solution of $z$ is non-trivial, we have to constrain parameter $\beta \lt q$, otherwise many trivial solutions exists, for example $z = [q, 0, ..., 0] \in \mathbb{Z}^m$.

2. We see that solving the SIS problem is solving a constrained linear system over the integers. So, more constrains implies more difficulty for finding a solution, and more unkowns (or variables) generally makes the problem easier, as it provides more degrees of freedom to satisfy the constraints. Therefore, we have 

    * larger $n$ increases the number of constraints, making the problem harder.
    * larger $m$ increases the number of variables, making the problem easier.
    * larger bound $\beta$ allows for larger solution space to search, making the problem easier.

3. $m > n \log_2 q$ and $\sqrt{m} \le \beta$ ensures that there exists solutions $z \in \{-1, 0, 1\}^m$ to the SIS problem with high probability. 

    Consider a map represented by matrix $A$, its input is $x \in \{0, 1\}^m$, and output is $y = A x \pmod{q} \in \mathbb{Z}_q^n$. There are $2^m$ possible elements in input domain, and $q^n$ possible elements in the output domain. If $2^m > q^n$, then by the pigeonhole principle, there must exist distinct inputs $x_1, x_2 \in \{0, 1\}^m$ such that $A x_1 \equiv A x_2 \pmod{q}$. Consequently, $z = x_1 - x_2 \in \{-1, 0, 1\}^m$ is a non-zero solution to the SIS problem.

    Furthermore, the solution norm is bounded by $\| z \| \le \sqrt{m}$. Thus, if we further set the bound parameter $\sqrt{m} \le \beta$, then a non-trivial solution $z$ to the SIS problem is always guaranteed.


