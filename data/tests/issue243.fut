-- This test exposed a bug in the index functions of group stream
-- lambda parameter index functions.  The index function of the split
-- would be overwritten by the new offset of the group lambda chunk.
--
-- Thus, not technically a split feature, but where else to put it?
--
-- ==
-- input { 10 }
-- output { [4i32, 3i32, 4i32, 2i32, 4i32, 2i32, 3i32, 2i32, 2i32, 1i32] }

fun boolToInt (x: bool): int =
  if x
  then 1
  else 0

fun resi (x: int) (y: int): int =
  if (x == 0)
  then y
  else (y % x)

entry main (n: int): []int =
  let (_, t_v1) = split 1 (iota (n+1)) in
  let t_v7 = rearrange (1, 0) (replicate n t_v1) in
  let t_v8 = reshape ((n, n)) (iota (n*n)) in
  let t_v12 = let array = zipWith (fn (x: []int) (y: []int): [n]int =>
                                   zipWith resi (x) (y)) t_v7 t_v8 in
              let n = (shape (array))[1] in
              map (fn (x: []int): [n]bool =>
                   map (0==) x) (array) in
  let array =
    (map (fn (x: []int): int => reduce (+) (0) (x))
     (let array = rearrange (1, 0) (t_v12) in
      let n = (shape (array))[1] in
      map (fn (x: []bool): [n]int =>
             map boolToInt (x)) (array)))
  in array
