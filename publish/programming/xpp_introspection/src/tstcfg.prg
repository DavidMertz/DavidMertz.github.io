PROCEDURE Main
  LOCAL oCfg
  oCfg := Configuration():new()

  ? "Testing Configuration Class"
  ? "------------------------------------------"
  ? "Class version", Configuration():C_version
  ? "New Instance version", oCfg:version
  ? "Up to date?", oCfg:uptoDate()
  ?
  ? "oCfg:Font_Alert", oCfg:Font_Alert
  INKEY(20)
  ?
  ? "Change version", (oCfg:version := 2)
  ? "Up to date?", oCfg:uptoDate()
  ?
  INKEY(20)

  ? "Write to disk, read back configuration"
  ? "------------------------------------------"
  oCfg:toDisk("USER.CFG")
  oCfg := Configuration():new():fromDisk("USER.CFG")
  ?
  ? "Read Instance version", oCfg:version
  ? "Up to date?", oCfg:uptoDate()
  ?
  ? "What's antiquated?"
  ? oCfg:antiquated()
  INKEY(20)

  ? "Try updating the diskfile version"
  ? "------------------------------------------"
  oCfg := oCfg:verUpdate()
  oCfg:toDisk("USER.CFG")
  oCfg := Configuration():new():fromDisk("USER.CFG")
  ?
  ? "Read Instance version", oCfg:version
  ? "Up to date?", oCfg:uptoDate()
  ?
  ? "What's antiquated?"
  ? oCfg:antiquated()
  INKEY(20)

RETURN

