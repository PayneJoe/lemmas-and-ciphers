## Table of Contents
- [C10 S01 — Linear Algebra: Summary Notes](#c10-s01--linear-algebra-summary-notes)
  - [Vector Spaces as Modules](#vector-spaces-as-modules)
    - [Distribution property](#distribution-property)
    - [Commutativity property](#commutativity-property)
    - [Module over ideals/submodules](#module-over-idealssubmodules)
    - [Module over Ring vs. Semiring](#module-over-ring-vs-semiring)
  - [Linear Maps](#linear-maps)
    - [Linear maps form a vector space](#linear-maps-form-a-vector-space)
    - [Composition](#composition)
    - [Constructing a linear map from scratch](#constructing-a-linear-map-from-scratch)
    - [Internal vs. user-facing lemmas](#internal-vs-user-facing-lemmas)
    - [`lsmul`](#lsmul)
  - [Linear Equivalence](#linear-equivalence)
  - [Binary Products](#binary-products)
    - [Projection maps](#projection-maps)
    - [Universal property of the product](#universal-property-of-the-product)
    - [Parallel combination (`prodMap`)](#parallel-combination-prodmap)
    - [Inclusion maps](#inclusion-maps)
    - [Universal property of the sum (coproduct)](#universal-property-of-the-sum-coproduct)
  - [Vector Families (`DirectSum`)](#vector-families-directsum)
    - [Direct sum (finite support)](#direct-sum-finite-support)
    - [Product (infinite support)](#product-infinite-support)
    - [Projection, inclusion, and single](#projection-inclusion-and-single)
    - [Sum vs. product](#sum-vs-product)

# C10 S01 — Linear Algebra: Summary Notes

Summary generated from the comments in `C10-S01.lean`.

## Vector Spaces as Modules

A vector space `V` over a field `K` is a special case of a module, instantiated as `Module K V`:

```lean
variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]
```

| Class in `Module` | Instantiated by (vector space) |
| --- | --- |
| `AddCommMonoid` (the object) | `AddCommGroup V` |
| `Semiring` (the scalars) | `Field K` |

> [!NOTE]
> `Semiring` is a `Ring` without the inverse property for `+` in `AddCommMonoid`. Upgrading the scalars from `Semiring` to `Field` and the object from `AddCommMonoid` to `AddCommGroup` is exactly what turns a module into a vector space.

### Distribution property

Scalar multiplication `•` distributes over `+` on both sides — the operator `•` defined in `Module` describes the interaction between the `AddCommMonoid` object and the `Semiring` scalars:

| Lemma | Statement |
| --- | --- |
| `smul_add` | `a • (u + v) = a • u + a • v` |
| `add_smul` | `(a + b) • u = a • u + b • u` |

### Commutativity property

Since `Field` is commutative, scalar multiplication is commutative in the scalars:

- `smul_comm`: `a • b • u = b • a • u`

### Module over ideals/submodules

The following somewhat surprising instance holds:

```lean
example {R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M] :
    Module (Ideal R) (Submodule R M) :=
  inferInstance
```

`Module (Ideal R) (Submodule R M)` holds because:
1. `Submodule R M` is itself a `Module`, instantiating the `AddCommMonoid` that `Module` extends.
2. `Ideal R` is a `CommSemiring`, instantiating the scalar `Semiring` (since `CommSemiring` extends `Semiring`).

### Module over Ring vs. Semiring

| Scalars | Object required | Why |
| --- | --- | --- |
| `Ring R` | `AddCommGroup M` | the object of a `Ring` is an `AddCommGroup` |
| `Semiring R` | `AddCommMonoid M` | the object of a `Semiring` is an `AddCommMonoid` |

Over a `Ring` the module automatically has additive inverses; over a `Semiring` it does not.

## Linear Maps

Let `W` be another vector space over the same field `K`. A linear map `φ : V →ₗ[K] W` satisfies two properties:

| Property | Lemma | Statement |
| --- | --- | --- |
| Homogeneity | `map_smul` | `φ (a • v) = a • φ v` |
| Additivity | `map_add` | `φ (v + w) = φ v + φ w` |

### Linear maps form a vector space

`V →ₗ[K] W` is itself a vector space, satisfying:
1. `0 ∈ V →ₗ[K] W` — the zero map sending everything in `V` to `0` in `W`.
2. `∀ x y ∈ V →ₗ[K] W, x + y ∈ V →ₗ[K] W` — addition closure.
3. `∀ a ∈ K, x ∈ V →ₗ[K] W, a • x ∈ V →ₗ[K] W` — scalar multiplication closure.

For example, linear combinations of linear maps are linear maps:

```lean
#check (2 • φ + ψ : V →ₗ[K] W)
```

### Composition

`∘ₗ` composes linear maps into another linear map. The two spellings are equivalent:

```lean
variable (θ : W →ₗ[K] V)
#check (φ.comp θ : W →ₗ[K] W)
#check (φ ∘ₗ θ : W →ₗ[K] W)
```

### Constructing a linear map from scratch

Example: the homothety `toFun v := 3 • v` as a term of `V →ₗ[K] V`:

```lean
example : V →ₗ[K] V where
  toFun v := 3 • v
  map_add' _ _ := smul_add ..
  map_smul' _ _ := smul_comm ..
```

The two proof obligations are:
- `map_add'`: `toFun (a + b) = toFun a + toFun b`, i.e. `3 • (a + b) = 3 • a + 3 • b`, proved by `smul_add ..`.
- `map_smul'`: `toFun (a • b) = a • toFun b`, i.e. `3 • (a • b) = a • (3 • b)`, proved by `smul_comm ..`.

### Internal vs. user-facing lemmas

| Lemma | Kind | Statement |
| --- | --- | --- |
| `φ.map_add'` | internal proposition | `∀ x y : V, φ.toFun (x + y) = φ.toFun x + φ.toFun y` |
| `φ.map_add` | derived, user-facing | `∀ x y : V, φ (x + y) = φ x + φ y` |

`map_add φ` is the same as `φ.map_add` — dot notation and first-argument application coincide.

### `lsmul`

`LinearMap.lsmul K V : K →ₗ[K] V →ₗ[K] V` turns scalar multiplication into a bilinear map; partially applied, `LinearMap.lsmul K V 3 : V →ₗ[K] V` is the homothety `v ↦ 3 • v`.

```lean
#check (LinearMap.lsmul K V : K →ₗ[K] V →ₗ[K] V)
#check (LinearMap.lsmul K V 3 : V →ₗ[K] V)
```

## Linear Equivalence

A **linear equivalence** `f : V ≃ₗ[K] W` is a bijective linear map bundled with its (also linear) inverse.

- Composing with the inverse gives the identity:
  $$f \circ f^{-1} = \mathrm{id}$$
  ```lean
  example (f : V ≃ₗ[K] W) : f ≪≫ₗ f.symm = LinearEquiv.refl K V :=
    f.self_trans_symm
  ```
- A bijective linear map upgrades to a linear equivalence:
  ```lean
  noncomputable example (f : V →ₗ[K] W) (h : Function.Bijective f) : V ≃ₗ[K] W :=
    .ofBijective f h
  ```

## Binary Products

Throughout this section, `V`, `W`, `U`, `T` are vector spaces over the same field `K`.

### Projection maps

```lean
example : V × W →ₗ[K] V := LinearMap.fst K V W   -- first projection
example : V × W →ₗ[K] W := LinearMap.snd K V W   -- second projection
```

### Universal property of the product

Given `φ : U →ₗ[K] V` and `ψ : U →ₗ[K] W`, `LinearMap.prod φ ψ : U →ₗ[K] V × W` is the unique map such that:

$$
\mathsf{fst} \circ (\varphi \times \psi) = \varphi, \qquad \mathsf{snd} \circ (\varphi \times \psi) = \psi
$$

```lean
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : U →ₗ[K] V × W := LinearMap.prod φ ψ
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : LinearMap.fst K V W ∘ₗ LinearMap.prod φ ψ = φ := rfl
example (φ : U →ₗ[K] V) (ψ : U →ₗ[K] W) : LinearMap.snd K V W ∘ₗ LinearMap.prod φ ψ = ψ := rfl
```

Both equations hold by `rfl` — the product map does the expected thing on each component, definitionally.

### Parallel combination (`prodMap`)

`φ.prodMap ψ : (V × W) →ₗ[K] (U × T)` combines `φ : V →ₗ[K] U` and `ψ : W →ₗ[K] T` in parallel:

```lean
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] T) :
    φ.prodMap ψ = (φ ∘ₗ .fst K V W).prod (ψ ∘ₗ .snd K V W) := rfl
```

### Inclusion maps

```lean
example : V →ₗ[K] V × W := LinearMap.inl K V W   -- first inclusion
example : W →ₗ[K] V × W := LinearMap.inr K V W   -- second inclusion
```

### Universal property of the sum (coproduct)

Given `φ : V →ₗ[K] U` and `ψ : W →ₗ[K] U`, `φ.coprod ψ : V × W →ₗ[K] U` is the unique map such that:

$$
(\varphi \sqcup \psi) \circ \mathsf{inl} = \varphi, \qquad (\varphi \sqcup \psi) \circ \mathsf{inr} = \psi
$$

| Lemma | Statement |
| --- | --- |
| `LinearMap.coprod_inl` | `φ.coprod ψ ∘ₗ LinearMap.inl K V W = φ` |
| `LinearMap.coprod_inr` | `φ.coprod ψ ∘ₗ LinearMap.inr K V W = ψ` |

Concretely, the coproduct map adds the two images:

```lean
example (φ : V →ₗ[K] U) (ψ : W →ₗ[K] U) (v : V) (w : W) :
    φ.coprod ψ (v, w) = φ v + ψ w := rfl
```

> [!TIP]
> In the category of vector spaces, the binary product and coproduct coincide: the same object `V × W` is universal in both directions, which is why this section can discuss projections and inclusions side by side.

## Vector Families (`DirectSum`)

`V : ι → Type*` is a family of vector spaces over `K` indexed by `ι` (with `DecidableEq ι`):

```lean
variable {ι : Type*} [DecidableEq ι]
         (V : ι → Type*) [∀ i, AddCommGroup (V i)] [∀ i, Module K (V i)]
```

### Direct sum (finite support)

Given a family of linear maps `φ : Π i, (V i →ₗ[K] W)`, assemble them into a single map from the direct sum:

```lean
example (φ : Π i, (V i →ₗ[K] W)) : (⨁ i, V i) →ₗ[K] W :=
  DirectSum.toModule K ι W φ
```

This is the universal coproduct of a family of linear maps — the infinitary generalization of `coprod`.

### Product (infinite support)

Given a family of linear maps `φ : Π i, (W →ₗ[K] V i)`, assemble them into a single map into the product:

```lean
example (φ : Π i, (W →ₗ[K] V i)) : W →ₗ[K] (Π i, V i) :=
  LinearMap.pi φ
```

This is the universal product of a family of linear maps — the infinitary generalization of `prod`.

### Projection, inclusion, and single

| Map | Type | Role |
| --- | --- | --- |
| `LinearMap.proj i` | `(Π j, V j) →ₗ[K] V i` | universal projection out of the product |
| `DirectSum.lof K ι V i` | `V i →ₗ[K] (⨁ i, V i)` | universal inclusion into the direct sum |
| `LinearMap.single K V i` | `V i →ₗ[K] (Π i, V i)` | inclusion into the product: `x ↦ (fun j => if j = i then x else 0)` |

### Sum vs. product

There is always a linear map `(Π j, V j) →ₗ[K] (⨁ i, V i)`, since `(Π j, V j) →ₗ[K] V i →ₗ[K] (⨁ i, V i)`.

> [!IMPORTANT]
> Elements of `⨁ i, V i` are **finitely supported** tuples, while elements of `Π i, V i` may have infinite support — so in general only one direction exists. When `ι` is a `Fintype`, every tuple is finitely supported, and the two coincide:

```lean
example [Fintype ι] : (⨁ i, V i) ≃ₗ[K] (Π i, V i) :=
  linearEquivFunOnFintype K ι V
```

$$
\bigoplus_{i : \iota} V_i \;\cong\; \prod_{i : \iota} V_i \qquad (\iota \text{ finite})
$$
