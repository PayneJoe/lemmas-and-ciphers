import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Eigenspace.Minpoly
import Mathlib.LinearAlgebra.Charpoly.Basic
import MIL.Common

/- Properties of submodules of a vector space -/
section SubmoduleProperties

/-
1. vector space `V` over the field `K`
-/
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]

/- Property of addition closure of subspace `U` -/
example (U : Submodule K V) {x y : V} (hx : x ∈ U) (hy : y ∈ U) :
    x + y ∈ U :=
  -- `Submodule.add_mem` works for `U ≤ V, x, y ∈ U, x + y ∈ U`
  U.add_mem hx hy
/- Property of scalar multiplication closure of subspace `U` -/
example (U : Submodule K V) {x : V} (hx : x ∈ U) (a : K) :
    a • x ∈ U :=
  -- `Submodule.smul_mem` works for `U ≤ V, x ∈ U, a ∈ K, a • x ∈ U`
  U.smul_mem a hx

end SubmoduleProperties

/- Subspace example of ℝ ≤ ℂ -/
/-
  1. scalar `Semiring` in `Submodule` is instantiated with `ℝ` (a field)
  2. object `Module` in `Submodule` is instantiated with `ℂ` (a vector space over field `ℝ`)
-/
noncomputable example : Submodule ℝ ℂ where
  /- The structure of submodule `Submodule ℝ ℂ` -/
  /- 1. `carrier` is the object (set) of the submodule `Submodule ℝ ℂ` -/
  /-
    a. `(↑)` is the coercion function of type `ℝ → ℂ`, converting a real number to a complex number.
       This enforced conversion is necessary because the module is of type `ℂ`,  then its submodule
       must also be of type `ℂ`.
    b. `Set.range ((↑) : ℝ → ℂ)` is the set of all images of the coercion function, i.e. `ℝ`
  -/
  carrier := Set.range ((↑) : ℝ → ℂ)
  /- 2. `add_mem'` proves the closure under addition of the submodule -/
  /-
    a. `add_mem'` is a proof of `∀ {x, y : ℂ}, x y ∈ carrier, x + y ∈ carrier`, where `carrier ⊆ ℂ`
    b. `rintro _ _` introduces two variables `x` and `y` of type `ℂ` into the proof context.
    c. `⟨n, rfl⟩` destructs `x ∈ ((↑) : ℝ → ℂ).range ↔ ∃ n : ℝ, x = ↑n` and rewrite `x` as `↑n` in goal
    d. `⟨m, rfl⟩` destructs `y ∈ ((↑) : ℝ → ℂ).range ↔ ∃ m : ℝ, y = ↑m` and rewrite `y` as `↑m` in goal
    e. `use n + m` destructs `↑n + ↑m ∈ (↑) : ℝ → ℂ).range ↔ ∃ k : ℝ, ↑n + ↑m = ↑k` and provides `k = n + m`.
    f. `simp` simplifies the expression `↑(n + m) = ↑n + ↑m` since `↑` is a linear map of two vector spaces `ℝ →ₗ[ℝ] ℂ`
      , and thus preserves addition.
  -/
  add_mem' := by
    rintro _ _ ⟨n, rfl⟩ ⟨m, rfl⟩
    use n + m
    simp
  /- 3. `zero_mem'` proves the existence of zero element in the submodule -/
  /-
    a. `zero_mem'` is a proof of `0 ∈ carrier`, where `carrier ⊆ ℂ`
    b. `0 ∈ carrier ↔ ∃ n : ℝ, 0 = ↑n` and `n = 0` is a witness of the existential quantifier.
    c. `↑` maps `0 : ℝ` to `0 : ℂ` as `↑` is a linear map of two vector spaces `ℝ →ₗ[ℝ] ℂ`,
        and thus preserves zero.
  -/
  zero_mem' := by
    use 0
    simp
  /- 4. `smul_mem'` proves the closure under scalar multiplication of the submodule -/
  /-
    a. `smul_mem'` is a proof of `∀ {c : ℝ} {x : ℂ}, x ∈ carrier, c • x ∈ carrier`, where `carrier ⊆ ℂ`
    b. `rintro c -` introduces a variable `c` of type `ℝ` and a variable `x` of type `ℂ` into the proof context.
    c. `⟨a, rfl⟩` destructs `x ∈ ((↑) : ℝ → ℂ).range ↔ ∃ a : ℝ, x = ↑a` and rewrite `x` as `↑a` in goal
    d. `use c*a` destructs `c • ↑a ∈ ((↑) : ℝ → ℂ).range ↔ ∃ k : ℝ, c • ↑a = ↑k` and provides `k = c * a`.
    e. `simp` simplifies the expression `↑(c * a) = c • ↑a` since `↑` is a linear map of two vector spaces `ℝ →ₗ[ℝ] ℂ`,
        and thus preserves scalar multiplication.
  -/
  smul_mem' := by
    rintro c - ⟨a, rfl⟩
    use c*a
    simp

-- Vector space `V` over the field `K`
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]

-- Given another vector space `W`, a linear map `φ : V →ₗ[K] W`, and a submodule `H` of `W`,
-- the preimage of a submodule `H` of `W` is a submodule of `V`.
def preimage {W : Type*} [AddCommGroup W] [Module K W] (φ : V →ₗ[K] W) (H : Submodule K W) :
    Submodule K V where
  /- 1. `carrier` defines the underlying set of the submodule as the preimage of `H` under `φ` -/
  /-
    a. `φ ⁻¹' H` is the set of all elements `v ∈ V` such that `φ(v) ∈ H`
  -/
  carrier := φ ⁻¹' H
  /- 2. `zero_mem'` proves the existence of zero element in the preimage submodule -/
  /-
    a. `Set.mem_preimage` rewrite `0 ∈ φ ⁻¹' H ↔ φ(0) ∈ H`
    b. `LinearMap.map_zero` rewrites `φ(0)` as `0` since `φ` is a linear map, and thus preserves zero.
    c. `Submodule.zero_mem H` proves that `0 ∈ H` since `H` is a submodule.
  -/
  zero_mem' := by
    rw [Set.mem_preimage, LinearMap.map_zero]
    exact Submodule.zero_mem H
  /- 3. `add_mem'` proves the closure under addition of the preimage submodule -/
  /-
    a. `rintro a b ha hb` destruct `∀ {a b : V}, a ∈ ⇑φ ⁻¹' ↑H → b ∈ ⇑φ ⁻¹' ↑H`
    b. `Set.mem_preimage` rewrite `a ∈ φ ⁻¹' H ↔ φ(a) ∈ H`, `b ∈ φ ⁻¹' H ↔ φ(b) ∈ H` and `a + b ∈ φ ⁻¹' H ↔ φ(a + b) ∈ H`
    c. `LinearMap.map_add` rewrites `φ(a + b)` as `φ(a) + φ(b)` since `φ` is a linear map, and thus preserves addition.
    d. `Submodule.add_mem H ha hb` shows that `φ(a), φ(b) ∈ H, φ(a) + φ(b) ∈ H`
  -/
  add_mem' := by
    rintro a b ha hb
    rw [Set.mem_preimage, LinearMap.map_add] at *
    exact Submodule.add_mem H ha hb
  /- 4. `smul_mem'` proves the closure under scalar multiplication of the preimage submodule -/
  /-
    a. `rintro c x hx` destruct `∀ {c : K} {x : V}, x ∈ φ ⁻¹' H → c • x ∈ φ ⁻¹' H`
    b. `Set.mem_preimage` rewrite `x ∈ φ ⁻¹' H ↔ φ(x) ∈ H` and `c • x ∈ φ ⁻¹' H ↔ φ(c • x) ∈ H`
    c. `LinearMap.map_smul` rewrites `φ(c • x)` as `c • φ(x)` since `φ` is a linear map, and thus preserves scalar multiplication.
    d. `Submodule.smul_mem H c hx` shows that `φ(x) ∈ H` implies `c • φ(x) ∈ H` since `H` is a submodule.
  -/
  smul_mem' := by
    rintro c x hx
    rw [Set.mem_preimage, LinearMap.map_smul] at *
    exact Submodule.smul_mem H c hx

/- Theorems of subspaces -/
/- Subspace is also a vector space -/
-- If `U` is a subspace of vector space `V`, then `U` is also a vector space over the same field `K`.
example (U : Submodule K V) : Module K U := inferInstance
example (U : Submodule K V) : Module K {x : V // x ∈ U} := inferInstance

/- Intersections `⊓` of subspaces is also a subspace -/
-- Intersection of two subspaces is defined as the intersection of their underlying sets.
example (H H' : Submodule K V) :
    ((H ⊓ H' : Submodule K V) : Set V) = (H : Set V) ∩ (H' : Set V) := rfl

/- Union `⊔` of subspaces is also a subspace -/
-- Union of two subspaces is defined as the span of the union of their underlying sets.
example (H H' : Submodule K V) :
    ((H ⊔ H' : Submodule K V) : Set V) = Submodule.span K ((H : Set V) ∪ (H' : Set V)) := by
  simp [Submodule.span_union]

/- Top `⊤` is also a subspace -/
-- The top subspace `⊤` is defined as the set of all vectors in the vector space `V`.
example (x : V) : x ∈ (⊤ : Submodule K V) := trivial
/- Bottom `⊥` is also a subspace -/
-- The bottom subspace `⊥` is defined as the set containing only the zero vector.
example (x : V) : x ∈ (⊥ : Submodule K V) ↔ x = 0 := Submodule.mem_bot K

/- IsComplete of two subspaces -/
-- That `U` and `V` are complete means `U ⊓ V = ⊥` and `U ⊔ V = ⊤`.
example (U V : Submodule K V) (h : IsCompl U V) :
  -- `IsComplete.sup_eq_top` show that the supremum of `U` and `V` is the top submodule.
  U ⊔ V = ⊤ := h.sup_eq_top
example (U V : Submodule K V) (h : IsCompl U V) :
  -- `IsComplete.inf_eq_bot` show that the infimum of `U` and `V` is the bottom submodule.
  U ⊓ V = ⊥ := h.inf_eq_bot

/- Direct sum of subspaces -/
section DirectSumOfSubspaces

open DirectSum
-- `DecidableEq ι` means `∀ (a b : ι), Decidable (a = b)`,
-- i.e. for any two elements `a` and `b` of type `ι`, it is decidable whether they are equal or not.
variable {ι : Type*} [DecidableEq ι]

-- `DirectSum.IsInternal U` means that the family of subspaces `U` is in internal direct sum of vector space `V`.
-- That is `V` can be decomposed into a direct sum of the subspaces `U i` for `i : ι`, i.e. `(⨁ i, U i) ≃ₗ[K] V`
-- "direct sum" means: a) `⊔ i, U i = ⊤` (the subspaces together span the whole space)
--                     b) `U i ⊓ U j = ⊥` for `i ≠ j` (the subspaces intersect only at zero)
example (U : ι → Submodule K V) (h : DirectSum.IsInternal U) :
  -- `DirectSum.IsInternal.submodule_iSup_eq_top` shows that the supremum of the submodules `U i` is the top submodule.
  ⨆ i, U i = ⊤ := h.submodule_iSup_eq_top
example {ι : Type*} [DecidableEq ι] (U : ι → Submodule K V) (h : DirectSum.IsInternal U)
    {i j : ι} (hij : i ≠ j) : U i ⊓ U j = ⊥ :=
  -- `DirectSum.IsInternal.submodule_iSupIndep.pairwiseDisjoint` shows that the submodules `U i` and `U j` are disjoint for `i ≠ j`.
  (h.submodule_iSupIndep.pairwiseDisjoint hij).eq_bot
#check DirectSum.isInternal_submodule_iff_iSupIndep_and_iSup_eq_top
noncomputable example {ι : Type*} [DecidableEq ι] (U : ι → Submodule K V)
    (h : DirectSum.IsInternal U) : (⨁ i, U i) ≃ₗ[K] V :=
  LinearEquiv.ofBijective (coeLinearMap U) h

end DirectSumOfSubspaces

-- Span of a set of vectors `s` is a subspace of another subspace `E` if and only if `s` is a subset of `E`.
example {s : Set V} (E : Submodule K V) : Submodule.span K s ≤ E ↔ s ⊆ E :=
  Submodule.span_le
-- The coercion function `(↑)` converts a subspace of `V` to a set of type `Set V`.
example : GaloisInsertion (Submodule.span K) ((↑) : Submodule K V → Set V) :=
  Submodule.gi K V

-- Any element from the supremum of two submodules can be expressed as the sum of an element from each submodule.
-- It is good to known that we can convert the problem of `S ⊔ T` to the problem of `Submodule.span K (↑S ∪ ↑T)`
example {S T : Submodule K V} {x : V} (h : x ∈ S ⊔ T) :
    ∃ s ∈ S, ∃ t ∈ T, x = s + t  := by
  -- `Submodule.span_eq` means `Span K ↑S = S`, it will explicityly use coercion `((↑) : Submodule K V → Set V)` to convert submodules to set.
  -- `Submodule.span_union` means `Span K (S ∪ T) = Span K S ⊔ Span K T`
  rw [← S.span_eq, ← T.span_eq, ← Submodule.span_union] at h
  -- prove with induction on the submodule span induction `x ∈ Submodule.span K (↑S ∪ ↑T)`
  induction h using Submodule.span_induction with
  -- for the case of `x = y ∈ (↑S ∪ ↑T)`
  | mem y h =>
      rcases h with (y_in_S | y_in_T)
      · use y, y_in_S, 0, T.zero_mem; simp
      · use 0, S.zero_mem, y, y_in_T; simp
  -- for the case of `x = 0 ∈ Submodule.span K (↑S ∪ ↑T)`
  | zero =>
      use 0, S.zero_mem, 0, T.zero_mem; simp
  -- for the induction case of `x ∈ Span K (↑S ∪ ↑T), ∃ s ∈ S, ∃ t ∈ T, x = s + t, y ∈ Span K (↑S ∪ ↑T), ∃ s ∈ S, ∃ t ∈ T, y = s + t`
  -- `→ ∃ s ∈ S, ∃ t ∈ T, x + y = s + t`
  | add x y hx hy hx' hy' =>
      rcases hx' with ⟨sx, sx_in_S, tx, tx_in_T, rfl⟩
      rcases hy' with ⟨sy, sy_in_S, ty, ty_in_T, rfl⟩
      use sx + sy, S.add_mem sx_in_S sy_in_S, tx + ty, T.add_mem tx_in_T ty_in_T
      module
  -- for the induction case of `x ∈ Span K (↑S ∪ ↑T), ∃ s ∈ S, ∃ t ∈ T, x = s + t, c ∈ K → ∃ s ∈ S, ∃ t ∈ T, c • x = s + t`
  | smul a x hx hx' =>
      rcases hx' with ⟨sx, sx_in_S, tx, tx_in_T, rfl⟩
      use a • sx, S.smul_mem a sx_in_S, a • tx, T.smul_mem a tx_in_T
      simp

/- LinearMap of Vector Spaces -/
section LinearMapOfVectorSpaces

/- Basic properties of linear map of vector space -/
-- linear map `φ : V →ₗ[K] W` between two vector spaces `V` and `W` over the same field `K`
variable {W : Type*} [AddCommGroup W] [Module K W] (φ : V →ₗ[K] W)
-- define another subspace `E` of `V`
variable (E : Submodule K V) in
-- linear map `φ` restricted to the subspace `E` of `V` is also a linear map from `E` to `W`
#check (Submodule.map φ E : Submodule K W)
-- define another subspace `F` of `W`
variable (F : Submodule K W) in
-- linear map `φ` restricted to the preimage of the subspace `F` of `W` is also a linear map from `V` to the preimage of `F`
#check (Submodule.comap φ F : Submodule K V)
-- the range of linear map `φ` is the image of the top subspace `⊤` of `V` under `φ`,
-- conceptually range and image are the same thing, but in Lean, they are defined differently.
example : LinearMap.range φ = .map φ ⊤ := LinearMap.range_eq_map φ
-- the kernel of linear map `φ` is the preimage of the bottom subspace `⊥` of `W` under `φ`,
-- conceptually kernel and preimage are the same thing, but in Lean, they are defined differently.
example : LinearMap.ker φ = .comap φ ⊥ := Submodule.comap_bot φ -- or `rfl`

open Function LinearMap
/- injective property of linear map -/
-- linear map `φ` is injective if and only if its kernel is the bottom subspace `⊥` of `V`
example : Injective φ ↔ ker φ = ⊥ := ker_eq_bot.symm
-- linear map `φ` is surjective if and only if its range is the top subspace `⊤` of `W`
example : Surjective φ ↔ range φ = ⊤ := range_eq_top.symm

-- the image of one element of subspace under linear map `φ` is in the image of the subspace under `φ`
-- i.e. if `x ∈ p ≤ E → φ(x) ∈ φ(E)`
#check Submodule.mem_map_of_mem
-- one element of the image of a subspace under linear map `φ` must has a preimage in the subspace
-- i.e. if `y ∈ φ(E) ↔ ∃ x ∈ E, φ(x) = y`
#check Submodule.mem_map
-- one element of the preimage of a subspace under linear map `φ` is in the preimage of the subspace under `φ`
-- i.e. if `x ∈ φ⁻¹(F) ↔ φ(x) ∈ F`
#check Submodule.mem_comap

-- The image of a subspace under linear map `φ` is a subspace of the codomain if and only if the subspace is a subspace of the preimage of the codomain
example (E : Submodule K V) (F : Submodule K W) :
    Submodule.map φ E ≤ F ↔ E ≤ Submodule.comap φ F := by
  constructor
  -- forward direction: if `Submodule.map φ E ≤ F → E ≤ Submodule.comap φ F`
  · rintro h x x_in_E
    -- `∀ y ∈ Submodule.map φ E, y ∈ F ↔ ∃ x ∈ E, φ(x) = y`
    specialize h ⟨x, x_in_E, rfl⟩
    exact h
  -- backward direction: if `E ≤ Submodule.comap φ F → Submodule.map φ E ≤ F`
  · rintro h _ ⟨x, x_in_E, rfl⟩
    rcases h x_in_E with h1
    exact h1

/- Properties of Quotient space -/
-- Quotient space `V ⧸ E` is a vector space over the same field `K` if `E` is a subspace of `V`.
variable (E : Submodule K V)
example : Module K (V ⧸ E) := inferInstance
-- `Submodule.mkQ` is the canonical projection of linear map from `V` to the quotient space `V ⧸ E`, i.e. `mkQ : V →ₗ[K] V ⧸ E`
example : V →ₗ[K] V ⧸ E := E.mkQ
-- `Submodule.ker_mkQ` shows that the kernel of linear map `mkQ` is the subspace `E`, i.e. `ker (mkQ) = E`
example : ker E.mkQ = E := E.ker_mkQ
-- ```Submodule.range_mkQ` shows that the range of linear map `mkQ` is the top subspace `⊤`, i.e. `range (mkQ) = ⊤`
example : range E.mkQ = ⊤ := E.range_mkQ
-- `Submodule.liftQ` is the universal property of lifting quotient space,
-- i.e. if `hφ : E ≤ ker φ`, then there exists a unique linear map `V ⧸ E →ₗ[K] W` such that `φ = liftQ φ hφ ∘ mkQ`
example (hφ : E ≤ ker φ) : V ⧸ E →ₗ[K] W := E.liftQ φ hφ
-- `φ : V →ₗ[K] W, E ≤ ker φ, mkQ : V →ₗ[K] V ⧸ E, liftQ : V ⧸ E →ₗ[K] W ↔ φ = liftQ φ hφ ∘ mkQ`
-- `Submodule.mapQ` is the universal property of mapping quotient space,
-- i.e. if `hφ : E ≤ .comap φ F`, then there exists a unique linear map `V ⧸ E →ₗ[K] W ⧸ F` such that `φ = mapQ F φ hφ ∘ mkQ`
-- V     →     W
-- ↓mkQ  φ     ↓mkQ
-- V ⧸ E →     W ⧸ F
--      mapQ
example (F : Submodule K W) (hφ : E ≤ .comap φ F) : V ⧸ E →ₗ[K] W ⧸ F := E.mapQ F φ hφ
-- There is an isomorphism between the quotient space `V ⧸ ker φ` and the range of linear map `φ`, i.e. `(V ⧸ ker φ) ≃ₗ[K] range φ`
noncomputable example : (V ⧸ LinearMap.ker φ) ≃ₗ[K] range φ := φ.quotKerEquivRange

open Submodule

-- `Submodule.map_comap_eq` shows that the image of the preimage of a subspace under linear map `φ` is equal to the intersection of the subspace and the range of `φ`,
-- i.e. `Submodule.map φ (Submodule.comap φ F) = F ⊓ range φ`
-- The reason is that there `∃ y ∈ F, y ∉ φ`, in other words, these elements of `F` do not have preimage in domain under `φ`
#check Submodule.map_comap_eq
-- `Submodule.comap_map_eq` shows that the preimage of the image of a subspace under linear map `φ` is equal to the sum of the subspace and the kernel of `φ`,
-- i.e. `Submodule.comap φ (Submodule.map φ E) = E ⊔ ker φ`
-- The reason is that if `E ≤ ker φ`, then `0 ∈ φ E` and `ker φ ⊆ comap φ (φ E)`.
#check Submodule.comap_map_eq

example : Submodule K (V ⧸ E) ≃ { F : Submodule K V // E ≤ F } where
  toFun := sorry
  invFun := sorry
  left_inv := sorry
  right_inv := sorry

end LinearMapOfVectorSpaces
