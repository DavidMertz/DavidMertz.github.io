/************************************************************************
* [dqm 8/99] Functions related to string manipulation.
*            CountTokens() -- How many occurances of delimiter in string?
*            Proper()      -- Convert a string to initial capitalization
*            Stringify()   -- String representation of passed variable
*************************************************************************/

#define crlf CHR(13)+CHR(10)

****************************************************************************
* Return a string representation of any passed expression
*****************************************************************************
FUNCTION Stringify(x, nLevel)
  LOCAL i, c := ""
  LOCAL cType := VALTYPE(x)
  nLevel := IIF(VALTYPE(nLevel) <> "N", 0, nLevel)

  DO CASE
  CASE cType == "U" ; c := "NIL"                // NIL
  CASE cType == "B" ; c := "(block)"+Var2Bin(x) // code block
  CASE cType == "C" ; c := x                    // character string
  CASE cType == "D" ; c := "(date)"+DTOC(x)     // date value
  CASE cType == "L" ; c := IIF(x, ".T.", ".F.") // logical value
  CASE cType == "M" ; c := "(memo)"+LEFT(x,20)  // memo field
  CASE cType == "N" ; c := "(numeric)"+STR(x)   // numeric value

  CASE cType == "A"                             // array
     c += " [ARRAY("+ALLTRIM(STR(LEN(x)))+")]" + crlf
     FOR i = 1 TO LEN(x)
        c += SPACE(nLevel)+STR(i,4)+"."+Stringify(x[i], nLevel+1)
     NEXT i

  CASE cType == "O"                             // object
     c := "(obj)"+x:className() +crlf
     IF IsMemberVar(x, "_data")
        c += SPACE(3*nLevel+2)
        c += "[Exposed member data]"+crlf
        FOR i = 1 TO LEN(x:_data)
           c += SPACE(3*nLevel+2)
           c += x:_data[i] +" = "
           c += ALLTRIM( Stringify(x:&(x:_data[i]), nLevel+1) )
        NEXT i
     ELSE
        c += SPACE(3*nLevel+2)
        c += "No member data exposed for introspection"
     ENDIF

     c += crlf
     IF IsMemberVar(x, "_methods")
        c += SPACE(3*nLevel+2)
        c += "[Exposed member methods]"+crlf
        FOR i = 1 TO LEN(x:_methods)
           c += SPACE(3*nLevel+2)
           c += x:_methods[i] +crlf
        NEXT i
     ELSE
        c += SPACE(3*nLevel+2)
        c += "No member methods exposed for introspection"
     ENDIF
  ENDCASE

  c := SPACE(nLevel) + c + crlf

RETURN c

****************************************************************************
* How many d's are in c? */
*****************************************************************************
FUNCTION CountTokens(c, d)
  LOCAL nCount := 0, i
  DO WHILE 0 <> (i := AT(d, c))
    nCount++
    c := SUBSTR(c, i+1)
  ENDDO
RETURN nCount

*****************************************************************************
* Convert a string to initial capitals.
* Second (optional parameter) will allow caller to force inital caps even
* if passed in string is already mixed case
*****************************************************************************
FUNCTION Proper(c, lForce)
  LOCAL i, cProper := "", cPair, cLeft, cRight
  lForce := IIF( EMPTY(lForce), .F., lForce )

  IF (c = UPPER(c)) .OR. (c = LOWER(c)) .OR. lForce
    cProper += UPPER(LEFT(c, 1))
    FOR i = 1 TO LEN(c)-1
      cPair  := SUBSTR(c, i, 2)
      cLeft  := LEFT(cPair, 1)
      cRight := RIGHT(cPair, 1)
      DO CASE
        CASE cRight= SPACE(1)   ; cProper += cRight
        CASE cLeft = SPACE(1)   ; cProper += UPPER(cRight)
        CASE cLeft $ '/.,;:-!"' ; cProper += UPPER(cRight)
        OTHERWISE               ; cProper += LOWER(cRight)
      ENDCASE
    NEXT i
  ELSE
    cProper := c
  ENDIF
RETURN cProper

//-- eof
