import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Eigenspace.Minpoly
import Mathlib.LinearAlgebra.Charpoly.Basic

import MIL.Common

/- Recall that `Semiring` is a `Ring` without inverse property for `+` in `AddCommMonoid` -/

/- Global variables -/
/-
Vector space `V` over the field `K` is a special case of module instantiated with `Module K V` where:
1. `AddCommMonoid` in `Module` is instantiated with `AddCommGroup V`
2. `Semiring` in `Module` is instantiated with `Field K`
-/
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]

/- Distribution property of vector space -/
-- The operator `•` defined in `Module` describes the operations between object `AddCommMonoid` and scalar `Semiring`
example (a : K) (u v : V) : a • (u + v) = a • u + a • v := by
  -- `smul_add` implies operations `•` and `+`
  rw [smul_add]
example (a b : K) (u : V) : (a + b) • u = a • u + b • u := by
  -- `add_smul` implies operations `+` and `•`
  rw [add_smul]

/- Commutativity property of vector space -/
-- Since `Field` is commutative, scalar multiplication is commutative
example (a b : K) (u : V) : a • b • u = b • a • u := by
  -- `smul_comm` implies commutativity of scalars in operation `•`
  rw [smul_comm]

/-
Module `Module (Ideal R) (Submodule R M)`:
1. object `AddCommMonoid` is instantiated with `Submodule R M` as `Module` extends `AddCommMonoid`, and `Submodule R M` is a `Module`
2. scalar `Semiring` is instantiated with `Ideal R` as `CommSemiring` extends `Semiring`, and `Ideal R` is a `CommSemiring`
-/
example {R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M] :
    Module (Ideal R) (Submodule R M) :=
  inferInstance

/- Module over Ring -/
section
variable {R : Type*} [Ring R] {M : Type*} [AddCommGroup M] [Module R M]
end
/- Module over Semiring -/
section
variable {R : Type*} [Semiring R] {M : Type*} [AddCommMonoid M] [Module R M]
end

-- Another vector space `W` over field `K`
variable {W : Type*} [AddCommGroup W] [Module K W]
-- A linear map `φ` from vector space `V` to vector space `W`
variable (φ : V →ₗ[K] W)

/- Two properties of linear map -/
-- 1. Homogeneity property of linear map
example (a : K) (v : V) : φ (a • v) = a • φ v :=
  -- `map_smul` implies operations `→` and `•`
  map_smul φ a v
-- 2. Additivity property of linear map
example (v w : V) : φ (v + w) = φ v + φ w :=
  -- `map_add` implies operations `→` and `+`
  map_add φ v w

-- Another linear map `ψ` from vector space `V` to vector space `W`
variable (ψ : V →ₗ[K] W)

-- Linear map `V →ₗ[K] W` is also a vector space, so it satisfies the three conditions of vector space:
-- 1. `0 ∈ V →ₗ[K] W` is the zero map which maps all elements in `V` to `0` in `W`
-- 2. `∀ x, y ∈ V →ₗ[K] W, x + y ∈ V →ₗ[K] W`
-- 3. `∀ a ∈ K, x ∈ V →ₗ[K] W, a • x ∈ V →ₗ[K] W`
#check (2 • φ + ψ : V →ₗ[K] W)

-- Another linear map `θ` from vector space `W` to vector space `V`
variable (θ : W →ₗ[K] V)
-- `∘ₗ` is a composition operator for linear maps, which is also a linear map
#check (φ.comp θ : W →ₗ[K] W)
#check (φ ∘ₗ θ : W →ₗ[K] W)

-- An instance of linear map from vector space `V` to vector space `V` itself :
example : V →ₗ[K] V where
  -- function underline `fun v → 3 • v`
  toFun v := 3 • v
  -- Additivity proof `map_add` of linear map, `toFun (a + b) = toFun a + toFun b`, that is `3 • (a + b) = 3 • a + 3 • b`
  map_add' _ _ := smul_add ..
  -- Homogeneous proof `map_smul` of linear map, `toFun (a • b) = a • toFun b`, that is `3 • (a • b) = a • (3 • b)`
  map_smul' _ _ := smul_comm ..

-- `map_add'` is the internal proposal for preserving addition
#check (φ.map_add' : ∀ x y : V, φ.toFun (x + y) = φ.toFun x + φ.toFun y)
-- `φ.map_add` derived lemma(user-facing) from `map_add'`
#check (φ.map_add : ∀ x y : V, φ (x + y) = φ x + φ y)
-- `map_add φ` is the same with `φ.map_add`
#check (map_add φ : ∀ x y : V, φ (x + y) = φ x + φ y)

-- `lsmul` of type `K →ₗ[K] V →ₗ[K] V` transforms a scalar multiplication into a bilinear map
#check (LinearMap.lsmul K V 3 : V →ₗ[K] V)
#check (LinearMap.lsmul K V : K →ₗ[K] V →ₗ[K] V)

/- Linear Equivalence -/
-- if `f` is linear equivalence from vector space `V` to vector space `W`,
-- then the composition of `f` and `f.symm` is an identity map,  i.e. `f ∘ₗ f.symm = 1`
example (f : V ≃ₗ[K] W) : f ≪≫ₗ f.symm = LinearEquiv.refl K V :=
  f.self_trans_symm
-- if a linear map `f` is bijective, then it is a linear equivalence
noncomputable example (f : V →ₗ[K] W) (h : Function.Bijective f) : V ≃ₗ[K] W :=
  .ofBijective f h


section binary_product

-- Define three different vector spaces `V`, `W`, and `U` over the same field `K`
variable {W : Type*} [AddCommGroup W] [Module K W]
variable {U : Type*} [AddCommGroup U] [Module K U]
variable {T : Type*} [AddCommGroup T] [Module K T]

/- Projection Map -/
-- First projection map
example : V × W →ₗ[K] V := LinearMap.fst K V W
-- Second projection map
example : V × W →ₗ[K] W := LinearMap.snd K V W
-- Universal property of the product
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : U →ₗ[K]  V × W := LinearMap.prod φ ψ
-- The product map does the expected thing, first component
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : LinearMap.fst K V W ∘ₗ LinearMap.prod φ ψ = φ := rfl
-- The product map does the expected thing, second component
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : LinearMap.snd K V W ∘ₗ LinearMap.prod φ ψ = ψ := rfl
-- parallel combination of two linear maps `φ` and `ψ` into a single linear map from `V × W` to `U × T`
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] T) : (V × W) →ₗ[K] (U × T) := φ.prodMap ψ
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] T) :
  φ.prodMap ψ = (φ ∘ₗ .fst K V W).prod (ψ ∘ₗ .snd K V W) := rfl

/- Inclusion Map -/
-- First inclusion map
example : V →ₗ[K] V × W := LinearMap.inl K V W
-- Second inclusion map
example : W →ₗ[K] V × W := LinearMap.inr K V W
-- Universal property of the sum (aka coproduct)
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] U) : V × W →ₗ[K] U := φ.coprod ψ
-- `LinearMap.coprod_inl` implies operations input `×` and `inl`
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] U) : φ.coprod ψ ∘ₗ LinearMap.inl K V W = φ :=
  LinearMap.coprod_inl φ ψ
-- `LinearMap.coprod_inr` implies operations input `×` and `inr`
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] U) : φ.coprod ψ ∘ₗ LinearMap.inr K V W = ψ :=
  LinearMap.coprod_inr φ ψ

-- An instance of coproduct `φ ∘ ψ (v, w) ↦ φ v + ψ w` of linear maps `φ` and `ψ`
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] U) (v : V) (w : W) :
    φ.coprod ψ (v, w) = φ v + ψ w :=
  rfl

end binary_product

/- Vector Families -/
section families
open DirectSum
/- Definition of family vector space -/
-- `V i` is a family of vector spaces over the same field `K` indexed by type `ι`
variable {ι : Type*} [DecidableEq ι]
         (V : ι → Type*) [∀ i, AddCommGroup (V i)] [∀ i, Module K (V i)]

/- Direct Sum (finite) -/
-- Given a family of linear maps `φ : Π i, (V i →ₗ[K] W)`,
-- we can assemble them into a single linear map from the direct sum `⨁i, V i` to `W`.
-- This is a universal version of coproduct of linear maps, we call it DirectSum `⨁`.
example (φ : Π i, (V i →ₗ[K] W)) : (⨁ i, V i) →ₗ[K] W :=
  DirectSum.toModule K ι W φ
/- Product (inifinite) -/
-- Given a family of linear maps `φ : Π i, (W →ₗ[K] V i)`,
-- we can assemble them into a single linear map from `W` to the product `Π i, V i`.
-- This is a universal version of product of linear maps, we call it Pi `Π`.
example (φ : Π i, (W →ₗ[K] V i)) : W →ₗ[K] (Π i, V i) :=
  LinearMap.pi φ
-- This is a universal version of projection of linear maps, we call it `LinearMap.proj`.
example (i : ι) : (Π j, V j) →ₗ[K] V i := LinearMap.proj i
-- This is a universal version of inclusion of linear maps, we call it `DirectSum.lof`.
example (i : ι) : V i →ₗ[K] (⨁ i, V i) := DirectSum.lof K ι V i
-- The inclusion maps into the infinite product, we call it `LinearMap.single`.
-- i.e. `x ↦ (λ j, if j = i then x else 0)`
example (i : ι) : V i →ₗ[K] (Π i, V i) := LinearMap.single K V i
-- We have a linear map `(Π j, V j) →ₗ[K] (⨁ i, V i)` since `(Π j, V j) →ₗ[K] V i →ₗ[K] (⨁ i, V i)`
-- Moreover, if `ι` is a finite type, then the contrary direction also holds, and we have an isomorphism between the sum and product.
example [Fintype ι] : (⨁ i, V i) ≃ₗ[K] (Π i, V i) :=
  linearEquivFunOnFintype K ι V

end families
