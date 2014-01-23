inicializarTablero(Tablero) :-
   Tablero = [' ', '<', ' ', '<', ' ', '<', ' ', '<',
              '<', ' ', '<', ' ', '<', ' ', '<', ' ',
              ' ', '<', ' ', '<', ' ', '<', ' ', '<',
              ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
              ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
              '>', ' ', '>', ' ', '>', ' ', '>', ' ',
              ' ', '>', ' ', '>', ' ', '>', ' ', '>',
              '>', ' ', '>', ' ', '>', ' ', '>', ' '].



comerDiagonal(X,Y,X1,Y1,Tablero):-
	X =:= X1, Y =:= Y1,
	nb_setval(tab,Tablero).
comerDiagonal(X,Y,X1,Y1,Tablero):- %Arriba a la derecha
	X1 < X,
	Y1 > Y,
	nb_getval(turno, Turno),
	calcPos(X-1,Y+1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; verificarFicha(Posicion, Tablero, Adversario)),

	remove_at(_, Tablero, Posicion, Tablero1),
	insert_at(' ', Tablero1, Posicion, Tablero2),
    
	comerDiagonal(X-1,Y+1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Arriba a la izquierda
	X1 < X,
	Y1 < Y,
	nb_getval(turno, Turno),
	calcPos(X-1,Y-1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; verificarFicha(Posicion, Tablero, Adversario)),

	remove_at(_, Tablero, Posicion, Tablero1),
	insert_at(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X-1,Y-1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Abajo a la derecha 
	X1 > X,
	Y1 > Y,
	nb_getval(turno, Turno),
	calcPos(X+1,Y+1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; verificarFicha(Posicion, Tablero, Adversario)),
	remove_at(_, Tablero, Posicion, Tablero1),
	insert_at(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X+1,Y+1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Abajo a la izquierda 
	X1 > X,
	Y1 < Y,
	nb_getval(turno, Turno),
	calcPos(X+1,Y-1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; verificarFicha(Posicion, Tablero, Adversario)),
	remove_at(_, Tablero, Posicion, Tablero1),
	insert_at(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X+1,Y-1,X1,Y1,Tablero2).
	

esRey(Ficha):-
	Ficha = '<<' ;
	Ficha = '>>'.	
esPeon(Ficha):-
	Ficha = '<' ;
	Ficha = '>'.	

coronar(Orig, Dest, Ficha):-
	Dest > 56,
	Ficha = '<',
	nb_getval(tab, Tablero),
	remove_at(_, Tablero, Orig, Tablero1),
	insert_at('<<', Tablero1, Orig, Tablero2),
	nb_setval(tab, Tablero2).	
coronar(Orig, Dest, Ficha):-
	Dest < 9,
	Ficha = '>',
	nb_getval(tab, Tablero),
	remove_at(_, Tablero, Orig, Tablero1),
	insert_at('>>', Tablero1, Orig, Tablero2),
	nb_setval(tab, Tablero2).

coronar(Orig, Dest, Ficha).

puedeMoverse(X,Y,X1,Y1):-   %Regla para el rey
	X < 9,
	Y < 9,
	X1 < 9,
	Y1 < 9,
	nb_getval(tab,Tablero),  %Se obtiene el tablero
	calcPos(X,Y,Orig),
	element_at(Ficha, Tablero, Orig),
	
	esRey(Ficha),
	%% nb_getval(turno,Turno),  %Se obtiene el turno
	
	comerDiagonal(X,Y,X1,Y1,Tablero).




puedeMoverse(X,Y,X1,Y1):- %Regla para un peon cuando no come
	X < 9,
	Y < 9,
	X1 < 9,
	Y1 < 9,
	nb_getval(tab,Tablero),  %Se obtiene el tablero
	calcPos(X,Y,Orig),
	element_at(Ficha, Tablero, Orig),

	esPeon(Ficha),
	nb_getval(turno,Turno),  %Se obtiene el turno
	calcPos(X1,Y1,Dest),        %Posicion de destino
	verificarFicha(Orig, Tablero, Turno),
	esVacia(Dest, Tablero),

	X1 =:= X -2*Turno + 1,
	(Y1 =:= Y + 1  ;  Y1 =:= Y - 1),
	coronar(Orig, Dest, Ficha).

puedeMoverse(X,Y,X1,Y1):- %Regla para un peon cuando come
	X < 9,
	Y < 9,
	X1 < 9,
	Y1 < 9,
	nb_getval(tab,Tablero),  %Se obtiene el tablero
	calcPos(X,Y,Orig),
	element_at(Ficha, Tablero, Orig),
	esPeon(Ficha),
	nb_getval(turno,Turno),  %Se obtiene el turno
	calcPos(X1,Y1,Dest),        %Posicion de destino
	verificarFicha(Orig, Tablero, Turno),
	esVacia(Dest, Tablero),

	X1 =:= X -4*Turno + 2,
	(Y1 =:= Y + 2  ;  Y1 =:= Y - 2),
	puntoMedio(X,X1,Xmedio),
	puntoMedio(Y,Y1,Ymedio),
	calcPos(Xmedio,Ymedio,PosMedio),
	Adversario is (Turno + 1) mod 2,
	verificarFicha(PosMedio, Tablero, Adversario),
	comerFicha(PosMedio),
    descontarFicha(Turno),
    coronar(Orig, Dest, Ficha).

descontarFicha(Turno) :-
    Turno = 0,
    nb_getval(fichas1, Fichas),
    Fichas2 is Fichas - 1,
    nb_setval(fichas1, Fichas2).

descontarFicha(Turno) :-
    Turno = 1,
    nb_getval(fichas0, Fichas),
    Fichas2 is Fichas - 1,
    nb_setval(fichas0, Fichas2).

puntoMedio(A, B, C):-
	C is (A + B) div 2.

verificarFicha(Posicion, Tablero, Turno) :-
	 element_at(Ficha, Tablero, Posicion),
    Ficha = '<<',
    Turno = 0.
verificarFicha(Posicion, Tablero, Turno) :-
	 element_at(Ficha, Tablero, Posicion),
    Ficha = '<',
    Turno = 0.
verificarFicha(Posicion, Tablero, Turno) :-
	 element_at(Ficha, Tablero, Posicion),
    Ficha = '>',
    Turno = 1.
verificarFicha(Posicion, Tablero, Turno) :-
	 element_at(Ficha, Tablero, Posicion),
    Ficha = '>>',
    Turno = 1.

esVacia(Posicion, Tablero):-
	 element_at(Ficha, Tablero, Posicion),
	 Ficha = ' '.

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
    (X = '>>' ; X = '<<'),
    write('|'),
    write(X),
    write('| '),
    imprimirLinea(Xs).

imprimirLinea([X|Xs]) :-
    write('|'),
    write(X),
    write(' | '),
    imprimirLinea(Xs).
    

calcPos(X,Y,Z):-
	Z is(X-1)*8 +Y.


comerFicha(PosMedio):- 
	nb_getval(tab, Tablero),
	remove_at(_, Tablero, PosMedio, Tablero1),
	insert_at(' ', Tablero1, PosMedio, Tablero2),
	nb_setval(tab, Tablero2).	

mover(Tablero, PosIni, PosFin, Ficha) :-
    remove_at(Ficha, Tablero, PosIni, Tablero2),
    insert_at(' ', Tablero2, PosIni, Tablero3),
    remove_at(' ', Tablero3, PosFin, Tablero4),
    insert_at(Ficha, Tablero4, PosFin, Tablero5),
    nb_setval(tab, Tablero5).

jugadaAux(X,Y,X1,Y1) :-
		nb_getval(turno, Turno),
		nb_getval(tab, Tablero),
		PosIni = (X-1)*8+Y,
		element_at(Ficha, Tablero, PosIni),
		puedeMoverse(X,Y,X1,Y1),

		calcPos(X1,Y1,PosFin),
		nb_getval(tab,Tablero2),
		mover(Tablero2, PosIni, PosFin, _),

		cambiarTurno,
		imprimirTablero, nl,
		imprimirTurno, nl,
        not(finJuego).

finJuego :-
    nb_getval(fichas0, Fichas),
    Fichas = 0,
    write('Ha ganado el jugador 1'),nl.

finJuego :-
    nb_getval(fichas1, Fichas),
    Fichas = 0,
    write('Ha ganado el jugador 2'),nl.


jugada(X1,Y1,X2,Y2):-
	 jugadaAux(X1,Y1,X2,Y2).
%jugada(X1,Y1,X2,Y2):-
%	 nb_getval(juegapc,Pc),
%	 Pc = 's',
%	 jugadaAux(X1,Y1,X2,Y2),
	 
	
    %% Ficha = Turno,
    %% element_at(Destino, Tablero, (X2-1)*8+Y2),


cambiarTurno:-
	nb_getval(turno, Turno), 
	X is (Turno + 1) mod 2,	
	nb_setval(turno, X).

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

imprimirTurno :-
    nb_getval(turno, Turno),
    Turno = 0,
    write('Juega jugador 2').
imprimirTurno :-
    nb_getval(turno, Turno),
    Turno = 1,
    write('Juega jugador 1').

jugar :-
	 nb_setval(fichas0, 12),  %cantidad de fichas del jugador 1
	 nb_setval(fichas1, 12),  %cantidad de fichas del jugador 2
	 write('¿Desea jugar contra la maquina? '),
	 read(X),
	 nb_setval(juegapc,X),
	 nb_getval(juegapc, Juegapc),
	 write('Este es el valor de juegapc = '),
	 write(Juegapc),nl,
    inicializarTablero(Tablero),
    nb_setval(tab, Tablero),
    nb_setval(turno, 1),
    imprimirTablero, nl,
    imprimirTurno, nl.


% Pruebas

prueba:-
	jugada(6,5,5,4),
	jugada(3,4,4,3),
	jugada(6,7,5,8),
	jugada(4,3,6,5).
