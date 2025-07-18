/* Here's a small but realistic setting where you could use Dafny.

   The setting is that we're implementing an interval library that manages a
   data structure with a low and a high value. It implements some computations
   on intervals, and we want to make sure those are right.
 */

// Interval is the Dafny model of the data structure itself. We're using `real`
// here for the numbers; the specifics don't really matter, as long as we can
// compare them with <.
datatype Interval = Interval(lo: real, hi: real)

// Contains is one of the core operations on intervals, both because we support
// it in the API and because in some ways it defines what the interval means.
predicate contains(i: Interval, r: real) {}

// We also provide a way to check if an interval is empty.
predicate empty(i: Interval) {
  i.lo > i.hi
}

/* Now we can already do our first proof! Empty is a way to check if an interval
 * doesn't contain any numbers - let's prove that empty and contains agree with
 * each other. */

lemma empty_ok(i: Interval)
  // this is the sort of property that's easy to express logically but hard to test for
  ensures empty(i) <==> !exists r :: contains(i, r)
{}

// min and max are just helper functions for the implementation
function min(r1: real, r2: real): real {}

function max(r1: real, r2: real): real {}

/* The first complicated operation we expose is a function to intersect two
 * intervals. It's not so easy to think about whether this is correct - for
 * example, does it handle empty intervals correctly? Maybe two empty intervals
 * could intersect to a non-empty one? */

function intersect(i1: Interval, i2: Interval): Interval {}

// This theorem proves that intersect does exactly what we wanted it to, using
// `contains` as the specification.
lemma intersect_ok(i1: Interval, i2: Interval)
  ensures forall r :: contains(intersect(i1, i2), r) <==> contains(i1, r) && contains(i2, r)
{
}

/* Next we'll define the union of intervals. This is more complicated because if
 * the intervals have no overlap, a single interval can't capture their union
 * exactly. */

// Intersect gives us an easy way to define overlap, and we already know it
// handles empty intervals correctly.
predicate overlap(i1: Interval, i2: Interval) {}

lemma overlap_ok(i1: Interval, i2: Interval)
  ensures overlap(i1, i2) <==> exists r :: contains(i1, r) && contains(i2, r)
{}

// We'll give this function a precondition so that it always does the right thing.
function union(i1: Interval, i2: Interval): Interval
  requires overlap(i1, i2)
{}

// We can prove union correct in much the same way as intersect, with a similar
// specification, although notice that now we require that the intervals
// overlap.
lemma union_ok(i1: Interval, i2: Interval)
  requires overlap(i1, i2)
  ensures forall r :: contains(union(i1, i2), r) <==> contains(i1, r) || contains(i2, r)
{
}

// Though not used elsewhere here, if two intervals overlap its possible to show
// that there's a common real contained in both of them. We also show off new
// syntax: this lemma returns a value which is used in the postcondition, and
// which the calling lemma can make use of.
lemma overlap_witness(i1: Interval, i2: Interval) returns (r: real)
  requires overlap(i1, i2)
  ensures contains(i1, r) && contains(i2, r)
{}

/* One extension you might try is adding is an operation to check if an interval
 * is contained in another and proving that correct. Or, try implementing a
 * similar library for 2D rectangles. */

