// RUN: %dafny /compile:0 /arith:1 "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

// Proof of the Lucas theorem
// Rustan Leino
// 9 March 2018
//
// Instead of the lemmas doing "up", like:
//   P(k) == P(2*k)
//   P(k) == P(2*k + 1)
// (see Lucas-up.dfy), the lemmas in this version go "down", like:
//   P(k%2) == P(k)

// This file defines the ingredients of the Lucas theorem, proves some
// properties of these, and then states and proves the Lucas theorem
// itself.

// The following predicate gives the boolean value of bit "k" in
// the natural number "n".
predicate Bit(k: nat, n: nat)
{}

// Function "BitSet" returns the set of bits in the binary representation
// of a number.
function BitSet(n: nat): set<nat>
{}

// The following lemma shows that the "i < n" conjunct in
// the set comprehension in "BitSet" does not restrict
// the set any more than the conjunct "Bit(i, n)" does.
lemma BitSize(i: nat, n: nat)
  requires Bit(i, n)
  ensures i < n
{
}

// An easy-to-read name for the expression that checks if a number
// is even.
predicate EVEN(n: nat)
{
  n % 2 == 0
}

// The binomial function is defined like in the Pascal triangle.
// "binom(a, b)" is also knows as "a choose b".
function binom(a: nat, b: nat): nat
{}

// This lemma shows that the parity of "binom" is preserved if
// div-2 is applied to both arguments--except in the case where
// the first argument to "binom" is even and the second argument
// is odd, in which case "binom" is always even.
lemma Lucas_Binary''(a: nat, b: nat)
  ensures binom(a, b) % 2 == if EVEN(a) && !EVEN(b) then 0 else binom(a / 2, b / 2) % 2
{}

// "Suc(S)" returns the set constructed by incrementing
// each number in "S" by 1. Stated differently, it is the
// increment-by-1 (successor) function applied pointwise to the
// set.
function Suc(S: set<nat>): set<nat>
{}

// The following lemma clearly shows the correspondence between
// "S" and "Suc(S)".
lemma SucElements(S: set<nat>)
  ensures forall x :: x in S <==> (x+1) in Suc(S)
{
}

// Here is a lemma that relates BitSet and Suc.
lemma BitSet_Property(n: nat)
  ensures BitSet(n) - {0} == Suc(BitSet(n / 2))
{}

lemma Lucas_Theorem'(m: nat, n: nat)
  ensures BitSet(m) <= BitSet(n) <==> !EVEN(binom(n, m))
{
  if m == 0 && n == 0 {
  } else if EVEN(n) && !EVEN(m) {
    calc {
      !EVEN(binom(n, m));
    ==  { Lucas_Binary''(n, m); }
      false;
    ==  { assert 0 in BitSet(m) && 0 !in BitSet(n); }
      BitSet(m) <= BitSet(n);
    }
  } else {
    var m', n' := m/2, n/2;
    calc {
      !EVEN(binom(n, m));
    ==  { Lucas_Binary''(n, m); }
      !EVEN(binom(n', m'));
    ==  { Lucas_Theorem'(m', n'); }
      BitSet(m') <= BitSet(n');
    ==  { SucElements(BitSet(m')); SucElements(BitSet(n')); }
      Suc(BitSet(m')) <= Suc(BitSet(n'));
    ==  { BitSet_Property(m); BitSet_Property(n); }
      BitSet(m) - {0} <= BitSet(n) - {0};
    ==  { assert 0 !in BitSet(m) ==> BitSet(m) == BitSet(m) - {0};
      BitSet(m) <= BitSet(n);
    }
  }
}

