## Fundamentals

### Basic Logic Inference

1. $P \to Q, P \implies Q$ 
2. $P \to Q, \neg Q \implies \neg P$
3. $P \lor Q, \neg P \implies Q$
4. $P (\text{or } Q) \implies P \lor Q$
5. $P, Q \implies P \land Q$
6. $P \land Q \implies P (\text{or } Q)$
7. $P \lor Q \to R \implies (P \to R) \land (Q \to R)$

### Equivalence 

**Equality Problem**
Find the equivalence of equality problem :
1. $a = b \iff a \le b \land b \le a$, reduce the equality problem to a pair of inequality problems.
2. $a = b \iff a \cdot 1 = b \iff a \cdot (c \cdot c^{-1}) = b$, introducing multiplication by identity.

**Inequalitiy Problem**
Find the equivalence of inequality problem :
1. $a \le b \iff \neg (a > b)$, reduce the inequality problem to its negation.
2. $a \le b \iff a \le c \land c \le b$, reduce the inequality problem to a pair of inequalities with an intermediate value $c$.

<br />

### Counting

**Counting Multisets**

*Definition : Multiset is a special kind of set where elements are allowed to appear more than once.*

<br />

Given a multiset with $n$ elements, the number of ways to choose $k$ elements from it is given by the formula:
$$
\binom{n + k - 1}{k}
$$

Proof : This is a typical example of star-and-bars problem, which is a combinatorial method used to determine the number of ways to place $k$ indistinguishable items into $n$ distinguishable bins. There are $k + n - 1$ positions in total, in which $k$ positions are chosen to place the items, and the remaining $n - 1$ positions are used as dividers between the bins.

<br />

**Counting Permutations of Multisets**

Given a multiset with $n$ elements, where the element $i$ appears $n_i$ times ($i = 1, 2, \dots, k$), the number of distinct permutations of the multiset is given by the formula:
$$
\frac{n!}{n_1! n_2! \cdots n_k!}
$$

<br />

**Pigeonhole Principle**

*Definition : If $n$ items are put into $m$ containers, with $n > m$, then at least one container must contain more than one item. On the contrary if $n \le m$, it is possible that each container contains at most one item.*

<br />

Example : Choose $6$ distinct numbers from $0-9$, then exists a pair of numbers whose sum is $9$.

Proof : 
1. divide $0-9$ into five buckets containing $(0, 9), (1, 8), (2, 7), (3, 6), (4, 5)$ separately.
2. By the pigeonhole principle, since we are choosing $6$ numbers and there are only $5$ buckets, at least one bucket must contain at least two chosen numbers.
3. The two numbers in the same bucket sum to $9$.

<br />

**Combinatorial Proof**

$$
\binom{n + 1}{k} = \binom{n}{k - 1} + \binom{n}{k}
$$

Proof : The left-hand side describes the number of ways to choose $k$ elements from a set of $n + 1$ elements. We can split this combinatorial problem into two sub-cases:
1. The first item of the set is chosen. Then we only need to choose the remaining $k - 1$ elements from the remaining $n$ elements, which can be done in $\binom{n}{k - 1}$ ways.
2. The first item of the set is not chosen. Then we need to choose all $k$ elements from the remaining $n$ elements, which can be done in $\binom{n}{k}$ ways.

<br />

## How to Prove Conditional Statements

Regardint statement $P \to Q$, there are several common methods to prove it.

### Direct Proof

**Methodology of direct proof**

The methodology of direct proof involves assuming the premise $P$ is true and then using logical reasoning and known facts to show that the conclusion $Q$ must also be true. The steps are as follows:
1. write down the line of premise $P$ in the proof.
2. write down the line of conclusion $Q$ in the proof, left the middle part empty. 
3. fill in the middle part with logical reasoning and known facts to connect $P$ to $Q$, in practice the process is not always straightforward from top to bottom, and it may jump between up and down until the connection happens in the middle of somewhere.

<br />

**Using Cases**

Given statement $P$, we want to prove $Q$. If the statement $P$ can be splitted into several cases, typically if $P = P_1 \lor P_2$, then we can prove $Q$ by considering each case separately:
1. Consider the first case $P_1$. Prove that $P_1 \to Q$.
2. Consider the second case $P_2$. Prove that $P_2 \to Q$.
3. Both cases hold, then we have $P = (P_1 \lor P_2) \to Q$

This is a basic technique in direct proof, often referred to as proof by cases, which can be formulated as:
$$
(P \lor Q) \to R \implies (P \to R) \land (Q \to R)
$$

<br />

### Contrapositive Proof

### Proof by Contradiction