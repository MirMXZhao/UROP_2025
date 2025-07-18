ghost method M1()
{}

lemma IntersectionIsSubsetOfBoth(A: set, B: set, C: set)
	requires C == A*B
	ensures C <= A && C <= B
{}

lemma BothSetsAreSubsetsOfTheirUnion(A: set, B: set, C: set)
	requires C == A+B
	ensures A <= C && B <= C
{}

const s0 := {3,8,1}
//var s2 := {4,5}

lemma M2()
{}

lemma TheEmptySetIsASubsetOfAnySet(A: set, B: set)
	requires A == {}
	ensures A <= B // same as writing: B >= A
{}

lemma AnySetIsASubsetOfItself(A: set)
	ensures A <= A
{}

lemma TheIntersectionOfTwoSetsIsASubsetOfTheirUnion(A: set, B: set, C: set, D: set)
	requires C == A*B && D == A+B
	ensures C <= D
{
}

