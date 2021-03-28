#define crlf CHR(13)+CHR(10)

/*****************************************************************************
*  Class to examine "quick-and-dirty" debugging information
*****************************************************************************/
CLASS Debug
   PROTECTED:
      VAR     filename READONLY
      INLINE METHOD toDisk ; RETURN MEMOWRIT(::filename, ::rpt)

   EXPORTED:
      VAR     rpt
      METHOD  init, View, WorkAreas, CallStack, Message

ENDCLASS


/*--------------------------------------------------------------------------*/
METHOD Debug:init(filename)
   ::rpt      := ""
   ::filename := IIF(EMPTY(GETENV("MYHOME")), "", GETENV("MYHOME")) + "\" ;
               + IIF(VALTYPE(filename) <> "C", "Debug_MY.RPT", filename)
RETURN self


/*--------------------------------------------------------------------------*/
METHOD Debug:View()
   LOCAL cTitle := "Quick Debug ("+::filename+")"
   TextFile():new(::rpt, 3, 2, 22, 40):_Show(cTitle, .F.)
RETURN self


/*--------------------------------------------------------------------------*/
METHOD Debug:WorkAreas()
   LOCAL i
   LOCAL cProcName := PROCNAME(1)
   LOCAL cProcLine := ALLTRIM(STR(PROCLINE(1)))

   ::rpt += crlf+ "----------------------------------------" +crlf
   ::rpt += " WORKAREA SNAPSHOT" +crlf
   ::rpt += " Invoked at "+DTOC(DATE())+" "+TIME() +crlf
   ::rpt += " Called from "+cProcName+ "(" +cProcLine+ ")"
   ::rpt += crlf+ "----------------------------------------" +crlf

   ::rpt += "   SELECT() ="+STR(SELECT(),2)+crlf

   FOR i = 1 TO 99
      ::rpt += IIF( EMPTY(ALIAS(i)), "",                              ;
                    "   Workarea "+STR(i,2)+": ALIAS() = "+ALIAS(i)+crlf )
   NEXT i

   ::toDisk()
RETURN self


/*--------------------------------------------------------------------------*/
METHOD Debug:CallStack(nLevels)
   LOCAL i
   nLevels := IIF( VALTYPE(nLevels) <> "N", 15, nLevels )

   ::rpt += crlf+ "----------------------------------------" +crlf
   ::rpt += " CALLSTACK SNAPSHOT" +crlf
   ::rpt += " Invoked at "+DTOC(DATE())+" "+TIME()
   ::rpt += crlf+ "----------------------------------------" +crlf

   FOR i = 1 TO nLevels
      IF EMPTY(PROCLINE(i))
         EXIT
      ELSE
         ::rpt += "   Called from "+PROCNAME(i)+          ;
                  "("+ALLTRIM(STR(PROCLINE(i)))+")"+crlf
      ENDIF
   NEXT i

   ::toDisk()
RETURN self

/*--------------------------------------------------------------------------*/
METHOD Debug:Message(x, y)
   LOCAL cText := Stringify(x) + IIF(y==NIL,"",SPACE(2)+Stringify(y))
   LOCAL cProcName := PROCNAME(1)
   LOCAL cProcLine := ALLTRIM(STR(PROCLINE(1)))

   ::rpt += crlf+ "----------------------------------------" +crlf
   ::rpt += " USER MESSAGE" +crlf
   ::rpt += " Invoked at "+DTOC(DATE())+" "+TIME() +crlf
   ::rpt += " Called from "+cProcName+ "(" +cProcLine+ ")"
   ::rpt += crlf+ "----------------------------------------" +crlf +"  "
   ::rpt += cText +crlf

   ::toDisk()
RETURN self

//-- eof
