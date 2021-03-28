/****************************************************************************
* ABSTRACT PERSISTENCE
*
*    Class Persistent contains a framework for child class serialization,
*    storage and versioning

* Class Notes:
*
*   XBase++ does not allow redfinition of self.  Therefore, the methods
*   :fromDisk() and :verUpdate() return the modified instance, but do not
*   update the existing instance in-place.
*
*   The version number (either class or instance) is numeric.  The
*   specific number used is the modification date in significance order,
*   i.e. 19990921.  Please update the initClass() method of child classes
*   *EVERY* time any change is made to instance data members
****************************************************************************/

#define crlf CHR(13)+CHR(10)

****************************************************************************
CLASS Persistent
   PROTECTED:
      // Child's initClass must call ::exposeSelf(), then ::exposeParent()
      // Implementation of exposeSelf must init C_data, C_methods, C_version
      DEFERRED CLASS METHOD exposeSelf

      INLINE CLASS METHOD exposeParent
         AADD(::C_data,    "savedCfg")
         AADD(::C_data,    "version")
         AADD(::C_methods, "init")
         AADD(::C_methods, "toDisk")
         AADD(::C_methods, "fromDisk")
         AADD(::C_methods, "antiquated")
         AADD(::C_methods, "verUpdate")
         AADD(::C_methods, "uptoDate")
      RETURN self

   EXPORTED:
      CLASS VAR C_data, C_methods
      CLASS VAR C_version READONLY

      VAR     _data, _methods,                    ;
              savedCfg, version

      METHOD  _init,                              ;
              _toDisk, _fromDisk,                 ;
              _antiquated, _verUpdate, _uptoDate

      DEFERRED METHOD                             ;
              init, toDisk, fromDisk,             ;
              antiquated, verUpdate, uptoDate
ENDCLASS

/*--------------------------------------------------------------------------*/
METHOD Persistent:_init(child)
   // Introspection data
   child:_data     := &(::className()+"():C_data")
   child:_methods  := &(::className()+"():C_methods")

   // Version data
   child:version   := &(::className()+"():C_version")
   child:savedCfg  := .F.
RETURN child

/*--------------------------------------------------------------------------*/
METHOD Persistent:_fromDisk(child, cFile)
   LOCAL cBin
   LOCAL oCfg := child
   IF VALTYPE(cFile)=="C" .AND. FILE(cFile)
      cBin := MEMOREAD(cFile)
      oCfg := Bin2Var(cBin)
      oCfg:savedCfg := .T.
   ELSE
      oCfg:savedCfg := .F.
   ENDIF
RETURN oCfg

/*--------------------------------------------------------------------------*/
METHOD Persistent:_toDisk(child, cFile)
   MEMOWRIT(cFile, Var2Bin(child))
RETURN child

/*--------------------------------------------------------------------------*/
METHOD Persistent:_antiquated(child)
   LOCAL cTxt, i
   LOCAL aData := &(::className()+"():C_data")

   IF ::_uptoDate(child)
      cTxt := "This instance matches the current format"
   ELSE
      cTxt := "Summary of instance data availability:"+crlf
      cTxt += "- Instance version = "+STR(::version, 8)+crlf
      cTxt += "- Class version = "   + ;
                 STR(&(::className()+"():C_version"), 8)+crlf
      FOR i = 1 TO LEN(aData)
         IF IsMemberVar(child, aData[i])
            cTxt += "<<"+aData[i]+">> available in this instance"+crlf
         ELSE
            cTxt += "<<"+aData[i]+">> missing from this instance"+crlf
         ENDIF
      NEXT i
   ENDIF
RETURN cTxt

/*--------------------------------------------------------------------------*/
METHOD Persistent:_verUpdate(child)
   LOCAL oCfg  := &(::className()+"():new()")
   LOCAL aData :=&(::className()+"():C_data")
   LOCAL i

   ** copy any available old data to the new instance
   FOR i = 1 TO LEN(aData)
      IF IsMemberVar(child, aData[i])
         oCfg:&(aData[i]) := child:&(aData[i])
      ENDIF
   NEXT i

   ** although we copied in old data, we want to update version data
   oCfg:version := &(::className()+"():C_version")

RETURN oCfg

/*--------------------------------------------------------------------------*/
METHOD Persistent:_uptoDate(child)
RETURN ( child:version == &(::className()+"():C_version") )

