module Main where
import XmlLib
-- Concise XSLT-like specification of output
main = processXmlWith (hexagrams `o` tag "IChing")
hexagrams = 
    html [
      hhead [htitle [keep /> tag "title" /> txt] ], 
      hbody [htableBorder [rows `o` children `with` tag "hexagram"] ]
    ]
htableBorder = mkElemAttr "TABLE" [("BORDER",("1"!))]
rows f =
    let
      num = keep /> tag "number" /> txt
      nam = keep /> tag "name" /> txt
      jdg = keep /> tag "judgement" /> txt 
    in
      if (condition (num f) (nam f) (jdg f))
      then hrow [hcol [num], hcol [nam], hcol [jdg]] f
      else []
condition num nam jdg = isPrime (makeInt num)

-- Supporting computations for rows condition
makeInt = stringToInt . unwrap      -- Turn a Content into an Integer
unwrap [(CString b c)] = c          -- Turn a Content into a String
stringToInt = revToInteger.reverse  -- Turn a String into an Integer
    where
    revToInteger = toInteger . revToInt
    revToInt []  = 0
    revToInt (d:ds) = digitToInt d + (10*(revToInt ds))
isPrime = ordSearch (sieve [2..])   -- ordered search of Sieve of Eratosthenes
    where               
    ordSearch (x:xs) n
        | x < n     = ordSearch xs n
        | x == n    = True
        | otherwise = False
    sieve (x:xs) = x : sieve [y | y <- xs, y `mod` x > 0]
