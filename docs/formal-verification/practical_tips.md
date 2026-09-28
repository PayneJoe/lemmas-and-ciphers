1. How to instantiate a typeclass?

    Take `CoeOut` as an example :
    ```lean
    /--
        `CoeOut α β` is for coercions that are applied from left-to-right.
    -/
    class CoeOut (α : Sort u) (β : semiOutParam (Sort v)) where
      /-- Coerces a value of type `α` to type `β`. Accessible by the notation `↑x`,
      or by double type ascription `((x : α) : β)`. -/
      coe : α → β
    ```

    there is only one field to be filled, which is `coe`

    ```lean
    instance : CoeOut MyType MyOtherType := {
        coe := myCoerceFunction
    }
    ```
    or 
    ```lean
    instance : CoeOut MyType MyOtherType :=
      ⟨myCoerceFunction⟩
    ```

2. How to define and instantiate a subtype? 

    Take `MySubtype` as an example:
    ```lean
    def MySubtype := { x : MyType // x.property }
    ```

    Here, `MySubtype` is a subtype of `MyType` consisting of elements `x` that satisfy `x.property`.

    To instantiate a value of `MySubtype`, you need to provide a value of `MyType` along with a proof that it satisfies the property:

    ```lean
    def mySubtypeInstance : MySubtype :=
      ⟨myValueOfMyType, myProofThatItSatisfiesProperty⟩
    ```

3. How to define a linear map?

    For example :
    ```lean
    def RSEvalLinear [Semiring F] (α : ι → F) : F[X] →ₗ[F] ι → F where
        toFun := RSEval α
        -- `simp` uses registered theorem `Eval_add`
        map_add' := by
          intro p q
          simp
        -- `simp` uses registered theorem `Eval_smul`
        map_smul' := by
          intro c p
          simp 
    ```
    linear map is a homomorphism between vector spaces, preserving both vector addition and scalar multiplication. So besides defining the function itself `toFun`, you also need to provide proofs that it respects addition and scalar multiplication, which are `map_add'` and `map_smul'` in the `LinearMap` structure.



