# Evaluation von Datenstrukturen in Prolog

Dieses Repository wurde für die Messung der Laufzeit und Speicherplatzbelegung von Operationen auf ausgewählten Datenstrukturen in SICStus Prolog verwendet.
Die verwendeten Daten werden teilweise mit dem generate/2 Prädikat aus dem SICStus Prolog Fuzzer von J. Schmidt erstellt.(https://github.com/Joshua27/SICStusPrologFuzzer)

##Operationen
Die zu evaluierenden Operationen sind insert,get,update und remove. In den gleichnamigen Dateien befinden sich folgende Prozeduren, um abhängig der verwendeten Datenstruktur die richtigen Prädikate in der Datei datastructure.pl aufzurufen.
	- **insert(Datastructuretype,Measurement,Keys,Values,Result).**
	Ruft die durch 'Measurement' bestimmte Messung auf und übergibt den Aufruf der für die Datenstruktur passenden Prozedur mit den einzufügenden Keys und Values. Das Ergebnis der Messung wird in 'Result' zurückgegeben.
	- **insertBack(Datastructuretype,Keys,Values,Back).**
	Fügt Datenpaare bestehend aus den Einträgen in 'Keys' und 'Values' in die durch 'Datastructuretype' definierte Datenstruktur ein und gibt diese in Back zurück.
	- **get(Datastructuretype,Measurement,Keys,Datastructure, Result, Back).**
	Ruft die durch 'Measurement' bestimmte Messung auf und übergibt den Aufruf der für die Datenstruktur passenden Prozedur für das Unifizieren der 'Keys' mit den Daten in der befüllten Datenstruktur 'Datastructure'. Das Ergebnis der Messung wird in 'Result' zurückgegeben.
	- **update(Datastructuretype, Measurement,Keys,Values,Datastructure, Result).**
	Ruft die durch 'Measurement' bestimmte Messung auf und übergibt den Aufruf der für die Datenstruktur passenden Prozedur für das Updaten der 'Values' der 'Keys' in der befüllten Datenstruktur 'Datastructure'. Das Ergebnis der Messung wird in 'Result' zurückgegeben.
	- **remove(Datastructuretype,Measurement,Keys,Datastructure,Result).**
	Ruft die durch 'Measurement' bestimmte Messung auf und übergibt den Aufruf der für die Datenstruktur passenden Prozedur für das Entfernen der 'Keys' in der befüllten Datenstruktur 'Datastructure'. Das Ergebnis der Messung wird in 'Result' zurückgegeben.

##Datenstrukturen
Die zu evaluierende Datenstrukturen sind Assert, BB, Assoc, Avl, Mutdict, Logarr und das Mutarray.
Assert wurde angepasst, sodass ebenfalls Schlüssel-Wert-Paare eingefügt werden. Die Implementierungen befinden sich in der Datei datastructures.pl. Dort ist ebenfalls die Prozedur clean definiert. Diese dient dem manuellen Aufruf des Garbage Collectors oder dem Reinigen der Datenbasis von auf das Blackboard oder mittels assert eingefügten Daten. Die in datastructure.pl definierten Prozeduren werden aus der Datei timeAndStorage.pl heraus aufgerufen, um die Messung der Zeit und der Speicherbelegung direkt vor den Operationen starten zu können.

##Datentypen
Die verwendeten Datentypen sind:
	- ordIdx: Durchgehend aufsteigende Integer-Werte zwischen 1 bis N.
	- revIdx: Durchgehend absteigende Integer-Werte zwishen N bis 1.
	- unordIdx: zufällig gemischte, sich nicht wiederholende Integerwerte zwischen 1 bis N.
	- integer: Zufällige Integerwerte zwischen -20.000 und +20.000
	- atom: Zufällige Atome bestehend aus kleingeschriebenen Buchstaben
	- string: Listen zufälliger Länge bestehend aus Integern zwischen 33-126 die Buchstaben in Ascii-Code repräsentieren
	- atomNoDup: Wie atom, allerdings ohne Wiederholungen
	- stringNoDup: Wie string, allerdings ohne Wiederholungen

Die Datentypen wurden in der Datei datagenerator.pl definiert. Es gibt zudem die Parameter first, last und random, die für die Imitierung von Zugriffsreihenfolgen verwendet wurden:
	- first: Die ersten N Elemente einer Liste werden in einer Liste ausgegeben.
	- last: Die letzten N Elemente werden umgekehrt in einer Liste ausgegeben.
	- random: Die Elemente einer Liste werden gemischt und von diesen die ersten N ausgewählt und in einer Liste ausgegeben.
	
##Measurements

In der Datei timeAndStorage.pl wurden die verschiedenen möglichen Messungen definiert.Mögliche Parameter sind
	- time: misst die Laufzeit einer Prozedur
	- heap: Misst den Unterschied der Belegung des Heaps vor und nach dem ausführen einer Prozedur.
	- core: Misst den Unterschied des Prolog zugewiesenen Speichers vor und nach dem Ausführen einer Prozedur.
	- garbage: Misst den Unterschied der Anzahl der GC-Aufrufe, des befreiten Speichers und der für GC aufgewendeten zeit vor und nach dem Ausführen einer Prozedur.
	- Identisch verhalten sich die Parameter global_stack_used,local_stack_used,trail_used und choice_used
	
##Statistiken

In der Datei statistics.pl wurden Prozeduren definiert, um statistische Daten zu erhalten. So ist es möglich, das geometrische Mittel von Elementen einer Liste und das Konfidenzintervall zu berechnen.

## Datei evaluation.pl

Da ich für die Daten in der Bachelorarbeit verschiedene Seeds und mehrere Durchläufe pro Seed verwenden wollte, befinden sich in dieser Datei Konstrukte aus verschachtelten Akkumulatoren.
Der Aufbau ist pro Operation ähnlich: Es existiert ein Prädikat, welches Parameter übergeben bekommt und diese mit einer Liste an Seeds an einen Seed Akkumulator weitergibt. In diesem wird eine Funktion aufgerufen, die für die jeweilige zu untersuchende Operation die Daten erzeugt, den Seed setzt und einen Akkumulator aufruft, der dann die Durchläufe pro Seed durchführt und in dem auch die letztendliche zu untersuchende Operation aufgerufen wird.

##Datei dataForTheEvaluation.pl
Hier sind die Aufrufe der in evaluation.pl definierten Prädikate aufgelistet, die ich letztendlich für die Erzeugung der Daten in meiner Bachelorarbeit verwendet habe. 

**Eine Übersicht der möglichen zu verwendenden Parameter:**

  % Datastructures: assert, bb, assoc, avl, mutdict,logarr und mutarray
  % KeyTypes: ordIdx,unordIdx, revIdx,integer, atom, string, atomNoDup,stringNoDup
  % ValueTypes: integer, atom, string
  % StorageTypes:global_stack_used, local_stack_used, trail_used, choice_used, heap,garbage,core
  % AccessType: random, first, last

**Einige zusätzliche Anmerkungen:**

Das remove-Prädikat funktioniert lediglich für die Datenstrukturen assert,bb,avl und mutdict.
Die Datenstrukturen Mutarray und Logarr können nur mit den Datentypen ordIdx,revIdx und unordIdx als Schlüssel verwendet werden.


