

data AB a = Nil | Bin (AB a) a (AB a)

foldAB :: b -> (b -> a -> b -> b) -> AB a -> b 
foldAB fnil fbin t = case t of 
    Nil -> fnil
    (Bin i r d) -> fbin (rec i) r (rec d)
        where rec = foldAB fnil fbin

mismaEstructura :: AB a -> AB b -> Bool 
mismaEstructura = foldAB 
                    (\a2 -> case a2 of 
                        Nil -> True 
                        Bin i r d -> False) 
                    (\ri r rd -> \a2 -> case a2 of
                                                Nil -> False
                                                Bin izq raiz der -> (ri izq) && (rd der)) 


----------------

data Caja = Bombilla Bool | Nada
            deriving Eq 

data Circuito =  Caja Caja 
                | Serie Circuito Circuito 
                | Paralelo Caja Circuito Circuito Caja 
                    deriving Eq 

foldCr :: (Caja -> b) -> (b -> b -> b) -> (Caja -> b -> b -> Caja -> b) -> Circuito -> b 
foldCr fcaja fserie fparalelo c = case c of 
    Caja a -> fcaja a 
    Serie caja1 caja2 -> fserie (rec caja1) (rec caja2)
    Paralelo caja1 c1 c2 caja2 -> fparalelo caja1 (rec c1) (rec c2) caja2
    where rec = foldCr fcaja fserie fparalelo 

esCaja :: Circuito -> Bool 
esCaja (Caja _) = True 
esCaja (Serie _ _) = False
esCaja (Paralelo _ _ _ _) = False  


tienenLaMismaEstructura :: Circuito -> Circuito -> Bool 
tienenLaMismaEstructura = foldCr 
            (\circuito -> \circuito2 -> esCaja(circuito2))
            (\recc1 recc2 -> \circuito2 -> case circuito2 of 
                Caja _ -> False 
                Serie c1 c2 -> (recc1 c1) && (recc2 c2)
                Paralelo _ _ _ _ -> False )
            (\caja1 recc1 recc2 caja2 -> \circuito2 -> case circuito2 of
                Caja _ -> False
                Serie _ _ -> False
                Paralelo acaja1 c1 c2 acaja2 -> (recc1 c1) && (recc2 c2) )


-----------------
data AIH a = Hoja a | Bin2 (AIH a) (AIH a)

foldAIH :: (a -> b) -> (b -> b -> b) -> AIH a -> b 
foldAIH fh fbin2 arbol = case arbol of 
    Hoja a -> fh a
    Bin2 h1 h2 -> fbin2 (rec h1) (rec h2)
        where rec = foldAIH fh fbin2

alturaAIH :: AIH a -> Integer 
alturaAIH = foldAIH (const 1) (\ni nd -> (+) 1  (max ni nd))

tamañoAIH :: AIH a -> Integer 
tamañoAIH = foldAIH (const 1) (\ti td -> ti + td)


--------

data Fórmula
    = V
    | F
    | Not Fórmula
    | And Fórmula Fórmula
    | Or Fórmula Fórmula
    deriving (Eq, Show)


fórmulasDeTamañoN :: Int -> [Fórmula]
fórmulasDeTamañoN 0 = []
fórmulasDeTamañoN 1 = [V, F]
fórmulasDeTamañoN n =
    (map Not (fórmulasDeTamañoN (n-1)))
    ++
    [c f1 f2 | c  <- [And, Or],
               x  <- [1..n-2],
               f1 <- fórmulasDeTamañoN x,
               f2 <- fórmulasDeTamañoN (n-1-x)
    ]

todasLasFórmulas :: [Fórmula]
todasLasFórmulas = concatMap fórmulasDeTamañoN [0..]



