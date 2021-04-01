#include "Xbp.ch"
#include "Gra.ch"


****************************************************************************
CLASS ColorScheme
    EXPORTED:
       VAR     _data, _methods
       VAR     Activeborder, Passiveborder,            ;
               Hilite, Shadow, Titlebar, Titletext,    ;
               Statusbar, DialogBG,                    ;
               SchemeName
       METHOD  init, Old, Windows

ENDCLASS


/*--------------------------------------------------------------------------*/
METHOD ColorScheme:init()
   // Introspection data
   ::_data    := { "Activeborder", "Passiveborder",             ;
                   "Hilite", "Shadow", "Titlebar", "Titletext", ;
                   "Statusbar", "DialogBG",                     ;
                   "SchemeName" }
   ::_methods := { "init", "Old", "Windows" }

   ::Old()
RETURN self


/*--------------------------------------------------------------------------*/
METHOD ColorScheme:Old()
   ::SchemeName    := "Compatibility Color Scheme"
   ::Statusbar     := GRA_CLR_CYAN
   ::Hilite        := XBPSYSCLR_HILITEFOREGROUND
   ::Shadow        := XBPSYSCLR_HILITEBACKGROUND
   ::Titlebar      := GRA_CLR_PINK
   ::Titletext     := XBPSYSCLR_TITLETEXT
   ::Activeborder  := XBPSYSCLR_ACTIVEBORDER
   ::Passiveborder := XBPSYSCLR_INACTIVEBORDER
   ::DialogBG      := GRA_CLR_PALEGRAY
RETURN self


/*--------------------------------------------------------------------------*/
METHOD ColorScheme:Windows()
   ::SchemeName    := "Windows Color Scheme"
   ::Statusbar     := XBPSYSCLR_BUTTONMIDDLE
   ::Hilite        := XBPSYSCLR_HILITEFOREGROUND
   ::Shadow        := XBPSYSCLR_HILITEBACKGROUND
   ::Titlebar      := XBPSYSCLR_ACTIVETITLE
   ::Titletext     := XBPSYSCLR_TITLETEXT
   ::Activeborder  := XBPSYSCLR_ACTIVEBORDER
   ::Passiveborder := XBPSYSCLR_INACTIVEBORDER
   ::DialogBG      := XBPSYSCLR_DIALOGBACKGROUND
RETURN self
