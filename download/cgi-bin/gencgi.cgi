#!/usr/bin/python

"""Generic Superclasses for cgi forms processing."""

### this file has been patched to correct for 1.4 cgi module
### changes and to allow for systems that don't support signals.

import cgi, sys, string, traceback, os

# use this error to terminate early
CGITerminate = "generic.CGITerminate"

# generic format for an HTML reply
HTMLReply = """\
Content-type: text/html
%(otherheaders)s

<HTML><HEAD>
<TITLE>%(title)s</TITLE>
</HEAD>
<BODY>
%(body)s
</BODY></HTML>
"""

# generic error format, only for unhandled errors
Errorfmt = """\
Unhandled exception encountered.
<pre>
%(type)s
%(value)s
</pre>"""

# default body string format, used for debugging
DEFAULTBODY = """\
The form data was:
<pre>
%s
</pre>
... and the environment was
<pre>
%s
</pre>"""

def send_reply(outfile, title, body, otherheaders=""):
    D = {"title": title, "body": body, "otherheaders": otherheaders}
    reply = HTMLReply % D
    outfile.write( reply )

def send_error(type, value, outfile=sys.stdout):
    D = {"type": type, "value": value}
    body = Errorfmt % D
    send_reply(outfile, "Error", body)

class myStdin:
    """Standard input file clone, which redefineds f.read()
       to allow signals to be detected during the read."""

    def __init__(self, fp = sys.stdin):
        self.fp = sys.stdin

    def __getattr__(self, name):
        return getattr(self.fp, name)

    def read(self, length):
        list = [""] * length
        fp = self.fp
        for i in xrange(length):
            list[i] = fp.read(1) # one char at a time...
        result = string.joinfields(list, "")
        return result

class cgiBase:
   """Superclass for developing CGI processing objects."""

   # some default parameters
   Content_length_limit = None # set to integer to limit content length
   Form_data_Timeout = 3       # set to None for no timeout

   traceback = 1 # set to zero to disable debug traceback dump.

   def __init__(self, infile=myStdin(sys.stdin), outfile=sys.stdout,
                      environ=os.environ):
       self.infile = infile
       self.outfile = outfile
       self.environ = environ

   def GO(self):
       """This is the standard processing sequence for handling a Request.
          Any step that terminates this process early should generate a 
          complete response and raise CGITerminate.
       """
       try:
          # perform sanity checks
          self.sanity_check()
          # get the form data
          form = self.get_form()
          # check the form data, prepare response
          self.prepare_response(form)
          # generate the title, otherheaders, and body
          title = self.get_title()
          otherheaders = self.get_otherheaders()
          body = self.get_body()
          send_reply(self.outfile, title, body, otherheaders)
       except CGITerminate:
          # on CGITerminate the process was terminated early, on purpose.
          self.aborted()
       except: # any other error was an accident... report it.
          (type, value) = (sys.exc_type, sys.exc_value)
          self.UnhandledError(type, value, sys.exc_traceback)
       else:
          # normal successful completion.
          self.success()

   def sanity_check(self):
       """Check for sanity conditions before doing anything else.
          This default implementation checks the CONTENT_LENGTH,
          if present and terminates if it is too large, but only
          if self.Content_length_limit is defined.
          This function only serves to raise an error if there's
          a problem.
       """
       cll = self.Content_length_limit
       if not cll is None:
          try:
              CL = self.environ["CONTENT_LENGTH"]
          except KeyError:
              return # no content length means "ok"
          else:
              cl = string.atoi(CL)
              if cl>cll:
                 self.DataTooLarge(cl)
                 raise CGITerminate # abort

   def DataTooLarge(self, size):
       """Send a message saying the data size was too big.
          A professional implementation should redefine this method;
          the default implementation is primarily for debugging.
       """
       value = "Too much data: "+`size`
       send_error("Data size error", value, self.outfile)
       raise CGITerminate # abort

   def get_form(self):
       """Get the form data.  Default implementation
          times out the reading of data using signals if it
          takes too long.
          Upon success, sets self.form and returns self.form.
       """
       # pass in stdin only if request method is not GET
       infile = self.infile
       try:
          method = self.environ["REQUEST_METHOD"]
       except KeyError:
          pass
       else:
          if method=="GET":
             infile = None
       timeout = self.Form_data_Timeout
       try:
          import signal
       except:
          signal=None
       else:
          if not timeout is None:
             # set a timeout
             signal.signal(signal.SIGALRM, self.AlarmHandler)
             signal.alarm(timeout)
       self.form = cgi.FieldStorage(infile)
       if signal!=None and timeout!=None:
          # cancel the timeout
          signal.alarm(0)
       return self.form

   def AlarmHandler(self, number, traceback):
       """Send a message saying it took to long to read input.
          The default implementation is for debugging.
       """
       send_error("Timeout", "It took too long to read the data")
       raise CGITerminate

   def prepare_response(self, form):
       """Use the form data to prepare a to send a response.
          This default implementation is strictly for debugging.
          Always redefine this method.
       """
       fields = []
       try:
           keys = form.keys() # raises error if there are no fields
       except TypeError:
           pass
       else:
           for key in form.keys():
               fields.append( (key, form[key]) )
       environment = self.environ.items()
       def formatpair(pair):
           return "[%s]\n%s" % pair
       fieldsmap = map(formatpair, fields)
       envmap = map(formatpair, environment)
       fstring = (string.joinfields(fieldsmap, "\n") or "empty")
       estring = (string.joinfields(envmap, "\n") or "no environment?")
       self.body = DEFAULTBODY % (fstring, estring)

   def get_title(self):
       """return the title, always redefine this method."""
       return "Generic CGI script in DEBUG mode"

   def get_otherheaders(self):
       """additional headers to include in the response, default null."""
       return ""

   def get_body(self):
       """get the body for the response, defaults to self.body."""
       return self.body

   def aborted(self):
       """Hook called during a controlled abort. Default: do nothing.
          Other implementations may write to a log file, for example.
          This method should assume the error response has been sent.
       """
       pass

   def UnhandledError(self, type, value, tb=None):
       """Hook called after an uncaught exception in self.go().
          This method must send a response.
          Defaults to a standard error response.
       """
       diagnostics = self.Make_Diagnostics()
       if tb and self.traceback:
          fmt = traceback.format_tb(tb)
          fmt.insert(0, `value`) 
          value = string.joinfields(fmt, "\n")
       value = "%s\n%s" % (value, diagnostics)
       send_error(type, value)

   def Make_Diagnostics(self):
       """return a string for dumping diagnostics, default null."""
       return ""

   def success(self):
       """Hook called after normal completion: default -- do nothing.
          other implementation may write to a log file, for example.
       """
       pass

class Verbose_Mixin:
   """Mixin for cgiBase that provides verbose diagnostics for debugging."""

   def Make_Diagnostics(self):
       items = self.__dict__.items()
       items = map(str, items)
       return string.joinfields(items, "\n")

class ParseMixin:
   """Mixin class for cgiBase that automatically parses the form
      data, extracting single valued fields and multi-valued fields
      into a dictionary self.formdict.
      Single valued fields that are absent or multi-valued in the
      form result in a call to an error routine, either
           SingleValuedFieldAbsent or SingleValuedFieldMultiple.
      Multiple valued fields are permitted to be single valued or
      missing.
       self.formdict[name] returns field value for single valued fields.
       self.formdict[name] returns list of values for multi valued fields.
   """
   SingleValuedFields = [] # override in subclasses
   MultiValuedFields = []  # override in subclasses
   get_form_base = cgiBase.get_form # maybe override in subclasses

   def get_form(self):
       form = self.get_form_base(self)
       # extract single valued fields from the form
       formdict = {}
       for sname in self.SingleValuedFields:
           try:
              field = form[sname]
           except (KeyError, TypeError):
              self.SingleValuedFieldAbsent(sname)
              raise CGITerminate
           try:
              formdict[sname] = field.value
           except AttributeError:
              self.SingleValuedFieldMultiple(sname)
              raise CGITerminate
       # extract multivalued fields
       for mname in self.MultiValuedFields:
           try:
              field = form[mname]
           except (KeyError, TypeError):
              formdict[mname] = []
           else:
              try:
                 formdict[mname] = [field.value]
              except AttributeError:
                 list = []
                 for subfield in field:
                     list.append( subfield.value )
                 formdict[mname] = list
       self.formdict = formdict
       return formdict

   def SingleValuedFieldAbsent(self, name):
       diagnostics = self.Make_Diagnostics()
       text = "%s \n %s" % (name, diagnostics)
       send_error("required field absent", text)
       raise CGITerminate

   def SingleValuedFieldMultiple(self, name):
       send_error("multiple values disallowed", name)
       raise CGITerminate

   # redefine prepare_response to do nothing (may be overridden)
   def prepare_response(self, form):
       pass

if __name__=="__main__":
   # if called as a script run the cgiBase as a form handler.
   H = cgiBase()
   H.GO()
