:- use_module(evaluation).

/* Im Folgenden werden anhand von Beispielen die Aufrufe aufgeführt, die für die Erzeugung der Daten in der Evaluation meiner Bachelorarbeit verwendet wurden. */

/*Tabelle 4.1
Datenstrukturen:Alle
Key: unordIdx,ordIdx
Value:integer,atom,string
Size: 100.000*/

%Bsp:  
?- insertMeasurement(assert,unordIdx,integer,100000,10).


/*Tabelle 4.2
Datenstrukturen: assert,bb,avl,mutidct,assoc
Key:stringNoDup,atomNoDup
Value: string, atom
Size:100.000 */


%Bsp: 
?- insertMeasurement(assert,stringNoDup,string,100000,100).


/* Tabelle 4.3
Datenstrukturen:Alle
Key:ordIdx,revIdx,unordIdx
Zugriff: random,first,last
SizeTotal: 200.000
SizeGet: 100.000 */

%Bsp:
?- getMeasurement(assert,ordIdx,integer,random,200000,100000,100).

/* Tabelle 4.4
Datenstrukturen: Alle
Key: unordIdx
Value: integer
Zugriff: ranom
SizeTotal: 200.000
SizeGet: 100.000 */

%Bsp:
?- updateMeasurement(assert,unordIdx,integer,random,200000,100000,100).

?- updateMeasurement(hamt,unordIdx,integer,random,200000,100000,10).


/* Tabelle 4.5
Datenstrukturen: assert,bb, avl,mutdict
Key: unordIdx
Value: integer
Zugriff: random
SizeTotal: 200.000
SizeGet: 100.000 */

%Bsp:
?- removeMeasurement(assert,200000,100000,unordIdx,integer,random,100).



/*Speicher */
/* Abbildung 4.1,4.2,4.3
Datenstrukturen: Alle mit Ausnahme des Mutarrays
Key: unordIdx
Value: integer*/
%Bsp:
?- storageInsert(hamt,on,[100000,200000,300000,400000,500000,600000,700000,800000,900000,1000000],random(26010,5548,23873,425005073),unordIdx,integer).

/* Abbildung 4.4.
Datenstrukturen: Assoc
Keys:ordIdx, unordIdx
Value: integer  */
?- storageInsert(assoc,on,[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000,12000,13000,14000,15000,16000,17000,18000,19000,20000],random(26010,5548,23873,425005073),unordIdx,integer).
?- storageInsert(assoc,on,[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000,12000,13000,14000,15000,16000,17000,18000,19000,20000],random(26010,5548,23873,425005073),ordIdx,integer).



