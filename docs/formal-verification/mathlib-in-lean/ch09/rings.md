## Table of Contents
- [C09 S02 — Rings: Summary Notes](#c09-s02--rings-summary-notes)
  - [Units of a Ring](#units-of-a-ring)
  - [Quotient Rings](#quotient-rings)
    - [The quotient projection](#the-quotient-projection)
    - [Universal properties: `lift` and `quotientMap`](#universal-properties-lift-and-quotientmap)
    - [First isomorphism theorem for rings](#first-isomorphism-theorem-for-rings)
  - [Ideal Arithmetic](#ideal-arithmetic)
  - [Polynomial Rings](#polynomial-rings)
    - [The embedding `C` and the indeterminate `X`](#the-embedding-c-and-the-indeterminate-x)
    - [Degrees](#degrees)
    - [Evaluation and roots](#evaluation-and-roots)

# C09 S02 — Rings: Summary Notes

Note on the ring section of Chapter 09, rewritten from the original `ch09.md`.

## Units of a Ring

For a monoid `M`, `Mˣ` (`Units M`) is the type of invertible elements.

| Fact | Lemma | Statement |
| --- | --- | --- |
| The units of `ℤ` are exactly `1` and `-1` | `Int.units_eq_one_or` | `x = 1 ∨ x = -1` for `x : ℤˣ` |
| A unit times its inverse is one | `Units.mul_inv` | `(x : M) * x⁻¹ = 1` |
| The units form a group | (instance) | `Group Mˣ` |
| Ring homomorphisms act on units | `Units.map` | `f : R →+* S` induces `Rˣ →* Sˣ` |

```lean
example (x : ℤˣ) : x = 1 ∨ x = -1 := Int.units_eq_one_or x
example {M : Type*} [Monoid M] (x : Mˣ) : (x : M) * x⁻¹ = 1 := Units.mul_inv x
example {M : Type*} [Monoid M] : Group Mˣ := inferInstance
example {R S : Type*} [Ring R] [Ring S] (f : R →+* S) : Rˣ →* Sˣ := Units.map f
```

> [!NOTE]
> `Monoid` is multiplicative by default, so the group structure on `Mˣ` is multiplicative, and the induced map on units is a *monoid* homomorphism `→*`.

## Quotient Rings

Let `R` be a commutative ring and `I : Ideal R`.

### The quotient projection

`Ideal.Quotient.mk I : R →+* R ⧸ I` is the canonical ring homomorphism onto the quotient ring — the ring analogue of `QuotientGroup.mk`:

```lean
example {R : Type*} [CommRing R] (I : Ideal R) : R →+* R ⧸ I :=
  Ideal.Quotient.mk I
```

Its kernel is exactly `I` — an element maps to zero in the quotient iff it lies in the ideal:

$$
\mathsf{mk}_I(a) = 0 \iff a \in I
$$

```lean
example {R : Type*} [CommRing R] {a : R} {I : Ideal R} :
    Ideal.Quotient.mk I a = 0 ↔ a ∈ I :=
  Ideal.Quotient.eq_zero_iff_mem
```

### Universal properties: `lift` and `quotientMap`

- **Lifting.** If `I ≤ RingHom.ker f` (the ideal dies under `f`), then `f` factors through the quotient:

  ```lean
  example {R S : Type*} [CommRing R] [CommRing S] (I : Ideal R) (f : R →+* S)
      (H : I ≤ RingHom.ker f) : R ⧸ I →+* S :=
    Ideal.Quotient.lift I f H
  ```

- **Mapping quotients.** If `I ≤ Ideal.comap f J` (the image of `I` lands in `J`), then `f` descends to a map of quotients:

  ```lean
  example {R S : Type*} [CommRing R] [CommRing S] (I : Ideal R) (J : Ideal S) (f : R →+* S)
      (H : I ≤ Ideal.comap f J) : R ⧸ I →+* S ⧸ J :=
    Ideal.quotientMap J f H
  ```

  <details>
  <summary><strong>Why the quotient map is well-defined</strong> (click to expand)</summary>

  By the definition of `comap`, `∀ x ∈ I, f x ∈ J`, i.e. `f(I) ⊆ J`. Define the lift by sending each coset `x + I` to `f x + J`. If `x + I = y + I`, then `x - y ∈ I`, hence `f (x - y) = f x - f y ∈ J`, which gives `f x + J = f y + J`.

  </details>

- **Equal ideals give isomorphic quotients:**
  ```lean
  example {R : Type*} [CommRing R] {I J : Ideal R} (h : I = J) : R ⧸ I ≃+* R ⧸ J :=
    Ideal.quotEquivOfEq h
  ```
  Since `I = J`, the cosets coincide, so `x + I ↦ x + J` is an isomorphism — well-defined because `x + I = y + I` implies `x - y ∈ I = J`, hence `x + J = y + J`.

### First isomorphism theorem for rings

$$
R / \ker f \;\cong\; \operatorname{im} f
$$

```lean
example {R S : Type*} [CommRing R] [CommRing S] (f : R →+* S) :
    R ⧸ RingHom.ker f ≃+* f.range :=
  RingHom.quotientKerEquivRange f
```

## Ideal Arithmetic

Let `I J : Ideal R` for a commutative ring `R`.

**Sum.** Elements of `I + J` are sums of an element of `I` and an element of `J`:

```lean
example {x : R} : x ∈ I + J ↔ ∃ a ∈ I, ∃ b ∈ J, a + b = x := by
  simp [Submodule.mem_sup]
```

**Product.** The product ideal `I * J` is contained in each factor, and hence in their intersection:

| Lemma | Statement | Why |
| --- | --- | --- |
| `Ideal.mul_le_left` | `I * J ≤ J` | for every `x ∈ R`, `x * J ⊆ J`; since `I ⊆ R`, also `∀ x ∈ I, x * J ⊆ J` |
| `Ideal.mul_le_right` | `I * J ≤ I` | symmetrically, `∀ y ∈ R, I * y ⊆ I`, so `∀ y ∈ J, I * y ⊆ I` |
| `Ideal.mul_le_inf` | `I * J ≤ I ⊓ J` | combining both: every `z ∈ I * J` lies in both `I` and `J` |

$$
I \cdot J \;\subseteq\; I \cap J
$$

## Polynomial Rings

For a commutative ring `R`, the polynomial ring `R[X]` is again a commutative ring.

### The embedding `C` and the indeterminate `X`

`C : R →+* R[X]` is the canonical embedding sending `r` to the constant polynomial; `X` is the indeterminate.

```lean
-- `C r` is the constant polynomial with value `r`
example {R : Type*} [CommRing R] (r : R) := X - C r

-- `C` is a ring homomorphism, so `(C r)^2 = C (r^2)`
example {R : Type*} [CommRing R] (r : R) : (X + C r) * (X - C r) = X ^ 2 - C (r ^ 2) := by
  rw [C.map_pow]
  ring

-- Coefficients are computed with `Polynomial.coeff`
example {R : Type*} [CommRing R] (r : R) : (C r).coeff 0 = r := by simp
example {R : Type*} [CommRing R] : (X ^ 2 + 2 * X + C 3 : R[X]).coeff 1 = 2 := by simp
```

The coefficient of the constant polynomial `C r` is `r`, and the coefficient of `X` in `X ^ 2 + 2 * X + C 3` is `2`.

### Degrees

Over a semiring with no zero divisors, degree behaves as expected:

| Lemma | Statement |
| --- | --- |
| `Polynomial.degree_mul` | `degree (p * q) = degree p + degree q` |
| `Polynomial.natDegree_comp` | `natDegree (comp p q) = natDegree p * natDegree q` |

```lean
example {R : Type*} [Semiring R] [NoZeroDivisors R] {p q : R[X]} :
    degree (p * q) = degree p + degree q :=
  Polynomial.degree_mul

example {R : Type*} [Semiring R] [NoZeroDivisors R] {p q : R[X]} :
    natDegree (comp p q) = natDegree p * natDegree q :=
  Polynomial.natDegree_comp
```

> [!WARNING]
> `NoZeroDivisors` is essential here: if `R` has zero divisors, leading coefficients can cancel and the degree of a product can drop.

### Evaluation and roots

- **Evaluation.** `P.eval x : R` evaluates a polynomial at a ring element:
  ```lean
  example {R : Type*} [CommRing R] (P : R[X]) (x : R) := P.eval x
  ```

- **Roots.** `r` is a root of `P` iff the evaluation vanishes:
  $$
  \mathsf{IsRoot}(P, r) \iff P(r) = 0
  $$
  ```lean
  example {R : Type*} [CommRing R] (P : R[X]) (r : R) : IsRoot P r ↔ P.eval r = 0 := Iff.rfl
  ```

- **Roots of `X - C r`.** Over an integral domain, the linear polynomial `X - C r` has exactly the root `r`:
  ```lean
  example {R : Type*} [CommRing R] [IsDomain R] (r : R) : (X - C r).roots = {r} :=
    roots_X_sub_C r
  ```
  Indeed `X - C r = 0` forces `X = C r`, so `r` is the only solution.

  > [!IMPORTANT]
  > `IsDomain R` (a commutative ring with no zero divisors) is necessary for `.roots`, which relies on the theorem that a nonzero polynomial of degree `n` has at most `n` roots in an integral domain.

- **Repeated roots.** `.roots` returns a **multiset**; the roots of `(X - C r) ^ n` are `r` with multiplicity `n`:
  ```lean
  example {R : Type*} [CommRing R] [IsDomain R] (r : R) (n : ℕ) :
      ((X - C r) ^ n).roots = n • {r} := by
    simp
  ```
  Here `n • {r}` denotes the multiset containing `r` with multiplicity `n` (`•` is the `SMul` operator on multisets).
