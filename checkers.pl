%% Proyecto 2 - ci3661
%% Juego de damas
%% Gabriel Formica - 10-11036
%% Melecio Ponte - 08-10893

%Inicializacion del tablero 
inicializarTablero(Tablero) :-
   Tablero = [' ', '<', ' ', '<', ' ', '<', ' ', '<',
              '<', ' ', '<', ' ', '<', ' ', '<', ' ',
              ' ', '<', ' ', '<', ' ', '<', ' ', '<',
              ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
              ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
              '>', ' ', '>', ' ', '>', ' ', '>', ' ',
              ' ', '>', ' ', '>', ' ', '>', ' ', '>',
              '>', ' ', '>', ' ', '>', ' ', '>', ' '].


% Predicado que cambia toda la diagonal el tablero por la cual un rey se mueve
% Recibe X,Y como coordenadas de partida del rey, X1,Y1 como coordenadas de 
% llegada sobre el Tablero
comerDiagonal(X,Y,X1,Y1,Tablero):- 
	X =:= X1, Y =:= Y1,
	nb_setval(tab,Tablero).

comerDiagonal(X,Y,X1,Y1,Tablero):- %Caso arriba a la derecha
	X1 < X,
	Y1 > Y,
	nb_getval(turno, Turno),
	calcPos(X-1,Y+1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; (verificarFicha(Posicion, Tablero, Adversario),
    descontarFicha(Turno))),
	eliminarElem(_, Tablero, Posicion, Tablero1),
	insertarElem(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X-1,Y+1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Caso arriba a la izquierda
	X1 < X,
	Y1 < Y,
	nb_getval(turno, Turno),
	calcPos(X-1,Y-1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; (verificarFicha(Posicion, Tablero, Adversario),
    descontarFicha(Turno))),
	eliminarElem(_, Tablero, Posicion, Tablero1),
	insertarElem(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X-1,Y-1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Caso abajo a la derecha 
	X1 > X,
	Y1 > Y,
	nb_getval(turno, Turno),
	calcPos(X+1,Y+1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; (verificarFicha(Posicion, Tablero, Adversario),
    descontarFicha(Turno))),
	eliminarElem(_, Tablero, Posicion, Tablero1),
	insertarElem(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X+1,Y+1,X1,Y1,Tablero2).
	
comerDiagonal(X,Y,X1,Y1,Tablero):- %Caso abajo a la izquierda 
	X1 > X,
	Y1 < Y,
	nb_getval(turno, Turno),
	calcPos(X+1,Y-1, Posicion),
	Adversario is (Turno + 1) mod 2,
	(esVacia(Posicion,Tablero) ; (verificarFicha(Posicion, Tablero, Adversario),
    descontarFicha(Turno))),
	eliminarElem(_, Tablero, Posicion, Tablero1),
	insertarElem(' ', Tablero1, Posicion, Tablero2),
	comerDiagonal(X+1,Y-1,X1,Y1,Tablero2).
	
%Verifica si una Ficha es Rey o Peon
esRey(Ficha):-  
	Ficha = '<<' ;
	Ficha = '>>'.	
esPeon(Ficha):- 
	Ficha = '<' ;
	Ficha = '>'.	

%Predicado que convierte un peon en Rey, si corona.
coronar(Orig, Dest, Ficha):- 
	Dest > 56,
	Ficha = '<',
	nb_getval(tab, Tablero),
	eliminarElem(_, Tablero, Orig, Tablero1),
	insertarElem('<<', Tablero1, Orig, Tablero2),
	nb_setval(tab, Tablero2).	
coronar(Orig, Dest, Ficha):-
	Dest < 9,
	Ficha = '>',
	nb_getval(tab, Tablero),
	eliminarElem(_, Tablero, Orig, Tablero1),
	insertarElem('>>', Tablero1, Orig, Tablero2),
	nb_setval(tab, Tablero2).

coronar(Orig, Dest, Ficha).

% Predicado que verifica si dada las coordenadas de origin y las de detinos son
% una jugada valida. 
%
% Recibe X y Y como coordenadas de partida para la ficha y X1 y Y1 como coorde-
% nadas de llegada.

puedeMoverse(X,Y,X1,Y1):-   %Regla para el rey
	X < 9,
	Y < 9,
	X1 < 9,
	Y1 < 9,
	nb_getval(tab,Tablero),  %Se obtiene el tablero
	calcPos(X,Y,Orig),
	buscarElem(Ficha, Tablero, Orig),
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
	buscarElem(Ficha, Tablero, Orig),

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
	buscarElem(Ficha, Tablero, Orig),
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

% Descuenta numero de fichas de un jugador
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

%Calcula el punto medio de dos numeros.
puntoMedio(A, B, C):-
	C is (A + B) div 2.

%Verifica si hay una ficha del jugador Turno en Posicion de Tablero 
verificarFicha(Posicion, Tablero, Turno) :-
	 buscarElem(Ficha, Tablero, Posicion),
    Ficha = '<<',
    Turno = 0.
verificarFicha(Posicion, Tablero, Turno) :-
	 buscarElem(Ficha, Tablero, Posicion),
    Ficha = '<',
    Turno = 0.
verificarFicha(Posicion, Tablero, Turno) :-
	 buscarElem(Ficha, Tablero, Posicion),
    Ficha = '>',
    Turno = 1.
verificarFicha(Posicion, Tablero, Turno) :-
	 buscarElem(Ficha, Tablero, Posicion),
    Ficha = '>>',
    Turno = 1.

%Verifica si una Posicion en Tablero es vacia
esVacia(Posicion, Tablero):-
	 buscarElem(Ficha, Tablero, Posicion),
	 Ficha = ' '.

%Imprime el Tablero
imprimirTablero :-
    nb_getval(tab,Tablero),
    write('    1    2    3    4    5    6    7    8'), nl,
    subLista(Tablero, 1, 8, Linea),
    write('1  '),
    imprimirLinea(Linea), nl,
    subLista(Tablero, 9, 16, Linea2),
    write('2  '),
    imprimirLinea(Linea2), nl,
    subLista(Tablero, 17, 24, Linea3),
    write('3  '),
    imprimirLinea(Linea3), nl,
    subLista(Tablero, 25, 32, Linea4),
    write('4  '),
    imprimirLinea(Linea4), nl,
    subLista(Tablero, 33, 40, Linea5),
    write('5  '),
    imprimirLinea(Linea5), nl,
    subLista(Tablero, 41, 48, Linea6),
    write('6  '),
    imprimirLinea(Linea6), nl,
    subLista(Tablero, 49, 56, Linea7),
    write('7  '),
    imprimirLinea(Linea7), nl,
    subLista(Tablero, 57, 64, Linea8),
    write('8  '),
    imprimirLinea(Linea8), nl.
    
%Predicado Auxiliar para Imprimir tablero
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
    
%Dado un X,Y de se obtiene un Z que representa
%la posicion en el arreglo unidimensional del tablero
calcPos(X,Y,Z):-
	Z is(X-1)*8 +Y.

%Come ficha
comerFicha(PosMedio):- 
	nb_getval(tab, Tablero),
	eliminarElem(_, Tablero, PosMedio, Tablero1),
	insertarElem(' ', Tablero1, PosMedio, Tablero2),
	nb_setval(tab, Tablero2).	

%Mover ficha desde PosIni hasta PosFin
mover(Tablero, PosIni, PosFin, Ficha) :-
    eliminarElem(Ficha, Tablero, PosIni, Tablero2),
    insertarElem(' ', Tablero2, PosIni, Tablero3),
    eliminarElem(' ', Tablero3, PosFin, Tablero4),
    insertarElem(Ficha, Tablero4, PosFin, Tablero5),
    nb_setval(tab, Tablero5).

% Predicado de jugada
jugada(X1,Y1,X2,Y2):-
	 jugadaAux(X1,Y1,X2,Y2).

% Predicado auxiliar para jugada
jugadaAux(X,Y,X1,Y1) :-
		nb_getval(turno, Turno),
		nb_getval(tab, Tablero),
		PosIni = (X-1)*8+Y,
		buscarElem(Ficha, Tablero, PosIni),
		puedeMoverse(X,Y,X1,Y1),

		calcPos(X1,Y1,PosFin),
		nb_getval(tab,Tablero2),
		mover(Tablero2, PosIni, PosFin, _),

		cambiarTurno,
		imprimirTablero, nl,
		imprimirTurno, nl,
        not(finJuego).

% Se verifica si el juego ha terminado declarando a algun jugador como ganador.
finJuego :-
    nb_getval(fichas0, Fichas),
    Fichas = 0,
    write('Ha ganado el jugador 1'),nl.

finJuego :-
    nb_getval(fichas1, Fichas),
    Fichas = 0,
    write('Ha ganado el jugador 2'),nl.


% Se cambia el turno del jugador
cambiarTurno:-
	nb_getval(turno, Turno), 
	X is (Turno + 1) mod 2,	
	nb_setval(turno, X).

% Se consigue una sublista de una lista dada.
subLista([X|_],1,1,[X]).
subLista([X|Xs],1,K,[X|Ys]) :- K > 1, 
   K1 is K - 1, subLista(Xs,1,K1,Ys).
subLista([_|Xs],I,K,Ys) :- I > 1, 
   I1 is I - 1, K1 is K - 1, subLista(Xs,I1,K1,Ys).

%Busca si X pertenece a la lista y esta en K
buscarElem(X,[X|_],1).
buscarElem(X,[_|L],K) :- K > 1, K1 is K - 1, buscarElem(X,L,K1).

%Remueve el elemento Kesimo de la lista
eliminarElem(X,[X|Xs],1,Xs).
eliminarElem(X,[Y|Xs],K,[Y|Ys]) :- K > 1, 
   K1 is K - 1, eliminarElem(X,Xs,K1,Ys).

% Inserta el elemento Kesimo en la lista
insertarElem(X,L,K,R) :- eliminarElem(X,R,K,L).

% Verifica si se quiere jugar contra la maquina
contramaquina(Respuesta) :-
    Respuesta = 's',
    write('contra maquina').
contramaquina(Respuesta) :-
    Respuesta = 'n',
    write('contra jugador').

% Imprime el turno de la jugada a continuacion
imprimirTurno :-
    nb_getval(turno, Turno),
    Turno = 0,
    write('Juega jugador 2').
imprimirTurno :-
    nb_getval(turno, Turno),
    Turno = 1,
    write('Juega jugador 1').

%Se inicializa el juego
jugar :-
	nb_setval(fichas0, 12),  %cantidad de fichas del jugador 1
	nb_setval(fichas1, 12),  %cantidad de fichas del jugador 2
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
