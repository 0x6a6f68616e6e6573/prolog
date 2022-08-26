% Hilfsfunktionen
leere_liste([]).
intervall(X, Y) :-
    % member(X, [1, 2, 3, 4, 5, 6, 7, 8]),
    % member(Y, [1, 2, 3, 4, 5, 6, 7, 8]).
    member(X, [1, 2, 3, 4, 5]),
    member(Y, [1, 2, 3, 4, 5]).

entferne_element_von_liste(_, [], []).
entferne_element_von_liste(Element, [Element|Rest], Rest).
entferne_element_von_liste(Element, [Kopf|Rest], [Kopf|Rest_2]) :-
    Kopf\=Element,
    entferne_element_von_liste(Element, Rest, Rest_2).

kleinste_zahl_in_liste([Zahl|Rest], Kleinstes) :-
    kleinste_zahl_in_liste(Rest, Zahl, Kleinstes).

kleinste_zahl_in_liste([], Kleinstes, Kleinstes).
kleinste_zahl_in_liste([Zahl|Rest], Kleinstes_0, Kleinstes) :-
    Kleinstes_1 is min(Zahl, Kleinstes_0),
    kleinste_zahl_in_liste(Rest, Kleinstes_1, Kleinstes).

% ----- ----- ----- ----- -----
% groesste_zahl_in_liste([Zahl|Rest], Groesste) :-
%     groesste_zahl_in_liste(Rest, Zahl, Groesste).

% groesste_zahl_in_liste([], Groesste, Groesste).
% groesste_zahl_in_liste([Zahl|Rest], Groesste_0, Groesste) :-
%     Groesste_1 is max(Zahl, Groesste_0),
%     groesste_zahl_in_liste(Rest, Groesste_1, Groesste).

% ----- ----- ----- ----- -----
elemente_gleich([ElementX, _, ElementX|_]).
elemente_gleich([ElementX, ElementY, ElementX, ElementY|_]).
elemente_gleich([ElementX, ElementY, ElementZ, ElementX, ElementY, ElementZ|_]).

% ----- ----- ----- ----- -----
% Figuren erstellungs- und -verwaltungs-funktionen

% Prüft ob die Figur gültig ist
figur(Figur, X, Y) :-
    member(Figur, [koenig, turm]),
    intervall(X, Y).

% Erstellt eine neue Figur
% Abfragen welche Figur erstellt werden soll und wo sie gesetzt werden soll
neue_figur([Figur, X, Y]) :-
    writeln('Bitte geben Sie die Figur an: '),
    read(Figur),
    writeln('Bitte geben Sie die X-Position an: '),
    read(X),
    writeln('Bitte geben Sie die Y-Position an: '),
    read(Y),
    figur(Figur, X, Y). % Prüft ob die Figur gültig ist

% Abfrage ob eine weitere Figur erstellt werden soll
weitere_figur(Figuren, Figuren) :-                               % Setzt Figuren auf End_Figuren
    writeln('Möchten Sie eine weite Figur hinzufügen? (j/n)'),  % Abfrage ob weitere Figur hinzugefügt werden soll
    read(Antwort),
    Antwort==n.                                             % Prüft ob noch weitere Figuren gesetzt werden sollen oder nicht

% Wenn die Antwort ja ist, wird die Abfrage wiederholt
weitere_figur(Figuren, End_Figuren) :-           % Figuren - Liste mit allen Figuren vor dem Eintragen der neuen Figur | End_Figuren - Liste mit allen Figuren nach dem Eintragen der neuen Figur
    neue_figur(Figur),                          % Fragt nach der Figur
    append(Figuren, [Figur], Neue_Figuren),     % Fügt die Figur zu den vorhandenen hinzu
    weitere_figur(Neue_Figuren, End_Figuren).   % Fragt nach weiteren Figuren

% ----- ----- ----- ----- -----
bewerte(_, [], _, Liste, Liste).

bewerte(Figur, [Figur_Weiss|Rest], Koenig_Schwarz, Liste, Liste_Ende) :-
    bewerte_zug(Figur, Figur_Weiss, Koenig_Schwarz, Punkte),
    append(Liste, [Punkte], Liste_neu),
    bewerte(Figur, Rest, Koenig_Schwarz, Liste_neu, Liste_Ende).

bewerte_zug_mit_figuren(Figur, Figuren_Weiss, Koenig_Schwarz, Punkte) :-
    bewerte(Figur, Figuren_Weiss, Koenig_Schwarz, [], PunkteListe),
    kleinste_zahl_in_liste(PunkteListe, Punkte).

bewerte_zug([turm, X, Y], [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte) :-
    Koenig_Y=:=Y,
    Figur_Weiss_Y=:=Y,
    Koenig_X<Figur_Weiss_X,
    Figur_Weiss_X<X,
    Punkte=1, !.

bewerte_zug([turm, X, Y], [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte) :-
    Koenig_Y=:=Y,
    Figur_Weiss_Y=:=Y,
    Koenig_X>Figur_Weiss_X,
    Figur_Weiss_X>X,
    Punkte=1, !.

bewerte_zug([turm, X, Y], [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte) :-
    Koenig_X=:=X,
    Figur_Weiss_X=:=X,
    Koenig_Y>Figur_Weiss_Y,
    Figur_Weiss_Y>Y,
    Punkte=1, !.

bewerte_zug([turm, X, Y], [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte) :-
    Koenig_X=:=X,
    Figur_Weiss_X=:=X,
    Koenig_Y<Figur_Weiss_Y,
    Figur_Weiss_Y<Y,
    Punkte=1, !.

% ----- ----- ----- ----- -----
bewerte_zug([turm, X, _], _, [_, Koenig_X, _], Punkte) :-
    Koenig_X=:=X,
    Punkte=2, !.

bewerte_zug([turm, _, Y], _, [_, _, Koenig_Y], Punkte) :-
    Koenig_Y=:=Y,
    Punkte=2, !.

% ----- ----- ----- ----- -----
bewerte_zug([koenig, X, Y], [turm, Figur_Weiss_X, Figur_Weiss_Y], _, Punkte) :-
    X=\=Figur_Weiss_X,
    Y=\=Figur_Weiss_Y,
    Punkte=1, !.

% bewerte_zug([koenig, X, Y], [turm, Figur_Weiss_X, Figur_Weiss_Y], _, Punkte) :-
%     X=:=Figur_Weiss_X,
%     Y=\=Figur_Weiss_Y,
%     Punkte=2, !.

% ----- ----- ----- ----- -----
bewerte_zug([_, _, _], _, [_, _, _], Punkte) :-
    Punkte=0.

% ----- ----- ----- ----- -----
richtungen(turm, [hoch, rechts, runter, links]).
richtungen(koenig, [hoch, hoch_rechts, rechts, runter_rechts, runter, runter_links, links, hoch_links]).

zug([turm, X_alt, Y_alt], hoch, [X_new, Y_new]) :-
    X_new is X_alt,
    Y_new is Y_alt-1,
    intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], rechts, [X_new, Y_new]) :-
    X_new is X_alt+1,
    Y_new is Y_alt,
    intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], runter, [X_new, Y_new]) :-
    X_new is X_alt,
    Y_new is Y_alt+1,
    intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], links, [X_new, Y_new]) :-
    X_new is X_alt-1,
    Y_new is Y_alt,
    intervall(X_new, Y_new).

% ----- ----- ----- ----- -----
zug([koenig, X_alt, Y_alt], hoch, [X_neu, Y_neu]) :-
    X_neu is X_alt,
    Y_neu is Y_alt-1,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], hoch_rechts, [X_neu, Y_neu]) :-
    X_neu is X_alt+1,
    Y_neu is Y_alt-1,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], rechts, [X_neu, Y_neu]) :-
    X_neu is X_alt+1,
    Y_neu is Y_alt,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], runter_rechts, [X_neu, Y_neu]) :-
    X_neu is X_alt+1,
    Y_neu is Y_alt+1,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], runter, [X_neu, Y_neu]) :-
    X_neu is X_alt,
    Y_neu is Y_alt+1,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], runter_links, [X_neu, Y_neu]) :-
    X_neu is X_alt-1,
    Y_neu is Y_alt+1,
    intervall(X_neu, Y_neu).
    
zug([koenig, X_alt, Y_alt], links, [X_neu, Y_neu]) :-
    X_neu is X_alt-1,
    Y_neu is Y_alt,
    intervall(X_neu, Y_neu).

zug([koenig, X_alt, Y_alt], hoch_links, [X_neu, Y_neu]) :-
    X_neu is X_alt-1,
    Y_neu is Y_alt-1,
    intervall(X_neu, Y_neu).


% ----- ----- ----- ----- -----
zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, Richtung, [Punkte, X_neu, Y_neu], MinimalerWert) :-
    zug([Figur, X, Y], Richtung, [X_neu, Y_neu]),
    not(member([_, X_neu, Y_neu], Figuren_Weiss)),  % Wenn die neue Position, die einer Figur ist, dann wird die ganze Spur abgebrochen
    not(member([_, X_neu, Y_neu], [Koenig_Schwarz])),
    bewerte_zug_mit_figuren([Figur, X_neu, Y_neu],
                            Figuren_Weiss,
                            Koenig_Schwarz,
                            Punkte),
    Punkte>=MinimalerWert.

zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, Richtung, [Punkte, X_neu, Y_neu], MinimalerWert) :-
    zug([Figur, X, Y], Richtung, [X_n, Y_n]),
    not(member([_, X_n, Y_n], Figuren_Weiss)),  % Wenn die neue Position, die einer Figur ist, dann wird die ganze Spur abgebrochen
    not(member([_, X_n, Y_n], [Koenig_Schwarz])),
    zuege([Figur, X_n, Y_n],
          Figuren_Weiss,
          Koenig_Schwarz,
          Richtung,
          [Punkte, X_neu, Y_neu],
          MinimalerWert).

alle_zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, [Richtung|_], [Punkte, X_neu, Y_neu], MinimalerWert) :-
    zuege([Figur, X, Y],
          Figuren_Weiss,
          Koenig_Schwarz,
          Richtung,
          [Punkte, X_neu, Y_neu],
          MinimalerWert),
    Punkte>=MinimalerWert.

alle_zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, [_|Rest], [Punkte, X_neu, Y_neu], MinimalerWert) :-
    alle_zuege([Figur, X, Y],
               Figuren_Weiss,
               Koenig_Schwarz,
               Rest,
               [Punkte, X_neu, Y_neu],
               MinimalerWert).

versuche_zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, Ergebnis) :-
    richtungen(Figur, Richtungen),
    alle_zuege([Figur, X, Y],
               Figuren_Weiss,
               Koenig_Schwarz,
               Richtungen,
               Ergebnis,
               2).


versuche_zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, Ergebnis) :-
    richtungen(Figur, Richtungen),
    alle_zuege([Figur, X, Y],
               Figuren_Weiss,
               Koenig_Schwarz,
               Richtungen,
               Ergebnis,
               1).

                        
versuche_zuege([Figur, X, Y], Figuren_Weiss, Koenig_Schwarz, Ergebnis) :-
    richtungen(Figur, Richtungen),
    alle_zuege([Figur, X, Y],
               Figuren_Weiss,
               Koenig_Schwarz,
               Richtungen,
               Ergebnis,
               0).

% ----- ----- ----- ----- -----
versuche_zuege_fuer_alle([Figur|_], Figuren_Weiss, Koenig_Schwarz, [Figur, Punkte, X, Y]) :-
    versuche_zuege(Figur,
                   Figuren_Weiss,
                   Koenig_Schwarz,
                   [Punkte, X, Y]),
    Punkte>=2.

versuche_zuege_fuer_alle([Figur|_], Figuren_Weiss, Koenig_Schwarz, [Figur, Punkte, X, Y]) :-
    versuche_zuege(Figur,
                   Figuren_Weiss,
                   Koenig_Schwarz,
                   [Punkte, X, Y]),
    Punkte>=1.

versuche_zuege_fuer_alle([Figur|_], Figuren_Weiss, Koenig_Schwarz, [Figur, Punkte, X, Y]) :-
    entferne_element_von_liste(Figur, Figuren_Weiss, Figuren),
    versuche_zuege(Figur,
                   Figuren,
                   Koenig_Schwarz,
                   [Punkte, X, Y]),
    Punkte>=0.

versuche_zuege_fuer_alle([_|Rest], Figuren_Weiss, Koenig_Schwarz, Ergebnis) :-
    versuche_zuege_fuer_alle(Rest, Figuren_Weiss, Koenig_Schwarz, Ergebnis).
% ----- ----- ----- ----- -----
ist_gedeckt(_, []) :- !,
    false.

ist_gedeckt([_, Figur_X, _], [[_, Figur_Weiss_X, _]|_]) :-
    Figur_X=:=Figur_Weiss_X.

ist_gedeckt([_, _, Figur_Y], [[_, _, Figur_Weiss_Y]|_]) :-
    Figur_Y=:=Figur_Weiss_Y.

ist_gedeckt(Figur, [_|Rest]) :-
    ist_gedeckt(Figur, Rest).
        
kann_schlagen([_, X, Y], Figuren_Weiss, Figur_Weiss) :-
    member([_, X, Y], Figuren_Weiss),
    findall(O,
            ( member(O, Figuren_Weiss), % Prüfe für alle Figuren
              member([_, X, Y], [O])    % Ob der König die selbe position wie eine Figur hat.
            ),
            [Figur_Weiss|_]),
    entferne_element_von_liste(Figur_Weiss, Figuren_Weiss, Figuren_Weiss_Neu),
    not(ist_gedeckt(Figur_Weiss, Figuren_Weiss_Neu)).
    
% ----- ----- ----- ----- -----
zug_schwarz(_, _, [], [Punkte, _, _]) :-
    Punkte is -1, !,
    true.

zug_schwarz(Figuren_Weiss, [Figur, X, Y], [Richtung|_], [Punkte, X_neu, Y_neu]) :-
    zug([Figur, X, Y], Richtung, [X_neu, Y_neu]),
    not(member([_, X_neu, Y_neu], Figuren_Weiss)),
    bewerte_zug_mit_figuren([Figur, X_neu, Y_neu],
                            Figuren_Weiss,
                            [Figur, X_neu, Y_neu],
                            Punkte),
    Punkte>0.

zug_schwarz(Figuren_Weiss, [Figur, X, Y], [Richtung|_], [Punkte, X_neu, Y_neu]) :-
    zug([Figur, X, Y], Richtung, [X_neu, Y_neu]),
    member([_, X_neu, Y_neu], Figuren_Weiss),
    kann_schlagen([koenig, X_neu, Y_neu], Figuren_Weiss, _),
    Punkte=3.

    
zug_schwarz(Figuren_Weiss, Koenig_Schwarz, [_|Rest], Ergebnis) :-
    zug_schwarz(Figuren_Weiss, Koenig_Schwarz, Rest, Ergebnis).

% ----- ----- ----- ----- -----
figuren(1, Figuren_Weiss, _, Figuren_Weiss_Neu) :-
    append([], Figuren_Weiss, Figuren_Weiss_Neu).

figuren(3, Figuren_Weiss, Koenig_Schwarz, Figuren_Weiss_Neu) :-
    kann_schlagen(Koenig_Schwarz, Figuren_Weiss, Figur_Weiss),
    entferne_element_von_liste(Figur_Weiss, Figuren_Weiss, Figuren_Weiss_Neu),
    writeln(Figur_Weiss+"Geschlagen").

figur(3, _, _, _).


schach(Figuren_Weiss, Koenig_Schwarz, Zugreihenfolge_Weiss, Zugreihenfolge_Schwarz) :-
    versuche_zuege_fuer_alle(Figuren_Weiss,
                             Figuren_Weiss,
                             Koenig_Schwarz,
                             
                             [ [Figur, X, Y],
                               _,
                               X_neu,
                               Y_neu
                             ]),
    writeln("Weiss: "+[Figur, X, Y]+" => "+[Figur, X_neu, Y_neu]),
    append([[turm, X, Y, X_neu, Y_neu]],
           Zugreihenfolge_Weiss,
           Zugreihenfolge_Weiss_neu),
    not(elemente_gleich(Zugreihenfolge_Weiss_neu)),
    entferne_element_von_liste([Figur, X, Y],
                               Figuren_Weiss,
                               Figuren_Weiss_Neu),
    append(Figuren_Weiss_Neu, [[Figur, X_neu, Y_neu]], Figuren_Weiss_Ende),
    richtungen(koenig, Richtungen), !,   % deactive backtracing, für bessere beendung bei Schach Matt
    zug_schwarz(Figuren_Weiss_Ende,
                Koenig_Schwarz,
                Richtungen,
                [Punkte, Koenig_X, Koenig_Y]), !,   % deactive backtracing, für bessere beendung bei Schach Matt
    Punkte=\= -1,
    figuren(Punkte, Figuren_Weiss_Ende, [koenig, Koenig_X, Koenig_Y], Figuren_Weiss_Neusten),
    writeln("Schwarz: "+Koenig_Schwarz+" => "+[koenig, Koenig_X, Koenig_Y]),
    append([[Koenig_Schwarz, Koenig_X, Koenig_Y]], Zugreihenfolge_Schwarz, Zugreihenfolge_Schwarz_neu),
    schach(Figuren_Weiss_Neusten, [koenig, Koenig_X, Koenig_Y], Zugreihenfolge_Weiss_neu, Zugreihenfolge_Schwarz_neu).

% ----- ----- ----- ----- -----
spiel(Figuren_Weiss, Koenig_Schwarz, Zugreihenfolge_Weiss, Zugreihenfolge_Schwarz) :-
    schach(Figuren_Weiss, Koenig_Schwarz, Zugreihenfolge_Weiss, Zugreihenfolge_Schwarz).

spiel(_, _, _, _) :-
    writeln("Schach Matt!").

% ----- ----- ----- ----- -----
run :- 
%     leere_liste(Figuren),                       % Setzt Figuren auf leere Liste
%    neue_figur(Figur),                          % Fragt nach der ersten Figur
%    append([Figur], Figuren, Neue_Figuren),     % Fügt die Figur zu der Liste hinzu
%    weitere_figur(Neue_Figuren, Figuren_Weiss), % Fragt nach weiteren Figuren
%    neue_figur(Koenig_Schwarz),                 % Fragt nach der ersten Figur
    Figuren_Weiss=[[turm, 1, 1], [turm, 1, 3], [turm, 3, 1]],
    Koenig_Schwarz=[koenig, 4, 5],
    leere_liste(Zugreihenfolge_Weiss),
    leere_liste(Zugreihenfolge_Schwarz),
    spiel(Figuren_Weiss, Koenig_Schwarz, Zugreihenfolge_Weiss, Zugreihenfolge_Schwarz).
