## Table of Contents
- [C10 S04 — Bases: Summary Notes](#c10-s04--bases-summary-notes)
  - [Bases and Coordinates](#bases-and-coordinates)
    - [Constructing a basis](#constructing-a-basis)
    - [Canonical bases](#canonical-bases)
    - [Reconstructing a vector from its coordinates](#reconstructing-a-vector-from-its-coordinates)
  - [Linear Combinations](#linear-combinations)
    - [Linear combination with general vectors](#linear-combination-with-general-vectors)
    - [Linear combination with a basis](#linear-combination-with-a-basis)
  - [Linear Maps Constructed from a Basis](#linear-maps-constructed-from-a-basis)
    - [Extension by linearity (`B.constr`)](#extension-by-linearity-bconstr)
    - [Maps agreeing on a basis are equal (`B.ext`)](#maps-agreeing-on-a-basis-are-equal-bext)
  - [Matrices Representing Linear Maps](#matrices-representing-linear-maps)
    - [The matrix of a linear map (`toMatrix`)](#the-matrix-of-a-linear-map-tomatrix)
    - [Change of basis](#change-of-basis)
    - [Composition corresponds to matrix multiplication](#composition-corresponds-to-matrix-multiplication)
    - [The determinant of an endomorphism is basis-independent](#the-determinant-of-an-endomorphism-is-basis-independent)
  - [Finite Rank of Vector Spaces](#finite-rank-of-vector-spaces)
    - [The archetypical `n`-dimensional space](#the-archetypical-n-dimensional-space)
    - [The scalar field matters](#the-scalar-field-matters)
    - [Positivity of rank](#positivity-of-rank)
    - [Finite basis ⇔ finite-dimensional](#finite-basis--finite-dimensional)
  - [Finite Rank of Submodules](#finite-rank-of-submodules)

# C10 S04 — Bases: Summary Notes

Summary generated from the comments in `C10-S04.lean`.

Throughout, `V` is a vector space over a field `K`:

```lean
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]
open Module
```

## Bases and Coordinates

Fix a basis `B : Basis ι K V` indexed by a type `ι`, a vector `v : V`, and an index `i : ι`:

```lean
variable {ι : Type*} (B : Basis ι K V) (v : V) (i : ι)
```

| Expression | Type | Meaning |
| --- | --- | --- |
| `B i` | `V` | the basis vector with index `i` |
| `B.repr` | `V ≃ₗ[K] ι →₀ K` | the linear isomorphism between `V` and finitely supported functions `ι →₀ K` |
| `B.repr v` | `ι →₀ K` | the coordinate of `v` with respect to `B` |
| `B.repr v i` | `K` | the `i`-th entry of the coordinate of `v` |

> [!NOTE]
> `ι →₀ K` (`Finsupp`) is the type of functions `ι → K` that are nonzero on only finitely many inputs. Every vector in `V` has a **unique** coordinate representation of this form via the basis `B`.

### Constructing a basis

Given a linearly independent family of vectors `b` that spans `V`, we can assemble it into a basis:

```lean
noncomputable example (b : ι → V) (b_indep : LinearIndependent K b)
    (b_spans : ∀ v, v ∈ Submodule.span K (Set.range b)) : Basis ι K V :=
  Basis.mk b_indep (fun v _ ↦ b_spans v)
```

A basis is exactly the conjunction of two conditions:
1. the family `b` is **linearly independent**, and
2. the family `b` **spans** the whole vector space.

The constructed basis retrieves the original family pointwise:

```lean
example (b : ι → V) (b_indep : LinearIndependent K b)
    (b_spans : ∀ v, v ∈ Submodule.span K (Set.range b)) (i : ι) :
    Basis.mk b_indep (fun v _ ↦ b_spans v) i = b i :=
  Basis.mk_apply b_indep (fun v _ ↦ b_spans v) i
```

### Canonical bases

```lean
variable [DecidableEq ι]
-- The basis of `ι →₀ K` given by the single vectors
example : Finsupp.basisSingleOne.repr = LinearEquiv.refl K (ι →₀ K) := rfl
example (i : ι) : Finsupp.basisSingleOne i = Finsupp.single i 1 := rfl
-- Coordinates of a function `ι → K` with respect to the Pi basis
example [Finite ι] (x : ι → K) (i : ι) : (Pi.basisFun K ι).repr x i = x i := by simp
```

- `Finsupp.basisSingleOne` — the basis of `ι →₀ K` whose `i`-th vector is `Finsupp.single i 1`; its `repr` is definitionally the identity. `DecidableEq ι` is needed to decide equality of indices.
- `Pi.basisFun K ι` — the basis of `ι → K` (for finite `ι`) that recovers each function entry as its own coordinate.

### Reconstructing a vector from its coordinates

The vector `v` is the linear combination of the basis vectors `B i` with coefficients `B.repr v i`:

```lean
example [Fintype ι] : ∑ i : ι, B.repr v i • (B i) = v :=
  B.sum_repr v
```

## Linear Combinations

### Linear combination with general vectors

For a coefficient function `c : ι →₀ K` and any family of vectors `f : ι → V`, the linear combination over the support of `c` can be computed as a sum over **any** finset `s` containing that support — the extra terms contribute zero coefficients:

```lean
example (c : ι →₀ K) (f : ι → V) (s : Finset ι) (h : c.support ⊆ s) :
    Finsupp.linearCombination K f c = ∑ i ∈ s, c i • f i :=
  Finsupp.linearCombination_apply_of_mem_supported K h
```

Taking linear combinations is itself linear in the coefficients:

```lean
variable (f : ι → V) in
#check (Finsupp.linearCombination K f : (ι →₀ K) →ₗ[K] V)
```

### Linear combination with a basis

Combining the basis vectors with their coordinates gives back the vector:

```lean
example : Finsupp.linearCombination K B (B.repr v) = v :=
  B.linearCombination_repr v
```

## Linear Maps Constructed from a Basis

Let `W` be another vector space over `K`, `φ : V →ₗ[K] W`, and `u : ι → W` a family of vectors in `W`.

### Extension by linearity (`B.constr`)

A linear map out of `V` is completely determined by its values on a basis. This is packaged as a linear equivalence:

```lean
#check (B.constr K : (ι → W) ≃ₗ[K] (V →ₗ[K] W))
#check (B.constr K u : V →ₗ[K] W)
```

In other words, given a basis `B` of `V`:
- **(a)** once we specify the images `u` of the basis vectors, the linear map is completely determined;
- **(b)** conversely, once the linear map is specified on the basis vectors, the images `u` are determined.

The constructed map does what it should on basis vectors:

```lean
example (i : ι) : B.constr K u (B i) = u i :=
  B.constr_basis K u i
```

### Maps agreeing on a basis are equal (`B.ext`)

Two linear maps that agree on all basis vectors are equal:

```lean
example (φ ψ : V →ₗ[K] W) (h : ∀ i, φ (B i) = ψ (B i)) : φ = ψ :=
  B.ext h
```

## Matrices Representing Linear Maps

The matrix representing a linear map is determined by three things:
1. the choice of basis `B` for the source `V` — once `B` is fixed, `V` is coordinatized;
2. the choice of basis `B'` for the target `W`;
3. the action of the linear map on the basis vectors of `V`.

> [!IMPORTANT]
> The basis vectors `B i` need **not** be mapped to basis vectors of `W` — they can land anywhere in `W`, and different actions give different matrices. Moreover, even when `B` is mapped onto `B'`, the map on indices need not be bijective, since the index types `ι` and `ι'` may have different sizes.

### The matrix of a linear map (`toMatrix`)

With bases `B` of `V` (indexed by `ι`) and `B'` of `W` (indexed by `ι'`), both finite with decidable equality:

```lean
variable {ι' : Type*} (B' : Basis ι' K W)
         [Fintype ι] [DecidableEq ι] [Fintype ι'] [DecidableEq ι']
open LinearMap Matrix  -- `*ᵥ` is matrix–vector multiplication

#check (toMatrix B B' : (V →ₗ[K] W) ≃ₗ[K] Matrix ι' ι K)
```

This is a two-way correspondence:
- **(a)** given the linear map, the matrix `Matrix ι' ι K` with respect to these bases is determined;
- **(b)** given the matrix, the linear map is determined.

The matrix acts on coordinate vectors as expected — the coordinate of `v` multiplied by the matrix of `φ` gives the coordinate of `φ v`:

$$
M_{B'}^{B}(\varphi) \cdot [v]_{B} \;=\; [\varphi(v)]_{B'}
$$

```lean
example (φ : V →ₗ[K] W) (v : V) : (toMatrix B B' φ) *ᵥ (B.repr v) = B'.repr (φ v) :=
  toMatrix_mulVec_repr B B' φ v
```

### Change of basis

Let `B''` be another basis of `W` (indexed by `ι''`). The matrix of `φ` with respect to `B, B''` is obtained by multiplying the matrix of the **identity map** from `B'` to `B''` with the matrix of `φ` from `B` to `B'`:

$$
M_{B''}^{B}(\varphi) \;=\; M_{B''}^{B'}(\mathrm{id}) \cdot M_{B'}^{B}(\varphi)
$$

```lean
example (φ : V →ₗ[K] W) : (toMatrix B B'' φ) = (toMatrix B' B'' .id) * (toMatrix B B' φ) := by
  simp
```

### Composition corresponds to matrix multiplication

| Lemma | Statement |
| --- | --- |
| `toMatrix_comp` | `toMatrix v₁ v₃ (f.comp g) = toMatrix v₂ v₃ f * toMatrix v₁ v₂ g` |
| `id_comp` | `LinearMap.id ∘ₗ f = f` |
| `comp_id` | `f ∘ₗ LinearMap.id = f` |
| `toMatrix_id` | the identity map is represented by the identity matrix |
| `Matrix.det_mul` | `det (A * B) = det A * det B` |
| `Matrix.det_one` | `det 1 = 1` |

### The determinant of an endomorphism is basis-independent

If `B` and `B'` are both bases of the *same* space `V` and `φ : End K V`, then the determinant of the representing matrix does not depend on the chosen basis:

$$
\det M_B^B(\varphi) \;=\; \det M_{B'}^{B'}(\varphi)
$$

Two aspects are at play:
1. the matrix of an endomorphism is unchanged when the target basis varies together with the source basis;
2. once source and target bases are fixed, the matrix is uniquely determined by the map itself.

That is, `toMatrix B B φ` is determined by `φ`, not by the particular choice between `B` and `B'`.

<details>
<summary><strong>Proof walkthrough</strong> (click to expand)</summary>

```lean
example [Fintype ι] (B' : Basis ι K V) (φ : End K V) :
    (toMatrix B B φ).det = (toMatrix B' B' φ).det := by
  set M := toMatrix B B φ
  set M' := toMatrix B' B' φ
  set P := (toMatrix B B') LinearMap.id
  set P' := (toMatrix B' B) LinearMap.id
  have F : M = P' * M' * P := by
    rw [← toMatrix_comp, ← toMatrix_comp, id_comp, comp_id]
  have F' : P' * P = 1 := by
    rw [← toMatrix_comp, id_comp, toMatrix_id]
  rw [F, Matrix.det_mul, Matrix.det_mul,
      show P'.det * M'.det * P.det = P'.det * P.det * M'.det by ring, ← Matrix.det_mul, F',
      Matrix.det_one, one_mul]
```

1. **Name the players.** `M`, `M'` are the matrices of `φ` in the two bases; `P` and `P'` are the change-of-basis matrices (the identity map read in the two pairs of bases).
2. **Similarity (`F`).** `M = P' * M' * P`: fold matrix products back into compositions with `← toMatrix_comp` (twice), then simplify `id ∘ₗ φ ∘ₗ id` to `φ` via `id_comp`/`comp_id`.
3. **Inverse change of basis (`F'`).** `P' * P = 1`, since the two identity readings compose to the identity map, whose matrix is `1` (`toMatrix_id`).
4. **Determinant computation.** Expand `det M` via `Matrix.det_mul` twice, commute the scalar determinants with `ring`, refold `P'.det * P.det` into `det (P' * P) = det 1 = 1` (`← Matrix.det_mul`, `F'`, `Matrix.det_one`), and finish with `one_mul`.

</details>

## Finite Rank of Vector Spaces

The **finite rank** (dimension) of `V` over `K` is a natural number:

```lean
#check (Module.finrank K V : ℕ)
```

### The archetypical `n`-dimensional space

`Fin n → K` is the canonical space of dimension `n` over `K`:

```lean
example (n : ℕ) : Module.finrank K (Fin n → K) = n :=
  Module.finrank_fin_fun K
```

### The scalar field matters

Different scalar fields give different dimensions, even when the underlying additive group is the same. When computing a dimension, always keep the scalar field in mind:

- `ℂ` as a vector space over itself has dimension one: `Module.finrank ℂ ℂ = 1` (`Module.finrank_self`).
- `ℂ` as a vector space over `ℝ` has dimension two: `Module.finrank ℝ ℂ = 2` (`Complex.finrank_real_complex`).

### Positivity of rank

For a finite-dimensional space, the rank is positive iff the space is nontrivial:

```lean
example [FiniteDimensional K V] : 0 < Module.finrank K V ↔ Nontrivial V :=
  Module.finrank_pos_iff
```

The forward direction alone is often useful on its own:

```lean
example [FiniteDimensional K V] (h : 0 < Module.finrank K V) : Nontrivial V := by
  apply (Module.finrank_pos_iff (R := K)).1
  exact h
```

### Finite basis ⇔ finite-dimensional

A basis `B : Basis ι K V` relates finiteness of the index type `ι` to finite-dimensionality of `V`:

```lean
variable {ι : Type*} (B : Module.Basis ι K V)
example [Finite ι] : FiniteDimensional K V := Module.Basis.finiteDimensional_of_finite B
example [FiniteDimensional K V] : Finite ι := (FiniteDimensional.fintypeBasisIndex B).finite
```

## Finite Rank of Submodules

Let `E F : Submodule K V` with `V` finite-dimensional.

**Dimension formula.** The rank of the supremum plus the rank of the infimum equals the sum of the ranks:

$$
\dim(E + F) + \dim(E \cap F) = \dim E + \dim F
$$

```lean
example : finrank K (E ⊔ F : Submodule K V) + finrank K (E ⊓ F : Submodule K V) =
    finrank K E + finrank K F :=
  Submodule.finrank_sup_add_finrank_inf_eq E F
```

**Monotonicity.** The rank of a submodule is at most the rank of the whole space:

```lean
example : finrank K E ≤ finrank K V := Submodule.finrank_le E
```

**Pigeonhole for subspaces.** If the ranks of `E` and `F` add up to more than the rank of `V`, their intersection is nontrivial:

```lean
example (h : finrank K V < finrank K E + finrank K F) :
    Nontrivial (E ⊓ F : Submodule K V) := by
  rw [← Module.finrank_pos_iff (R := K)]
  rw [← Submodule.finrank_sup_add_finrank_inf_eq E F] at h
  have : finrank K (E ⊔ F : Submodule K V) ≤ finrank K V := Submodule.finrank_le (E ⊔ F : Submodule K V)
  linarith
```

The proof rewrites the goal into positivity of `finrank K (E ⊓ F)` (`← Module.finrank_pos_iff`), rewrites the hypothesis with the dimension formula, notes that `finrank K (E ⊔ F) ≤ finrank K V` by monotonicity, and lets `linarith` close the arithmetic.
