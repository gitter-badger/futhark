-- A value type parameter of a polymorphic function cannot be instantiated to a
-- function type by passing the function as an argument to another function.
-- ==
-- error: functional

let app (f : (i32 -> i32) -> (i32 -> i32)) : i32 =
  f (\(x:i32) -> x+x) 42

let id 'a (x:a) : a = x

let main : i32 = app id
