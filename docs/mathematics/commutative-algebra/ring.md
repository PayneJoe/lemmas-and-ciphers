<details>
<summary>Table of Contents</summary>

- [Rings and Ideals](#rings-and-ideals)
  - [Special Elements of Ring](#special-elements-of-ring)
    - [Facts on Special Elements of Ring](#facts-on-special-elements-of-ring)
    - [Domain VS Field](#domain-vs-field)
  - [Ideal](#ideal)
    - [Definitions of Some Ideals](#definitions-of-some-ideals)
    - [Special Ring](#special-ring)
    - [Facts on Ideals](#facts-on-ideals)
  - [Ideal Operations](#ideal-operations)
    - [Facts on Ideal Operations](#facts-on-ideal-operations)
    - [Properties of the Radical](#properties-of-the-radical)
  - [Maximal Ideal](#maximal-ideal)
    - [Zorn's Lemma](#zorns-lemma)
    - [Facts on Maximal Ideal](#facts-on-maximal-ideal)
  - [Other Special Ideals](#other-special-ideals)
    - [Facts on Special Ideals](#facts-on-special-ideals)

</details>

<br />

Note that all rings considered here are commutative and have a multiplicative identity.

Lean 4 proofs are given under each proof below. They are collected and compiled in [`mathlib-in-lean/commutative-algebra/Ring.lean`](https://github.com/PayneJoe/lemmas-and-ciphers/blob/main/mathlib-in-lean/commutative-algebra/Ring.lean). All snippets assume `variable {A : Type*} [CommRing A]`.

# Rings and Ideals

## Special Elements of Ring

1. A **set of units**, $A^* = \{a \in A \mid \exists b \in A, a \cdot b = 1\}$

2. A **set of zero divisors**, $\mathcal{D}(A) = \{a \in A \mid \exists b \in A \setminus \{0\}, a \cdot b = 0\}$

3. A **set of nilpotent elements**, $\mathcal{N}(A) = \{a \in A \mid \exists n \in \mathbb{N}, a^n = 0\}$

4. $a$ is **idempotent** if $a^2 = a$

<br />

### Facts on Special Elements of Ring

1. If $A \ne 0$, then $\mathcal{N}(A) \subseteq \mathcal{D}(A)$, i.e., every nilpotent element is a zero divisor.

    <details>
    <summary>Proof</summary>

    It is suffice to show that $\forall y \in \mathcal{N}(A) \to y \in \mathcal{D}(A)$.

    By definition (3), choose the **least** $n \in \mathbb{N}$ such that $y^n = 0$. Since $y^0 = 1 \ne 0$, we have $n \ge 1$, so $0 = y^n = y \cdot y^{n - 1}$. By minimality of $n$, $y^{n - 1} \ne 0$. By definition (2), use $b = y^{n - 1}$, we have $y \cdot b = 0$ with $b \ne 0$, hence $y \in \mathcal{D}(A)$.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /-- `a` is a zero divisor if `a * b = 0` for some nonzero `b`. -/
    def IsZeroDivisor (a : A) : Prop := ∃ b : A, b ≠ 0 ∧ a * b = 0

    /- Fact 1: in a nonzero ring, every nilpotent element is a zero divisor. -/
    theorem isZeroDivisor_of_isNilpotent [Nontrivial A] {y : A} (hy : IsNilpotent y) :
        IsZeroDivisor y := by
      classical
      -- choose the least `n` with `y ^ n = 0`
      set n := Nat.find hy with hn_def
      have hn : y ^ n = 0 := Nat.find_spec hy
      -- `n ≠ 0`, since `y ^ 0 = 1 ≠ 0`
      have hn0 : n ≠ 0 := by
        intro h
        rw [h, pow_zero] at hn
        exact one_ne_zero hn
      obtain ⟨m, hm⟩ := Nat.exists_eq_succ_of_ne_zero hn0
      -- take `b = y ^ (n - 1)`, which is nonzero by minimality of `n`
      refine ⟨y ^ m, fun h => ?_, ?_⟩
      · have : n ≤ m := Nat.find_min' hy h
        omega
      · calc y * y ^ m = y ^ (m + 1) := (pow_succ' y m).symm
          _ = y ^ n := by rw [hm]
          _ = 0 := hn
    ```

    </details>

    </details>

    <br />

2. If $A \ne 0$, then $A^* \cap \mathcal{D}(A) = \emptyset$, i.e., no unit is a zero divisor.

    <details>
    <summary>Proof</summary>
    
    By contradiction, assume $A^* \cap \mathcal{D}(A) \ne \emptyset$, let $x \in A^* \cap \mathcal{D}(A)$.
    
    By definition (1), there exists $y \in A$ such that $x \cdot y = 1$. 
    By definition (2), there exists an non-zero $z \in A$ such that $x \cdot z = 0$. 
    
    So, we have :
    $$
    (x \cdot y) \cdot z = 1 \cdot z = z \ne 0
    $$
    By the associativity and commutativity of $A$ (as we mentioned earlier that $A$ is commutative ring with identity), the left-hand side $(x \cdot y) \cdot z = (y \cdot x) \cdot z = y \cdot (x \cdot z) = y \cdot 0 = 0$.  
    
    This is a contradiction since the right-hand side is $z \ne 0$. Hence no unit can be a zero divisor.
    

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 2: no unit is a zero divisor. -/
    theorem not_isZeroDivisor_of_isUnit {x : A} (hx : IsUnit x) : ¬ IsZeroDivisor x := by
      rintro ⟨z, hz, hxz⟩
      obtain ⟨y, hy⟩ := hx.exists_right_inv
      -- `z = (x * y) * z = y * (x * z) = y * 0 = 0`, contradicting `z ≠ 0`
      apply hz
      calc z = (x * y) * z := by rw [hy, one_mul]
        _ = y * (x * z) := by ring
        _ = 0 := by rw [hxz, mul_zero]

    example {x z : A} (hx : IsUnit x) : x * z = 0 ↔ z = 0 := hx.mul_right_eq_zero
    ```

    </details>

    </details>
    
    <br />

3. Let $A$ be a *finite* ring. Then, $A = A^* \cup \mathcal{D}(A)$, i.e., every element of a finite ring is either a unit or a zero divisor.

    <details>
    <summary>Proof</summary>

    Firstly, considering $A = \{0\}$, then $0 \cdot 0 = 0 = 1$, so $A^* = \{0\}$ and $\mathcal{D}(A) = \emptyset$. Hence, $A = A^* \cup \mathcal{D}(A)$ in this case.

    Secondly, if $A \ne \{0\}$. By (b), we have $A^* \cap \mathcal{D}(A) = \emptyset$. Since $A^* \subseteq A$ and $\mathcal{D}(A) \subseteq A$, we have $A^* \cup \mathcal{D}(A) \subseteq A$. So it is suffice to show that $A \subseteq A^* \cup \mathcal{D}(A)$, which implies that 
    $$
    \forall x \in A \to x \in A^* \cup \mathcal{D}(A)
    $$

    Assume $x \in A$. Consider the function $f: A \to A$ defined by $f(y) = x \cdot y$. Since $A$ is finite, $f$ is either injective or not. 

    - If $f$ is not injective, then there exist distinct $y_1, y_2 \in A$ such that $x \cdot y_1 = x \cdot y_2$, which implies $x \cdot (y_1 - y_2) = 0$. Let $z = y_1 - y_2 \ne 0$, then $x \cdot z = 0$, hence $x \in \mathcal{D}(A)$. 

    - If $f$ is injective, since $A$ is finite, by the **pigeonhole principle**, $f$ is also surjective, then there exists $y \in A$ such that $f(y) = x \cdot y = 1$, hence $x \in A^*$. 

    Therefore, every element $x \in A$ is either a unit or a zero divisor, i.e., $x \in A^* \cup \mathcal{D}(A)$.
    

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 3: every element of a finite ring is a unit or a zero divisor. -/
    theorem isUnit_or_isZeroDivisor [Finite A] (x : A) : IsUnit x ∨ IsZeroDivisor x := by
      -- consider `f : A → A`, `f y = x * y`
      by_cases hinj : Function.Injective (fun y : A => x * y)
      · -- injective ⇒ surjective (pigeonhole), so `x * y = 1` for some `y`
        left
        obtain ⟨y, hy⟩ := Finite.injective_iff_surjective.mp hinj 1
        exact IsUnit.of_mul_eq_one y hy
      · -- not injective ⇒ `x * (y₁ - y₂) = 0` with `y₁ ≠ y₂`
        right
        simp only [Function.Injective, not_forall] at hinj
        obtain ⟨y₁, y₂, h, hne⟩ := hinj
        exact ⟨y₁ - y₂, sub_ne_zero.mpr hne, by rw [mul_sub, h, sub_self]⟩
    ```

    </details>

    </details>
    <br />

### Domain VS Field

1. Commutative ring + (multiplicative) identity + $\mathcal{D}(A) = 0$ is an integeral domain (or domain)

2. Commutative ring + (multiplicative) identity + $A^* = A \setminus \{0\}$ is a field.

3. A finite (integral) domain is a field. 

    <details>
    <summary>Proof</summary>

    By the proof of fact (3), $\mathcal{D}(A) = 0$ implies function $f$ is injective for every non-zero $x \in A$.

    By **pigeonhole principle**, *finite* implies that every injective function from the domain to itself is also surjective, which ensures that every non-zero element has a multiplicative inverse, hence the domain is a field.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 3: a finite integral domain is a field. -/
    theorem isField_of_finite_domain [IsDomain A] [Finite A] : IsField A := by
      refine ⟨exists_pair_ne A, mul_comm, ?_⟩
      intro x hx
      -- no zero divisors ⇒ `y ↦ x * y` is injective, hence surjective
      have hinj : Function.Injective (fun y : A => x * y) :=
        fun y₁ y₂ h => mul_left_cancel₀ hx h
      exact Finite.injective_iff_surjective.mp hinj 1

    example [IsDomain A] [Finite A] : IsField A := Finite.isField_of_domain A
    ```

    </details>

    </details>

    <br />

## Ideal 

Ideal is a subset of a ring such that 
1. It is an additive subgroup of the ring. i.e. for any $a, b \in I$, we have $a - b \in I$
2. It is closed under multiplication by any element of the ring, i.e., for all $a \in A$ and $x \in I$, we have $a \cdot x \in I$.

### Definitions of Some Ideals 

1. If an ideal $I$ is **proper**, then $1 \notin I$.

2. If a proper ideal $I$ is **maximal** if it is not strictly contained in any other proper ideal of the ring.

3. Ideal generated by a strict subset $S \subset A$ is  
   $$
   \langle S \rangle = \left\{ \sum_{i=1}^n a_i \cdot s_i \mid n \in \mathbb{N}, a_i \in A, s_i \in S \right\},
   $$
    the elements of $S$ are generators of ideal $I = \langle S \rangle$. Since cardinality $|S| = n \in \mathbb{N}$ is a finite number, the ideal $I$ is finitely generated. Let $S = \{s_1, ..., s_n\}$, then $I = \langle s_1, ..., s_n\rangle$.
   
4. If the cardinality of $S$ is 1, i.e., $S = \{s\}$, then the ideal $I$ generated by $S$ is **principal**, i.e., $I = \langle s \rangle$.

5. A ring $A$ always contains two special ideals, one is the **bottom ideal** $\langle 0 \rangle = \{0\}$ (denoted as $\bot$ lean), and the other is the **top ideal** $\langle 1 \rangle = A$ (denoted as $\top$ lean).

<br />

### Special Ring

1. A ring $A$ is called **Principal Ideal Ring (PIR)** if every ideal of $A$ is principal, i.e., can be generated by a single element. Moreover, if $A$ is also an integral domain, it is called a **Principal Ideal Domain (PID)**.

<br />

### Facts on Ideals

1. $1 \notin I \iff A^* \cap I = \emptyset$, i.e. No unit exists in a proper ideal of a ring.

    <details>
    <summary>Proof</summary>

    (a) Regarding the forward direction, in a contrapositive way, we assume $a \in A^*, a \in I$. 

    - Since $a \in A^*$, there exists $b \in A$ such that $a \cdot b = 1$. 

    - Since $a \in I$, we have $\forall c \in A, a \cdot c \in I$. 

    Putting these two hypotheses together. we obtain $a \cdot b = 1 \in I$, which contradicts the assumption that $I$ is proper.

    (b) Regarding the backward direction, assume $A^* \cap I = \emptyset$, which implies that: 
    $$
    \forall a \in I \to \urcorner(\exists b \in A, a \cdot b = 1) \\
    \Updownarrow \\
    \forall a \in I \to \forall b \in A, a \cdot b \ne 1
    $$
    By definition of ideal, $\forall b \in A, a \cdot b \in I$, therefore, $1 \notin I$.


    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 1: an ideal is proper iff it contains no unit. -/
    theorem one_not_mem_iff (I : Ideal A) : (1 : A) ∉ I ↔ ∀ a ∈ I, ¬ IsUnit a := by
      constructor
      · -- if a unit `a` with `a * b = 1` lies in `I`, then `1 = a * b ∈ I`
        intro h1 a ha hu
        obtain ⟨b, hb⟩ := hu.exists_right_inv
        apply h1
        rw [← hb]
        exact I.mul_mem_right b ha
      · -- `1` is itself a unit
        intro h h1
        exact h 1 h1 isUnit_one

    example (I : Ideal A) {a : A} (ha : a ∈ I) (hu : IsUnit a) : I = ⊤ :=
      Ideal.eq_top_of_isUnit_mem I ha hu
    ```

    </details>

    </details>

<br />

2. If $A$ is a field, then it has only has two ideals: the zero ideal $\langle 0 \rangle$ and the field itself $\langle 1 \rangle = A$.

    <details>
    <summary>Proof</summary>

    (a) Firstly, considering the special case of $A = \{0\}$, then the only ideal is $\langle 0 \rangle = \{0\}$.

    (b) Secondly, consider the case when $A$ is a non-zero field. Let $I$ be a non-zero ideal of $A$. By the definition of field $A$ : 
    $$
        \forall a \ne 0 \in A, \exists b \in A,  a \cdot b = 1.
    $$

    Take any non-zero element $a \in I \subseteq A$, by definition of ideal, we have : 
    $$
        \forall b \in A, a \cdot b \in I
    $$
    Putting these two hypotheses together, we obtain $a \cdot b = 1 \in I$. Since $1 \in I$, thus $I = \langle 1 \rangle = A$.

    Completing the proof.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 2: a field has only the ideals `⟨0⟩` and `⟨1⟩`. -/
    theorem eq_bot_or_top_of_field {K : Type*} [Field K] (I : Ideal K) : I = ⊥ ∨ I = ⊤ := by
      by_cases h : I = ⊥
      · exact Or.inl h
      · -- take a nonzero `a ∈ I`; then `1 = a⁻¹ * a ∈ I`
        right
        obtain ⟨a, ha, ha0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot h
        rw [Ideal.eq_top_iff_one, ← inv_mul_cancel₀ ha0]
        exact I.mul_mem_left a⁻¹ ha

    example {K : Type*} [Field K] (I : Ideal K) : I = ⊥ ∨ I = ⊤ := Ideal.eq_bot_or_top I
    ```

    </details>

    </details>

<br />

## Ideal Operations

1. **Intersection**. For any family of ideals $\{I_h\}_{h \in H}$ of $A$, their intersection $\bigcap_{h \in H} I_h$ is also an ideal of $A$.
   
<br />

2. **Sum**. For any family of ideals $\{I_h\}_{h \in H}$ of $A$, the ideal generated by their union $\bigcup_{h \in H} I_h$ is also an ideal of $A$. It is denoted by $\sum_{h \in H} I_h$. That is exists a function :
    $$
    f: \bigcup_{h \in H} I_h \to \sum_{h \in H} I_h = \{ \sum_{i=1}^n a_i \mid a_i \in I_{h_i}, h_i \in H, n \in \mathbb{N} \}
    $$
    which is inclusion map. $\sum_{h \in H} I_h$ is smallest ideal containing $\bigcup_{h \in H} I_h$.

<br />

3. **Product**. For any *finite* family of ideals $\{I_h\}_{h \in H}$ of $A$, their product ideal $\prod_{h \in H} I_h$ is generated by  
    $$
    \left\{ \prod_{h \in H} x_h \mid x_h \in I_h \text{ for all } h \in H \right\}.
    $$

    > [!Note] Observations
    > Fact : $I^k \subseteq I^{k - 1} \subseteq \cdots \subseteq I \subseteq I^0 = A$ for all $k \in \mathbb{N}$. 
    > 
    > Two cases considered, (a) if $1 \in I \iff I = A$, then $I^k = I^{k - 1} = \cdots = I^0 = A$. (b) if $1 \notin I$, then we must have $I^k \subseteq I^{k - 1} \subseteq \cdots \subseteq I \subseteq I^0 = A$. For example, for $A = \mathbb{Z}/(6)$, it is possible that $(\langle 2 \rangle)^2 = \langle 2 \rangle$. 

<br />

4. **Quotient and Annihilator**. For any two ideals $I, J$ of $A$, we define the quotient of $I$ by $J$ as the set
    $$
    I : J = \{ a \in A \mid a \cdot J \subseteq I \}.
    $$
    In particular, when $I = \langle 0 \rangle$, then the quotient $I : J$ is called the annihilator of $J$ and is denoted by $\mathrm{Ann}(J)$. When $J$ is principal $J = \langle a \rangle$, we simply denote it by $\mathrm{Ann}(a)$.
    
    > [!Note] Observations
    > As $J$ is an ideal, so $\forall a \in A, a J = J$. So 
    > 1. if $J \subseteq I$, then $I : J = A$.
    > 
    > 2. if $I \subsetneq J$, then $I : J \subsetneq A$.
    > 
    > 3. if $I \cap J = \emptyset$, then $I : J = \emptyset$.

<br />

5. **Radical**. For any ideal $I$ of $A$, the radical of $I$ is defined as the set
    $$
    \sqrt{I} = \{ a \in A \mid \exists n \in \mathbb{N}, a^n \in I \}.
    $$

<br />

### Facts on Ideal Operations

1. Intersection of a family of ideals is also an ideal.

   <details>
   <summary>Proof</summary>

   Since $\bigcap_{h \in H} I_h \subseteq I_k$ for all $k \in H$, then :
   - for any $a, b \in \bigcap_{h \in H} I_h$, we have $a + b \in I_h$ for all $h \in H$. That implies that $a + b \in \bigcap_{h \in H} I_h$.
   - for any $a \in A$ and $x \in \bigcap_{h \in H} I_h$, we have $x \in I_h$ for all $h \in H$. Since each $I_h$ is an ideal, $a \cdot x \in I_h$ for all $h \in H$. That implies that $a \cdot x \in \bigcap_{h \in H} I_h$.

   <details>
   <summary>Lean 4 proof</summary>

   ```lean
   /- Fact 1: the intersection of a family of ideals is an ideal. -/
   def iInter {ι : Type*} (I : ι → Ideal A) : Ideal A where
     carrier := {x | ∀ h, x ∈ I h}
     zero_mem' := by
       intro h
       exact (I h).zero_mem
     add_mem' := by
       intro a b ha hb h
       exact (I h).add_mem (ha h) (hb h)
     smul_mem' := by
       intro a x hx h
       exact (I h).mul_mem_left a (hx h)

   example {ι : Type*} (I : ι → Ideal A) : iInter I = ⨅ h, I h := by
     ext x
     exact (Submodule.mem_iInf I).symm
   ```

   </details>

   </details>
   <br />

2. Quotient is also an ideal.

    <details>
    <summary>Proof that quotient is also an ideal</summary>

    For addition closure, let $a, b \in I : J$, we need to show that $a - b \in I : J$. Since 
    - $a \cdot J \subseteq I \iff \forall x \in J, a \cdot x \in I$
    - $b \cdot J \subseteq I \iff \forall x \in J, b \cdot x \in I$

    By addition closure property of ideal, we have $\forall x \in J, (a - b) \cdot x \in I$, which implies that $a - b \in I : J$.

    For multiplicity closure, let $a \in I : J$ and for any $r \in A$, we need to show that $r \cdot a \in I : J$. 
    - if $r = 0$, it trivially holds that $r \cdot a = 0 \in I : J$.

    - if $r \ne 0$. Since $a \cdot J \subseteq I \iff \forall x \in J, a \cdot x \in I$, then $\forall x \in J, (r \cdot a) \cdot x = r \cdot (a \cdot x) \in I$ always holds, which implies that $r \cdot a \in I : J$.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 2: the quotient `I : J = {a | a * J ⊆ I}` is an ideal. -/
    def colon (I J : Ideal A) : Ideal A where
      carrier := {a | ∀ x ∈ J, a * x ∈ I}
      zero_mem' := by
        intro x _
        rw [zero_mul]
        exact I.zero_mem
      add_mem' := by
        intro a b ha hb x hx
        rw [add_mul]
        exact I.add_mem (ha x hx) (hb x hx)
      smul_mem' := by
        -- `(r * a) * x = r * (a * x) ∈ I`
        intro r a ha x hx
        rw [smul_eq_mul, mul_assoc]
        exact I.mul_mem_left r (ha x hx)

    example (I J : Ideal A) (a : A) : a ∈ colon I J ↔ a ∈ I.colon J := by
      rw [Submodule.mem_colon]
      rfl
    ```

    </details>

    </details>
    <br />

3. Radical is also an ideal.

    <details>
    <summary>Proof that radical is also an ideal</summary>

    For the addition closure, let $a, b \in \sqrt{I}$, we need to show that $a - b \in \sqrt{I}$. 

    - $\exists m \in \mathbb{N}, a^m \in I$
    - $\exists n \in \mathbb{N}, b^n \in I$

    Consider $(a - b)^{m + n}$. By the binomial theorem,
    $$
    (a - b)^{m + n} = \sum_{k=0}^{m+n} \binom{m+n}{k} a^k (-b)^{m+n-k}.
    $$
    Each term in this sum is in $I$ because either $k \ge m$ or $m+n-k \ge n$, so $a^k \in I$ or $b^{m+n-k} \in I$: 
    $$
        (a - b)^{m + n} = (-b)^n \cdot \sum_{k = 0}^{m} \binom{m}{k} a^k (-b)^{m - k} + a^m \cdot \sum_{k = m + 1}^{m + n} \binom{m+n}{k} a^{k-m} (-b)^{m+n-k} 
    $$
    
    Since $I$ is an ideal and closed under addition, $(a - b)^{m+n} \in I$, which implies that $a - b \in \sqrt{I}$.

    For the multiplicity closure, let $a \in \sqrt{I}$ and $r \in A$, we need to show that $r \cdot a \in \sqrt{I}$. 
    - $\exists n \in \mathbb{N}, a^n \in I$
    Consider $(r \cdot a)^n = r^n \cdot a^n$. Since $a^n \in I$ and $I$ is an ideal, $r^n \cdot a^n \in I$, which implies that $(r \cdot a)^n \in I$. Therefore, $r \cdot a \in \sqrt{I}$.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 3: the radical `√I = {a | ∃ n, a ^ n ∈ I}` is an ideal. -/
    def radical (I : Ideal A) : Ideal A where
      carrier := {a | ∃ n : ℕ, a ^ n ∈ I}
      zero_mem' := by
        refine ⟨1, ?_⟩
        rw [pow_one]
        exact I.zero_mem
      add_mem' := by
        -- binomial theorem: each term of `(a + b) ^ (m + n)` has `a ^ k` with `k ≥ m`
        -- or `b ^ (m + n - k)` with `m + n - k ≥ n`
        rintro a b ⟨m, hm⟩ ⟨n, hn⟩
        refine ⟨m + n, ?_⟩
        rw [add_pow]
        refine I.sum_mem fun k _ => ?_
        by_cases h : m ≤ k
        · have e : a ^ k = a ^ m * a ^ (k - m) := by rw [← pow_add, Nat.add_sub_cancel' h]
          rw [e]
          exact I.mul_mem_right _ (I.mul_mem_right _ (I.mul_mem_right _ hm))
        · have hk : n ≤ m + n - k := by omega
          have e : b ^ (m + n - k) = b ^ n * b ^ (m + n - k - n) := by
            rw [← pow_add, Nat.add_sub_cancel' hk]
          rw [e]
          exact I.mul_mem_right _ (I.mul_mem_left _ (I.mul_mem_right _ hn))
      smul_mem' := by
        -- `(r * a) ^ n = r ^ n * a ^ n ∈ I`
        rintro r a ⟨n, hn⟩
        refine ⟨n, ?_⟩
        rw [smul_eq_mul, mul_pow]
        exact I.mul_mem_left _ hn

    example (I : Ideal A) (a : A) : a ∈ radical I ↔ a ∈ I.radical := Iff.rfl
    ```

    </details>

    </details>
    <br />

4. The set of nipotent elements $\mathcal{N}(A)$ is also an ideal.

    In particular, set of nilpotent elements is a special case of radical : $\mathcal{N}(A) = \sqrt{\langle 0 \rangle}$. So it is an ideal.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 4: the nilpotent elements form the ideal `√⟨0⟩`. -/
    theorem isNilpotent_iff_mem_radical_bot (a : A) : IsNilpotent a ↔ a ∈ radical ⊥ := by
      show (∃ n : ℕ, a ^ n = 0) ↔ ∃ n : ℕ, a ^ n ∈ (⊥ : Ideal A)
      simp only [Ideal.mem_bot]

    example (a : A) : a ∈ nilradical A ↔ IsNilpotent a := mem_nilradical
    ```

    </details>


5. The set of zero-divisors $\mathcal{D}(A)$ is not an ideal in general.

    <details>
    <summary>Proof</summary>

    Not an ideal means either addition or multiplicity closure fails, we choose the former one. That is 
    $$
    \exists a, b \in \mathcal{D}(A) \text{ such that } a + b \notin \mathcal{D}(A).
    $$
    Take $A = \mathbb{Z}/(6)$, $a = 2$ and $b = 3$. Since $2 \cdot 3 = 0$ with $3 \ne 0$ and $2 \ne 0$, both $a$ and $b$ are zero-divisors.

    However, $a + b = 5$ and $5 \cdot 5 = 25 = 1$, so $a + b$ is a unit. By fact (2) on special elements, no unit is a zero divisor, so $a + b \notin \mathcal{D}(A)$.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 5: the zero divisors need not form an ideal.
    In `ℤ/6ℤ`, `2` and `3` are zero divisors (`2 * 3 = 0`), but `2 + 3 = 5` is a unit. -/
    theorem zeroDivisors_not_ideal :
        ¬ ∃ I : Ideal (ZMod 6), ∀ a, a ∈ I ↔ IsZeroDivisor a := by
      rintro ⟨I, hI⟩
      have h2 : (2 : ZMod 6) ∈ I := (hI 2).mpr ⟨3, by decide, by decide⟩
      have h3 : (3 : ZMod 6) ∈ I := (hI 3).mpr ⟨2, by decide, by decide⟩
      have h5 : IsUnit (2 + 3 : ZMod 6) := IsUnit.of_mul_eq_one 5 (by decide)
      exact not_isZeroDivisor_of_isUnit h5 ((hI _).mp (I.add_mem h2 h3))
    ```

    </details>

    </details>
    <br />

6. If $I, J$ are two ideals of a ring $A$, then $I J \subseteq I \cap J$.

    <details>
    <summary>Proof</summary>

    Firstly we decompose the argument :
    $$
        I J \subseteq I \cap J \iff \forall x \in IJ, x \in I \cap J \iff \forall a \in I, \forall b \in J, a \cdot b \in I \cap J
    $$
    Since $a \in I$, so we have $a \cdot b \in I$. Similarly, since $b \in J$, we have $a \cdot b \in J$. Therefore, $a \cdot b \in I \cap J$. Completing the proof.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 6: `I J ⊆ I ∩ J`. -/
    theorem mul_le_inf' (I J : Ideal A) : I * J ≤ I ⊓ J := by
      -- it suffices to check the generators `a * b` with `a ∈ I`, `b ∈ J`
      rw [Ideal.mul_le]
      intro a ha b hb
      exact Submodule.mem_inf.mpr ⟨I.mul_mem_right b ha, J.mul_mem_left a hb⟩

    example (I J : Ideal A) : I * J ≤ I ⊓ J := Ideal.mul_le_inf
    ```

    </details>

    </details>
    <br />

7. If $I, J$ are two ideals of a ring $A$, and $I + J = \langle 1 \rangle$, then $I \cap J = I J$. $I$ and $J$ are *comaximal*.
    
    <details>
    <summary>Proof</summary>

    By (6), we only need to show the converse inclusion: $I \cap J \subseteq I J$ when $I + J = \langle 1 \rangle$.

    By $I + J = \langle 1 \rangle \iff A \subseteq I + J \iff \forall x \in A, \exists y \in I, \exists z \in J, x = y + z$, thus for any $x \in I \cap J$, we can write $x = y + z$ with existence of $y \in I$ and $z \in J$. 

    So for any $x \in I \cap J$, we can write it as $x = x \cdot 1 = x \cdot (y + z) \in I \cap J$ with the existence of $y \in I$ and $z \in J$. After some expanding, and $x \in J$ and $x \in I$, we have :
    $$
        x = x \cdot (y + z) = x \cdot y + x \cdot z \in I J
    $$
    which proves $\forall x \in I \cap J, x \in I J$. Therefore, $I \cap J \subseteq I J$. Completing the proof.

    <details>
    <summary>Lean 4 proof</summary>

    ```lean
    /- Fact 7: if `I + J = ⟨1⟩`, then `I ∩ J = I J`. -/
    theorem inf_eq_mul_of_sup_eq_top (I J : Ideal A) (h : I ⊔ J = ⊤) : I ⊓ J = I * J := by
      refine le_antisymm ?_ (mul_le_inf' I J)
      intro x hx
      obtain ⟨hxI, hxJ⟩ := Submodule.mem_inf.mp hx
      -- write `1 = y + z` with `y ∈ I`, `z ∈ J`
      have h1 : (1 : A) ∈ I ⊔ J := by
        rw [h]
        exact Submodule.mem_top
      obtain ⟨y, hy, z, hz, hyz⟩ := Submodule.mem_sup.mp h1
      -- `x = x * (y + z) = y * x + x * z ∈ I J`
      have e : x = y * x + x * z := by
        calc x = x * (y + z) := by rw [hyz, mul_one]
          _ = y * x + x * z := by ring
      rw [e]
      exact Ideal.add_mem _ (Ideal.mul_mem_mul hy hxJ) (Ideal.mul_mem_mul hxI hz)

    example (I J : Ideal A) (h : I ⊔ J = ⊤) : I * J = I ⊓ J := Ideal.mul_eq_inf_of_coprime h
    ```

    </details>

    </details>
    <br />

8. Let $I_1,...,I_n$ are pairwise *comaximal* ideals of a ring $A$. Then 
    $$
        I_1 \cap ... \cap I_n = I_1 \cdot ... \cdot I_n.
    $$

    This is a general form of the result in (7) for two comaximal ideals. We omit the proof here.

<br />

9. Let $I, J, H$ be ideals of a ring $A$. Then 
    $$
    \begin{aligned}
    \text{(a) } &(I + J) H = I H + J H \\
    \text{(b) } &(I + J)(I \cap J) \subseteq I J \\
    \text{(c) } &(I \cap J) + (I \cap H) \subseteq I \cap (J + H) \\
    \text{(d) } &J \subset I \text{ or } I \subset H \to I \cap (J + H) = (I \cap J) + (I \cap H) \\
    \text{(e) } &I + JH \subseteq (I + J) \cap (I + H)
    \end{aligned}
    $$

<br />

### Properties of the Radical

Let $A$ be a ring, and let $I, J, H$ be ideals of $A$. Then : 

1. if $I \subseteq J$, then $\sqrt{I} \subseteq \sqrt{J}$.

    <details>
    <summary>Proof</summary>

    In order to show $\sqrt{I} \subseteq \sqrt{J}$, it is suffices to show :
    $$
      \forall x \in \sqrt{I} \implies x \in \sqrt{J} \iff \forall x \in \sqrt{I}, \exists n \in \mathbb{N}, x^n \in I \implies \exists m \in \mathbb{N}, x^m \in J
    $$

    Since $x^n \in I \subseteq J$, use $m = n$, we have $x^m \in J$. Completing the proof.

    </details>
    <br />

2. $I \subseteq \sqrt{I}$ and $\sqrt{\sqrt{I}} = \sqrt{I}$

    <details>
    <summary>Proof</summary>

    For any $x \in I$, we have $x^1 = x \in I$, hence $x \in \sqrt{I}$. This shows $I \subseteq \sqrt{I}$.

    In order to show $\sqrt{\sqrt{I}} = \sqrt{I}$, since $\sqrt{I} \subseteq \sqrt{\sqrt{I}}$ follows from the fact that $I \subseteq \sqrt{I}$, it suffices to show the forward inclusion is true, i.e., $\sqrt{\sqrt{I}} \subseteq \sqrt{I}$. That is, 
    $$
      \sqrt{\sqrt{I}} \subseteq \sqrt{I} \iff \forall x \in \sqrt{\sqrt{I}} \implies x \in \sqrt{I} \\
      \iff  \forall x \in \sqrt{\sqrt{I}}, \exists n \in \mathbb{N}, x^n \in \sqrt{I} \implies \exists m \in \mathbb{N}, x^m \in I
    $$

    Since $x^n \in \sqrt{I}$ for some $n \in \mathbb{N}$, by definition of $\sqrt{I}$, there exists $p \in \mathbb{N}$ such that $(x^n)^p = x^{np} \in I$. So use $m = np$, we have $x^m \in I$. Completing the proof.

    </details>
    <br />

3. $\sqrt{I J} = \sqrt{I \cap J} = \sqrt{I} \cap \sqrt{J}$

    <details>
    <summary>Proof</summary>

    (a) First, we show $\sqrt{I J} = \sqrt{I \cap J}$. Since $I J \subseteq I \cap J$, by property (1) above, we have $\sqrt{I J} \subseteq \sqrt{I \cap J}$. So it suffices to show the backward direction inclusion $\sqrt{I \cap J} \subseteq \sqrt{I J}$. That is, 
    $$
      \sqrt{I \cap J} \subseteq \sqrt{I J} \iff \forall x \in \sqrt{I \cap J} \implies x \in \sqrt{I J} \\
      \iff \forall x \in \sqrt{I \cap J}, \exists n \in \mathbb{N}, x^n \in I \cap J \implies \exists m \in \mathbb{N}, x^m \in I J
    $$
    $x^n \in I \cap J$ for some $n \in \mathbb{N}$ implies $x^n \in I$ and $x^n \in J$, hence by definition we have $x^{2n} = (x^n)^2 \in I J$. So use $m = 2n$, we have $x^m \in I J$. Completing the proof of (a).

    <br />

    (b) Next, in order to show the equality $\sqrt{I \cap J} = \sqrt{I} \cap \sqrt{J}$, we first show the forward inclusion direction $\sqrt{I \cap J} \subseteq \sqrt{I} \cap \sqrt{J}$. That is,
    $$
      \sqrt{I \cap J} \subseteq \sqrt{I} \cap \sqrt{J} \iff \forall x \in \sqrt{I \cap J} \implies x \in \sqrt{I} \cap \sqrt{J} \\
      \iff \forall x \in \sqrt{I \cap J}, \exists n \in \mathbb{N}, x^n \in I \cap J \implies \exists m_1, m_2 \in \mathbb{N}, x^{m_1} \in I \text{ and } x^{m_2} \in J
    $$
    $x^n \in I \cap J$ for some $n \in \mathbb{N}$ implies $x^n \in I$ and $x^n \in J$, hence use $m_1 = n, m_2 = n$, we have $x^{m_1} \in I$ and $x^{m_2} \in J$. Completing the proof of the forward inclusion.

    <br />

    Then we show the backward inclusion direction $\sqrt{I} \cap \sqrt{J} \subseteq \sqrt{I \cap J}$. That is,  
    $$
        \sqrt{I} \cap \sqrt{J} \subseteq \sqrt{I \cap J} \iff \forall x \in \sqrt{I} \cap \sqrt{J} \implies x \in \sqrt{I \cap J} \\
        \iff \forall x \in \sqrt{I} \cap \sqrt{J}, \exists m_1, m_2 \in \mathbb{N}, x^{m_1} \in I \text{ and } x^{m_2} \in J \implies \exists n \in \mathbb{N}, x^n \in I \cap J \\
    $$

    Since $x^{m_1} \in I, x^{m_2} \in J$, by definition, we have $x^{m_1} \cdot x^{m_2} = x^{m_1 + m_2} \in I J$. Hence, using $n = m_1 + m_2$, we have $x^n \in IJ$. Again by $I J \subseteq I \cap J$, we have $x^n \in I \cap J$. Completing the proof of the backward inclusion.

  </details>
  <br />

4. $\sqrt{I^n} = \sqrt{I}$ for any $n \in \mathbb{N}$

    <details>
    <summary>Proof</summary>

    This is a special case of $\sqrt{IJ} = \sqrt{I \cap J}$ in property (3) above, where we take $J = I^{n-1}$. We just omit the detailed proof here. 
  
    </details>
    <br />

5. $\sqrt{I} = \langle 1 \rangle$ if and only if $I = \langle 1 \rangle$.

6. $\sqrt{I + J} = \sqrt{\sqrt{I} + \sqrt{J}}$

    <details>
    <summary>Proof</summary>

      In order to show the equality $\sqrt{I + J} = \sqrt{\sqrt{I} + \sqrt{J}}$, we first show the forward inclusion directions. That is,
      $$
        \sqrt{I + J} \subseteq \sqrt{\sqrt{I} + \sqrt{J}} \iff \forall x \in \sqrt{I + J} \implies x \in \sqrt{\sqrt{I} + \sqrt{J}} \\
        \iff \forall x \in \sqrt{I + J}, \exists n \in \mathbb{N}, x^n \in I + J \implies \exists m \in \mathbb{N}, x^m \in \sqrt{I} + \sqrt{J} \\
      $$
      As $x^n \in I + J$ implies $\exists x_1 \in I, x_2 \in J$ such that $x^n = x_1 + x_2$. We use $m = n$, then by the property (2) above, we have $x_1 \in \sqrt{I}, x_2 \in \sqrt{J}$, thus $x^m = x_1 + x_2 \in \sqrt{I} + \sqrt{J}$. Completing the proof of the forward inclusion.

      <br />

      Next, we show the backward inclusion direction $\sqrt{\sqrt{I} + \sqrt{J}} \subseteq \sqrt{I + J}$. That is,
      $$
        \sqrt{\sqrt{I} + \sqrt{J}} \subseteq \sqrt{I + J} \iff \forall x \in \sqrt{\sqrt{I} + \sqrt{J}} \implies x \in \sqrt{I + J} \\
        \iff \forall x \in \sqrt{\sqrt{I} + \sqrt{J}}, \exists m \in \mathbb{N}, x^m \in \sqrt{I} + \sqrt{J} \implies \exists n \in \mathbb{N}, x^n \in I + J \\
      $$

      Since $x^m \in \sqrt{I} + \sqrt{J}$, we have $\exists x_1 \in \sqrt{I}, x_2 \in \sqrt{J}$ such that $x^m = x_1 + x_2$. By definition, there exist $k_1, k_2 \in \mathbb{N}$ such that $x_1^{k_1} \in I$ and $x_2^{k_2} \in J$. Let $n = m \cdot k_1 \cdot k_2$, then $x^n = (x^m)^{k_1 k_2} = (x_1 + x_2)^{k_1 k_2} \in I + J$. Completing the proof of the backward inclusion.

    </details>
    <br />
  
7. $\sqrt{I + JH} = \sqrt{I + J} \cap \sqrt{I + H}$

    <details>
    <summary>Proof</summary>

    In order to prove the equality $\sqrt{I + JH} = \sqrt{I + J} \cap \sqrt{I + H}$, we need to show both inclusions.

    **Forward inclusion**: $\sqrt{I + JH} \subseteq \sqrt{I + J} \cap \sqrt{I + H}$, that is,
    $$
        \sqrt{I + JH} \subseteq \sqrt{I + J} \cap \sqrt{I + H} \iff \forall x \in \sqrt{I + JH} \implies x \in \sqrt{I + J} \cap \sqrt{I + H} \\
        \iff \forall x \in \sqrt{I + JH}, \exists n \in \mathbb{N}, x^n \in I + JH \implies \exists m_1, m_2 \in \mathbb{N}, x^{m_1} \in I + J \text{ and } x^{m_2} \in I + H \\
    $$

    As $x^n \in I + JH$ implies $\exists x_1 \in I, x_2 \in JH$ such that $x^n = x_1 + x_2$. We use $m_1 = m_2 = n$, as $H \subseteq A$ thus we have $J H \subseteq J$, then $x^{m_1} = x_1 + x_2 \in I + J H \subseteq I + J$, similarly we have $x^{m_2} = x_1 + x_2 \in I + J H \subseteq I + H$. Completing the proof of the forward inclusion.

    <br />

    **Backward inclusion**: $\sqrt{I + J} \cap \sqrt{I + H} \subseteq \sqrt{I + JH}$, that is,
    $$
        \sqrt{I + J} \cap \sqrt{I + H} \subseteq \sqrt{I + JH} \iff \forall x \in \sqrt{I + J} \cap \sqrt{I + H} \implies x \in \sqrt{I + JH} \\
        \iff \forall x \in \sqrt{I + J} \cap \sqrt{I + H}, \exists m_1, m_2 \in \mathbb{N}, x^{m_1} \in I + J \text{ and } x^{m_2} \in I + H \implies \exists n \in \mathbb{N}, x^n \in I + JH \\
    $$

    Since $x^{m_1} \in I + J$ and $x^{m_2} \in I + H$, thus we have $x^{m_1} \cdot x^{m_2} = x^{m_1 + m_2} \in (I + J)(I + H) \subseteq I + JH$. Let $n = m_1 + m_2$, then $x^n \in I + JH$. Completing the proof of the backward inclusion.

    </details>
    <br />


## Maximal Ideal

As we know, maximal ideal is derived from the concept of proper ideal. A few important facts upon maximal ideal are derived from Zorn's Lemma.

### Zorn's Lemma

Poset Definition : A *poset* $(\Sigma, \leq)$ is a set $\Sigma$ equipped with a partial order $\leq$ which is 
reflexive, antisymmetric, and transitive. Every chain in a poset is a totally ordered subset of $\Sigma$.

<br />

Zorn's Lemma : Let $(\Sigma, \leq)$ be a partially ordered set in which every chain has an upper bound in $\Sigma$. Then $\Sigma$ contains maximal elements with respect to the partial order $\le$.

### Facts on Maximal Ideal

Let $A$ be a non-zero ring. Then

1. $A$ has at least one *maximal ideal* $\mathfrak{m}$.

2. For any proper *ideal* $I$ of $A$, there exists a maximal ideal $\mathfrak{m}$ such that $I \subseteq \mathfrak{m}$.

3. Every non-invertible element of $A$ is contained in some maximal ideal of $A$.

<details>
<summary>Proof</summary>

Regarding (1), we can treat $A$ as a poset whose elements are the proper ideals of $A$, ordered by inclusion $\subseteq$. 
$$
\Sigma = \{ I \subsetneq A \mid I \text{ is a ideal of } A\}
$$
For example, $\langle a \rangle \subseteq \langle a, b \rangle \subseteq \langle a, b, c \rangle \subseteq \cdots$.

By Zorn's Lemma, in order to show $A$ contains maximal ideals with respect to order relation $\subseteq$, it suffices to show that for any chain of proper ideals $\mathcal{C} = \{I_h : h \in H\}$ in $A$, there exists an upper bound in $A$.

For any chain of proper ideals $\mathcal{C} = \{I_h : h \in H\}$ in $A$, the upper bound of this chain is the minimal set containing all the proper ideals, it can defined by  
$$
I = \bigcup_{h \in H} I_h.
$$
Then we need to show that :
1. $I$ is an ideal of $A$.
    - Addition closure, i.e. for any $x, y \in I$, we have $x + y \in I$.
    - Multiplication closure, i.e. for any $a \in A$ and $x \in I$, we have $a \cdot x \in I$.
3. $I$ is a proper ideal of $A$, i.e. $I \subsetneq A$.
    - $1 \notin I$
proof details are ignored here.

<br />

Regarding (2), it is trivially holds for any chain of proper ideals in $A$.

<br />

Regarding (3), if $a \in A$ is not invertible, implying that 
$$ 
\urcorner (\exists b \in A, a \cdot b = 1) \iff \forall b \in A, a \cdot b \neq 1
$$
Then the principal ideal $\langle a \rangle$ do not contains $1$, which means $\langle a \rangle$ is a proper ideal of $A$. By (2), there exists a maximal ideal $\mathfrak{m}$ such that $\langle a \rangle \subseteq \mathfrak{m}$.

<details>
<summary>Lean 4 proof</summary>

```lean
/- Fact 2: every proper ideal is contained in a maximal ideal (Zorn's lemma). -/
theorem exists_le_maximal' (I : Ideal A) (hI : I ≠ ⊤) :
    ∃ M : Ideal A, M.IsMaximal ∧ I ≤ M := by
  -- every nonempty chain of proper ideals has a proper upper bound: its union
  have ih : ∀ c ⊆ {J : Ideal A | J ≠ ⊤}, IsChain (· ≤ ·) c →
      ∀ J ∈ c, ∃ ub ∈ {J : Ideal A | J ≠ ⊤}, ∀ K ∈ c, K ≤ ub := by
    intro c hcs hchain J hJ
    refine ⟨sSup c, ?_, fun K hK => le_sSup hK⟩
    -- `1 ∉ ⋃ c`, since `1` would lie in some proper ideal of the chain
    show sSup c ≠ ⊤
    rw [Ne, Ideal.eq_top_iff_one]
    intro h1
    obtain ⟨K, hKc, h1K⟩ := (Submodule.mem_sSup_of_directed ⟨J, hJ⟩ hchain.directedOn).mp h1
    exact hcs hKc ((Ideal.eq_top_iff_one K).mpr h1K)
  obtain ⟨M, hIM, hM⟩ := zorn_le_nonempty₀ {J : Ideal A | J ≠ ⊤} ih I hI
  -- a maximal element of the proper ideals is a maximal ideal
  refine ⟨M, ⟨⟨hM.prop, fun J hMJ => ?_⟩⟩, hIM⟩
  by_contra hJ
  exact hMJ.ne' (le_antisymm (hM.2 hJ hMJ.le) hMJ.le)

example (I : Ideal A) (hI : I ≠ ⊤) : ∃ M : Ideal A, M.IsMaximal ∧ I ≤ M :=
  Ideal.exists_le_maximal I hI

/- Fact 1: a nonzero ring has at least one maximal ideal. -/
theorem exists_maximal' [Nontrivial A] : ∃ M : Ideal A, M.IsMaximal := by
  obtain ⟨M, hM, -⟩ := exists_le_maximal' (⊥ : Ideal A) bot_ne_top
  exact ⟨M, hM⟩

example [Nontrivial A] : ∃ M : Ideal A, M.IsMaximal := Ideal.exists_maximal A

/- Fact 3: every non-invertible element lies in some maximal ideal. -/
theorem exists_maximal_of_not_isUnit {a : A} (ha : ¬ IsUnit a) :
    ∃ M : Ideal A, M.IsMaximal ∧ a ∈ M := by
  -- `⟨a⟩` is proper, so apply Fact 2
  have hprop : Ideal.span {a} ≠ ⊤ := fun h => ha (Ideal.span_singleton_eq_top.mp h)
  obtain ⟨M, hM, haM⟩ := exists_le_maximal' _ hprop
  exact ⟨M, hM, haM (Ideal.mem_span_singleton_self a)⟩

example {a : A} (ha : a ∈ nonunits A) : ∃ M : Ideal A, M.IsMaximal ∧ a ∈ M :=
  exists_max_ideal_of_mem_nonunits ha
```

</details>

</details>
<br />

## Other Special Ideals

Let $A$ be a ring, and let $I, I_1, I_2 \subset A$ be proper ideals. Then, $I$ is :

1. **prime**, if $ab \in I$ implies $a \in I$ or $b \in I$ for all $a, b \in A$;

    Prime ideal means any element of the ideal can be decomposed into a product of elements, at least one of which lies in the ideal.

2. **radical**, if $I = \sqrt{I}$;

    Note the difference between *radical of an ideal* and *radical ideal*, by the property (2) of radical, $I \subseteq \sqrt{I}$, we see that radical ideal is a special case where the ideal coincides with its radical.

3. **primary**, if $ab \in I$ implies $a \in I$ or $b \in \sqrt{I}$;

    Note the difference between primary ideal and prime ideal, a prime ideal is always primary, but a primary ideal need not be prime. This is reflected by the fact that $I \subseteq \sqrt{I}$, and the inclusion can be strict.

4. **irreducible**, if $I = I_1 \cap I_2$ implies $I = I_1$ or $I = I_2$.

    Irreducible ideal only exists when $I_1 \subseteq I_2$ or $I_2 \subseteq I_1$.

<br />

### Facts on Special Ideals

Let $I$ be a proper ideal of $A$. Then we have the following facts:

1. If $I$ is primary, then $\sqrt{I}$ is prime.

    This fact is a direct consequence of the inclusion relationship between prime ideal and primary ideal,  
    $$
      \text{prime ideal} \subseteq \text{primary ideal}
    $$

    <details>
    <summary>Proof</summary>
    
    By the definition of primary ideal, we have
    $$
    a b \in I \implies a \in I \text{ or } b \in \sqrt{I}
    $$
    - Suppose $a \in I$, then choose left side of the implication in definition of prime ideal $a \in I$, thus $a b \in I$ is satisfied trivially.
    - Suppose $a \notin I, b \in \sqrt{I}$, then choose the right side of the implication in definition of prime ideal $b \in \sqrt{I}$, thus $a b \in \sqrt{I}$ is satisfied trivially.
    
    </details>
    <br />

2. If $I$ is a maximal ideal, then $A/I$ is a field. 
    <details>
    <summary>Proof</summary>
    
    By the definition of field, it is suffices to show :
    $$
      \forall x + I \in A/I, x \notin I \implies \exists m + I \in A/I, (x + I)(m + I) = 1
    $$

    ----

    If $x \notin I$, $I$ is maximal, then we must have :
    $$
    I \subseteq \langle x \rangle + I = A
    $$
    otherwise, $\langle x \rangle  + I$ would be the maximal ideal containing $I$, not $I$ itself.

    ---

    So any element $a \in A$ can be represented as $a = mx + i$ for $i \in I$, we take $a = 1$. Then modulo $I$ on both sides, we get
    $$
    1 + I = mx + I = (m + I)(x + I)
    $$
    Completing the proof.

    
    </details>
    <br />

3. If $\sqrt{I} = \mathfrak{m}$ is a maximal ideal, then $I$ is primary.

    <details>
    <summary>Proof</summary>

    By the definition of primary ideal, it is suffices to show that for any $ab \in I$ when $a \notin I$, we must have $b \in \sqrt{I}$. By contradiction, we assume $b \notin \sqrt{I}$.
    
    ----

    Since $\sqrt{I}$ is maximal, by fact (2) above, we know that the quotient ring $A/\sqrt{I}$ is a field, which implies every nonzero element in $A/\sqrt{I}$ is invertible. More specially,
    $$
      b + \sqrt{I} \in A/\sqrt{I}, b \notin \sqrt{I}, \exists c + \sqrt{I} \in A/\sqrt{I}, (b + \sqrt{I})(c + \sqrt{I}) = 1
    $$
    Thus we have :
    $$
     (b + \sqrt{I})(c + \sqrt{I}) = b c + \sqrt{I} = 1 + \sqrt{I} 
     \implies bc - 1 \in \sqrt{I} \iff \exists n \in \mathbb{N}, (b c - 1)^n \in I \\
     \iff \exists n \in \mathbb{N}, a (bc - 1)^n \in I
    $$

    ---

    After expanding :
    $$
    a (bc - 1)^n = (-1)^n a + \sum_{k=1}^{n} \binom{n}{k} a (bc)^k (-1)^{n-k} \in I
    $$
    We have assumed that $a b \in I$, thus $\sum_{k=1}^{n} \binom{n}{k} a (bc)^k (-1)^{n-k} \in I$ as well, which implies $(-1)^n a \in I$, and hence $a \in I$. Contradiction happens, which completes the proof.

    </details>