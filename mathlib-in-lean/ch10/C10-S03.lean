import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Eigenspace.Minpoly
import Mathlib.LinearAlgebra.Charpoly.Basic
import MIL.Common

noncomputable section

-- Vector space `V` over the field `K`
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]
-- Another vector space `W` over the field `K`
variable {W : Type*} [AddCommGroup W] [Module K W]
open Polynomial Module LinearMap End

/- Endomorphisms and polynomial evaluations on them -/
-- Multplication of endomorphisms is composition of linear maps, i.e. `* ↔ ∘ₗ`
example (φ ψ : End K V) : φ * ψ = φ ∘ₗ ψ :=
  End.mul_eq_comp φ ψ -- `rfl` would also work
-- Evaluating polynomial `P` on endomorphism `φ`, it is a special kind of evalution, called algrebra `aeval`
-- `φ` is an endomorphism, and polynomial evaluation on it is an endomorphism as well, i.e. `aeval φ P : V →ₗ[K] V`
example (P : K[X]) (φ : End K V) : V →ₗ[K] V :=
  aeval φ P
-- Evaluating simple polynomial `X` on endomorphism `φ` gives back `φ`, `aeval_X` confirms this
example (φ : End K V) : aeval φ (X : K[X]) = φ :=
  aeval_X φ

-- Definition of bottom `⊥`, which is the trivial subspace containing only the zero vector
#check Submodule.eq_bot_iff
-- Definition of intersection of subspaces, `S ⊓ T` is the set of vectors that are in both `S` and `T`
#check Submodule.mem_inf
-- Definition of kernel of a linear map, `ker φ` is the set of vectors that are mapped to zero by `φ`
#check LinearMap.mem_ker

-- Theorem : If `P` and `Q` are coprime polynomials, then the intersection of the kernels of their evaluations on an endomorphism `φ` is trivial.
example (P Q : K[X]) (h : IsCoprime P Q) (φ : End K V) : ker (aeval φ P) ⊓ ker (aeval φ Q) = ⊥ := by
  rw [Submodule.eq_bot_iff]
  rintro x h1
  rw [Submodule.mem_inf, LinearMap.mem_ker, LinearMap.mem_ker] at h1
  rcases h1 with ⟨h2, h3⟩
  rcases h with ⟨a, b, bezout_identy⟩
  -- apply `aeval φ` on the both side of the Bezout identity
  have := congr((aeval φ) $bezout_identy.symm x)
  -- `aeval φ` is an algebra homomorphism `AlgHom` as it maps polynomials to endomorphisms, even though both of them are vector spaces
  -- In lean, it is not treated as a linear map,
  -- but we can still use linearity of `aeval φ` to split the evaluation of the sum of polynomials into the sum of evaluations
  -- The simplest way to do this is to use `simpa [hx]`
  rwa [map_add, map_mul, map_mul, map_one, LinearMap.add_apply, End.mul_apply, End.mul_apply, h2, h3, LinearMap.map_zero, LinearMap.map_zero, add_zero, End.one_apply] at this

-- Definition of of supremum of subspaces, `S ⊔ T` is the set of vectors that can be written as the sum of a vector in `S` and a vector in `T`
#check Submodule.add_mem_sup
-- Definition of polynomial multiplication, `P * Q` is the polynomial obtained by multiplying `P` and `Q`
#check map_mul
-- Definition of multiplication of endomorphisms, `φ * ψ` is the endomorphism obtained by composing `φ` and `ψ`
#check End.mul_apply
-- Definition of the kernel inclusion for composed linear maps, `ker f ≤ ker (g ∘ f)` means that if a vector is mapped to zero by `f`, it is also mapped to zero by `g ∘ f`
#check LinearMap.ker_le_ker_comp

-- Theorem : The sum of the kernels of the evaluations of two polynomials on an endomorphism `φ` is equal to the kernel of the evaluation of their product.
example (P Q : K[X]) (h : IsCoprime P Q) (φ : End K V) :
    ker (aeval φ P) ⊔ ker (aeval φ Q) = ker (aeval φ (P*Q)) := by
  -- `le_antisymm` works for `a = b ↔ a ≤ b ∧ b ≤ a`
  apply le_antisymm
  -- for the case of `ker (aeval φ P) ⊔ ker (aeval φ Q) ≤ ker (aeval φ (P*Q))`
  -- `sup_le` works for `a ⊔ b ≤ c ↔ a ≤ c ∧ b ≤ c`
  · apply sup_le
    -- for the case of `ker (aeval φ P) ≤ ker (aeval φ (P*Q))`
    -- since `aeval φ` is a `AlgHom`, it preserves multiplication, i.e. `aeval φ (P*Q) = aeval φ P * aeval φ Q`
    · rw [mul_comm, map_mul]
      -- `LinearMap.ker_le_ker_comp` works for `ker ((aeval φ) P) ≤ ker ((aeval φ) Q * (aeval φ) P)`
      apply LinearMap.ker_le_ker_comp
    -- for the case of `ker (aeval φ Q) ≤ ker (aeval φ (P*Q))`
    · rw [map_mul]
      apply LinearMap.ker_le_ker_comp
  -- for the case of `ker (aeval φ (P*Q)) ≤ ker (aeval φ P) ⊔ ker (aeval φ Q)`
  · rintro x h1
    -- destruct `IsCoprime P Q` with Bezout identity, i.e., find polynomials `U` and `W` such that `U*P + W*Q = 1`
    rcases h with ⟨U, W, h2⟩
    have key : x = aeval φ (U*P) x + aeval φ (W*Q) x := by simpa using congr((aeval φ) $h2.symm x)
    rw [key, add_comm]
    apply Submodule.add_mem_sup <;> rw [mem_ker] at *
    -- `aeval φ ⨯` is type of `End K V`, so `← End.mul_apply` reduce `((aeval φ) P) (((aeval φ) (W * Q)) x)` to `((aeval φ) P ∘ (aeval φ) (W * Q)) x`
    -- `aeval φ` is type of `AlgHom`, so `← map_mul` reduce `((aeval φ) P ∘ (aeval φ) (W * Q)) x` to `(aeval φ)(P * (W * Q)) x`
    -- `P, W, Q` are polynomial rings, so `ring` reduce `P*(W*Q) = W*(P*Q)`
    · rw [← End.mul_apply, ← map_mul, show P*(W*Q) = W*(P*Q) by ring, map_mul, End.mul_apply, h1,
          map_zero]
    · rw [← End.mul_apply, ← map_mul, show Q*(U*P) = U*(P*Q) by ring, map_mul, mul_apply, h1,
          map_zero]
