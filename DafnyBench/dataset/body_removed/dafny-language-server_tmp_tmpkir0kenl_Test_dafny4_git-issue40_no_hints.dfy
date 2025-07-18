// RUN: %dafny /compile:0 "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

function SeqRepeat<T>(count:nat, elt:T) : seq<T>
    ensures |SeqRepeat<T>(count, elt)| == count
    ensures forall i :: 0 <= i < count ==> SeqRepeat<T>(count, elt)[i] == elt

datatype Maybe<T> = Nothing | Just(v: T)
type Num = x | 0 <= x < 10
datatype D = C(seq<Maybe<Num>>)

lemma test()
{}




