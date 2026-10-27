
padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).
abuelo(X,Y) :- padre(X,Z), padre(Z,Y).


ancestro(X, X).
ancestro(X, Y) :- padre(X, Z), ancestro(Z, Y).

juntar([],L2,L2).
juntar([X|L1],L2,[X|L3]) :- juntar(L1,L2,L3).

last1(L,U) :- append(_, [U], L).
last2(L,U) :- append(_, [U|[]], L).

% PERTENECE RECORRE LA LISTA DE A 1 

%%%%% HICE UNION 
union2(L1,[X],L1) :- pertenece(X,L1).
union2(L1,[X], L2) :- not(pertenece(X,L1)), append(L1,[X],L2).
union2(L1,[X|T],L3) :- pertenece(X,L1), union2(L1,T,L3).
union2(L1,[X|T],L3) :- not(pertenece(X,L1)), append(L1,[X], L2), union2(L2,T,L3).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5

%%%%%%reverse(+L, ?R)
rev([], []).
rev([X|T], R) :- rev(T, RT), append(RT, [X], R).

%%%%%%prefijo(?P, +L), donde P es prefijo de la lista L.

prefijo(P,L) :- append(_,P,L).
sufijo(S,L) :- append(S,_,L).

%%%%%%sublista(?S, +L), donde S es sublista de L.

sublista(S,L) :- prefijo(L2,L), sufijo(S,L2), not((S = [])).
 
%%%%%%pertenece(?X, +L), que es verdadero sii el elemento X se encuentra en la lista L

pertenece(X,L) :- append(_,[X|_],L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 6 FALTA

% aplanar(+Xs, -Ys)

%aplanar(L, [L2|_]) :- append(_,[Elem|_],L), aplanar(Elem,L2).

% ?- aplanar([a, [3, b, []], [2]], L).→ L=[a, 3, b, 2]
% ?- aplanar([[1, [2, 3], [a]], [[[]]]], L).→ L=[1, 2, 3, a]

%aplanar([], []).
%aplanar([X|T], [Xaplanado|R]) :- aplanar(X, Xaplanado), append(_, [X|_], R).

%aplanar(L,L) :- noContieneLista(L).
%aplanar(L,LA) :- append(_,[X|_], LA), pertenece(X,L).

aplanaLista([L],X) :- append(_,[X|_], L), pertenece(X,L).

noContieneLista(L):- not((append(_,[X|_],L), X = [_])).

aplanar(L,L) :- noContieneLista(L).
aplanar([X|T],LR) :- aplanar(X,Laplanado), aplanar(T,Taplanado),append(Laplanado,Taplanado,LR).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 7
interseccion([],_,[]).
interseccion(_,[],[]).
interseccion([X|T], L2, RT) :- not(pertenece(X,L2)), interseccion(T,L2,RT).
interseccion([X|T], L2, [X|RT]) :- pertenece(X,L2), interseccion(T,L2,RT).

partir(0,L,[],L). 
partir(N,[X|T],[X|RL],L3) :- N > 0, N2 is N-1,partir(N2,T,RL,L3).

borrar(_, [], []).
borrar(X,[X|T],LR) :- borrar(X,T,LR).
borrar(X,[Y|T],[Y|RL]) :- X \= Y, borrar(X,T,RL).

sacarDuplicados([],[]).
sacarDuplicados([X|T], [X|TR]) :- not(pertenece(X,T)) ,sacarDuplicados(T,TR).
sacarDuplicados([X|T], TR) :- pertenece(X,T) ,sacarDuplicados(T,TR).

permutacion([],[]).
permutacion([X|T],Lper) :- permutacion(T, LperSinX), select(X,Lper,LperSinX), pertenece(X,Lper) .

reparto(L,1,L).
reparto(L,N,LR) :- N > 1, append(La,Lb,L), N2 is N - 1,reparto(Lb, N2, LbR), append([La],[LbR],LR).
 
repartoSinVacias(L,1,L).
repartoSinVacias(L,N,LR) :- N > 1, append(La,Lb,L), N2 is N - 1,
                            repartoSinVacias(Lb, N2, LbR), 
                            La \= [], LbR \= [],
                            append([La],[LbR],LR).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 8

%%%%%%Definir el predicado parteQueSuma(+L,+S,-P) que es verdadero cuando P es una lista con elementos de L que

parteQueSuma(_, 0, []).
parteQueSuma([X], X, [X]). 
parteQueSuma(L,S,LQS) :-    partirNumero(S,SA,SB), 
                            append(LA,LB,L), LA \= [], LB \= [],
                            parteQueSuma(LA,SA,RA), 
                            parteQueSuma(LB,SB,RB), 
                            append(RA,RB,LQS).  

partirNumero(X, Y, XmenosY) :- between(0, X, Y), XmenosY is X-Y.

pqsCORRECTO([], 0, []).
pqsCORRECTO([X|T], S, [X|P]) :- S2 is S - X, S2 >= 0, pqsCORRECTO(T, S2, P).
pqsCORRECTO([_|T], S, P) :- pqsCORRECTO(T, S, P).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 9

desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y).

%% X tiene que estar instanciado siempre: N is X+1 exige que X tenga valor, si no tira error de instanciacion
%% la clausula recursiva no tiene ninguna condicion que la frene cuando ya se paso de Y, y Y nunca se usa para acotar.

% desdeReversible(+X, ?Y)
desdeReversible(X, Y) :- var(Y), desde(X, Y).
desdeReversible(X, Y) :- nonvar(Y), X =< Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 10

intercalar([],L,L).
intercalar([X|T],[],[X|T]).
intercalar([X|T],[Y|I], [X,Y|RL]) :- intercalar(T,I,RL). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 11

vacio(nil).
raiz(bin(_, R, _), R).

altura(nil,0).
altura(bin(I,_,D),A) :- altura(I, AI), altura(D, AD), A is 1 + max(AI,AD).

cantidadDeNodos(nil, 0).
cantidadDeNodos(bin(I,_,D), N) :- cantidadDeNodos(I, NI), cantidadDeNodos(D, ND), N is NI + 1 + ND.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 12

%% inorder(+AB,-Lista), que tenga exito si AB es un arbol binario y Lista la lista de sus nodos segun el
%%recorrido inorder.
inorder(nil, []).
inorder(bin(I,R,D), L) :- inorder(I,LI), inorder(D,LD), append(LI,[R|LD],L).

%%arbolConInorder(+Lista,-AB)
arbolConInorder([],nil).
arbolConInorder(L, bin(I,R,D)) :- append(AI,[R|AD],L), arbolConInorder(AI,I), arbolConInorder(AD,D). 

%%aBB(+T), que sera verdadero si T es un arbol binario de busqueda.
aBB(A) :- inorder(A,LA), listaOrdenada(LA).

listaOrdenada([]).
listaOrdenada([_]).
listaOrdenada([X|Y|XS]) :- X < Y, listaOrdenada([Y|XS]).

%% aBBInsertar(+X, +T1, -T2), donde T2 resulta de insertar X en orden en el arbol T1.
aBBInsertar(X,nil, bin(nil,X,nil)).
aBBInsertar(X,bin(I,R,D),bin(InsertarI,R,D)) :- X =< R, aBBInsertar(X,I,InsertarI).
aBBInsertar(X,bin(I,R,D),bin(I,R,InsertarD)) :- X > R, aBBInsertar(X,D,InsertarD).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 13

coprimos(X,Y) :- desde(1,N), between(1,N,X), Y is N-X, gcd(X, Y) =:= 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 14


cuadradoSemiMagico(Tamanio,Matriz):- desde(0,N), matrizQueSumaN(Tamanio,Tamanio,N,Matriz).

matrizQueSumaN(0,_,_,[]).
matrizQueSumaN(TamanioMatriz, TamanioListas,  Suma, Matrix):-
                                        TamanioMatriz > 0,
                                        listaLongQueSuma(TamanioListas,Suma,LA),
                                        TamanioMatriz2 is TamanioMatriz - 1,
                                        matrizQueSumaN(TamanioMatriz2, TamanioListas, Suma, LB),
                                        append([LA],LB,Matrix).

listaLongQueSuma(0,0,[]).
listaLongQueSuma(LongLista,Suma,L):-    LongLista > 0,
                                        between(0,Suma,X),
                                        append([X],LB,L),
                                        Suma2 is Suma - X,
                                        LongB is LongLista - 1,
                                        listaLongQueSuma(LongB, Suma2, LB).






%%%%%%%%%%%%%%%%%%%%%%%%%%%% OBS APPEND 
% ?- append(X,Y,[1,2,3,4]).
% X = [],
% Y = [1, 2, 3, 4] ;
% X = [1],
% Y = [2, 3, 4] ;
% X = [1, 2],
% Y = [3, 4] ;
% X = [1, 2, 3],
% Y = [4] ;
% X = [1, 2, 3, 4],
% Y = [] ;
% false.


