class Counter {
 
  var value : int ;
  
  constructor init() 
  ensures value == 0;
  {}
  
  method getValue() returns (x:int)
  ensures x == value;
  {}
  
  method inc()
  modifies this`value
  requires value >= 0;
  ensures value == old(value) + 1; 
  {}
  
  method dec()
  modifies this`value
  requires value > 0;
  ensures value == old(value) - 1; 
  {}
  
  method Main ()
  {}
}

