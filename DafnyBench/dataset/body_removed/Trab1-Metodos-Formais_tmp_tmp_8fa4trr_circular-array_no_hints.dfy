/*
  Class CircularArray.

  Names:
  Arthur Sudbrack Ibarra,
  Miguel Torres de Castro,
  Felipe Grosze Nipper,
  Willian Magnum Albeche,
  Luiz Eduardo Mello dos Reis.
*/
class {:autocontracts} CircularArray {
  /*
    Implementation
  */
  var arr: array<int>; // The array.
  var start: nat; // The index of the first element.
  var size: nat; // The number of elements in the queue.

  /*
    Abstraction.
  */
  ghost const Capacity: nat; // The capacity of the queue. (WE WERE UNABLE TO MAKE THE SIZE OF THE ARRAY DYNAMIC).
  ghost var Elements: seq<int>; // The elements in the array represented as a sequence.

  /*
    Class invariant.
  */
  ghost predicate Valid()
  {}

  /*
    Constructor.
  */
  constructor EmptyQueue(capacity: nat)
    requires capacity > 0
    ensures Elements == []
    ensures Capacity == capacity
  {}

  /*
    Enqueue Method
  */
  method Enqueue(e: int)
    requires !IsFull()
    ensures Elements == old(Elements) + [e]
  {}

  /*
    Dequeue method.
  */
  method Dequeue() returns (e: int)
    requires !IsEmpty()
    ensures Elements == old(Elements)[1..]
    ensures e == old(Elements)[0]
  {}

  /*
    Contains predicate.
  */
  predicate Contains(e: int)
    ensures Contains(e) == (e in Elements)
  {}

  /*
    Size function.
  */
  function Size(): nat
    ensures Size() == |Elements|
  {
    size
  }

  /*
    IsEmpty predicate.
  */
  predicate IsEmpty()
    ensures IsEmpty() <==> (|Elements| == 0)
  {
    size == 0
  }

  /*
    IsFull predicate.
  */
  predicate IsFull()
    ensures IsFull() <==> |Elements| == Capacity
  {}

  /*
    GetAt method.
    (Not requested in the assignment, but useful).
  */
  method GetAt(i: nat) returns (e: int)
    requires i < size
    ensures e == Elements[i]
  {}

  /*
    AsSequence method.
    (Auxiliary method for the Concatenate method)
  */
  method AsSequence() returns (s: seq<int>)
    ensures s == Elements
    {}

  /*
    Concatenate method.
  */
  method Concatenate(q1: CircularArray) returns(q2: CircularArray)
    requires q1.Valid()
    requires q1 != this
    ensures fresh(q2)
    ensures q2.Capacity == Capacity + q1.Capacity
    ensures q2.Elements == Elements + q1.Elements
  {}
}

/*
  Main method.
  Here the the CircularArray class is demonstrated.
*/
method Main()
{}

