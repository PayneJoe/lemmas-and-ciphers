## Ch02 - Early Results

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

## Ch03 - Modern Foundations

### 3.1 - SIS Problem 

**Definition of SIS problem**

Given a matrix $A \in \mathbb{Z}_q^{n \times m}$ and a positive integer $\beta$, the Short Integer Solution (SIS) problem asks to find a non-zero integer vector $z \in \mathbb{Z}^m$ such that:
$$
    A z \equiv 0 \pmod{q} \quad \text{and} \quad \| z \| \le \beta.
$$

<br />

### 3.2 - Observations on the SIS Problem

1. If no constraint on $\| z \| \le \beta$, then it is easy to find a solution via Gauss elimination. Furthermore, in order to ensure the solution of $z$ is non-trivial, we have to constrain parameter $\beta \lt q$, otherwise many trivial solutions exists, for example $z = [q, 0, ..., 0] \in \mathbb{Z}^m$.

2. We see that solving the SIS problem is solving a constrained linear system over the integers. So, more constrains implies more difficulty for finding a solution, and more unkowns (or variables) generally makes the problem easier, as it provides more degrees of freedom to satisfy the constraints. Therefore, we have 

    * larger $n$ increases the number of constraints, making the problem harder.
    * larger $m$ increases the number of variables, making the problem easier.
    * larger bound $\beta$ allows for larger solution space to search, making the problem easier.

3. $m > n \log_2 q$ and $\sqrt{m} \le \beta$ guarantees the existence of solutions  to the SIS problem. 

    Consider a map represented by matrix $A$, its input is $x \in \{0, 1\}^m$, and output is $y = A x \pmod{q} \in \mathbb{Z}_q^n$. There are $2^m$ possible elements in input domain, and $q^n$ possible elements in the output domain. If $2^m > q^n$, then by the pigeonhole principle, there must exist distinct inputs $x_1, x_2 \in \{0, 1\}^m$ such that $A x_1 \equiv A x_2 \pmod{q}$. Consequently, $z = x_1 - x_2 \in \{-1, 0, 1\}^m$ is a non-zero solution to the SIS problem if it is within the bound $\| z \| \le \beta$.

    Obviously, the solution norm is bounded by $\| z \| \le \sqrt{m}$. Thus, if we further set the bound parameter $\sqrt{m} \le \beta$, then existence of a non-trivial solution $z$ to the SIS problem is always guaranteed.

<br />

### 3.3 - Compression of SIS Instances

Actually, SIS instances can often be compressed without changing the underlying problem significantly. Given a matrix $A \in \mathbb{Z}_q^{n \times m}$, one can compress the size of instance $A$ by $n$ columns through a technique from linear algebra called **Hermite normal form (HNF)**.

Specifically, we can split matrix $A$ into two parts $A = [A_1 \mid A_2]$, *assume the left square matrix $A_1 \in \mathbb{Z}_q^{n \times n}$ is invertible*, that is to say, the first $n$ columns are linearly independent. Then, we can transform $A$ into its Hermite normal form:
$$
    A_1^{-1} \cdot A \equiv [I_n \mid \overline{A} = A_1^{-1} A_2] \pmod{q},
$$
where $I_n$ is the $n \times n$ identity matrix. If $z \in \mathbb{Z}^m$ is a solution to the SIS problem for the original matrix $A$, then it is also a solution for its HNF matrix $[I_n \mid \overline{A}]$. Vice versa, any solution for the HNF matrix is also a solution for the original matrix $A$.

<details>
<summary> Here is the explanation ... </summary>

For the forward direction 
$$
A z = 0 \implies A_1^{-1} (A z) = 0
$$
always trivially holds.

For the backward direction
$$
A_1^{-1} A z = 0 \implies A z = 0
$$
also holds since $A_1$ is invertible ensures that all columns of $A_1$ are linearly independent, that is $A z = 0$.

</details>
<br />

### 3.4 - Hardness

For now, we see that pure SIS problem is not a kind of classical lattice problems, for example SVP, CVP, or SIVP. But we can relate its hardness to these problems through **reductions**. We will immediately show how to construct a SIVP instance from a given SIS instance.

----

First of all, let us recall the definition of the SIVP problem. Given a lattice $\Lambda = \mathcal{L}(B) \subset \mathbb{R}^n$ with rank $n$ and a parameter $\gamma \ge 1$, the $\gamma$-SIVP problem asks to find $n$ linearly independent lattice vectors $v_1, \dots, v_n \in \Lambda$ such that
$$
\| v_i \| \le \gamma \cdot \lambda_n(\Lambda) \quad \text{for all } i = 1, \dots, n,
$$
where $\lambda_n(\Lambda)$ denotes the $n$-th successive minimum of the lattice $\Lambda$, i.e., the smallest radius $r$ such that $\Lambda$ contains $n$ linearly independent vectors of norm at most $r$.

<br />

Then, we will focus on constructing a SIVP instance from a given SIS instance with a lattice $\Lambda$ with basis $B$, and show how the hardness of SIS can be related to the hardness of SIVP.

**Step 1: Sampling the SIS matrix**

Given the basis $B \in \mathbb{R}^{n \times n}$ of the lattice $\Lambda$, by randomly sampling an integer vector $a_i \in \mathbb{Z}^n$, we can then obtain a lattice vector corresponding to $a_i$ :
$$
v_i = B \cdot a_i
$$
So, if we sample $m$ times, we obtain a lattice matrix $V^{n \times m}$ corresponding to a random integer matrix $A^{n \times m}$, that is,  
$$
V = B \cdot A
$$
, where matrix $A$ is the SIS matrix.

<br />

**Step 2: Generating an SIVP vector**

Assume there is a SIS oracle $O$, given the SIS matrix $A$, we can query $O$ to obtain a non-trivial solution $z \in \mathbb{Z}^m$ such that
$$
A z = 0 \pmod{q} \tag{3.1} 
$$
Then, we can construct a new lattice vector with the SIS solution vector $z$ and initially sampled lattice matrix $V$ as follows:
$$
v = \frac{V \cdot z}{q} = \frac{B \cdot A \cdot z}{q} = B \cdot \frac{A \cdot z}{q} = B \cdot c 
$$
where $c = \frac{A \cdot z}{q} \in \mathbb{Z}^n$ is an integer vector as equation (3.1) already ensures that $A \cdot z$ is divisible by $q$. Thus, vector $v$ is a lattice vector in $\Lambda$.

----

Furthermore, we can try to bound the norm of the new lattice vector $v$ as follows. By triangle inequality, we have
$$ 
\| V z \| \le \sum_{i=1}^m |z_i| \cdot \| v_i \|.
$$
Assume the length of inital sampled lattice vector $v_i$ is bounded by some value $\| v_i \| \le R$, then we have 
$$
\sum_{i = 1}^m | z_i | \cdot \| v_i \| \le \| z \|_1 \cdot R.
$$
By Cauchy-Schwarz inequality $| \langle u, v \rangle | \le \| u \|_2 \cdot \| v \|_2$, we have
$$
\| z \|_1 = \langle z, \mathbf{1} \rangle \le \| z \|_2 \cdot \| \mathbf{1} \|_2 = \| z \|_2 \cdot \sqrt{m},
$$
which implies
$$
\| V z \| \le \| z \|_1 \cdot R \le \sqrt{m} \cdot \| z \|_2 \cdot R.
$$

Therefore, the norm of the reduced lattice vector $v$ is bounded as :
$$
\| v \| = \left\| \frac{V z}{q} \right\| = \frac{\| V z \|}{q} \le \frac{\sqrt{m} \cdot \| z \|_2 \cdot R}{q} 
$$
So if $q$ is sufficiently large compared to $\sqrt{m} \cdot \| z \|_2$, the norm of the reduced lattice vector $v$ can be made much smaller compared with initial bound $R$.

----

For now, we only obtain an shorter lattice vector $v$ whose norm is dropped by a factor of roughly $\frac{\sqrt{m} \cdot \| z \|_2}{q}$ compared to the initial bound $R$ on the original lattice vectors $v_i$. If we repeat this (sampling) process $n$ times, then we will get $n$ such lattice vectors like $v$. 

But our final goal is to generate a SIVP solution, two conditions must be satisfied simultaneously for each iteration :  
1. We need to ensure that the newly generated vector is linearly independent from the previously generated vectors. I think this is achievable by carefully choosing the SIS matrix $A$ and the solution vector $z$ in each iteration, so that the resulting lattice vector $v$ does not lie in the span of the previously generated vectors. We won't plan to detail too much here for this.

2. We need to ensure that 
    $$
        \| v \| \le \gamma \cdot \lambda_n(\Lambda)
    $$
    where $\gamma$ is the approximation factor and $\lambda_n(\Lambda)$ is the $n$-th successive minimum of the lattice $\Lambda$. This condition ensures that the generated vector $v$ is not only short but also within a factor $\gamma$ of the optimal shortest vector in the lattice. 
    
    > [!Warning]
    Notice that $\lambda_n(\Lambda)$ is an intrinsic property of the lattice that represents the length of the longest vector among the $n$ linearly independent shortest vectors in the lattice. We do not know its exact value in general, it only provides a benchmark for analysis, we won't actually compare $\| v \|$ with $\lambda_n(\Lambda)$ in practice.

So, the natural question is how to ensure the second condition of SIVP problem is satisfied?

<br />

**Step 3: Ensuring the Second Condition**

