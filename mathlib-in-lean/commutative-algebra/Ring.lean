import Mathlib.RingTheory.Ideal.Maximal
import Mathlib.RingTheory.Ideal.Operations
import Mathlib.RingTheory.Nilpotent.Lemmas
import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.RingTheory.IntegralDomain
import Mathlib.Order.Zorn

import MIL.Common

/-!
# Rings and Ideals

Lean 4 companion to `docs/mathematics/commutative-algebra/ring.md`.

Each fact is proved by following the written proof step by step, and is then
cross-checked against the corresponding Mathlib lemma.
All rings are commutative with identity.
-/

namespace CommAlg

variable {A : Type*} [CommRing A]

/-! ## Special Elements of Ring -/

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

/-! ## Domain VS Field -/

/- Fact 3: a finite integral domain is a field. -/
theorem isField_of_finite_domain [IsDomain A] [Finite A] : IsField A := by
  refine ⟨exists_pair_ne A, mul_comm, ?_⟩
  intro x hx
  -- no zero divisors ⇒ `y ↦ x * y` is injective, hence surjective
  have hinj : Function.Injective (fun y : A => x * y) :=
    fun y₁ y₂ h => mul_left_cancel₀ hx h
  exact Finite.injective_iff_surjective.mp hinj 1

example [IsDomain A] [Finite A] : IsField A := Finite.isField_of_domain A

/-! ## Facts on Ideals -/

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

/-! ## Facts on Maximal Ideal -/

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

/-! ## Facts on Ideal Operations -/

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

/- Fact 4: the nilpotent elements form the ideal `√⟨0⟩`. -/
theorem isNilpotent_iff_mem_radical_bot (a : A) : IsNilpotent a ↔ a ∈ radical ⊥ := by
  show (∃ n : ℕ, a ^ n = 0) ↔ ∃ n : ℕ, a ^ n ∈ (⊥ : Ideal A)
  simp only [Ideal.mem_bot]

example (a : A) : a ∈ nilradical A ↔ IsNilpotent a := mem_nilradical

/- Fact 5: the zero divisors need not form an ideal.
In `ℤ/6ℤ`, `2` and `3` are zero divisors (`2 * 3 = 0`), but `2 + 3 = 5` is a unit. -/
theorem zeroDivisors_not_ideal :
    ¬ ∃ I : Ideal (ZMod 6), ∀ a, a ∈ I ↔ IsZeroDivisor a := by
  rintro ⟨I, hI⟩
  have h2 : (2 : ZMod 6) ∈ I := (hI 2).mpr ⟨3, by decide, by decide⟩
  have h3 : (3 : ZMod 6) ∈ I := (hI 3).mpr ⟨2, by decide, by decide⟩
  have h5 : IsUnit (2 + 3 : ZMod 6) := IsUnit.of_mul_eq_one 5 (by decide)
  exact not_isZeroDivisor_of_isUnit h5 ((hI _).mp (I.add_mem h2 h3))

/- Fact 6: `I J ⊆ I ∩ J`. -/
theorem mul_le_inf' (I J : Ideal A) : I * J ≤ I ⊓ J := by
  -- it suffices to check the generators `a * b` with `a ∈ I`, `b ∈ J`
  rw [Ideal.mul_le]
  intro a ha b hb
  exact Submodule.mem_inf.mpr ⟨I.mul_mem_right b ha, J.mul_mem_left a hb⟩

example (I J : Ideal A) : I * J ≤ I ⊓ J := Ideal.mul_le_inf

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

end CommAlg
