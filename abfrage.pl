% Hilfsfunktionen
leere_liste([]).
intervall(X, Y):-
    member(X, [1, 2, 3, 4, 5, 6, 7, 8]),
    member(Y, [1, 2, 3, 4, 5, 6, 7, 8]).

element_aus_liste([X|_], X).  % Gibt die Figur aus der Liste zurück ohne die Liste zu ändern

% ----- ----- ----- ----- -----
% Figuren erstellungs- und -verwaltungs-funktionen

% Prüft ob die Figur gültig ist
figur(Figur, X, Y):-
    member(Figur, [koenig, turm]),
    intervall(X, Y).

% Erstellt eine neue Figur
% Abfragen welche Figur erstellt werden soll und wo sie gesetzt werden soll
neue_figur([Figur,X, Y]):-
    writeln('Bitte geben Sie die Figur an: '),
    read(Figur),
    writeln('Bitte geben Sie die X-Position an: '),
    read(X),
    writeln('Bitte geben Sie die Y-Position an: '),
    read(Y),
    figur(Figur, X, Y). % Prüft ob die Figur gültig ist

% Abfrage ob eine weitere Figur erstellt werden soll
weitere_figur(Figuren, Figuren):-                               % Setzt Figuren auf End_Figuren
    writeln('Möchten Sie eine weite Figur hinzufügen? (j/n)'),  % Abfrage ob weitere Figur hinzugefügt werden soll
    read(Antwort),                                              
    Antwort == 'n'.                                             % Prüft ob noch weitere Figuren gesetzt werden sollen oder nicht

% Wenn die Antwort ja ist, wird die Abfrage wiederholt
weitere_figur(Figuren, End_Figuren):-           % Figuren - Liste mit allen Figuren vor dem Eintragen der neuen Figur | End_Figuren - Liste mit allen Figuren nach dem Eintragen der neuen Figur
    neue_figur(Figur),                          % Fragt nach der Figur
    append(Figuren, [Figur], Neue_Figuren),     % Fügt die Figur zu den vorhandenen hinzu
    weitere_figur(Neue_Figuren, End_Figuren).   % Fragt nach weiteren Figuren

% ----- ----- ----- ----- -----

bewerte_zug(turm, X, Y, [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte):-
    Koenig_Y == Y,
    Figur_Weiss_Y == Y,
    Koenig_X < Figur_Weiss_X,
    Figur_Weiss_X < X,
    Punkte is 1.

bewerte_zug(turm, X, Y, [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte):-
    Koenig_Y == Y,
    Figur_Weiss_Y == Y,
    Koenig_X > Figur_Weiss_X,
    Figur_Weiss_X > X,
    Punkte is 1.

bewerte_zug(turm, X, Y, [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte):-
    Koenig_X == X,
    Figur_Weiss_X == X,
    Koenig_Y > Figur_Weiss_Y,
    Figur_Weiss_Y > Y,
    Punkte is 1.

bewerte_zug(turm, X, Y, [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], Punkte):-
    Koenig_X == X,
    Figur_Weiss_X == X,
    Koenig_Y < Figur_Weiss_Y,
    Figur_Weiss_Y < Y,
    Punkte is 1.

bewerte_zug(turm, X, _, _, [_, Koenig_X, _], Punkte):-
    Koenig_X == X,
    Punkte is 2.

bewerte_zug(turm, _, Y, _, [_, _, Koenig_Y], Punkte):-
    Koenig_Y == Y,
    Punkte is 2.

bewerte_zug(_, _, _, _, _, Punkte):-
    Punkte is 0.

% ----- ----- ----- ----- -----

bewerte_zug_fuer_alle_figuren(Figur, X, Y, [Figur_Weiss], Figuren_Schwarz, Punkte):- 
    element_aus_liste(Figuren_Schwarz, Koenig_Schwarz),
    bewerte_zug(Figur, X, Y, Figur_Weiss, Koenig_Schwarz, Punkte).

bewerte_zug_fuer_alle_figuren(Figur, X, Y, [Figur_Weiss|Figuren_Weiss], Figuren_Schwarz, Punkte):-
    element_aus_liste(Figuren_Schwarz, Koenig_Schwarz),
    bewerte_zug(Figur, X, Y, Figur_Weiss, Koenig_Schwarz, Punkte),
    Punkte == 1;    % Wenn der Zug eine Figur schlagen kann, check ob der Zug blockiert wird
    bewerte_zug_fuer_alle_figuren(Figur, X, Y, Figuren_Weiss, Figuren_Schwarz, Punkte).

% ----- ----- ----- ----- -----

zug([turm, X_alt, Y_alt], [X_new, Y_new]):-
    X_new is X_alt + 1, Y_new is Y_alt, intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], [X_new, Y_new]):-
    X_new is X_alt, Y_new is Y_alt + 1, intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], [X_new, Y_new]):-
    X_new is X_alt - 1, Y_new is Y_alt, intervall(X_new, Y_new).

zug([turm, X_alt, Y_alt], [X_new, Y_new]):-
    X_new is X_alt, Y_new is Y_alt - 1, intervall(X_new ,Y_new).

% ----- ----- ----- ----- -----

zug_schlaegt([Punkte|_]):- Punkte == 2. 

% bester_zug_weiss([Figur|Rest], Figuren_Weiss, Figuren_Schwarz, Zug):-
%     zug(Figur, Figuren_Weiss, Figuren_Schwarz, Zug),
%     zug_schlaegt(Zug),
%     bester_zug_weiss(Rest, Figuren_Weiss, Figuren_Schwarz, Zug).


% bewege_weiss(Figuren_Weiss, Figuren_Schwarz):-
%     bester_zug_weiss(Figuren_Weiss, Figuren_Weiss, Figuren_Schwarz, Bester_Zug),
%     bewege_figur(Bester_Zug, Figuren_Weiss).


% schach(Figuren_Weiss, Figuren_Schwarz):-
%     bewege_weiss(Figuren_Weiss, Figuren_Schwarz),
%     bewege_schwarz(Figuren_Schwarz, Figuren_Weiss, Figuren_Schwarz, Figuren_Schwarz),
%     schach_pruefen(Figuren_Weiss, Figuren_Schwarz),
%     schach(Figuren_Weiss, Figuren_Schwarz).

% ----- ----- ----- ----- -----

:- 
    bewerte_zug_fuer_alle_figuren(turm, 2, 3, [[turm,  4, 5], [turm, 5, 2]], [[koenig, 7, 2]], X),
    writeln(X).

    % leere_liste(Figuren),                       % Setzt Figuren auf leere Liste
    % neue_figur(Figur),                          % Fragt nach der ersten Figur
    % append([Figur], Figuren, Neue_Figuren),     % Fügt die Figur zu der Liste hinzu
    % weitere_figur(Neue_Figuren, Figuren_Weiss), % Fragt nach weiteren Figuren
    % neue_figur(Koenig_Schwarz),                 % Fragt nach der ersten Figur

    % Figuren_Weiss = [[turm,1,1],[turm,2,2]],
    % Koenig_Schwarz = [koenig,4,4],
    
    % Figuren_Schwarz = [Koenig_Schwarz],
    % leere_liste(Zugreihenfolge_Weiss),
    % leere_liste(Zugreihenfolge_Schwarz),
    % schach(Figuren_Weiss, Figuren_Schwarz).