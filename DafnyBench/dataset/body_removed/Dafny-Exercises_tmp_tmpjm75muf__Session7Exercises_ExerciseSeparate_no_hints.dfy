predicate strictNegative(v:array<int>,i:int,j:int)
reads v
requires 0<=i<=j<=v.Length
{}

predicate positive(s:seq<int>)
{}

predicate isPermutation(s:seq<int>, t:seq<int>)
{}

/**
returns an index st new array is a permutation of the old array
positive first and then strictnegative, i is the firs neg or len if not any */
method separate(v:array<int>) returns (i:int)
modifies v
ensures 0<=i<=v.Length
ensures positive(v[0..i]) && strictNegative(v,i,v.Length)
ensures isPermutation(v[0..v.Length], old(v[0..v.Length]))
{}
