inicializarTablero(Tablero) :-
    Tablero = [' ', '<', ' ', '<', ' ', '<', ' ', '<',
               '<', ' ', '<', ' ', '<', ' ', '<', ' ',
               ' ', '<', ' ', '<', ' ', '<', ' ', '<',
               ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
               ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
               ' ', '>', ' ', '>', ' ', '>', ' ', '>',
               '>', ' ', '>', ' ', '>', ' ', '>', ' ',
               ' ', '>', ' ', '>', ' ', '>', ' ', '>'].

jugada(X1,Y1,X2,Y2) :-
    X2 < 9,
    Y2 < 9,
    X1 < 9,
    Y1 < 9.


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




    
    
    
    
    
    
    













