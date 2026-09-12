## Table of Contents
- [C10 S03 — Endomorphisms: Summary Notes](#c10-s03--endomorphisms-summary-notes)
  - [Endomorphisms](#endomorphisms)
    - [Multiplication is composition](#multiplication-is-composition)
  - [Polynomial Evaluation on Endomorphisms (`aeval`)](#polynomial-evaluation-on-endomorphisms-aeval)
    - [`aeval` is an algebra homomorphism](#aeval-is-an-algebra-homomorphism)
  - [Toolbox: Subspace Lemmas](#toolbox-subspace-lemmas)
  - [Theorem 1: Coprime evaluations have trivially intersecting kernels](#theorem-1-coprime-evaluations-have-trivially-intersecting-kernels)
    - [Proof walkthrough](#proof-walkthrough)
  - [Theorem 2: Supremum of kernels is the kernel of the product](#theorem-2-supremum-of-kernels-is-the-kernel-of-the-product)
    - [Proof walkthrough](#proof-walkthrough-1)

# C10 S03 — Endomorphisms: Summary Notes

Summary generated from the comments in `C10-S03.lean`.

Throughout, `V` is a vector space over a field `K`:

```lean
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]
open Polynomial Module LinearMap End
```

## Endomorphisms

An **endomorphism** is a linear map from a vector space to itself. In Mathlib this has its own notation:

```lean
End K V   -- abbreviation for `V →ₗ[K] V`
```

Unlike general linear maps, endomorphisms can be **multiplied**, which makes `End K V` a (non-commutative) ring — and even a `K`-algebra.

### Multiplication is composition

Multiplication of endomorphisms is composition of linear maps, i.e. `* ↔ ∘ₗ`:

```lean
example (φ ψ : End K V) : φ * ψ = φ ∘ₗ ψ :=
  End.mul_eq_comp φ ψ -- `rfl` would also work
```

> [!NOTE]
> The multiplication `φ * ψ` applies `ψ` **first**: `(φ * ψ) x = φ (ψ x)`, as witnessed by `End.mul_apply`.

## Polynomial Evaluation on Endomorphisms (`aeval`)

Evaluating a polynomial `P : K[X]` at an endomorphism `φ` yields another endomorphism. This is a special kind of evaluation, called **algebra evaluation** (`aeval`):

```lean
example (P : K[X]) (φ : End K V) : V →ₗ[K] V :=
  aeval φ P
```

Evaluating the simplest polynomial `X` gives the endomorphism back:

```lean
example (φ : End K V) : aeval φ (X : K[X]) = φ :=
  aeval_X φ
```

### `aeval` is an algebra homomorphism

`aeval φ : K[X] →ₐ[K] End K V` is an `AlgHom` — it maps polynomials to endomorphisms and preserves the whole algebra structure. This is what justifies rewriting with:

| Rewrite | Meaning |
| --- | --- |
| `map_add` | `aeval φ (P + Q) = aeval φ P + aeval φ Q` |
| `map_mul` | `aeval φ (P * Q) = aeval φ P * aeval φ Q` |
| `map_one` | `aeval φ 1 = 1` (the identity endomorphism) |

> [!IMPORTANT]
> Even though both `K[X]` and `End K V` are vector spaces, `aeval φ` is **not** treated as a bare linear map in Lean — it is an algebra homomorphism, so multiplicative lemmas like `map_mul` apply directly.

## Toolbox: Subspace Lemmas

The two theorems below rely on the following characterizations:

| Lemma | Statement |
| --- | --- |
| `Submodule.eq_bot_iff` | `S = ⊥ ↔ ∀ x ∈ S, x = 0` — a subspace is trivial iff it only contains `0` |
| `Submodule.mem_inf` | `x ∈ S ⊓ T ↔ x ∈ S ∧ x ∈ T` — intersection membership |
| `LinearMap.mem_ker` | `x ∈ ker φ ↔ φ x = 0` — kernel membership |
| `Submodule.add_mem_sup` | `x ∈ S → y ∈ T → x + y ∈ S ⊔ T` — sums land in the supremum |
| `LinearMap.ker_le_ker_comp` | `ker f ≤ ker (g ∘ f)` — kernels grow under pre-composition |
| `End.mul_apply` | `(φ * ψ) x = φ (ψ x)` — multiplication is composition, pointwise |
| `map_mul` | `aeval φ (P * Q) = aeval φ P * aeval φ Q` — `aeval` preserves `*` |

## Theorem 1: Coprime evaluations have trivially intersecting kernels

**Statement.** If `P` and `Q` are coprime polynomials, then the kernels of their evaluations on an endomorphism `φ` intersect trivially:

$$
\gcd(P, Q) = 1 \;\Longrightarrow\; \ker P(\varphi) \cap \ker Q(\varphi) = \{0\}
$$

```lean
example (P Q : K[X]) (h : IsCoprime P Q) (φ : End K V) :
    ker (aeval φ P) ⊓ ker (aeval φ Q) = ⊥ := by
  rw [Submodule.eq_bot_iff]
  rintro x h1
  rw [Submodule.mem_inf, LinearMap.mem_ker, LinearMap.mem_ker] at h1
  rcases h1 with ⟨h2, h3⟩
  rcases h with ⟨a, b, bezout_identy⟩
  have := congr((aeval φ) $bezout_identy.symm x)
  rwa [map_add, map_mul, map_mul, map_one, LinearMap.add_apply, End.mul_apply, End.mul_apply,
       h2, h3, LinearMap.map_zero, LinearMap.map_zero, add_zero, End.one_apply] at this
```

### Proof walkthrough

1. **Unfold the goal.** `Submodule.eq_bot_iff` turns `S = ⊥` into `∀ x ∈ S, x = 0`. After `rintro x h1` and unfolding `⊓`/`ker` membership, `h1` becomes the pair
   - `h2 : aeval φ P x = 0`, and
   - `h3 : aeval φ Q x = 0`.
2. **Invoke Bézout.** `IsCoprime P Q` destructs into polynomials `a, b` with the Bézout identity `a * P + b * Q = 1`.
3. **Apply `aeval φ` to both sides**, then evaluate at `x` (via `congr((aeval φ) $ bezout_identy.symm x)`). This is legitimate because `aeval φ` is an `AlgHom`.
4. **Rewrite to `x = 0`.** The long `rwa [...]` chain pushes `aeval φ` through the algebra operations:
   - `map_add`, `map_mul`, `map_mul`, `map_one` split the evaluation into `(aeval φ a * aeval φ P + aeval φ b * aeval φ Q) x = (1 : End K V) x`;
   - `LinearMap.add_apply` and `End.mul_apply` (twice) turn this into `aeval φ a (aeval φ P x) + aeval φ b (aeval φ Q x) = x`;
   - `h2`, `h3` kill both terms; `map_zero`, `add_zero`, and `End.one_apply` finish with `x = 0`.

## Theorem 2: Supremum of kernels is the kernel of the product

**Statement.** For coprime `P` and `Q`, the sum of the kernels of the evaluations equals the kernel of the evaluation of the product:

$$
\gcd(P, Q) = 1 \;\Longrightarrow\; \ker P(\varphi) + \ker Q(\varphi) = \ker\big((PQ)(\varphi)\big)
$$

```lean
example (P Q : K[X]) (h : IsCoprime P Q) (φ : End K V) :
    ker (aeval φ P) ⊔ ker (aeval φ Q) = ker (aeval φ (P*Q)) := by
  apply le_antisymm
  · apply sup_le
    · rw [mul_comm, map_mul]
      apply LinearMap.ker_le_ker_comp
    · rw [map_mul]
      apply LinearMap.ker_le_ker_comp
  · rintro x h1
    rcases h with ⟨U, W, h2⟩
    have key : x = aeval φ (U*P) x + aeval φ (W*Q) x := by simpa using congr((aeval φ) $h2.symm x)
    rw [key, add_comm]
    apply Submodule.add_mem_sup <;> rw [mem_ker] at *
    · rw [← End.mul_apply, ← map_mul, show P*(W*Q) = W*(P*Q) by ring, map_mul, End.mul_apply, h1,
          map_zero]
    · rw [← End.mul_apply, ← map_mul, show Q*(U*P) = U*(P*Q) by ring, map_mul, mul_apply, h1,
          map_zero]
```

### Proof walkthrough

The equality is proved by mutual inclusion via `le_antisymm` (`a = b ↔ a ≤ b ∧ b ≤ a`).

**Direction `≤`: each kernel sits inside the kernel of the product.**

- `sup_le` reduces `S ⊔ T ≤ C` to the two goals `S ≤ C` and `T ≤ C`.
- For `ker (aeval φ P) ≤ ker (aeval φ (P*Q))`: rewrite `P*Q = Q*P` (`mul_comm`) and split the evaluation (`map_mul`), so the goal becomes `ker (aeval φ P) ≤ ker (aeval φ Q * aeval φ P)` — which is exactly `LinearMap.ker_le_ker_comp`, since the right-hand kernel contains everything killed by the *first* applied factor.
- The `Q` case is symmetric, without needing `mul_comm`.

**Direction `≥`: anything killed by the product splits across the two kernels.**

1. Take `x` with `h1 : aeval φ (P*Q) x = 0` and destruct the Bézout identity as `U*P + W*Q = 1`.
2. **Key decomposition** (`key`): applying `aeval φ` to Bézout and evaluating at `x` gives
   `x = aeval φ (U*P) x + aeval φ (W*Q) x` (proved by `simpa` off the same `congr` trick as Theorem 1).
3. After `rw [key, add_comm]`, `Submodule.add_mem_sup` reduces the goal to showing each summand lies in the appropriate kernel; `rw [mem_ker] at *` unfolds all kernel memberships.
4. For the first summand, `aeval φ P (aeval φ (W*Q) x) = 0`:
   - `← End.mul_apply` merges the two applications into one multiplication `(aeval φ P * aeval φ (W*Q)) x`;
   - `← map_mul` folds it into a single evaluation `aeval φ (P * (W * Q)) x`;
   - `show P*(W*Q) = W*(P*Q) by ring` re-associates inside the **polynomial ring** (which is commutative);
   - `map_mul, End.mul_apply` split again to expose the factor `aeval φ (P*Q) x`, which `h1` rewrites to `0`, and `map_zero` closes the goal.
5. The second summand is identical with the roles of `P`/`Q` and `U`/`W` swapped.

> [!TIP]
> The recurring pattern in both proofs: `End.mul_apply` (pointwise multiplication ⇔ composition) and `map_mul` (`aeval` ⇔ polynomial multiplication) let you move freely between *evaluating a product* and *composing evaluations* — with `ring` handling commutativity at the polynomial level.
