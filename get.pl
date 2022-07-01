:- module(get,[get/5]).

:- use_module(timeAndStorage).
:- use_module(datastructures).
:- use_module(insert).
:- use_module(datagenerator).
:- use_module(library(random),[getrand/1,setrand/1]).

get(hamt, Measurement,Keys,Trie,Result):-
	measurement(Measurement, Result, get_Trie(Keys,Trie)).

get(assert,Measurement,Keys,_Assert,Result) :-
        measurement(Measurement,Result,get_Assert(Keys)).
        
get(bb,Measurement,Keys,_BB,Result) :-
        measurement(Measurement,Result,get_BB(Keys)).

get(avl,Measurement,Keys,Avl,Result) :-
        measurement(Measurement,Result,get_AVL(Keys,Avl)).

get(mutdict,Measurement,Keys,Mutdict,Result) :-
        measurement(Measurement,Result,get_Mutdict(Keys,Mutdict)).

get(logarr,Measurement,Keys,Array,Result) :-
	measurement(Measurement,Result,get_Logarr(Keys,Array)).

get(mutarray,Measurement,Keys,Mutarray,Result) :-
	measurement(Measurement,Result,get_Mutarray(Keys,Mutarray)).
	
get(assoc,Measurement,Keys,Assoc,Result) :-
        measurement(Measurement,Result,get_Assoc(Keys,Assoc)).

