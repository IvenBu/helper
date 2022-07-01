:- module(datagenerator,[data/3,datagenerator/4,datagenerator/5,datagenerator/4,datageneratorRest/5]).

:- use_module(library(sets),[del_element/3]).
:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(file_systems),[file_members_of_directory/3]).
:- use_module(library(random),[random_member/2]).
:- use_module(library(random)).

include_type_definition(_-FullPath) :- consult(FullPath).

:- file_members_of_directory('./SICStusPrologFuzzer/','*.pl',FileList),
   maplist(include_type_definition,FileList). 

/* Erzeugung der Daten unter der Verwendung der generate/2 Funktion aus dem Fuzzer */

datagenerator(KeyType,ValueType,Size,Keys,Values):-
	data(KeyType,Size,Keys),
	data(ValueType,Size,Values),!.

datagenerator(random,Keys,Size,Data):-
        shuffle(Keys,Helper),
        datagenerator(first,Helper,Size,Data),!.
        
datagenerator(last,Keys,Size,Data):-
	length(Keys,X),
	Helper is X-Size,
	sublist(Keys,List,Helper,Size,0),
	reverse(List, Data),!.

datagenerator(first,Keys,Size,Data):-
	length(Keys,X),
	Helper is X-Size,
	sublist(Keys,Data,0,Size,Helper),!.
	
/*Die datageneratorRest Prädikate werden dafür verwendet nach Entfernen von Elementen aus dem Blackboard und Assert die übrigen ebenfalls zu löschen*/
datageneratorRest(random,Keys,Size,Data,RestData):-
        shuffle(Keys,Helper),
        datageneratorRest(first,Helper,Size,Data,RestData),!.

datageneratorRest(first,Keys,Size,Data,RestData):-
	length(Keys,X),
	Helper is X-Size,
	sublist(Keys,Data,0,Size,Helper),
	sublist(Keys,RestData,Size,Helper,0),!.

datageneratorRest(last,Keys,Size,Data,RestData):-
	length(Keys,X),
	Helper is X-Size,
	sublist(Keys,List,Helper,Size,0),
        sublist(Keys,RestData,0,Helper,Size),
	reverse(List, Data),!.
   
data(string,X, Data) :-
        generate(list(list(integer([between(33,126)])),[size:X]),Data),!.

data(atom,X, Data) :-
        generate(list(atom([alph]),[size:X]),Data),!.
        
data(atomNoDup,X,Data) :-
	XNeu is integer(X*1.2),
	data(atom,XNeu,Helper),
	remove_dups(Helper,Pruned),
	sublist(Pruned,Data,0,X,_),!.

data(stringNoDup,X,Data) :-
	XNeu is integer(X*1.2),
	data(string,XNeu,Helper),
	remove_dups(Helper,Pruned),
	sublist(Pruned,Data,0,X,_),!.

data(ordIdx,X,Data) :-
        numlist(1,X, Data),!.
        
data(revIdx,X,Data) :-
        numlist(1,X,H),
	reverse(H,Data),!.

data(unordIdx,X,Data) :-
        numlist(1,X,H),
        shuffle(H,Helper),
        datagenerator(first,Helper,X,Data),!.
       
data(integer,X,Data) :-
        generate(list(integer([]),[size:X]),Data),!.

/*Hilfsfunktion für das Mischen von Elementen einer Liste. Es wurde random_permutation aufgrund der geringen Laufzeit verwendet.*/
shuffle(TotalValues,Data):-
        random_permutation(TotalValues,Data).
