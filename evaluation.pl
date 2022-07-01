:- module(evaluation,[insertMeasurement/5,storageInsert/6,getMeasurement/7,updateMeasurement/7,removeMeasurement/7]).

:- use_module(insert).
:- use_module(remove).
:- use_module(get).
:- use_module(update).
:- use_module(statistics).
:- use_module(datagenerator).
:- use_module(datastructures).
:- use_module(library(sets),[subtract/3]).
:- use_module(library(random),[getrand/1,setrand/1]).
:- use_module(library(lists)).

        
/*Insert*/

insertMeasurement(Datastructure,KeyType,ValueType,Size,Repetitions) :-
	seedInInsert([64,42,random(26010,5548,23873,425005073),random(28499,25560,28471,425005073),random(22138,25686,18390,425005073), random(5844,16882,29420,425005073), random(30131,26455,14300,425005073), random(25476,15079,18343,425005073),random(6107,20268,13873,425005073),random(8660,29600,25519,425005073), random(25009,13268,28234,425005073), random(8515,19614,3128,425005073)],Datastructure,KeyType,ValueType,Size,Repetitions).

seedInInsert([],_,_,_,_,_).

seedInInsert([Seed|V],Datastructure,KeyType,ValueType,Size,Repetitions) :-
        insert(Mean,Confi,Datastructure,on,Seed,Size,KeyType,ValueType,Repetitions,_),
        format('~n Inserten in ~w mit Mean: ~w Confi: ~w ~n',[Datastructure,Mean,Confi]),
        seedInInsert(V,Datastructure,KeyType,ValueType,Size,Repetitions).

insert(Mean,Confi,DatastructureType,GC,Seed,Size,KeyType,ValueType,Repetitions,Result):-
        set_prolog_flag(gc,GC),
        setrand(Seed),
	format('~n Used Seed for Insert is ~w~n',[Seed]),
        datagenerator(KeyType,ValueType,Size,Keys,Values),
        format('~n Data is ready ~n',[]),
        accInsert(DatastructureType,time,Keys,Values,Repetitions,[],Result),
        confiAndMean(Result,Confi,Mean).

accInsert(_,_,_,_,0,R,R).
accInsert(DatastructureType,Measurement,Keys,Values,X,Acc,Result):-
        insert(DatastructureType,Measurement,Keys,Values,R),
        print(.),
        clean(DatastructureType,Keys),
        Xnew is X-1,
        accInsert(DatastructureType,Measurement,Keys,Values,Xnew,[R|Acc],Result).



/*Storage*/

tabelleStorage(Datastructure,GC,Times,Seed,Keytype,Valuetype) :-
	set_prolog_flag(gc,GC),
	setrand(Seed),
        datagenerator(Keytype,Valuetype,Times,Keys,Values),
        trimcore,
        insert(Datastructure,global_stack_used,Keys,Values,Global),
        clean(Datastructure,Keys),
        trimcore,
        insert(Datastructure,local_stack_used,Keys,Values,Local),
        clean(Datastructure,Keys),
        trimcore,
        insert(Datastructure,trail_used,Keys,Values,Trail),
        clean(Datastructure,Keys),
	trimcore,
	insert(Datastructure,heap,Keys,Values,Heap),
	clean(Datastructure,Keys),
	trimcore,
        insert(Datastructure,garbage,Keys,Values,Garbage),
        clean(Datastructure,Keys),
        trimcore,
        format('~n Datastructure ~w Times ~w Global ~w Local ~w Trail ~w Heap ~w Garbage ~w ~n',[Datastructure,Times,Global,Local,Trail,Heap,Garbage]).

storageInsert(_,_,[],_,_,_).

storageInsert(Datastructure, GC, [H|T], Seed, Keytype,Valuetype) :-
        tabelleStorage(Datastructure,GC,H,Seed,Keytype,Valuetype),
        storageInsert(Datastructure,GC,T,Seed,Keytype,Valuetype).

/* Get */

	
getMeasurement(Datastructure,KeyType,ValueType,Order,SizeTotal,SizeGet,Repetitions):-
	seedInGet([64,42,random(26010,5548,23873,425005073),random(28499,25560,28471,425005073),random(22138,25686,18390,425005073), random(5844,16882,29420,425005073), random(30131,26455,14300,425005073), random(25476,15079,18343,425005073),random(6107,20268,13873,425005073),random(8660,29600,25519,425005073), random(25009,13268,28234,425005073), random(8515,19614,3128,425005073)],Datastructure,KeyType,ValueType,Order,SizeTotal,SizeGet,Repetitions).
	
	
seedInGet([],_,_,_,_,_,_,_).

seedInGet([Seed|V],Datastructure,KeyType,ValueType,Order,SizeTotal,SizeGet,Repetitions) :-
        get(Mean,Confi,Datastructure,on,Seed,SizeTotal,SizeGet,KeyType,ValueType,Order,Repetitions),
        format('~n Get in ~w mit KeyType: ~w Zugriff: ~w Mean: ~w Confi: ~w ~n',[Datastructure,KeyType,Order,Mean,Confi]),
        seedInGet(V,Datastructure,KeyType,ValueType,Order,SizeTotal,SizeGet,Repetitions).

get(Mean,Confi,DatastructureType,GC,Seed,Size,ToGet,KeyType,ValueType,AccessType,Repetitions):-
        set_prolog_flag(gc,GC),
        setrand(Seed),
	format('~n Used Seed for Get is ~w~n',[Seed]),
        datagenerator(KeyType,ValueType,Size,Keys,Values),
        insertBack(DatastructureType,Keys,Values,Datastructure),
        setrand(Seed), 
	datagenerator(AccessType,Keys,ToGet,GetKeys),
        format('~n Data is ready ~n',[]),
        accGet(DatastructureType,time,GetKeys,Datastructure,Repetitions,[],Result),
        clean(DatastructureType,Keys),
        confiAndMean(Result,Confi,Mean).

accGet(_,_,_,_,0,R,R).
accGet(DatastructureType,Measurement,GetKeys,Datastructure,X,Acc,Result):-
        get(DatastructureType,Measurement,GetKeys,Datastructure,R),
        print(.),
        Xnew is X-1,
        accGet(DatastructureType,Measurement,GetKeys,Datastructure,Xnew,[R|Acc],Result).
 

/* Update*/
updateMeasurement(Datastructure,Keytype,ValueType,Order,SizeTotal,SizeUpdate,Repetitions) :-
	seedInUpd([64,42,random(26010,5548,23873,425005073),random(28499,25560,28471,425005073),random(22138,25686,18390,425005073), random(5844,16882,29420,425005073), random(30131,26455,14300,425005073), random(25476,15079,18343,425005073),random(6107,20268,13873,425005073),random(8660,29600,25519,425005073), random(25009,13268,28234,425005073), random(8515,19614,3128,425005073)],Datastructure,Keytype,ValueType,Order,SizeTotal,SizeUpdate,Repetitions).

seedInUpd([],_,_,_,_,_,_,_).

seedInUpd([Seed|V],Datastructure,Keytype,ValueType,Order,SizeTotal,SizeUpdate,Repetitions) :-
        update(Mean,Confi,Datastructure,on,Seed,SizeTotal,SizeUpdate,Keytype,ValueType,Order,Repetitions,_),
        format('~nUpdaten in ~w mit Mean: ~w Confi: ~w ~n',[Datastructure,Mean,Confi]),
        seedInUpd(V,Datastructure,Keytype,ValueType,Order,SizeTotal,SizeUpdate,Repetitions).
        
        
update(Mean,Confi,DatastructureType,GC,Seed,Size,ToUpdate,KeyType,ValueType,AccessType,Repetitions,Result):-
        set_prolog_flag(gc,GC),
        setrand(Seed),
	format('~n Used Seed for Update is ~w~n',[Seed]),
        datagenerator(KeyType,integer,Size,Keys,Values),
        insertBack(DatastructureType,Keys,Values,Datastructure),
        setrand(Seed),
	datagenerator(AccessType,Keys,ToUpdate,UpdateKeys),
        format('~n Data is ready ~n',[]),
	data(ValueType,ToUpdate,UpdateValues),
        accUpdate(DatastructureType,time,UpdateKeys,UpdateValues,Datastructure,Repetitions,[],Result),
        clean(DatastructureType,Keys),
        confiAndMean(Result,Confi,Mean).

accUpdate(_,_,_,_,_,0,R,R).
accUpdate(DatastructureType,Measurement,UpdateKeys,UpdateValues,Datastructure,X,Acc,Result):-
	update(DatastructureType,Measurement,UpdateKeys,UpdateValues,Datastructure,R),
        print(.),
        Xnew is X-1,
        accUpdate(DatastructureType,Measurement,UpdateKeys,UpdateValues,Datastructure,Xnew,[R|Acc],Result).


/* Remove */
removeMeasurement(Datastructure,SizeTotal,SizeRemove,KeyType,ValueType,Order,Repetitions) :-
	seedInRemove([64,42,random(26010,5548,23873,425005073),random(28499,25560,28471,425005073),random(22138,25686,18390,425005073), random(5844,16882,29420,425005073), random(30131,26455,14300,425005073), random(25476,15079,18343,425005073),random(6107,20268,13873,425005073),random(8660,29600,25519,425005073), random(25009,13268,28234,425005073), random(8515,19614,3128,425005073)],Datastructure,SizeTotal,SizeRemove,KeyType,ValueType,Order,Repetitions).
       
seedInRemove([],_,_,_,_,_,_,_).

seedInRemove([Seed|V],Datastructure,SizeTotal,SizeRemove,KeyType,ValueType,Order,Repetitions) :-
        remove(Mean,Confi,Datastructure,on,Seed,SizeTotal,SizeRemove,KeyType,ValueType,random,Repetitions,_),
        format('~n Entfernen in ~w mit Mean: ~w Confi: ~w ~n',[Datastructure,Mean,Confi]),
        seedInRemove(V,Datastructure,SizeTotal,SizeRemove,KeyType,ValueType,Order,Repetitions). 

remove(Mean,Confi,DatastructureType,GC,Seed,Size,ToRemove,KeyType,ValueType,AccessType,Repetitions,Result):-
        set_prolog_flag(gc,GC),
        setrand(Seed),
	format('~n Used Seed for Remove is ~w~n',[Seed]),
        datagenerator(KeyType,ValueType,Size,Keys,Values),
        setrand(Seed),
	datageneratorRest(AccessType,Keys,ToRemove,RemoveKeys,NotRemovedKeys),
        format('~n Data is ready ~n',[]),
        accRemove(DatastructureType,time,RemoveKeys,NotRemovedKeys,Keys,Values,Repetitions,[],Result),
        confiAndMean(Result,Confi,Mean).

accRemove(_,_,_,_,_,_,0,R,R).
accRemove(DatastructureType,Measurement,RemoveKeys,NotRemovedKeys,Keys,Values,X,Acc,Result):-
        insertBack(DatastructureType,Keys,Values,Datastructure),
	remove(DatastructureType,Measurement,RemoveKeys,Datastructure,R),
        clean(DatastructureType,NotRemovedKeys),
        print(.),
        Xnew is X-1,
        accRemove(DatastructureType,Measurement,RemoveKeys,NotRemovedKeys,Keys,Values,Xnew,[R|Acc],Result).






