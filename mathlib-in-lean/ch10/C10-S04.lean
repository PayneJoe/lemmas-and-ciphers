import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Eigenspace.Minpoly
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.LinearAlgebra.Complex.FiniteDimensional
import MIL.Common

-- Vector space `V`
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]
section BasisProperties
open Module

-- 1. `B` is a basis of vector space `V` indexed by `ι` over the field `K`
-- 2. `v` is a vector in `V`
-- 3. `i` is an index of type `ι`
variable {ι : Type*} (B : Basis ι K V) (v : V) (i : ι)
-- The basis vector with index ``i``
#check (B i : V)
-- There is a linear isomorphism between `V` and the space of finitely supported functions `ι →₀ K` induced by the basis `B`.
-- Every vector in `V` has a unique coordinate representated as a finitely supported function `ι →₀ K` via the basis `B`.
#check (B.repr : V ≃ₗ[K] ι →₀ K)
-- The coordinate of vector `v` with respect to the basis `B`
#check (B.repr v : ι →₀ K)
-- The `i`-th entry of the coordinate of vector `v` with respect to the basis `B`
#check (B.repr v i : K)

/- Construction of basis -/
-- Given a linearly independent family of vectors `b`, and a proof that it spans `V`, we can construct a basis from it.
noncomputable example (b : ι → V) (b_indep : LinearIndependent K b)
    (b_spans : ∀ v, v ∈ Submodule.span K (Set.range b)) : Basis ι K V :=
  -- Basis has two conditions:
  -- a. The family of vectors `b` is linearly independent.
  -- b. The family of vectors `b` spans the vector space `V`.
  Basis.mk b_indep (fun v _ ↦ b_spans v)
-- obtain the `i`-th basis vector from the constructed basis
example (b : ι → V) (b_indep : LinearIndependent K b)
    (b_spans : ∀ v, v ∈ Submodule.span K (Set.range b)) (i : ι) :
    Basis.mk b_indep (fun v _ ↦ b_spans v) i = b i :=
  Basis.mk_apply b_indep (fun v _ ↦ b_spans v) i

-- `DecidableEq` is necessary as we need it to decide equality of indices.
variable [DecidableEq ι]
example : Finsupp.basisSingleOne.repr = LinearEquiv.refl K (ι →₀ K) :=
  rfl
example (i : ι) : Finsupp.basisSingleOne i = Finsupp.single i 1 :=
  rfl
example [Finite ι] (x : ι → K) (i : ι) : (Pi.basisFun K ι).repr x i = x i := by
  simp

-- The vector `v` can be expressed as a linear combination of the basis vectors `B i` with coefficients given by the coordinates `B.repr v i`.
example [Fintype ι] : ∑ i : ι, B.repr v i • (B i) = v :=
  B.sum_repr v

/- Linear Combination -/
/- Linear combination with general vectors -/
-- The linear combination of the basis vectors `f i` with coefficients `c i` over the support of `c` can be expressed as a sum over any finite set `s` containing the support of `c`.
-- It is okay that finset `s` could be larger than the support of `c`, as the extra terms will have zero coefficients.
example (c : ι →₀ K) (f : ι → V) (s : Finset ι) (h : c.support ⊆ s) :
    Finsupp.linearCombination K f c = ∑ i ∈ s, c i • f i :=
  Finsupp.linearCombination_apply_of_mem_supported K h
/- Linear combination with basis -/
example : Finsupp.linearCombination K B (B.repr v) = v :=
  B.linearCombination_repr v

variable (f : ι → V) in
-- The linear combination of general vectors is a linear map of type `(ι →₀ K) →ₗ[K] V`
#check (Finsupp.linearCombination K f : (ι →₀ K) →ₗ[K] V)

section

/- Linear maps constructed from a basis -/
-- It means we can construct a linear map from `V` to `W` by specifying its action on the basis vectors `B i` in `V`.
-- Consider another vector space `W`, linear map `φ` from `V` to `W`, and a family of vectors `u` in `W`.
variable {W : Type*} [AddCommGroup W] [Module K W]
         (φ : V →ₗ[K] W) (u : ι → W)
-- There is a linear equivalence between the space of functions from the index set to `W` and the space of linear maps from `V` to `W` induced by the basis `B`.
-- In other words, given a basis `B` of vector space `V` :
-- a) once we specify the images `u` of the basis vectors `B` under a linear map, then the linear map is completely determined.
-- b) conversely, once the linear map is specified on the basis vectors `B`, the images `u` are determined.
#check (B.constr K : (ι → W) ≃ₗ[K] (V →ₗ[K] W))
#check (B.constr K u : V →ₗ[K] W)
-- The action of the linear map constructed from basis `B` of `V` and the family `u` in `W` on the basis vector `B i` retrieves the corresponding vector `u i`.
example (i : ι) : B.constr K u (B i) = u i :=
  B.constr_basis K u i
-- If two linear maps from `V` to `W` agree on all basis vectors `B i`, then they are equal.
example (φ ψ : V →ₗ[K] W) (h : ∀ i, φ (B i) = ψ (B i)) : φ = ψ :=
  B.ext h

/- Matrices representing linear maps with respect to different bases -/
-- The matrix representing a linear map is determined by threee things:
-- a) the choice of basis `B` for `V`, once basis `B` is fixed, then vector space `V` is fixed
-- b) the choice of basis `B'` for `W`, once basis `B'` is fixed, then vector space `W` is fixed
-- c) the action of linear map on the basis vectors `B` of `V`
-- Note that basis vectors `B` in `V` does not has to be mapped to the basis vectors `B'` in `W`, they can be mapped to any corresponding vectors in `W`.
-- Different actions of the linear map means different images, and different matrices representing the linear map with respect to basis `B`.
-- Moreover, even basis `B` is mapped to `B'`, this map do not have to be (one-to-one) bijective since the size (`ι` and `ι'`) of these two bases may differ.

-- Consider another basis `B'` of `W` indexed by `ι'`, the size of basis `B'` is `ι'` which might be different from the size of basis `B` of `V`.
variable {ι' : Type*} (B' : Basis ι' K W) [Fintype ι] [DecidableEq ι] [Fintype ι'] [DecidableEq ι']
open LinearMap
-- The linear map `φ` from `V` to `W` can be represented as a matrix with respect to the bases `B` and `B'`.
-- In other words, given basis `B` of source vector space `V`, basis `B'` of destination vector space `W`,
-- a) if the linear map `V →ₗ[K] W` between these two vector spaces, then the matrix `Matrix ι' ι K` representing the linear map with respect to these bases is determined.
-- b) conversely, if the matrix `Matrix ι' ι K` representing the linear map with respect to these bases is given, then the linear map `V →ₗ[K] W` is determined.
#check (toMatrix B B' : (V →ₗ[K] W) ≃ₗ[K] Matrix ι' ι K)
open Matrix -- get access to the ``*ᵥ`` notation for multiplication between matrices and vectors.

-- The action of the matrix representing `φ` on the coordinate vector of `v` with respect to `B` gives the coordinate vector of `φ v` with respect to `B'`.
-- That is the coordinate vector of `v` in `V` multiplied by the matrix representing `φ` gives the coordinate vector of `φ v` in `W`.
example (φ : V →ₗ[K] W) (v : V) : (toMatrix B B' φ) *ᵥ (B.repr v) = B'.repr (φ v) :=
  toMatrix_mulVec_repr B B' φ v

/- Change of basis for matrices representing linear maps -/
-- Consider another basis `B''` of `W` indexed by `ι''`, actually `ι''` should be equal with `ι'` since they both index bases of the same vector space `W`.
variable {ι'' : Type*} (B'' : Basis ι'' K W) [Fintype ι''] [DecidableEq ι'']
-- The matrix representing `φ` with respect to the bases `B` and `B''` can be obtained by multiplying the matrix representing the identity map from `B'` to `B''` with the matrix representing `φ` from `B` to `B'`.
-- The identity map means the linear map from `W` to `W` that sends each vector to itself.
example (φ : V →ₗ[K] W) : (toMatrix B B'' φ) = (toMatrix B' B'' .id) * (toMatrix B B' φ) := by
  simp

end


open Module LinearMap Matrix

-- if `toMatrix v₂ v₃ f` represents a linear map `V₂ →ₗ[K] V₃`, and `toMatrix v₁ v₂ g` represents a linear map `V₁ →ₗ[K] V₂`,
-- then `toMatrix v₁ v₃ (f.comp g)` is the product of the two matrices.
#check toMatrix_comp
-- Identity map composed with any linear map `f` gives `f` itself.
#check id_comp
-- Composition of any linear map `f` with the identity map gives `f` itself.
#check comp_id
-- Identity linear map represented as a matrix with respect to a basis.
#check toMatrix_id
-- Determinant of the product of two matrices is the product of their determinants.
#check Matrix.det_mul
-- Determinant of the identity matrix is one.
#check Matrix.det_one

-- if both `B` and `B'` are bases of `V`, `φ` is an endomorphism of `V`, then
-- the determinant of the matrix representing `φ` is independent of the choice of basis
-- two aspects are considered here :
-- 1) the matrix representing a linear map (endomorphism) is independent of the choice of target basis.
-- 2) once source and destination bases are fixed, then the matrix representing a linear map is uniquely determined by the map action itself
-- That is to say, `toMatrix B B φ` is determined by `φ`, not relevent with `B` or `B'`
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

end BasisProperties

/- Finite Rank of Vector Spaces -/
section FiniteRankOfVectorSpaces

-- finite rank of vector space `V`
#check (Module.finrank K V : ℕ)

-- `Fin n → K` is the archetypical space with dimension `n` over `K`.
example (n : ℕ) : Module.finrank K (Fin n → K) = n :=
  Module.finrank_fin_fun K

-- Different scalar `Field K` results different dimensions even though the underlying object `AddCommGroup M` (set) is the same.
-- So we consider the dimension of a vector space, pay atention to the underlying scalar field.
-- Seen as a vector space over itself `ℂ`, `ℂ` has dimension one.
example : Module.finrank ℂ ℂ = 1 :=
  Module.finrank_self ℂ
-- But as a vector space over `ℝ` it has dimension two.
example : Module.finrank ℝ ℂ = 2 :=
  Complex.finrank_real_complex

-- Assume vector space `V` is finite-dimensional (dimension is finite), then its rank (dimension) is positive if and only if `V` is nontrivial.
example [FiniteDimensional K V] : 0 < Module.finrank K V ↔ Nontrivial V  :=
  Module.finrank_pos_iff
example [FiniteDimensional K V] (h : 0 < Module.finrank K V) : Nontrivial V := by
  apply (Module.finrank_pos_iff (R := K)).1
  exact h

variable {ι : Type*} (B : Module.Basis ι K V)
-- The basis `B` provides a way to relate the finiteness of the index set `ι` to the finite-dimensionality of the vector space `V`.
example [Finite ι] : FiniteDimensional K V := Module.Basis.finiteDimensional_of_finite B
example [FiniteDimensional K V] : Finite ι :=
  (FiniteDimensional.fintypeBasisIndex B).finite

end FiniteRankOfVectorSpaces

/- Finite Rank of Submodules -/
section FiniteRankOfSubspaces
variable (E F : Submodule K V) [FiniteDimensional K V]

open Module
-- Theorem : The rank of the supremum of two submodules plus the rank of their infimum equals the sum of their ranks.
example : finrank K (E ⊔ F : Submodule K V) + finrank K (E ⊓ F : Submodule K V) =
    finrank K E + finrank K F :=
  Submodule.finrank_sup_add_finrank_inf_eq E F
-- The rank of a submodule is less than or equal to the rank of the whole space.
example : finrank K E ≤ finrank K V := Submodule.finrank_le E
-- If the sum of the ranks of two submodules exceeds the rank of the whole space, then their intersection is nontrivial.
example (h : finrank K V < finrank K E + finrank K F) :
    Nontrivial (E ⊓ F : Submodule K V) := by
  rw [← Module.finrank_pos_iff (R := K)]
  rw [← Submodule.finrank_sup_add_finrank_inf_eq E F] at h
  have : finrank K (E ⊔ F : Submodule K V) ≤ finrank K V := Submodule.finrank_le (E ⊔ F : Submodule K V)
  linarith
end FiniteRankOfSubspaces
