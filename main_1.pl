% paerioritaet(dame, Preaoritaet):-
%     Preaoritaet =:= 5.

% paerioritaet(turm, Preaoritaet):-
%     Preaoritaet =:= 4.

% preaoritaet(springer, Preaoritaet):-
%     Preaoritaet =:= 3.

% preaoritaet(laeufer, Preaoritaet):-
%     Preaoritaet =:= 2.

% paerioritaet(koenig, Preaoritaet):-
%     Preaoritaet =:= 1.

% Hilfsfunktion zum erstellen leerer Listen
leere_liste([]).

% Hilfsfunktion zum erstellen einer Figur
figur(Figur, Figur):-
    member(Figur, [koenig, turm]).

% Erlaubte Form einer Figur
figur(Figur, X, Y):-
    member(Figur, [koenig, turm]),
    member(X, [1, 2, 3, 4, 5, 6, 7, 8]),
    member(Y, [1, 2, 3, 4, 5, 6, 7, 8]).

% Abfrage ob eine neue Figur auf dem Feld gesetzt werden soll
weite_figur(X):-
    writeln('Möchten Sie eine weite Figur hinzufügen? (j/n)'),
    read(Antwort),
    (Antwort == 'n' -> X is 0); X is 1. % 1 = ja, 0 = nein

% Abfragen welche Figur gesetzt werden soll und wo sie gesetzt werden soll
neue_figur([Figur,X, Y]):-
    writeln('Bitte geben Sie die Figur an: '),
    read(Figur),
    writeln('Bitte geben Sie die X-Position an: '),
    read(X),
    writeln('Bitte geben Sie die Y-Position an: '),
    read(Y),
    figur(Figur, X, Y). % Prüft ob die Figur gültig ist

% Started das Spiel
start :-
    leere_liste(Figuren),           % Leere Liste für Figuren
    hinzufuegen_loop(1, Figuren).   % Fügt Figuren hinzu
    % hinzufuegen_loop(0, [[turm, 1, 1], [koenig, 2, 2]]). % Fügt Figuren hinzu

% X -> 1, wenn eine weite Figur hinzugefügt werden soll
% X -> 0, wenn keine weite Figur hinzugefügt werden soll
% Figuren -> Liste der Figuren
hinzufuegen_loop(X, Figuren) :-
    X =\= 0,
    neue_figur(Figur),                          % Fragt nach der Figur
    weite_figur(X1),                            % Fragt nach ob eine weite Figur hinzugefügt werden soll
    hinzufuegen_loop(X1, [Figur|Figuren]), !.   % Fügt die Figur hinzu, wenn dies gewünscht ist, sonst bricht die Loop ab

% Wenn keine weite Figur hinzugefügt werden soll, dann wird hier weiter gemacht
hinzufuegen_loop(_, Figuren) :-
    writeln(Figuren),
    game_loop(Figuren).

game_loop(Figuren) :-
    writeln('Bitte geben Sie die X-Position an: '),
    read(X),
    writeln('Bitte geben Sie die Y-Position an: '),
    read(Y),
    figur(Koenig, koenig),
    figur(Koenig, X, Y),
    writeln(Figur).