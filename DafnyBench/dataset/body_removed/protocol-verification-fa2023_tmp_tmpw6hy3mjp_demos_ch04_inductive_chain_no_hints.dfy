module Ex {
  // This simple example illustrates what the process of looking for an
  // inductive invariant might look like.

  datatype Variables = Variables(p1: bool, p2: bool, p3: bool, p4: bool)

  ghost predicate Init(v: Variables) {}

  // The state machine starts out with all four booleans false, and it "turns
  // on" p1, p2, p3, and p4 in order. The safety property says p4 ==> p1;
  // proving this requires a stronger inductive invariant.

  datatype Step =
    | Step1
    | Step2
    | Step3
    | Step4
    | Noop

  ghost predicate NextStep(v: Variables, v': Variables, step: Step)
  {}

  ghost predicate Next(v: Variables, v': Variables)
  {}

  ghost predicate Safety(v: Variables)
  {}

  ghost predicate Inv(v: Variables)
  {}

  lemma InvInductive(v: Variables, v': Variables)
    requires Inv(v) && Next(v, v')
    ensures Inv(v')
  {}

  lemma InvSafe(v: Variables)
    ensures Inv(v) ==> Safety(v)
  {
    return;
  }

  // This is the main inductive proof of Safety, but we moved all the difficult
  // reasoning to the lemmas above.
  lemma SafetyHolds(v: Variables, v': Variables)
    ensures Init(v) ==> Inv(v)
    ensures Inv(v) && Next(v, v') ==> Inv(v')
    ensures Inv(v) ==> Safety(v)
  {}

  // SOLUTION
  // Instead of worrying about Safety, we can approach invariants by starting
  // with properties that should hold in all reachable states. The advantage of
  // this approach is that we can "checkpoint" our work of writing an invariant
  // that characterizes reachable states. The disadvantage is that we might
  // prove properties that don't help with safety and waste time.
  //
  // Recall that an invariant may have a counterexample to induction (CTI): a
  // way to start in a state satisfying the invariant and transition out of it.
  // If the invariant really holds, then a CTI simply reflects an unreachable
  // state, one that we should try to eliminate by strengthening the invariant.
  // If we find a "self-inductive" property Inv that satisfies Init(v) ==>
  // Inv(v) and Inv(v) && Next(v, v') ==> Inv(v'), then we can extend it without
  // fear of breaking inductiveness: in proving Inv(v) && Inv2(v) && Next(v, v')
  // ==> Inv(v') && Inv2(v'), notice that we can immediately prove Inv(v').
  // However, we've also made progress: in proving Inv2(v'), we get to know
  // Inv(v). This may rule out some CTIs, and eventually will be enough to prove
  // Inv2 is inductive.
  //
  // Notice that the above discussion involved identifying a self-inductive
  // invariant without trying to prove a safety property. This is one way to go
  // about proving safety: start by proving "easy" properties that hold in
  // reachable states. This will reduce the burden of getting CTIs (or failed
  // proofs). However, don't spend all your time proving properties about
  // reachable states: there will likely be properties that really are
  // invariants, but (a) the proof is complicated and (b) they don't help you
  // prove safety.

  predicate Inv2(v: Variables) {}

  lemma Inv2Holds(v: Variables, v': Variables)
    ensures Init(v) ==> Inv2(v)
    ensures Inv2(v) && Next(v, v') ==> Inv2(v')
  {}
  // END
}

