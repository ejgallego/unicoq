From Unicoq Require Import Unicoq.

Set Primitive Projections.

Module Test1.

  Record cs := { ty : Type }.
  Canonical Structure cs_unit := {| ty := unit |}.

  (* The definition below used to fail with:

Error: In environment
c := ?c : cs
The term "tt" has type "unit" while it is expected to have type "ty c".

   *)
  Definition x :=
    let c : cs := _ in
    let x := (fun (u : ty c) => u) (tt) in
    c.
    
End Test1.

(* Similar to Test1 but with parameters *)
Module Test2.

  Record cs (A : Type) := { ty : Type }.
  Canonical Structure cs_unit {A} : cs A := {| ty := unit |}.

  Definition x :=
    let c : cs nat := _ in
    let x := (fun (u : ty _ c) => u) (tt) in
    c.

End Test2.


(* With a field that has a function type *)
Module Test3.

  Record cs (A : Type) := { ty : Type; #[canonical=no] f : ty -> Type }.
  Canonical Structure cs_unit {A} : cs A := {| f := fun 'tt => unit |}.

  Definition x :=
    let c : cs nat := _ in
    let x := (fun (u : f _ c tt) => u) (tt) in
    c.

  Canonical Structure cs_nat {A} : cs A := {|
    f := fun n => match n with 0 => nat | _ => nat end
  |}.

  Definition reduceR :=
    let x : cs nat := cs_nat in
    let scr : nat := _ in
    let T := f _ x scr in
    let other := _ in
    eq_refl : (match other with 0 => nat | _ => nat end : Type, other) = (T, 0).

  Definition reduceL :=
    let x : cs nat := cs_nat in
    let scr : nat := _ in
    let T := f _ x scr in
    let other := _ in
    eq_refl : (T, other) = (match other with 0 => nat | _ => nat end : Type, 0).

End Test3.
