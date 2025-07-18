// RUN: %dafny /compile:0 /dprint:"%t.dprint" "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

// A definition of a co-inductive datatype Stream, whose values are possibly
// infinite lists.
codatatype Stream<T> = SNil | SCons(head: T, tail: Stream<T>)

/*
  A function that returns a stream consisting of all integers upwards of n.
  The self-call sits in a productive position and is therefore not subject to
  termination checks.  The Dafny compiler turns this co-recursive call into a
  lazily evaluated call, evaluated at the time during the program execution
  when the SCons is destructed (if ever).
*/

function Up(n: int): Stream<int>
{}

/*
  A function that returns a stream consisting of all multiples
  of 5 upwards of n.  Note that the first self-call sits in a
  productive position and is thus co-recursive.  The second self-call
  is not in a productive position and therefore it is subject to
  termination checking; in particular, each recursive call must
  decrease the specific variant function.
 */

function FivesUp(n: int): Stream<int>
{}

// A co-predicate that holds for those integer streams where every value is greater than 0.
copredicate Pos(s: Stream<int>)
{}

// SAppend looks almost exactly like Append, but cannot have 'decreases'
// clause, as it is possible it will never terminate.
function SAppend(xs: Stream, ys: Stream): Stream
{}

/*
  Example: associativity of append on streams.

  The first method proves that append is associative when we consider first
  \S{k} elements of the resulting streams.  Equality is treated as any other
  recursive co-predicate, and has it k-th unfolding denoted as ==#[k].

  The second method invokes the first one for all ks, which lets us prove the
  postcondition (by (F_=)).  Interestingly, in the SNil case in the first
  method, we actually prove ==, but by (F_=) applied in the opposite direction
  we also get ==#[k].
*/

lemma {:induction false} SAppendIsAssociativeK(k:nat, a:Stream, b:Stream, c:Stream)
  ensures SAppend(SAppend(a, b), c) ==#[k] SAppend(a, SAppend(b, c));
{}

lemma SAppendIsAssociative(a:Stream, b:Stream, c:Stream)
  ensures SAppend(SAppend(a, b), c) == SAppend(a, SAppend(b, c));
{}

// Equivalent proof using the colemma syntax.
colemma {:induction false} SAppendIsAssociativeC(a:Stream, b:Stream, c:Stream)
  ensures SAppend(SAppend(a, b), c) == SAppend(a, SAppend(b, c));
{}

// In fact the proof can be fully automatic.
colemma SAppendIsAssociative_Auto(a:Stream, b:Stream, c:Stream)
  ensures SAppend(SAppend(a, b), c) == SAppend(a, SAppend(b, c));
{
}

colemma {:induction false} UpPos(n:int)
  requires n > 0;
  ensures Pos(Up(n));
{
  UpPos(n+1);
}

colemma UpPos_Auto(n:int)
  requires n > 0;
  ensures Pos(Up(n));
{
}

// This does induction and coinduction in the same proof.
colemma {:induction false} FivesUpPos(n:int)
  requires n > 0;
  ensures Pos(FivesUp(n));
{}

// Again, Dafny can just employ induction tactic and do it automatically.
// The only hint required is the decrease clause.
colemma FivesUpPos_Auto(n:int)
  requires n > 0;
  ensures Pos(FivesUp(n));
{
}


