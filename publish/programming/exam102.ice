//*******************************************************************
//**              LPI 102 Certification Practice Test              **
//*******************************************************************

//-------------------------------------------------------------------
//                              EXHIBITS
//-------------------------------------------------------------------

Exhibit_1 "Ex_1"
text{
    boot=/dev/hda
    map=/boot/map
    install=/boot/boot.b
    vga=791
    default=redhat
    keytable=/boot/us.klt
    lba32
    prompt
    timeout=200
    message=/boot/message
    menu-scheme=wb:bw:wb:bw
    image=/boot/vmlinuz-2.4.7-10
	    label=redhat-2.4.7
	    root=/dev/hda9
	    read-only
    image=/boot/vmlinuz-2.4.16
        label=redhat
	    alias=redhat-2.4.16
	    root=/dev/hda9
	    read-only
    image=/boot/vmlinuz-2.4.8-26mdk
	    label=mandrake81
	    root=/dev/hda10
	    initrd=/boot/initrd.img
	    append=" devfs=mount"
	    read-only
    image=/boot/vmlinuz-2.2.15-4mdk
	    label=mandrake71
	    root=/dev/hda7
	    read-only
    other=/dev/hda2
	    label=eComStation
	    table=/dev/hda
    other=/dev/fd0
	    label=floppy
	    unsafe
}

Exhibit_2 "Ex_2"
text{
    <M> Parallel port support
    <M>   PC-style hardware
    < >     Multi-IO cards (parallel and serial)
    [ ]     Use FIFO/DMA if available (EXPERIMENTAL)
    [ ]     SuperIO chipset support (EXPERIMENTAL)
    <M>     Support for PCMCIA management for PC-style ports
    [ ]   Support foreign hardware
    [*]   IEEE 1284 transfer modes
}

Exhibit_3 "Ex_3"
text{
    # head -2 /home/jdoe/.bashrc
    PS1='From .bashrc --* '
    export PS1
    # head -2 /home/jdoe/.bash_login
    PS1='From .bash_login --* '
    export PS1
    # head -2 .bash_profile
    PS1='From .bash_profile --* '
    export PS1
    # grep 'PS1=' /etc/bashrc
    [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
}

Exhibit_4 "Ex_4"
//*** Does xinitd config source need to be escaped? ***
text{
    # description: the floozflam server handles
    #              flamflooz client connections
    service floozflam
    {
            disable         = yes
            flags           = NORETRY
            socket_type     = stream
            wait            = yes
            user            = root
            server          = /usr/sbin/in.floozflamd
            log_on_failure  += USERID
    }
}

//-------------------------------------------------------------------
//                              QUESTIONS
//
// Note: Items are number with Topic/Objective/Sequence;
//       See LPI's exam objectives for details.
//-------------------------------------------------------------------

// Configure fundamental system hardware

item 1.1/1/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Suppose that after installing a serial multi-port card on a
    system, the mouse connected to a serial port on your
    motherboard stops functioning.  Which of the following
    commands is MOST likely to be useful in diagnosing this
    problem?

^^^^A. setserial /dev/com1 -v auto_irq
^^^^B. cat /dev/mouse > serial-info.dump
^^^^C. setserial -a /dev/cua0
^^^^D. ioaddr /dev/ttyS1
}
//-------------------------------------------------------------------
// Setup SCSI and NIC devices

item 1.1/2/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    To determine what SCSI devices are attached to and recognized
    on either of the two SCSI channels by the currently running
    system, which command line would be BEST to run?

^^^^A. cat /proc/scsi/scsi
^^^^B. ls -l -i /dev/sd*
^^^^C. stinit -v /dev/sda /dev/sdb
^^^^D. scsiinfo --all --probe
}

item 1.1/2/2
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Which of the following command lines would provide the most
    useful information in diagnosing a suspected hardware address
    conflict between an an EISA ethernet NIC card and a video controller?

^^^^A. cat /proc/irq
^^^^B. cat /proc/meminfo
^^^^C. cat /proc/iomem
^^^^D. cat /proc/modules
}
//-------------------------------------------------------------------
// Configure modem, sound cards

item 1.1/3/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Whick of the following Linux utilities is MOST useful in
    determining what sort of motherboard audio support exists on
    the current system?

^^^^A. less -f /dev/audio
^^^^B. pnpdetect
^^^^C. modprobe
^^^^D. sndconfig
}
//-------------------------------------------------------------------
// Design hard-disk layout

item 2.2/1/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which Linux utility would provide BEST guidance to
    determining the relative performance characteristics of the
    several local hard-disks installed on a system?

^^^^A. nfsstone
^^^^B. hdparm
^^^^C. fdisk
^^^^D. modprobe
}
//-------------------------------------------------------------------
// Install a boot manager

item 2.2/2/1
options
    exhibit = "Ex_1"
    response_type = multiple alphabetic
    correct_answer = "AD"
question
text{
    Please examine the '/etc/lilo.conf' file listed in the
    exhibit.  Assume for purposes of this question that this
    configuration accurately matches the partitioning of the
    current system, and also that 'lilo' has been run while this
    configuration file is as listed.  Which of the following
    statements do you know to be true?

^^^^A. lilo is installed to the master boot record of the first
       IDE hard-disk.
^^^^B. lilo is installed on the partition '/dev/hda9' where there is
       a kernel image called '/boot/vmlinuz-2.4.7-10' on that
       partition.
^^^^C. Exactly three partitions on '/dev/hda' contain separate
       Linux installation.
^^^^D. The default boot kernel image is in a file named
       'vmlinuz-2.4.16'.
^^^^E. The kernel image /boot/vmlinuz-2.4.8-26mdk is stored on
       the partition '/dev/hda10'.
^^^^F. The current system contains exactly one IDE hard-disk.
}
//-------------------------------------------------------------------
// Make and install programs from source

item 2.2/3/1
options
    exhibit = "  "
    response_type = mutliple alphabetic
    correct_answer = "BC"
question
text{
    Suppose that you have just downloaded the application
    'someapp' in the form of the file
    'someapp-1.3.7.src.tar.bz2'.  You have placed this file in
    your '~/tmp' directory.  Which of the following command
    lines would be a reasonable first step for installation of
    the application

^^^^A. rpm Uvh someapp-1.3.7.src.tar.bz2
^^^^B. tar xvfj someapp-*
^^^^C. bunzip2 someapp-1.3.7.src.tar.bz2 | tar tvf -
^^^^D. cat someapp-1.3.7* | tar xvfz -
^^^^E. dbkg -L someapp-1.3.7.src.tar.bz2 | less
^^^^F. make --all someapp-1.3.7.src.tar.bz2
}

item 2.2/3/2
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following commands is frequently run first when
    compiling an unpacked Linux application from C source code?

^^^^A. rpm Uvh *
^^^^B. make install
^^^^C. setup -c
^^^^D. configure
}
//-------------------------------------------------------------------
// Manage shared libraries

item 2.2/4/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which of the following command lines would be MOST useful in
    determining a list of the shared libraries loaded with the
    application '/usr/local/bin/someapp'?

^^^^A. cat /etc/ld.so.conf | grep someapp
^^^^B. ldd -v /usr/local/bin/someapp
^^^^C. ldconfig -l /usr/local/bin/someapp
^^^^D. readlink /usr/local/bin/someapp
}
//-------------------------------------------------------------------
// Use Debian package management

item 2.2/5/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Assume you are maintaining a Debian-based Linux system.
    You wish to install the application 'someapp'.  Which of the
    following command lines would be the most common way to
    install the application?

^^^^A. dselect someapp
^^^^B. apt-setup someapp
^^^^C. dpkg --install someapp
^^^^D. apt-get install someapp
}

item 2.2/5/2
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Assume you are maintaining a Debian-based Linux system.  You
    find a file on your system called '/usr/local/bin/curious',
    and are unsure why the file is present.  Which of the
    following commands would provide you with information about
    the Debian package from which the file was installed?

^^^^A. dpkg -s /usr/local/bin/curious
^^^^B. dpkg -L /usr/local/bin/curious
^^^^C. dpkg -S /usr/local/bin/curious
^^^^D. dpkg -l /usr/local/bin/curious
}
//-------------------------------------------------------------------
// User Red Hat package management (rpm)

item 2.2/6/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Assume you are maintaining a RPM-based Linux sysem. Which of
    the following command lines would be a likely choice for
    installing a precompiled distribution of the application
    'someapp'

^^^^A. rpm -i someapp-1.3.7.src.rpm
^^^^B. rpm -Uvh someapp-1.3.7.i586.rpm
^^^^C. tar xvfz someapp-1.3.7.i386.tgz | rpm -qpl
^^^^D. rpm -Kv someapp-1.3.7.i386.rpm
}

item 2.2/6/2
options
    exhibit = "  "
    response_type = multiple alphabetic
    correct_answer = "BDF"
question
text{
    Assume you are maintaining a RPM-based Linux sysem. Which of
    the following applications can be used (if present on your
    system) for interactive management of installed packages?

^^^^A. dselect
^^^^B. kpackage
^^^^C. gpackage
^^^^D. xrpm
^^^^E. rpmfind
^^^^F. gnorpm
}

item 2.2/6/3
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Which of the following command lines would you use to verify
    that a Red Hat Package for 'someapp' that you wish to
    install has not become corrupted, or been tampered with?

^^^^A. rpm -Kv someapp-1.3.7.i586.rpm | tee someapp-1.3.7.md5
^^^^B. md5sum someapp-1.3.7.i586.rpm | diff - someapp-1.3.7.md5
^^^^C. gpg --verify someapp-1.3.7.i586.rpm
^^^^D. checkrpm someapp-1.3.7.i586.rpm
}
//-------------------------------------------------------------------
// Manage kernel modules at runtime

item 1.5/1/1
options
    exhibit = "  "
    response_type = multiple alphabetic
    correct_answer = "AC"
question
text{
    Which of the following utilities can be used to load driver
    support for an additional hardware device at runtime?

^^^^A. modprobe
^^^^B. lsmod
^^^^C. insmod
^^^^D. chmod
^^^^E. modules
^^^^F. modinfo
}
//-------------------------------------------------------------------
// Reconfigure, build and install a custom kernal and modules

item 1.5/2/1
options
    exhibit = "Ex_1"
    response_type = multiple alphabetic
    correct_answer = "BF"
question
text{
    The exhibit for this question is one screen of the kernel
    config utility at '/usr/src/linux-2.4.17/scripts/Menuconfig'.
    Based on this screen which of the following statements
    describe the kernel that would be created after saving the
    listed options?

^^^^A. Multi-IO card drivers are contained in loadable modules
       rather than in the base kernel.
^^^^B. The compiled system supports parallel ports at a hardware
       level, but we cannot determine whether parallel printer
       support is installed.
^^^^C. IEEE 1284 (enhanced parallel) mode drivers are contained
       in loadable modules rather than in the base kernel.
^^^^D. PCMCIA management drivers are contained in loadable
       modules rather than in the base kernel.
^^^^E. Kernel support for SuperIO chipsets is included in this
       base kernel.
^^^^F. IEEE 1284 (enhanced parallel) mode drivers are compiled
       directly into this base kernel.
}

item 1.5/2/2
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Which of the following command lines can NOT be used to
    configure the compilation of a new Linux kernel and kernel
    modules?

^^^^A. make xconfig
^^^^B. make menuconfig
^^^^C. make kernconfig
^^^^D. make config
}
//-------------------------------------------------------------------
// Perform basic file editing operations using vi

item 1.7/1/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Which of the following key sequences will save changes made
    during a 'vi' editing session, and end the application?

^^^^A. <esc>:qw
^^^^B. <esc>:sx
^^^^C. <esc>:wq
^^^^D. <esc>:xs
}
//-------------------------------------------------------------------
// Manage printers and print queues

item 1.7/2/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which of the following utilities can be used to terminate a
    spooled print job without printing it?

^^^^A. lpr
^^^^B. lpc
^^^^C. lpd
^^^^D. lpq
}
//-------------------------------------------------------------------
// Print files

item 1.7/3/1
options
    exhibit = "  "
    response_type = multiple alphabetic
    correct_answer = "AB"
question
text{
    Which of the following Linux comand lines will convert a
    plain text file 'file.txt' to postscript for later
    (prettified) printing or viewing?  Assume for this question
    that any mentioned utilities are actually installed to the
    system in question.

^^^^A. enscript -p - file.txt > file.ps
^^^^B. a2ps -o file.ps file.txt
^^^^C. text2ps < file.txt > file.ps
^^^^D. cat file.txt | lpr -P file.ps
^^^^E. ps2ascii file.ps file.txt
^^^^F. gs --source=file.txt --output=file.ps
}
//-------------------------------------------------------------------
// Install and configure local and remote printers

item 1.7/4/1
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    There have been a number of print-spooling systems developed
    for Linux, often offering a different range of capabilities
    such as format conversions and job-control tools.  Which ONE
    of the following is NOT a widely used print-spooling system?

^^^^A. CUPS
^^^^B. GPR
^^^^C. PDQ
^^^^D. LPD
}

item 1.7/4/2
options
    exhibit = "  "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    There have been a number of document-type filtering systems
    developed for Linux, and working in cooperation with
    print-spooling daemons.  Which ONE of the following is NOT a
    widely used filtering tool?

^^^^A. Apsfilter
^^^^B. Magicfilter
^^^^C. printfilter
^^^^D. doctype-filter
}
//-------------------------------------------------------------------
// Customize and use the shell environment

item 1.9/1/1
options
    exhibit = "Ex_3"
    response_type = alphabetic
    correct_answer = "C"
question
text{
    The exhibit for this question shows several shell
    configuration files.  Assume for this exercise that the PS1
    environment variable is not modified elsewhere in the
    (partially) displayed files, nor is it set anywhere else.  If
    user 'jdoe' opens a secure shell connection to this system
    (named 'fury') from a remote location, what will his bash
    prompt display?

^^^^A. From .bashrc --*
^^^^B. From .bash_login --*
^^^^C. From .bash_profile --*
^^^^D. [jdoe@fury jdoe]$
}

item 1.9/1/2
options
    exhibit = "Ex_3"
    response_type = alphabetic
    correct_answer = "A"
question
text{
    The exhibit for this question shows several shell
    configuration files on machine 'fury'.  Assume for this
    exercise that the PS1 environment variable is not modified
    elsewhere in the (partially) displayed files, nor is it set
    anywhere else.  If the root user issues a 'su jdoe' command,
    what will her bash prompt display?

^^^^A. From .bashrc --*
^^^^B. From .bash_login --*
^^^^C. From .bash_profile --*
^^^^D. [jdoe@fury root]$
}
//-------------------------------------------------------------------
// Customize or write simple scripts

item 1.9/2/1
//*** Does bash source need to be escaped? ***
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following bash command lines could be used to
    "run every executable file in the current directory"?

^^^^A. for i in * ; do { case [ -x $i ] ; { ./$i; } esac } done
^^^^B. while i in * ; do { if [ -x $i ] ; then { ./$i; } fi } done
^^^^C. foreach i in * ; do { if [ -x $i ] ; then { ./$i; } done }
^^^^D. for i in * ; do { if [ -x $i ] ; then { ./$i; } fi } done
}

item 1.9/2/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    What special line is normally placed at the top of a custom
    bash shell script?

^^^^A. #/usr/local/bin/bash
^^^^B. #!/bin/bash
^^^^C. #!/usr/env bash
^^^^D. #!/bash
}
//-------------------------------------------------------------------
// Install & Configure XFree86

item 2.10/1/1
options
    exhibit = " "
    response_type = multiple alphabetic
    correct_answer = "BD"
question
text{
    Which of the following utilities are commonly available on a
    Linux system, and have the capability to detect chipset
    details and installed memory on local video cards (useful
    for configuring XFree86)?

^^^^A. XF86Config
^^^^B. SuperProbe
^^^^C. scanpci
^^^^D. XConfigurator
^^^^E. X11Setup
^^^^F. scanvideo
}

item 2.10/1/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    The file '/etc/X11XF86Config' contains configuration
    information about the local X server.  Where within this file
    can you specify the video resolutions available when using
    the Ctrl-Alt-(Plus/Minus) toggles?

^^^^A. Section "Device" / Subsection "Resolutions"
^^^^B. Section "Screen" / Subsection "Display"
^^^^C. Section "Monitor" /Subsection "Mode"
^^^^D. Section "Video" / Subsection "ModeLine"
}
//-------------------------------------------------------------------
// Setup XDM

item 2.10/2/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following XFree86 tools is used to configure
    access to remote X11 clients?

^^^^A. xf86config
^^^^B. xeyes
^^^^C. xaccess
^^^^D. xdm
}
//-------------------------------------------------------------------
// Identify and terminate runaway X applications

item 2.10/3/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Unfortunately, not all X11 applications are well behaved.  In
    particular, some applications are notorious for leaving
    behind phantom processes when an X session is exited.  Which
    command line below might you use to make sure the application
    'Xsomeapp' is terminated?

^^^^A. ps h -o pid -C Xsomeapp | xargs kill -9
^^^^B. kill -1 -C Xsomeapp
^^^^C. terminate `top -n Xsomeapp`
^^^^D. proc -kill Xsomeapp
}
//-------------------------------------------------------------------
// Install & Customize a Window Manager Environment

item 2.10/4/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Suppose that you would like to allow the current system to
    act as an X client for SOME remote X servers.  Also assume
    that the current system is configured to recognize the alias
    TRUSTED for a corresponding IP address.  Which of the
    following command lines would allow the machine TRUSTED to
    run an X11 application that lives on the current system?

^^^^A. xallow -a TRUSTED
^^^^B. addremote TRUSTED
^^^^C. xhost +TRUSTED
^^^^D. Xclient --allow TRUSTED
}

item 2.10/4/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following environment variables is used to
    determine which workstation--local or remote--a launched X11
    application will display on?

^^^^A. XTERM
^^^^A. CLIENT
^^^^A. SERVER
^^^^D. DISPLAY
}
//-------------------------------------------------------------------
// Fundamentals of TCP/IP

item 1.12/1/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    RFC 1700 defines a set of standard port numbers for TCP/IP
    services.  Some of these ports are fairly obscure, while a
    number are used on a daily basis by a Linux systems
    administrator for diagnosis of network issues.  Which
    three services are mapped to the TCP/IP ports 80, 110 and 21
    (in the listed order)?

^^^^A. http, telnet, ssh
^^^^B. http, pop3, ftp
^^^^C. kerberos, smtp, ftp
^^^^D. whois, telnet, pop3
}

item 1.12/1/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Which of the following files is used to define aliases for IP
    addresses, especially within a local TCP/IP network?

^^^^A. /etc/hosts
^^^^B. /etc/services
^^^^C. /etc/aliases
^^^^D. /etc/networks
}
//-------------------------------------------------------------------
// TCP/IP troubleshooting & configuration

item 1.12/3/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following statements BEST describes a reason why
    you would want to run a DHCP server on an internal company
    LAN network?

^^^^A. To serve as a gateway between the external internet and an
       internal network, and to provide IP address translation of
       packets.
^^^^B. To filter network packets that may contain unauthorized or
       malicious contents, such as "hacker" portscans or overly
       large email attachments.
^^^^C. To allow in-company machines to access a central
       "web-services" application that is utilized in common by
       various employees.
^^^^D. To avoid confict between assigned IP addresses on various
       in-company machines, especially where machines such as
       laptops may between different ethernet hubs.
}

item 1.12/3/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Which of the following TCP/IP network utilities is the BEST
    tool to use to establish if a given IP address is reachable
    under the current network configuration?

^^^^A. ping
^^^^B. finger
^^^^C. route
^^^^D. host
}

item 1.12/3/3
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which of the following TCP/IP network utilities is BEST used
    to determine the hardware ethernet address of the card(s)
    installed in the current machine?

^^^^A. netstat
^^^^B. ifconfig
^^^^C. ethers
^^^^D. arpwatch
}

item 1.12/3/4
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following TCP/IP network utilities is the BEST
    tool to use in identifying bottlenecks between remote
    machines on the network?  Specifically, assume a goal in
    this debugging is to determine the paths travelled in the
    forwarding of network packets, and identify intermediate
    routers that may be dropping packets.

^^^^A. route
^^^^B. netstat
^^^^C. ping
^^^^D. traceroute
}

item 1.12/3/5
options
    exhibit = " "
    response_type = multiple alphabetic
    correct_answer = "CDF"
question
text{
    Suppose that you find that your ISPs DNS service is slow or
    unreliable, and you would like to configure aliases for a
    few frequently targetted sites directly on the machines of
    users of the company internal network you maintain. Which of
    the following TCP/IP network utilities could you use to
    determine the IP address assigned to symbolic domain names
    (e.g. "www.somehostsite.com")?

^^^^A. hostname
^^^^B. whois
^^^^C. host
^^^^D. nslookup
^^^^E. netstat
^^^^F. ping
}
//-------------------------------------------------------------------
// Configure and use PPP

item 1.12/4/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following commands is NOT a widely used Linux
    utility for initiating and configuring PPP connections?

^^^^A. KPPP
^^^^B. WvDial
^^^^C. netconf
^^^^D. netppp
}
//-------------------------------------------------------------------
// Configure and manage inetd and related services

item 1.13/1/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Which of the following utilities is often used in conjunction
    with inetd to log and filter incoming connection requests?

^^^^A. tcpd
^^^^B. logwatch
^^^^C. ipfilt
^^^^D. xinetd
}

item 1.13/1/2
options
    exhibit = "Ex_4"
    response_type = alphabetic
    correct_answer = "C"
question
text{
    The exhibit for this question shows the content of a
    hypothetical '/etc/xinetd.d/floozflam' configuration file.
    Assume that '/etc/xinetd.conf' includes the line
    "includedir /etc/xinetd.d", and that xinetd is used on the
    current system.  Which of the following statements can you
    deduce from the provided information?

^^^^A. The floozflam service is carried over the UDP protocol.
^^^^B. Multiple floozflam servers will be forked if multiple
       incoming requests are received.
^^^^C. The floozflam service in not activated on the current
       system.
^^^^D. If a floozflam connection fails, the IP address of the
       requesting client is logged.
}
//-------------------------------------------------------------------
// Operate and perform basic configuration of sendmail

item 1.13/2/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Suppose that the 'sendmail' application is used on the
    current system as a mail transport agent.  What file may user
    'jdoe' modify in order to cause mail sent to him to be
    temporarily directed to an address outside the system's
    domain?

^^^^A. /etc/sendmail/jdoe/forward
^^^^B. /home/jdoe/aliases
^^^^C. /etc/mail/aliases
^^^^D. /home/jdoe/.forward
}

item 1.13/2/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Suppose that the 'sendmail' application is used on the
    current system as a mail transport agent.  If the file
    '/etc/aliases' has been manually updated, what command needs
    to be run in order to cause the changes to take effect?

^^^^A. sendmail -bh
^^^^B. sendmail -ba
^^^^C. sendmail -bi
^^^^D. sendmail -bp
}
//-------------------------------------------------------------------
// Operate and perform basic configuration of apache

item 1.13/3/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which of the following command lines can be used to determine
    the list of modules that have been compiled into the Apache
    web server?

^^^^A. ls /etc/httpd/modules/
^^^^B. httpd -l
^^^^C. apache --modules
^^^^D. less /etc/httpd/conf/modules.conf
}
//-------------------------------------------------------------------
// Properly manage the NFS, smb, and nmb daemons

item 1.13/4/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following files or directories is used to
    configure the local directories that are made available
    remotely by an Network File System server?

^^^^A. /etc/fstab
^^^^B. /mnt/nfs
^^^^C. /etc/smb.conf
^^^^D. /etc/exports
}

item 1.13/4/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "B"
question
text{
    Which of the following protocols/tools is MOST likely to be
    used in integrating a Linux system into a Windows network,
    and for accessing Windows files?

^^^^A. NFS
^^^^B. SAMBA
^^^^C. FTP
^^^^D. SCP
}
//-------------------------------------------------------------------
// Setup and configure basic DNS servies

item 1.13/5/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    Suppose that you have configured one Linux system on an
    internal LAN to run a DNS server.  Which of the following
    files need to be updated on each DNS client on the LAN to get
    them to utilize the DNS service?

^^^^A. /etc/hosts
^^^^B. /etc/exports
^^^^C. /etc/resolv.conf
^^^^D. /etc/dns.conf
}
//-------------------------------------------------------------------
// Perform security admin tasks

item 1.14/1/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "C"
question
text{
    In performing a security audit on a Linux system, one
    well-known security issue is applications that are configured
    to run as root (or from other high-permission accounts) that
    may be subject to call vulnerabilities such as buffer
    overruns.  Which of the following command lines can be used
    for an initial sweep in analyzing this issue?

^^^^A. suid --list /*
^^^^B. chmod -R u-s ./*
^^^^C. find / -perm +4000 -user root
^^^^D. chgrp root `find / -suid`
}

item 1.14/1/2
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    Which of the following protocols or tools is BEST used to
    batch copy files between networked machines in a manner that
    protects their contents from an intruder using a packet
    sniffer?

^^^^A. ssh/scp
^^^^B. httpd/SSL
^^^^C. gpg/snmp
^^^^D. nfs/md5sum
}
//-------------------------------------------------------------------
// Setup host security

item 1.14/2/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "D"
question
text{
    Which of the following Linux utilities is used to update the
    user passwords stored in '/etc/passwd' to utilize the more
    secure "shadow password" style.

^^^^A. passwd -s
^^^^B. mkshadow
^^^^C. shadowpw
^^^^D. pwconv
}

item 1.14/2/2
options
    exhibit = " "
    response_type = multiple alphabetic
    correct_answer = "ADF"
question
text{
    Which of the following websites are well-known and important
    resources for monitoring known security problems in Linux
    distributions, and for obtaining patches and updates for
    vulnerable applications and components?

^^^^A. http://www.securityfocus.com/
^^^^B. http://www.bugtraq.com/
^^^^C. http://www.securityupdate.net/
^^^^D. http://www.cert.org/
^^^^E. http://www.linux-bugwatch.gov/
^^^^F. http://www.linuxsecurity.com
}
//-------------------------------------------------------------------
// Setup user level security

item 1.14/3/1
options
    exhibit = " "
    response_type = alphabetic
    correct_answer = "A"
question
text{
    One danger of a poorly written (or malicious) CGI application
    is that it can fork overly many child processes, eventually
    swamping the host system.  Which of the following steps could
    BEST be used to control this specific danger?

^^^^A. Include the line 'ulimit -u 512'  in the file
       /etc/profile.
^^^^B. For each CGI user, run the command 'edquota username', and
       set blocks to 2048 (or other appropriate value).
^^^^C. If a user is discovered to have an errant CGI application,
       run the command line 'ps hU username -o pid | xargs kill -9'
       to terminate their stray processes.
^^^^D. Edit the file /etc/limits to include a line similar to
       'CGI 512 2048 0 0 -' (or other appropriate values).
}
