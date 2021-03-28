Evaluation of GNUmed
====================

:Author: David Mertz, Ph.D.
:Contact: mertz@gnosis.cx / +1-413-824-9414
:Version: $Revision: 1 $
:Copyright: This document has been placed in the public domain.
:Date: August, 2010

.. contents::

Background of Evaluation
------------------------

In September 2009, Jim Busser -- a medical doctor who has been a non-coding
volunteer in the GNUmed project -- contacted the Python Software Foundation
(PSF) Board of Directors seeking advice in finding independent profesional
evaluation of the codebase of GNUmed. Dr. Busser expressed an interest in
performing due diligence to assure that the projects design decisions have
been made soundly, that the code is meets professional software coding
standards, and that security issues have been adequately addressed in
protection of confidential data handled by GNUmed software.

Subsequent to this inquiry, as a then and current member of the PSF Board, I
forwarded the request to the general Python Software Foundation membership,
with an offer to Dr. Busser to help vet any replies that arose there for
competent evaluators. Unfortunately, I wasn't able to locate any PSF members
interested and competent to work on such an evaluation by these means;
however, in light of this, I volunteered to make such an evaluation myself,
being impressed with the goals of the project and usefulness of the software
after an overview evaluation. I performed this evaluation in November of
2009, and have monitored the general progress of the project since then.

I accepted a (somewhat nominal) payment for my time spent in performing an
evaluation, with the agreement that the evaluation would be independent, and
no *a priori* focus or conclusion was directed by such payment.  The goal
expressed by GNUmed project members I communicated with was that anything I
might find showing need for improvements would be at least as valuable as an
overview conclusion of design soundness.

Personal Background
-------------------

As well as my membership in the Python Software Foundation and its Board of
Directors, I serve as Chair of the PSF Trademarks Committee, and have
written a book and numerous well-read articles about the Python programming
language and other computer technologies, including databases, computer
security and networking.

In a professional volunteer capacity, I served as the Chief Technology
Officer of the non-profit Open Voting Consortium (OVC), which has advocated
for and developed the use of open source, secure and voter-transparent
software for use in governmental elections. Much of the software developed
under my supervision at OVC is written in Python.

In consulting positions I have worked with and evaluated a variety of
software systems, including large codebases, written in Python and other
programming languages. Additional resume details of this evaluator are
available upon request.

Overview of Evaluation
----------------------

As is typical of open source software, the entirety of the GNUmed code base
is available for download and evaluation, without restrictions, for any
interested user. As an initial step of the evaluation, I downloaded the
current code base in source form, as well as several packaged binary
distributions of the software.  Being written in an runtime-interpreted
programming language -- Python -- a separate compilation step is not
required to run GNUmed; however, GNUmed authors have packaged the source
files into bundles for several operating systems (including a self-booting
CD distribution) for easier evaluation and use.  These bundled forms are not
required for use, but make resolution of dependencies and configurations
simpler, especially for non-technical users.

In my evaluation, I initially examined the runtime user interface of GNUmed,
including its help system. I am not expert in the specific needs of medical
records software, but am broadly familiar with design of user interfaces. I
found the user interface to be simple to operate, contain a dense but well
structured presentation of record information, and to avoid any apparent
glitches or opaque functionality. Given the inherent complexity of the task
of medical record management, I believe that lay users of the interface will
require at least several hours of training to become fully familiar with the
user interface of GNUmed. However, there are no unnecessary surprises in its
operation or organization of information and I assume a similar training
requirement will exist for any other open source or proprietary software in
the same domain.

My evaluation of the user interface was peformed primarily to familiarize
myself with its overall operation to a degree sufficient to understand the
purpose of the source code that implemented these functions.  The bulk of my
evaluation was in examining that source code for typical design or coding
flaws that might be found in large and/or open source projects.

I was pleased to find the code base for GNUmed well structured, cleanly
coded, and free of any broad flaws that I was able to detect.  This is a
strong project written by highly competent and well-disciplined coders with
a good knowledge of Python programming practices and of general database and
security issues.  I believe the existing releases of GNUmed are stable and
secure, and that the code organization is such as to allow relatively easy
extension and customization as is needed for specific installations and
implementations.

Details on Source Code Evaluation
---------------------------------

Following my review of the source code, I provided a set of specific
comments.  Some additional points came out during discussion with GNUmed
developers, which I also address here.  I am not certain which of these
issue have been mooted by more current releases than I have examined
carefully, but none of them are "deal breaker" concerns, simply tweaks to
best coding practices.

Unified Printing System
~~~~~~~~~~~~~~~~~~~~~~~

Being written to run on multiple operating systems in multiple
configurations, producing consistent printed reports is somewhat of a
challenge that GNUmed had not fully addressed as of November 2009. Technical
`options for printing systems`_ are discussed on the GNUmed Wiki.

.. _options for printing systems:
   http://wiki.gnumed.de/bin/view/Gnumed/PrintingMethods

Documentation for developers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* A README in the top level directory would be a good place to put a section on "How to get started with editing source". Even a few paragraphs would help developers get oriented more quickly.

* The ``check-prerequisites.(sh|py)`` tool is a surprisingly friendly introduction to setup. That's a nice touch.

* The use of "Programmer notes" was a nice touch in the "GUI elements" page of the User Manual. Adding that other places would help a programmer encountering the software identify relations between functionality and code design. Of course, that could be intrusive for regular users, so some means of tucking away such notes would be good. Perhaps CSS to fold them away, or perhaps an "enhanced manual" that included them, with the end-user version generated by filtering out those sections.

* The `API documentation`_ is good; however, it would be worthwhile to include these pages with the GNUmed tarball, or in a supplementary GNUmed-Docs.tgz archive. The salaam.homeunix.com site seems to be fairly poorly performing, and links to it are not as obvious as one would wish.

.. _API documentation: http://salaam.homeunix.com/~ncq/gnumed/api/

Code Organization
~~~~~~~~~~~~~~~~~

* The directory organization is extremely inviting to developers. The separation of ``business/``, ``wxpython/``, and ``pycommon/`` is very well done. I do not believe it would be particularly difficult to jump into the code to add a new feature.

* When I first look at a set of business logic like this, tied to a database, the thought strikes me that perhaps the database operations should be factored out of the rest of the business logic. However, looking at this code, I am not inclined toward such further separation. Those methods that access the DB are primarily driven by those operations, with a minimum of other checks or calculations in the Python code, and these are quite readable as-is. Moreover, my own feeling is that something like an ORM is almost always more fragile than it is worth for obtaining more native-feeling source code. That applies here clearly, and the relational design is more robust than an ORM could capture.

* What is actually working? This I find less clear than I would like to (as either a user or developer). For example in 0.5.1, the file ``gmMedication.py`` contains ``cConsumedSubstance()``. The naming seems to provide a good indication of the function of the class. However, the bulk of the class is commented out in the implementation (I would guess because of some bug in its details; though the commented out code makes basic functional sense). The result, I presume is that allergy information cannot be modified in this version. A ``TODO`` or ``WHATSNEW`` in the source code tree could clarify this, though obviously takes work to maintain itself. I may be missing something functional along these lines within some other wiki page, issue/ticket tracker, or other out-of-stream documentation.

* Unit tests: Many of the ``business/`` modules have some unit tests built in to them. However, they do not seem to be systematic, and the results seem to need interpretation. For example, ``gmVaccination.py`` has quite a few tests, but all of them print out report-style values, but never raise explicit unit test failures if values are not as expected. It is possible that some called functions *will* raise exceptions in failure cases, but then it's a matter of tracing through call stacks rather than reading clearly encapsulated error reports.

 - Moreover, it would be nice if the unit tests came in a defined suit that could be run with a "test_all" command. It might not take that much to cobble together a wrapper that called the various modules and tested the outputs against expectations. Having that would be very helpful to release-cycle management (or even to running nightly regressions).

SQL
~~~

* Having an easy way to identify the table schemas would be a huge aid to new programmers. As is, there's nothing in the client code other than example of existing ``SELECT``/``INSERT`` statements. To see the organization, one needs to also grab the server code, and browse around ``sql/`` directory. It would be really helpful -- even on an ongoing basis, not only as a first look at code -- to have schema diagram of the tables and fields available. There might be FOSS tools to generate these from the SQL, I'd have to look around to see the state of that. There are two levels of development where the schema diagrams would help:

 (1) Answering the question, "Where should I put or find this data that my  new feature wants to work with?" I.e. the table and field names (and any foreign key constraints I need to maintain).

 (2) Answering the question, "Is there ANY existing table where my new feature can store its data? Do I need to change the schema to accommodate this new feature?"

* Following on the salaam.homeunix.com site, and partially superseding the comment I make above about database schemas, I see there *are* schema descriptions at http://salaam.homeunix.com/~ncq/gnumed/schema/devel/. Finding this was non-obvious; I only came across it by playing with the linked URL for the API docs to guess at what else was on that site.

* A minor code-style issue. I find it easier to scan SQL statements if they use consistent casing (even though SQL itself is case-insensitive). In particular, in my own code, I think it stands out nicely to put SQL keywords in CAPS, and table and field names in lowercase. The GNUmed source does this sometimes, but not consistently.

E.g. instead of::

 cmd = u"""
       insert into dem.lnk_person_org_address(id_identity, id_address)
       values (%(id)s, %(adr)s)"""

It would scan nicely to use::

 cmd = u"""
       INSERT INTO dem.lnk_person_org_address(id_identity, id_address)
       VALUES (%(id)s, %(adr)s)"""

Or even if the convention is all-lower, it should be consistent in the code.

* Over-the-wire encryption is available with the ``sslmode=prefer`` option in the ``psycopg2`` interface. That seems fine, though it might be nice to optionally allow SSH tunneling instead (which is outside the ``psycopg2`` interface itself, of course).
