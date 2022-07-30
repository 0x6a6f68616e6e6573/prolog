praeoritaet(dame, Praeoritaet):-
    Praeoritaet =:= 5.

praeoritaet(turm, Praeoritaet):-
    Praeoritaet =:= 4.

praeoritaet(springer, Praeoritaet):-
    Praeoritaet =:= 3.

praeoritaet(laeufer, Praeoritaet):-
    Praeoritaet =:= 2.

praeoritaet(koenig, Praeoritaet):-
    Praeoritaet =:= 1.

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
    Figuren is [],           % Leere Liste für Figuren
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

game_loop(Figuren_Weiss) :-
    writeln('Bitte geben Sie die X-Position an: '),
    read(X),
    writeln('Bitte geben Sie die Y-Position an: '),
    read(Y),
    figur(Koenig, koenig),
    figur(Koenig, X, Y),
    writeln(Figur),
    Zugreinfolge is [],
    zug_loop(1, Zugreinfolge, Figuren_Weiss, [[Koenig, X, Y]]).

bester_zug(Neuer_Zug, Zugreinfolge)

naechst_bester_zug(Neuer_Zug, Zugreinfolge, [Figur |Figuren_Weiss], Figuren_Schwarz) :-
    % Teste alle Züge für die aktuelle Figur und speichere den besten in Neuer_Zug
    zug(Figur, Figuren_Weiss, Figuren_Schwarz, Neuer_Zug),
    % Prüfe ob der neue Zug besser ist als der bisher beste
    (
        bester_zug(Neuer_Zug, Zugreinfolge) ->
        % Wenn der neue Zug besser ist, dann setze den neuen Zug als bisher besten Zug
        Zugreinfolge = [Neuer_Zug | _];
        % Wenn der neue Zug nicht besser ist, dann setze den neuen Zug als bisher besten Zug
        Zugreinfolge = [Neuer_Zug]
    ).

zug_auswahl_loop(Zugreinfolge, Figuren_Weiss, Figuren_Schwarz) :-
    naechst_bester_zug(Neuer_Zug, Zugreinfolge, Figuren_Weiss, Figuren_Schwarz),

    append(Neuer_Zug, Zugreinfolge).

zug_schwarz(X, Zugreinfolge, Figuren, [Koenig, X, Y]) :-
    % if matt / patt / tripple repetition, then X = 0

    X is 0.

zug_loop(X, Zugreinfolge, Figuren_Weiss, Figuren_Schwarz) :- 
    X =\= 0,
    zug_auswahl_loop(Zugreinfolge, Figuren_Weiss, Figuren_Schwarz),
    zug_schwarz(X, Zugreinfolge, Figuren_Weiss, Figuren_Schwarz),
    zug_loop(X, Zugreinfolge, Figuren_Weiss, Figuren_Schwarz).

zug_loop(_, _, _, _):-
    writeln('Spiel beendet.').