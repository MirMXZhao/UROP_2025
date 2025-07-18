// RUN: %testDafnyForEachResolver "%s" -- --warn-deprecation:false


// ----- Stream

codatatype Stream<T> = Nil | Cons(head: T, tail: Stream)

ghost function append(M: Stream, N: Stream): Stream
{}

// ----- f, g, and maps

type X

ghost function f(x: X): X
ghost function g(x: X): X

ghost function map_f(M: Stream<X>): Stream<X>
{}

ghost function map_g(M: Stream<X>): Stream<X>
{}

ghost function map_fg(M: Stream<X>): Stream<X>
{}

// ----- Theorems

// map (f * g) M = map f (map g M)
greatest lemma Theorem0(M: Stream<X>)
  ensures map_fg(M) == map_f(map_g(M));
{}
greatest lemma Theorem0_Alt(M: Stream<X>)
  ensures map_fg(M) == map_f(map_g(M));
{}
lemma Theorem0_Par(M: Stream<X>)
  ensures map_fg(M) == map_f(map_g(M));
{}
lemma Theorem0_Ind(k: nat, M: Stream<X>)
  ensures map_fg(M) ==#[k] map_f(map_g(M));
{}
lemma Theorem0_AutoInd(k: nat, M: Stream<X>)
  ensures map_fg(M) ==#[k] map_f(map_g(M));
{
}

// map f (append M N) = append (map f M) (map f N)
greatest lemma Theorem1(M: Stream<X>, N: Stream<X>)
  ensures map_f(append(M, N)) == append(map_f(M), map_f(N));
{}
greatest lemma Theorem1_Alt(M: Stream<X>, N: Stream<X>)
  ensures map_f(append(M, N)) == append(map_f(M), map_f(N));
{}
lemma Theorem1_Par(M: Stream<X>, N: Stream<X>)
  ensures map_f(append(M, N)) == append(map_f(M), map_f(N));
{}
lemma Theorem1_Ind(k: nat, M: Stream<X>, N: Stream<X>)
  ensures map_f(append(M, N)) ==#[k] append(map_f(M), map_f(N));
{}
lemma Theorem1_AutoInd(k: nat, M: Stream<X>, N: Stream<X>)
  ensures map_f(append(M, N)) ==#[k] append(map_f(M), map_f(N));
{
}
lemma Theorem1_AutoForall()
{}

// append NIL M = M
lemma Theorem2(M: Stream<X>)
  ensures append(Nil, M) == M;
{
  // trivial
}

// append M NIL = M
greatest lemma Theorem3(M: Stream<X>)
  ensures append(M, Nil) == M;
{}
greatest lemma Theorem3_Alt(M: Stream<X>)
  ensures append(M, Nil) == M;
{}

// append M (append N P) = append (append M N) P
greatest lemma Theorem4(M: Stream<X>, N: Stream<X>, P: Stream<X>)
  ensures append(M, append(N, P)) == append(append(M, N), P);
{}
greatest lemma Theorem4_Alt(M: Stream<X>, N: Stream<X>, P: Stream<X>)
  ensures append(M, append(N, P)) == append(append(M, N), P);
{}

// ----- Flatten

// Flatten can't be written as just:
//
//     function SimpleFlatten(M: Stream<Stream>): Stream
//     {}
//
// because this function fails to be productive given an infinite stream of Nil's.
// Instead, here are two variations of SimpleFlatten.  The first variation (FlattenStartMarker)
// prepends a "startMarker" to each of the streams in "M".  The other (FlattenNonEmpties)
// insists that "M" contain no empty streams.  One can prove a theorem that relates these
// two versions.

// This first variation of Flatten returns a stream of the streams in M, each preceded with
// "startMarker".

ghost function FlattenStartMarker<T>(M: Stream<Stream>, startMarker: T): Stream
{}

ghost function PrependThenFlattenStartMarker<T>(prefix: Stream, M: Stream<Stream>, startMarker: T): Stream
{}

// The next variation of Flatten requires M to contain no empty streams.

greatest predicate StreamOfNonEmpties(M: Stream<Stream>)
{}

ghost function FlattenNonEmpties(M: Stream<Stream>): Stream
  requires StreamOfNonEmpties(M);
{}

ghost function PrependThenFlattenNonEmpties(prefix: Stream, M: Stream<Stream>): Stream
  requires StreamOfNonEmpties(M);
{}

// We can prove a theorem that links the previous two variations of flatten.  To
// do that, we first define a function that prepends an element to each stream
// of a given stream of streams.

ghost function Prepend<T>(x: T, M: Stream<Stream>): Stream<Stream>
{}

greatest lemma Prepend_Lemma<T>(x: T, M: Stream<Stream>)
  ensures StreamOfNonEmpties(Prepend(x, M));
{}

lemma Theorem_Flatten<T>(M: Stream<Stream>, startMarker: T)
  ensures
    StreamOfNonEmpties(Prepend(startMarker, M)) ==> // always holds, on account of Prepend_Lemma;
                                          // but until (co-)method can be called from functions,
                                          // this condition is used as an antecedent here
    FlattenStartMarker(M, startMarker) == FlattenNonEmpties(Prepend(startMarker, M));
{}

greatest lemma Lemma_Flatten<T>(prefix: Stream, M: Stream<Stream>, startMarker: T)
  ensures
    StreamOfNonEmpties(Prepend(startMarker, M)) ==> // always holds, on account of Prepend_Lemma;
                                          // but until (co-)method can be called from functions,
                                          // this condition is used as an antecedent here
    PrependThenFlattenStartMarker(prefix, M, startMarker) == PrependThenFlattenNonEmpties(prefix, Prepend(startMarker, M));
{
  Prepend_Lemma(startMarker, M);
  match (prefix) {
    case Cons(hd, tl) =>
    Lemma_Flatten(tl, M, startMarker);
    case Nil =>
      match (M) {
        case Nil =>
        case Cons(s, N) =>
          if (*) {
            // This is all that's needed for the proof
            Lemma_Flatten(s, N, startMarker);
          } else {
            // ...but here are some calculations that try to show more of what's going on
            // (It would be nice to have ==#[...] available as an operator in calculations.)

            // massage the LHS:
            calc {
              PrependThenFlattenStartMarker(prefix, M, startMarker);
            ==  // def. PrependThenFlattenStartMarker
              Cons(startMarker, PrependThenFlattenStartMarker(s, N, startMarker));
            }
            // massage the RHS:
            calc {
              PrependThenFlattenNonEmpties(prefix, Prepend(startMarker, M));
            ==  // M == Cons(s, N)
              PrependThenFlattenNonEmpties(prefix, Prepend(startMarker, Cons(s, N)));
            ==  // def. Prepend
              PrependThenFlattenNonEmpties(prefix, Cons(Cons(startMarker, s), Prepend(startMarker, N)));
            ==  // def. PrependThenFlattenNonEmpties
              Cons(Cons(startMarker, s).head, PrependThenFlattenNonEmpties(Cons(startMarker, s).tail, Prepend(startMarker, N)));
            ==  // Cons, head, tail
              Cons(startMarker, PrependThenFlattenNonEmpties(s, Prepend(startMarker, N)));
            }

            // all together now:
            calc {
              PrependThenFlattenStartMarker(prefix, M, startMarker) ==#[_k] PrependThenFlattenNonEmpties(prefix, Prepend(startMarker, M));
              { // by the calculation above, we have:
              Cons(startMarker, PrependThenFlattenStartMarker(s, N, startMarker)) ==#[_k] PrependThenFlattenNonEmpties(prefix, Prepend(startMarker, M));
              { // and by the other calculation above, we have:
              Cons(startMarker, PrependThenFlattenStartMarker(s, N, startMarker)) ==#[_k] Cons(startMarker, PrependThenFlattenNonEmpties(s, Prepend(startMarker, N)));
            ==  // def. of ==#[_k] for _k != 0
              startMarker == startMarker &&
              PrependThenFlattenStartMarker(s, N, startMarker) ==#[_k-1] PrependThenFlattenNonEmpties(s, Prepend(startMarker, N));
              { Lemma_Flatten(s, N, startMarker);
                // the postcondition of the call we just made (which invokes the co-induction hypothesis) is:
              }
              true;
            }
          }
      }
  }
}

greatest lemma Lemma_FlattenAppend0<T>(s: Stream, M: Stream<Stream>, startMarker: T)
  ensures PrependThenFlattenStartMarker(s, M, startMarker) == append(s, PrependThenFlattenStartMarker(Nil, M, startMarker));
{
  match (s) {
    case Nil =>
    case Cons(hd, tl) =>
      Lemma_FlattenAppend0(tl, M, startMarker);
  }
}

greatest lemma Lemma_FlattenAppend1<T>(s: Stream, M: Stream<Stream>)
  requires StreamOfNonEmpties(M);
  ensures PrependThenFlattenNonEmpties(s, M) == append(s, PrependThenFlattenNonEmpties(Nil, M));
{
  match (s) {
    case Nil =>
    case Cons(hd, tl) =>
      Lemma_FlattenAppend1(tl, M);
  }
}

