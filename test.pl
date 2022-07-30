
figur_aus_liste([Figur|_], Figur).


bewerte_zug(turm, X, Y, [_, Figur_Weiss_X, Figur_Weiss_Y], [_, Koenig_X, Koenig_Y], [Punkte, turm, X, Y]):-
    Koenig_Y == Y,
    Figur_Weiss_Y == Y,
    Koenig_X > Figur_Weiss_X,
    Figur_Weiss_X > X,
    Punkte is 1.

bewerte_zug_fuer_alle_figuren(Figur, X, Y, [], [], [_, Figur, X, Y]).

bewerte_zug_fuer_alle_figuren(Figur, X, Y, [Figur_Weiss|Figuren_Weiss], Figuren_Schwarz, [Punkte, Figur, X_neu, Y_neu]):-
    writeln(Figur_Weiss),
    figur_aus_liste(Figuren_Schwarz, Koenig_Schwarz),
    bewerte_zug(Figur, X, Y, Figur_Weiss, Koenig_Schwarz, [Punkte, Figur, X_neu, Y_neu]),
    writeln(Punkte),
    Punkte == 1;
    bewerte_zug_fuer_alle_figuren(Figur, X, Y, Figuren_Weiss, Figuren_Schwarz, [Punkte, Figur, X_neu, Y_neu]).

bewerte_zug_fuer_alle_figuren(Figur, _, _, _, _, [Punkte, Figur, _, _]):-
    writeln(Punkte).


:- 
    bewerte_zug_fuer_alle_figuren(turm, 2, 2, [ [turm, 5, 2], [turm,  4, 5]], [[koenig, 7, 2]], X),
    writeln(X).