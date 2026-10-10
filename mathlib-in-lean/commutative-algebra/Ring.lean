import Mathlib.RingTheory.Ideal.Maximal
import Mathlib.RingTheory.Ideal.Operations
import Mathlib.RingTheory.Nilpotent.Lemmas
import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.RingTheory.IntegralDomain
import Mathlib.Order.Zorn
import Mathlib.RingTheory.Ideal.IsPrimary
import Mathlib.RingTheory.Ideal.Quotient.Operations
import Mathlib.RingTheory.Ideal.Quotient.Nilpotent

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

/-! ## Properties of the Radical -/

theorem radical_mono' (I J : Ideal A) (h : I ≤ J) : I.radical ≤ J.radical := by
  rintro x ⟨n, hn⟩
  exact ⟨n, h hn⟩

theorem le_radical_and_idem (I : Ideal A) :
    I ≤ I.radical ∧ I.radical.radical = I.radical := by
  have hle : I ≤ I.radical := fun x hx => ⟨1, by simpa using hx⟩
  refine ⟨hle, le_antisymm ?_ Ideal.le_radical⟩
  rintro x ⟨n, m, h⟩
  exact ⟨n * m, by simpa only [pow_mul] using h⟩

theorem radical_mul_inf (I J : Ideal A) :
    (I * J).radical = (I ⊓ J).radical ∧
      (I ⊓ J).radical = I.radical ⊓ J.radical := by
  have hi : (I ⊓ J).radical = I.radical ⊓ J.radical := by
    apply le_antisymm
    · exact le_inf (radical_mono' _ _ inf_le_left) (radical_mono' _ _ inf_le_right)
    · rintro x ⟨⟨m, hm⟩, ⟨n, hn⟩⟩
      refine ⟨m + n, ?_⟩
      rw [pow_add]
      exact ⟨I.mul_mem_right _ hm, J.mul_mem_left _ hn⟩
  refine ⟨le_antisymm (radical_mono' _ _ Ideal.mul_le_inf) ?_, hi⟩
  rintro x ⟨n, hn⟩
  refine ⟨n + n, ?_⟩
  rw [pow_add]
  exact Ideal.mul_mem_mul hn.1 hn.2

theorem radical_pow_positive (I : Ideal A) (n : ℕ) (hn : n ≠ 0) :
    (I ^ n).radical = I.radical := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hn
  induction k with
  | zero => simp
  | succ k ih =>
    rw [pow_succ, (radical_mul_inf _ _).1, (radical_mul_inf _ _).2,
      ih (Nat.succ_ne_zero k), inf_idem]

theorem radical_sup' (I J : Ideal A) :
    (I ⊔ J).radical = (I.radical ⊔ J.radical).radical := by
  apply le_antisymm
  · exact radical_mono' _ _ (sup_le_sup Ideal.le_radical Ideal.le_radical)
  · have h : I.radical ⊔ J.radical ≤ (I ⊔ J).radical :=
      sup_le (radical_mono' _ _ le_sup_left) (radical_mono' _ _ le_sup_right)
    exact (radical_mono' _ _ h).trans_eq (le_radical_and_idem _).2

theorem radical_sup_mul (I J H : Ideal A) :
    (I ⊔ J * H).radical = (I ⊔ J).radical ⊓ (I ⊔ H).radical := by
  apply le_antisymm
  · exact le_inf
      (radical_mono' _ _ (sup_le_sup_left ((mul_le_inf' J H).trans inf_le_left) I))
      (radical_mono' _ _ (sup_le_sup_left ((mul_le_inf' J H).trans inf_le_right) I))
  · rintro x ⟨⟨m, hm⟩, ⟨n, hn⟩⟩
    refine ⟨m + n, ?_⟩
    rw [pow_add]
    obtain ⟨a, ha, b, hb, hab⟩ := Submodule.mem_sup.mp hm
    obtain ⟨c, hc, d, hd, hcd⟩ := Submodule.mem_sup.mp hn
    rw [← hab, ← hcd]
    have hi : a * c + a * d + b * c ∈ I :=
      I.add_mem (I.add_mem (I.mul_mem_right _ ha) (I.mul_mem_right _ ha))
        (I.mul_mem_left _ hc)
    have hj : b * d ∈ J * H := Ideal.mul_mem_mul hb hd
    have he : (a + b) * (c + d) = (a * c + a * d + b * c) + b * d := by ring
    rw [he]
    exact (I ⊔ J * H).add_mem
      ((show I ≤ I ⊔ J * H from le_sup_left) hi)
      ((show J * H ≤ I ⊔ J * H from le_sup_right) hj)

/-! ## Facts on Special Ideals -/

theorem primary_radical_prime (I : Ideal A) (hI : I.IsPrimary) : I.radical.IsPrime := by
  refine ⟨?_, ?_⟩
  · exact fun h => (Ideal.isPrimary_iff.mp hI).1 (Ideal.radical_eq_top.mp h)
  · intro a b hab
    obtain ⟨n, hn⟩ := hab
    rw [mul_pow] at hn
    rcases (Ideal.isPrimary_iff.mp hI).2 hn with ha | hb
    · exact Or.inl ⟨n, ha⟩
    · exact Or.inr (Ideal.mem_radical_of_pow_mem hb)

theorem maximal_quotient_field (I : Ideal A) (hI : I.IsMaximal) : IsField (A ⧸ I) := by
  letI := hI
  letI := Ideal.Quotient.field I
  exact Field.toIsField _

theorem primary_of_maximal_radical (I : Ideal A) (h : I.radical.IsMaximal) :
    I.IsPrimary := by
  -- Mathlib packages the maximal-ideal argument, avoiding a binomial expansion.
  exact Ideal.isPrimary_of_isMaximal_radical h

/-! ## Quotient Rings and Homomorphisms -/

theorem quotient_operations_well_defined (I : Ideal A) (x x' y y' : A)
    (hx : Ideal.Quotient.mk I x = Ideal.Quotient.mk I x')
    (hy : Ideal.Quotient.mk I y = Ideal.Quotient.mk I y') :
    Ideal.Quotient.mk I (x + y) = Ideal.Quotient.mk I (x' + y') ∧
      Ideal.Quotient.mk I (x * y) = Ideal.Quotient.mk I (x' * y') := by
  have hxi := Ideal.Quotient.eq.mp hx
  have hyi := Ideal.Quotient.eq.mp hy
  constructor
  · apply Ideal.Quotient.eq.mpr
    have he : (x + y) - (x' + y') = (x - x') + (y - y') := by ring
    rw [he]
    exact I.add_mem hxi hyi
  · apply Ideal.Quotient.eq.mpr
    have he : x * y - x' * y' = (x - x') * y + x' * (y - y') := by ring
    rw [he]
    exact I.add_mem (I.mul_mem_right _ hxi) (I.mul_mem_left _ hyi)

def inducedHom {B : Type*} [CommRing B] (I : Ideal A) (f : A →+* B)
    (h : I ≤ RingHom.ker f) : A ⧸ I →+* B :=
  Ideal.Quotient.lift I f (fun _ ha => h ha)

theorem inducedHom_factorization {B : Type*} [CommRing B] (I : Ideal A)
    (f : A →+* B) (h : I ≤ RingHom.ker f) :
    (inducedHom I f h).comp (Ideal.Quotient.mk I) = f := by
  ext a
  exact Ideal.Quotient.lift_mk I f (fun _ ha => h ha)

noncomputable def firstIsomorphism {B : Type*} [CommRing B] (f : A →+* B) :
    A ⧸ RingHom.ker f ≃+* f.range :=
  RingHom.quotientKerEquivRange f

def secondIsomorphism (I J : Ideal A) (h : I ≤ J) :
    (A ⧸ I) ⧸ J.map (Ideal.Quotient.mk I) ≃+* A ⧸ J :=
  DoubleQuot.quotQuotEquivQuotOfLE h

noncomputable def subringQuotientImage (I : Ideal A) (B : Subring A) :
    B ⧸ I.comap B.subtype ≃+* ((Ideal.Quotient.mk I).comp B.subtype).range := by
  let f := (Ideal.Quotient.mk I).comp B.subtype
  have hk : RingHom.ker f = I.comap B.subtype := by
    ext b
    exact Ideal.Quotient.eq_zero_iff_mem
  exact (Ideal.quotEquivOfEq hk.symm).trans (RingHom.quotientKerEquivRange f)

-- The preimage of the image of B under A → A/I is precisely B + I.
def subringAddIdeal (I : Ideal A) (B : Subring A) : Subring A :=
  ((Ideal.Quotient.mk I).comp B.subtype).range.comap (Ideal.Quotient.mk I)

theorem mem_subringAddIdeal (I : Ideal A) (B : Subring A) (a : A) :
    a ∈ subringAddIdeal I B ↔ ∃ b ∈ B, ∃ i ∈ I, a = b + i := by
  change (∃ b : B, Ideal.Quotient.mk I (b : A) = Ideal.Quotient.mk I a) ↔ _
  constructor
  · rintro ⟨b, hb⟩
    refine ⟨b, b.property, a - b, Ideal.Quotient.eq.mp hb.symm, ?_⟩
    ring
  · rintro ⟨b, hb, i, hi, rfl⟩
    refine ⟨⟨b, hb⟩, ?_⟩
    rw [map_add, Ideal.Quotient.eq_zero_iff_mem.mpr hi, add_zero]

def subringAddIdealProjection (I : Ideal A) (B : Subring A) :
    subringAddIdeal I B →+* ((Ideal.Quotient.mk I).comp B.subtype).range where
  toFun a := ⟨Ideal.Quotient.mk I a, a.property⟩
  map_zero' := Subtype.ext (map_zero _)
  map_one' := Subtype.ext (map_one _)
  map_add' a b := Subtype.ext (map_add (Ideal.Quotient.mk I) (a : A) (b : A))
  map_mul' a b := Subtype.ext (map_mul (Ideal.Quotient.mk I) (a : A) (b : A))

noncomputable def thirdIsomorphism (I : Ideal A) (B : Subring A) :
    B ⧸ I.comap B.subtype ≃+*
      (subringAddIdeal I B) ⧸ I.comap (subringAddIdeal I B).subtype := by
  let g := subringAddIdealProjection I B
  have hg : Function.Surjective g := by
    rintro ⟨x, b, rfl⟩
    refine ⟨⟨b, ?_⟩, rfl⟩
    exact ⟨b, rfl⟩
  have hk : RingHom.ker g = I.comap (subringAddIdeal I B).subtype := by
    ext a
    change (⟨Ideal.Quotient.mk I a, a.property⟩ :
      ((Ideal.Quotient.mk I).comp B.subtype).range) = 0 ↔ (a : A) ∈ I
    rw [Subtype.ext_iff]
    exact Ideal.Quotient.eq_zero_iff_mem
  let e := (Ideal.quotEquivOfEq hk.symm).trans
    (RingHom.quotientKerEquivOfSurjective hg)
  exact (subringQuotientImage I B).trans e.symm

/-! ## Special Ideals and Quotient Rings -/

theorem proper_iff_nontrivial_quotient (I : Ideal A) :
    I ≠ ⊤ ↔ Nontrivial (A ⧸ I) :=
  Ideal.Quotient.nontrivial_iff.symm

theorem maximal_iff_field_quotient (I : Ideal A) :
    I.IsMaximal ↔ IsField (A ⧸ I) :=
  Ideal.Quotient.maximal_ideal_iff_isField_quotient I

theorem prime_iff_domain_quotient (I : Ideal A) :
    I.IsPrime ↔ IsDomain (A ⧸ I) :=
  (Ideal.Quotient.isDomain_iff_prime I).symm

theorem radical_iff_reduced_quotient (I : Ideal A) :
    I.IsRadical ↔ IsReduced (A ⧸ I) :=
  Ideal.isRadical_iff_quotient_reduced I

theorem nilpotent_mk_iff (I : Ideal A) (a : A) :
    IsNilpotent (Ideal.Quotient.mk I a) ↔ a ∈ I.radical := by
  simp only [IsNilpotent, Ideal.mem_radical_iff, ← map_pow,
    Ideal.Quotient.eq_zero_iff_mem]

theorem primary_iff_quotient_zeroDivisors (I : Ideal A) (hI : I ≠ ⊤) :
    I.IsPrimary ↔ ∀ x : A ⧸ I, IsNilpotent x ↔ IsZeroDivisor x := by
  letI : Nontrivial (A ⧸ I) := Ideal.Quotient.nontrivial_iff.mpr hI
  constructor
  · intro hp x
    constructor
    · exact isZeroDivisor_of_isNilpotent
    · rintro ⟨y, hy, hxy⟩
      obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective x
      obtain ⟨b, rfl⟩ := Ideal.Quotient.mk_surjective y
      have hba : b * a ∈ I := Ideal.Quotient.eq_zero_iff_mem.mp (by
        rw [map_mul, mul_comm]
        exact hxy)
      rcases (Ideal.isPrimary_iff.mp hp).2 hba with hb | ha
      · exact False.elim (hy (Ideal.Quotient.eq_zero_iff_mem.mpr hb))
      · exact (nilpotent_mk_iff I a).mpr ha
  · intro h
    refine Ideal.isPrimary_iff.mpr ⟨hI, ?_⟩
    intro a b hab
    by_cases ha : a ∈ I
    · exact Or.inl ha
    · right
      apply (nilpotent_mk_iff I b).mp
      apply (h _).mpr
      refine ⟨Ideal.Quotient.mk I a, ?_, ?_⟩
      · exact fun hz => ha (Ideal.Quotient.eq_zero_iff_mem.mp hz)
      · rw [← map_mul, mul_comm]
        exact Ideal.Quotient.eq_zero_iff_mem.mpr hab

theorem maximal_prime (I : Ideal A) (h : I.IsMaximal) : I.IsPrime :=
  h.isPrime

theorem prime_radical (I : Ideal A) (h : I.IsPrime) : I.IsRadical := by
  rintro x ⟨n, hn⟩
  exact h.mem_of_pow_mem n hn

theorem prime_primary (I : Ideal A) (h : I.IsPrime) : I.IsPrimary := by
  refine Ideal.isPrimary_iff.mpr ⟨h.ne_top, ?_⟩
  intro a b hab
  exact (h.mem_or_mem hab).imp id (fun hb => Ideal.le_radical hb)

end CommAlg
