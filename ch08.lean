class One₁ (α : Type) where
  /-- The element one -/
  one : α

@[inherit_doc]
notation "𝟙" => One₁.one
