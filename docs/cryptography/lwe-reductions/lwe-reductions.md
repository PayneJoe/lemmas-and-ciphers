The **discrete Gaussian distribution**  $D_{\mathcal{L}, r}(x)$ is defined over a lattice $\mathcal{L}$ with parameter $r$ such that the probability of sampling a lattice vector $x \in \mathcal{L}$ is proportional to its weight
$$
    w(x) = e^{-\pi \|x\|^2 / r^2}
$$
where $r$ is the Gaussian parameter, ensures that vectors closer to the origin are more likely to be chosen, which is crucial for many lattice-based cryptographic constructions.

![Discrete Gauss Distribution](./img/discrete-gauss-distribution.png)

We see that :
- smaller length of vector $x$ is more likely to be sampled.
- smaller parameter $r$ means the distribution is more concentrated around the origin, making shorter vectors more likely to be sampled.