/**
 *  A proof in Dafny of the non blocking property of a queue.
 *  @author Franck Cassez.
 *
 *  @note: based off Modelling Concurrency in Dafny, K.R.M. Leino
 *  @link{}
 */
module ProdCons {

    //  A type for process id that supports equality (i.e. p == q is defined).
    type Process(==) 

    //  A type for the elemets in the buffer.
    type T

    /**
     *  The producer/consumer problem.
     *  The set of processes is actuall irrelevant (included here because part of the 
     *  original problem statement ...)
     */
    class ProdCons { 

        /**
         *  Set of processes in the system.
         */
        const P: set<Process>

        /**
         *  The maximal size of the buffer.
         */
        var maxBufferSize : nat 

        /**
         *  The buffer.
         */
        var buffer : seq<T> 

        /**
         *  Invariant.
         *
         *  Buffer should always less than maxBufferSize elements,
         *  Set of processes is not empty
         *  
         */
        predicate valid() 
            reads this
        {}
        
        /**
         *  Initialise set of processes and buffer and maxBufferSize
         */
        constructor (processes: set<Process>, m: nat ) 
            requires processes != {}        //  Non empty set of processes.
            requires m >= 1                 //  Buffer as at least one cell.
            ensures valid()                 //  After initilisation the invariant is true
        {}

        /**
         *  Enabledness of a put operation.
         *  If enabled any process can perform a put.
         */
        predicate putEnabled(p : Process) 
            reads this
        {}

        /** Event: a process puts an element in the queue.  */
        method put(p: Process, t : T) 
            requires valid()                
            requires putEnabled(p)          //  |buffer| < maxBufferSize
            modifies this 
        {}

        /**
         *  Enabledness of a get operation. 
         *  If enabled, any process can perform a get.
         */
        predicate getEnabled(p : Process) 
            reads this
        {}

        /** Event: a process gets an element from the queue. */
        method get(p: Process) 
            requires getEnabled(p)
            requires valid()                //  Invariant is inductive
            ensures |buffer| == |old(buffer)| - 1   //  this invariant is not needed and can be omitted
            modifies this 
        {}
                
        /** Correctness theorem: no deadlock. 
         *  From any valid state, at least one process is enabled.
         */
        lemma noDeadlock() 
            requires valid() 
            ensures exists p :: p in P && (getEnabled(p) || putEnabled(p))

            //  as processes are irrelevant, this could be simplified
            //  into isBufferNotFull() or isBufferNotEmpty()
        {}
    }
}





