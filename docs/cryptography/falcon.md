# Falcon: Lattice-Based Digital Signature Scheme

Why the shortness of the basis of orthogonal lattice $\mathcal{L}_A^{\perp}$ ensures the security of SIS-based signature schemes? We will explain this in the next section.

## Pubkey and Secret Key

Solving the ISIS problem is at the core of the Falcon digital signature scheme, which relies on the hardness of finding short integer solutions to certain lattice-based problems. It is formally defined as finding a **short enough**, e.g. $\| s \|_2 < \beta$, vector $s$ that satisfies:
$$
A \cdot s = u \pmod q
$$
where $A \in \mathbb{Z}_q^{n \times m}$ and $u \in \mathbb{Z}_q^n$ forms the pubkey of ISIS-based signature, and <u> $s \in \mathbb{Z}^m$ is the secret vector to be found </u>. 

No! In practice, $u \in \mathbb{Z}_q^n$ encodes the message to be signed, in this case, the secret $s$ which depends on message cannot be qualified as secret key of the signature scheme. Because secret key is used to be sign many messages, it must be independent of message content. So, what is the actual secret key?

----

ISIS problem can be reduced to a classical CVP problem :
1. Find any solution (not necessarily short) $t \in \mathbb{Z}^m$ to the equation:
    $$
    A \cdot t = u \pmod q
    $$
2. Find a vector $z$ in orthogonal lattice : 
    $$
    \mathcal{L}_A^{\perp} = \{ x \in \mathbb{Z}^m : A \cdot x = 0 \pmod q \}
    $$
    which is the closest lattice vector to $t$, that is $\| t - z \|_2$ is minimized.
3. If the basis $\mathcal{B}$ of the lattice $\mathcal{L}_A^{\perp}$ is sufficiently **short enough**, then it is likely that the displacement 
    $$
    s = t - z 
    $$
    is what we are looking for, i.e., a short solution to the ISIS problem.

As we see, step (1) is computationaly possible in the inhomegeneous system. And step (2) is essentially solving a Closest Vector Problem (CVP) in the lattice $\mathcal{L}_A^{\perp}$, which is known to be **computationally hard** in general. But, it is not always hard, especially if we know a short basis $\mathcal{T} = [t_1, t_2, \dots, t_m]$ of $\mathcal{L}_A^{\perp}$. 
1. We can find the coefficients of $t$ on the basis $\mathcal{T}$ in $\mathbb{Q}^m$: 
    $$
        t = \sum_{i=1}^m \alpha_i t_i, \alpha_i \in \mathbb{Q}
    $$
2. Then the rounded of $t$ is in the lattice $\mathcal{L}_A^{\perp}$ 
    $$
        z = \sum_{i=1}^m \lfloor \alpha_i \rceil t_i, \lfloor \alpha_i \rceil \in \mathbb{Z}
    $$
3. Finally, the displacement 
    $$
     \| t - z \|_2 = \left\| \sum_{i=1}^m (\alpha_i - \lfloor \alpha_i \rceil) t_i \right\|_2
    $$
    is short enough if and only if the basis vectors $t_i$ are sufficiently short as all coefficients $(\alpha_i - \lfloor \alpha_i \rceil)$ are already bounded by $1/2$ in absolute value.

Therefore, if the length of $\mathcal{T}$ is bounded by a sufficiently small value $\gamma$ such that the displacement is guaranteed to be within the desired bound, i.e., 
$$
\| t - z \|_2 \leq \frac{\sqrt{m}}{2} \gamma \le \beta
$$
then the SVP problem is solved, furthermore the ISIS problem can be efficiently solved.

---

In conclusion, given parameters $\beta$ and $\gamma$ which satisfy the condition 
$$
\frac{\sqrt{m}}{2} \gamma \le \beta,
$$
If we know a short basis $\mathcal{T}$ bounded by $\gamma$, then the ISIS problem can be efficiently solved. Therefore, this short basis $\mathcal{T}$ is regarded as the secret key in SIS-based signature schemes. In addition, any public info including pubkey and signature cannot leak any information about the secret key, otherwise, the hardness of ISIS or CVP is broken.

