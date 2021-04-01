/****************************************************************************
* CONFIGURATION MAINTENANCE:
*    Function Cfg() is a simple storage area for the configuration.  We use
*                   use the function version because of the inherent scope
*                   visibility of a library function, and to self-initialize
*                   the configuration info w/o requiring call in INIT.
*
*    Class Configuration contains all the instance data associated with
*                   individualizable module configuration.  Data may be
*                   of either simple or compound types.
****************************************************************************/


#define crlf CHR(13)+CHR(10)

****************************************************************************
FUNCTION Cfg(o)
  STATIC oCfg := NIL

  // in case we are called without global initialization (e.g testing)...
  MY_HOMEPATH := IIF(VALTYPE(MY_HOMEPATH)=="C", MY_HOMEPATH, "")

  IF VALTYPE(o) == "O"
     oCfg := o
  ELSEIF oCfg == NIL
     oCfg := Configuration():new()
     oCfg := oCfg:fromDisk(MY_HOMEPATH+"USER.CFG")
     IF ! oCfg:uptoDate()
        oCfg := oCfg:verUpdate()
        oCfg:toDisk()
     ENDIF
  ENDIF
RETURN oCfg


****************************************************************************
CLASS Configuration FROM Persistent
   PROTECTED:
      // Child's initClass must call ::exposeSelf(), then ::exposeParent()
      INLINE CLASS METHOD initClass
         ::exposeSelf()
         ::exposeParent()
      RETURN self

      // Implement deferred class method exposeChild
      INLINE CLASS METHOD exposeSelf
         ::C_version := 19990924
         ::C_data    := { "Font_Alert", "ButtonLabels", "GrayBar",     ;
                          "ColorScheme", "MY_Date" }
         ::C_methods := { }
      RETURN self

   EXPORTED:
      VAR     Font_Alert,                                              ;
              ButtonLabels,                                            ;
              GrayBar,                                                 ;
              ColorScheme,                                             ;
              MY_Date

      METHOD init

      INLINE METHOD fromDisk(c)  ; RETURN ::Persistent:_fromDisk(self, c)
      INLINE METHOD antiquated() ; RETURN ::Persistent:_antiquated(self)
      INLINE METHOD uptoDate()   ; RETURN ::Persistent:_uptoDate(self)

      INLINE METHOD toDisk(c)
         MY_HOMEPATH := IIF(VALTYPE(MY_HOMEPATH)=="C", MY_HOMEPATH, "")
         c := IIF(VALTYPE(c)=="C", c, MY_HOMEPATH+"USER.CFG")
         RETURN ::Persistent:_toDisk(self, c)

      INLINE METHOD verUpdate
         // generic update of instance
         LOCAL oCfg := ::Persistent:_verUpdate(self)

         // the ColorScheme member object may have changed structure.
         // (this will have the side effect of resetting to default colors)
         oCfg:ColorScheme := ColorScheme():new()
         RETURN oCfg

ENDCLASS


/*--------------------------------------------------------------------------*/
METHOD Configuration:init()
   // Configuration data
   ::Font_Alert     := "10.Arial"
   ::ButtonLabels   := .F.
   ::GrayBar        := .F.
   ::ColorScheme    := ColorScheme():new()
   ::MY_Date        := DATE()

   // Introspection and version data
   ::Persistent:_init(self)
RETURN self

//-- eof
