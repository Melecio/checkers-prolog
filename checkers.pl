inicializarTablero(Tablero) :-
    Tablero = [' ', '<', ' ', '<', ' ', '<', ' ', '<',
               '<<', ' ', '<', ' ', '<', ' ', '<', ' ',
               ' ', '<', ' ', '<', ' ', '<', ' ', '<',
               ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
               ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
               ' ', '>', ' ', '>', ' ', '>', ' ', '>',
               '>', ' ', '>', ' ', '>', ' ', '>', ' ',
               ' ', '>', ' ', '>', ' ', '>', ' ', '>'].


coordValidas(X1, Y1, X2, Y2, Casilla) :-
    Casilla = '<',
    X2 < 9,
    Y2 < 9,
    X1 < 9,
    Y1 < 9,
    (
    (X2 =:= X1+1, Y2 =:= Y1+1);
    (X2 =:= X1+1, Y2 =:= Y1-1)
    ).

coordValidas(X1, Y1, X2, Y2, Casilla) :-
    Casilla = '>',
    X2 < 9,
    Y2 < 9,
    X1 < 9,
    Y1 < 9,
    (
    (X2 =:= X1-1, Y2 =:= Y1+1);
    (X2 =:= X1-1, Y2 =:= Y1-1)
    ).
coordValidas(X1, Y1, X2, Y2, Casilla) :-
    Casilla = '<<',
    X2 < 9,
    Y2 < 9,
    X1 < 9,
    Y1 < 9,
    (
    (X2 =:= X1-1, Y2 =:= Y1-1);
    (X2 =:= X1-1, Y2 =:= Y1+1);
    (X2 =:= X1+1, Y2 =:= Y1+1);
    (X2 =:= X1+1, Y2 =:= Y1-1)
    ).
coordValidas(X1, Y1, X2, Y2, Casilla) :-
    Casilla = '>>',
    X2 < 9,
    Y2 < 9,
    X1 < 9,
    Y1 < 9,
    (
    (X2 =:= X1-1, Y2 =:= Y1-1);
    (X2 =:= X1-1, Y2 =:= Y1+1);
    (X2 =:= X1+1, Y2 =:= Y1+1);
    (X2 =:= X1+1, Y2 =:= Y1-1)
    ).

esTurno(Casilla, Turno) :-
    Casilla = '>',
    Casilla = Turno.
esTurno(Casilla, Turno) :-
    Casilla = '>>',
    Turno = '>'.
esTurno(Casilla, Turno) :-
    Casilla = '<<',
    Turno = '<'.
esTurno(Casilla, Turno) :-
    Casilla = '<',
    Casilla = Turno.
    
jugada(X1,Y1,X2,Y2) :-
    nb_getval(turno, Turno),
    nb_getval(tab, Tablero),
    element_at(Casilla, Tablero, (X1-1)*8+Y1),
    esTurno(Casilla, Turno),
    coordValidas(X1,Y1,X2,Y2, Casilla).
    %% Casilla = Turno,
    %% element_at(Destino, Tablero, (X2-1)*8+Y2),
    



    



element_at(X,[X|_],1).
element_at(X,[_|L],K) :- K > 1, K1 is K - 1, element_at(X,L,K1).


remove_at(X,[X|Xs],1,Xs).
remove_at(X,[Y|Xs],K,[Y|Ys]) :- K > 1, 
   K1 is K - 1, remove_at(X,Xs,K1,Ys).

insert_at(X,L,K,R) :- remove_at(X,R,K,L).


contramaquina(Respuesta) :-
    Respuesta = 's',
    write('contra maquina').
contramaquina(Respuesta) :-
    Respuesta = 'n',
    write('contra jugador').

imprimirTurno(Turno) :-
    Turno = '<',
    write('Juega jugador 1').
imprimirTurno(Turno) :-
    Turno = '>',
    write('Juega jugador 2').

jugar :-
    inicializarTablero(Tablero),
    nb_setval(tab, Tablero),
    nb_setval(turno, '<'),
    imprimirTurno('<').
    % Imprimir tablero




    
    
    
    
    
    
    













