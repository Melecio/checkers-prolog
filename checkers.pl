inicializarTablero(Tablero) :-
    Tablero = [' ', '<', ' ', '<', ' ', '<', ' ', '<',
               '<', ' ', '<', ' ', '<', ' ', '<', ' ',
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

destinoValido(Destino, Turno) :-
    Destino = ' '.



imprimirTablero :-
    nb_getval(tab,Tablero),
    write('    1    2    3    4    5    6    7    8'), nl,
    slice(Tablero, 1, 8, Linea),
    write('1  '),
    imprimirLinea(Linea), nl,
    slice(Tablero, 9, 16, Linea2),
    write('2  '),
    imprimirLinea(Linea2), nl,
    slice(Tablero, 17, 24, Linea3),
    write('3  '),
    imprimirLinea(Linea3), nl,
    slice(Tablero, 25, 32, Linea4),
    write('4  '),
    imprimirLinea(Linea4), nl,
    slice(Tablero, 33, 40, Linea5),
    write('5  '),
    imprimirLinea(Linea5), nl,
    slice(Tablero, 41, 48, Linea6),
    write('6  '),
    imprimirLinea(Linea6), nl,
    slice(Tablero, 49, 56, Linea7),
    write('7  '),
    imprimirLinea(Linea7), nl,
    slice(Tablero, 57, 64, Linea8),
    write('8  '),
    imprimirLinea(Linea8), nl.
    

imprimirLinea([]) :-
    !.
imprimirLinea([X|Xs]) :-
    write('|'),
    write(X),
    write(' | '),
    imprimirLinea(Xs).
    



mover(Tablero, PosIni, PosFin, Casilla) :-
    remove_at(Casilla, Tablero, PosIni, Tablero2),
    insert_at(' ', Tablero2, PosIni, Tablero3),
    remove_at(' ', Tablero3, PosFin, Tablero4),
    insert_at(Casilla, Tablero4, PosFin, Tablero5),
    nb_setval(tab, Tablero5).

jugada(X1,Y1,X2,Y2) :-
    nb_getval(turno, Turno),
    nb_getval(tab, Tablero),
    PosIni = (X1-1)*8+Y1,
    element_at(Casilla, Tablero, PosIni),
    esTurno(Casilla, Turno),

    coordValidas(X1,Y1,X2,Y2, Casilla),

    PosFin = (X2-1)*8+Y2,
    element_at(Destino, Tablero, PosFin),
    destinoValido(Destino,Turno),
    mover(Tablero, PosIni, PosFin, Casilla),
    imprimirTablero.


    %% Casilla = Turno,
    %% element_at(Destino, Tablero, (X2-1)*8+Y2),
    

slice([X|_],1,1,[X]).
slice([X|Xs],1,K,[X|Ys]) :- K > 1, 
   K1 is K - 1, slice(Xs,1,K1,Ys).
slice([_|Xs],I,K,Ys) :- I > 1, 
   I1 is I - 1, K1 is K - 1, slice(Xs,I1,K1,Ys).

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
    imprimirTurno('<'), nl,
    imprimirTablero.
    % Imprimir tablero




    
    
    
    
    
    
    













