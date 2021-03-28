//******************************************************************* 
//**              LPI 101 Certification Practice Test              ** 
//******************************************************************* 
 
//------------------------------------------------------------------- 
//                              EXHIBITS 
//------------------------------------------------------------------- 
 
Exhibit_1 "Ex_1" 
text{ 
    # jobs -l 
    [1]   5110 Running                 kedit & 
    [2]-  5382 Stopped (signal)        pine 
    [3]+  5457 Stopped (tty output)    vi 
} 
 
Exhibit_2 "Ex_2" 
//*** Does C source text w/ curly braces need to be escaped? *** 
text{ 
    int double(int n) 
    { /* int arg, int return */ 
       return n*2; 
    } 
    char hello(int n) 
    { /* int arg, char return */ 
       printf("hello %i\n", n); 
    } 
    int five() 
    { /* no args, int return */ 
       return 5; 
    } 
    int        triple(int n, int other, char nonsense) 
    { /* int arg, int return */ 
       return n*3; 
    } 
} 
Exhibit_3 "Ex_3" 
text{ 
    # nl /etc/fstab 
     1  LABEL=/                 /                       ext3    defaults        1 1 
     2  none                    /dev/pts                devpts  gid=5,mode=620  0 0 
     3  none                    /proc                   proc    defaults        0 0 
     4  none                    /dev/shm                tmpfs   defaults        0 0 
     5  /dev/hda5               swap                    swap    defaults        0 0 
     6  /dev/cdrom              /mnt/cdrom              iso9660 noauto,owner,kudzu,ro 0 0 
     7  /dev/fd0                /mnt/floppy             auto    noauto,owner,kudzu 0 0 
     8  /dev/hda7               /mnt/mandrake           ext2    defaults     0 0 
     9  /dev/hda8               /mnt/iso                ext2    defaults     0 0 
    10  /mnt/iso/enigma-i386-disc1.iso /mnt/iso/iso1    iso9660 loop         0 0 
    11  /mnt/iso/enigma-i386-disc2.iso /mnt/iso/iso2    iso9660 loop         0 0 
} 
Exhibit_4 "Ex_4" 
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
    image=/boot/vmlinuz 
            label=failsafe 
            root=/dev/hda10 
            initrd=/boot/initrd.img 
            append=" devfs=mount failsafe" 
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
    other=/dev/hda2 
            label=eComStation 
            table=/dev/hda 
    other=/dev/fd0 
            label=floppy 
            unsafe 
} 
Exhibit_5 "Ex_5" 
text{ 
    jdoe:x:502:1000:John Doe:/home/jdoe:/bin/bash 
} 
Exhibit_6 "Ex_6" 
text{ 
    SHELL=/bin/bash 
    PATH=/sbin:/bin:/usr/sbin:/usr/bin 
    MAILTO=root 
    HOME=/ 
 
    # run-parts 
    01 * * * * root run-parts /etc/cron.hourly 
    02 4 * * * root run-parts /etc/cron.daily 
    22 4 * * 0 root run-parts /etc/cron.weekly 
    42 4 1 * * root run-parts /etc/cron.monthly 
    23 4 * 1,6 1 root run-parts /etc/cron.special 
} 
Exhibit_7 "Ex_7" 
text{ 
    # cat /etc/cron.daily/slocate.cron 
    #!/bin/sh 
    renice +19 -p $$ >/dev/null 2>&1 
    /usr/bin/updatedb -f "nfs,smbfs,ncpfs,proc,devpts" -e "/tmp,/var/tmp,/usr/tmp" 
} 
 
//------------------------------------------------------------------- 
//                              QUESTIONS 
// 
// Note: Items are number with Topic/Objective/Sequence; 
//       See LPI's exam objectives for details. 
//------------------------------------------------------------------- 
 
// Work Effectively on the Unix Command Line 
 
item 1.3/1/1 
options 
    exhibit = "  " 
    response_type = multiple alphabetic 
    correct_answer = "CE" 
question 
text{ 
    Suppose that you have an application whose behavior depends 
    on the environment variable BAR.  Which of the following 
    command lines may be used in a bash shell to configure the 
    application? 
 
^^^^A. export $BAR=baz; echo $BAR 
^^^^B. set BAR=baz 
^^^^C. BAR=baz ; export BAR 
^^^^D. echo $BAR=baz 
^^^^E. declare -x BAR=baz 
^^^^F. echo BAR=baz 
} 
item 1.3/1/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Which of the following commands can be used to assure that a 
    file 'myfile' exists? 
 
^^^^A. cp myfile /dev/null 
^^^^B. touch myfile 
^^^^C. create myfile 
^^^^D. mkfile myfile 
} 
//------------------------------------------------------------------- 
// Process Text Streams Using Text Processing Filters 
 
item 1.3/2/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Which of the following command lines can be used to convert a 
    file containing DOS-style CR-LF line endings into Unix-style 
    LF line endings?  Assume for this question that the DOS-style 
    file is called 'dosfile', and we want the modified contents 
    in 'unixfile' 
 
^^^^A. sed 's/\r//' dosfile > unixfile 
^^^^B. tr -d '\r' < dosfile > unixfile 
^^^^C. dos2unix dosfile unixfile 
^^^^D. strip '\r' < dosfile > unixfile 
} 
 
item 1.3/2/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Suppose for this question that you have a file called 
    'wordlist' that contains a number of words, one per line. 
    You would like to produce an ad-hoc report that contains a 
    numbered list of the first five words, according to 
    alphabetical order.  Which of the following command lines can 
    be used to produce this report to the console? 
 
^^^^A. sort wordlist | nl | head -5 
^^^^B. split -1 wordlist ; cat xa? | head -5 
^^^^C. nl wordlist | sort | sed '/^     [^12345]/d' 
^^^^D. nl wordlist | sort | head -5 
} 
 
item 1.3/2/3 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    The command 'ps -A' displays an ordered list of all running 
    processes, with the right-justifed process ID in the first 
    space-separated field.  Suppose you would like to display to 
    screen a list of the five most recently launched processes 
    (those with the highest process IDs).  Which of the following 
    commands will display the desired items? 
 
^^^^A. ps -A | tail -5 | cut -f 1 -d " " 
^^^^B. ps -A | tail -5 | sed 's/[ ]*[0-9]*//' 
^^^^C. ps -A | head -5 | nl 
^^^^D. ps -A | tac | head -5 | cut -b 1-5 
} 
 
item 1.3/2/4 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Suppose that a file 'names' contains a list of names in the 
    form, "firstname lastname", one per line.  These names are 
    unsorted, and you would like them sorted by lastname; 
    however, the format of names on each line should remain the 
    same.  Which ONE of the following commands will NOT output an 
    appropriately sorted list of names to the console? 
 
^^^^A. cut -f 2 -d " " names | paste names - | sort -k 3 | cut -f 1 
^^^^B. sort -k 2 names 
^^^^C. sed 's/\(\w*\) \(\w*\)/\2 \1 \2/' names | sort | cut -f 2-3 -d " " 
^^^^D. cut -f 2 -d " " names | sort 
^^^^E. cut -f 2 -d " " names | paste - names | sort | cut -f 2 
} 
//------------------------------------------------------------------- 
// Perform Basic File Management 
 
item 1.3/3/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Assume that your current working directory is '/tmp' 
    and your home directory is '/home/jane'.  Which of the below 
    commands will copy all the content of '/tmp/test/' to 
    a 'test' subdirectory of your home directory? 
 
^^^^A. cp -r test/* /home/jane 
^^^^B. cp -r ./test ~ 
^^^^C. cp -r ~/test . 
^^^^D. cp -r /tmp/test /home/jane/test 
} 
//------------------------------------------------------------------- 
// Use Unix Streams, Pipes, and Redirects 
 
item 1.3/4/1 
options 
    exhibit = "  " 
    response_type = multiple alphabetic 
    correct_answer = "ABDE" 
question 
text{ 
    Suppose that you have several files matching the filename 
    pattern 'file[0-9]'.  You would like to visually compare the 
    contents of all such files, in a side-by-side fashion.  Which 
    of the following commands would let you view the desired ad 
    hoc report? 
 
^^^^A. ls file[0-9] | xargs paste | less 
^^^^B. paste `ls file[0-9]` > report ; vi report ; rm report 
^^^^C. cat file[0-9] | paste - | more | less 
^^^^D. ls file[0-9] | tee fnames | paste `cat fnames` 
^^^^E. ls file[0-9] | tee fnames | xargs paste | more 
^^^^F. ls *word* > fnames ; paste < xargs `cat fnames` | vi 
} 
//------------------------------------------------------------------- 
// Create Monitor, and Kill Processes 
 
item 1.3/5/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Which of the following Linux utilities does NOT include the 
    capability to list the process IDs of running applications? 
 
^^^^A. jobs 
^^^^B. ps 
^^^^C. nice 
^^^^D. top 
} 
 
item 1.3/5/2 
options 
    exhibit = "Ex_1" 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Given the 'jobs' display in the exhibit, which command could 
    you use to switch display focus to the application 'vi'? 
 
^^^^A. bg %3 
^^^^B. fg %3 
^^^^C. top -p 5457 
^^^^D. switch %5457 
} 
 
item 1.3/5/3 
options 
    exhibit = "Ex_1" 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Given the 'jobs' display in the exhibit, which command could 
    you use to terminate the application 'vi'? 
 
^^^^A. bg %3 
^^^^B. kill -9 5457 
^^^^C. term -i %3 
^^^^D. fg 5457 
} 
//------------------------------------------------------------------- 
// Modify Process Execution Priorities 
 
item 1.3/6/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Suppose you have a running program called 'myprog', that is a 
    child of the current shell.  You would like to decrease the 
    CPU usage of this program.  Which of the following command 
    lines can you use to make 'myprog' yield more CPU resources? 
 
^^^^A. nice +1 myprog 
^^^^B. ps h -o pid -C myprog | xargs nice +1 - 
^^^^C. renice +1 -u `whoami` myprog 
^^^^D. renice +1 -p `ps -a | grep myprog | cut -b 1-6` 
} 
//------------------------------------------------------------------- 
// Perform Searches of Text Files, Use of Regular Expressions 
 
item 1.3/7/1 
options 
    exhibit = "Ex_2" 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Correctly parsing a C source file requires a full-fledged 
    parser (such as that built into a C compiler).  Nonetheless, 
    regular expressions can be used to provide a pretty good 
    approximate descriptions of many program constructs. Which of 
    the following searches will locate at least most of the C 
    functions that accept an int as a first argument, and return 
    an int (and will not produce false positives very often). 
    The exhibit contains a fragment of C code with several 
    annotated matching and non-matching functions (for non-C 
    programmers). 
 
^^^^A. grep -E "int[ \t]+\w+[ \t]*\([ \t]*int" *.c 
^^^^B. grep -E "^int\w+[A-Za-z_]+\w*\(\w*int" *.c 
^^^^C. grep -E "int.+\([ \t]+int.*\) " *.c 
^^^^D. grep -E "int[ \t]+[A-Za-z_][ \t]+\(int" *.c 
} 
 
//------------------------------------------------------------------- 
 
item 1.3/7/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Some tools that use regular expressions support so-called 
    "extended" regular expressions.  For example, GNU 'grep' with 
    the '-E' option uses extended regular expressions.  Other 
    tools like 'sed' only support "basic" regular expressions. 
    As a consequence, one must be careful in selecting the right 
    regular expression syntax.  Which of the following characters 
    have a special meaning in extended regular expressions, but 
    not in basic regular expressions.  That is, which of the 
    following is an extended regular expression "meta-character", 
    but only a regular character in basic regular expressions? 
 
^^^^A. ^ 
^^^^B. [ 
^^^^C. + 
^^^^D. * 
} 
//------------------------------------------------------------------- 
// Create partitions and filesystems 
 
item 2.4/1/1 
options 
    exhibit = "  " 
    response_type = multiple alphabetic 
    correct_answer = "CF" 
question 
text{ 
    Based on Linux' partition naming system, which of the 
    following device names point to "logical" partitions 
    (assuming the corresponding partitions exist at all on the 
    system in question)? 
 
^^^^A. /dev/sda3 
^^^^B. /dev/fd0 
^^^^C. /dev/hdb7 
^^^^D. /dev/hda4 
^^^^E. /dev/fd7 
^^^^F. /dev/sdc11 
} 
 
item 2.4/1/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Which of the following command lines can (possibly) be used 
    to format a partition? Assume required partitions exist, and 
    also that logical partitioning is used on each hard-disk. 
 
^^^^A. mkfs -t msdos /dev/sda1 
^^^^B. mkfs.ext2 /dev/null 
^^^^C. mkfs -t ext2 /dev/hda4 
^^^^D. mkfs --type=ext2 /dev/hdb7 
} 
//------------------------------------------------------------------- 
// Maintain the integrity of filesystems 
 
item 2.4/2/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Which Linux command can be used to repair improperly 
    shutdown, or otherwise potentially corrupt partitions? 
 
^^^^A. chkdsk 
^^^^B. scandisk 
^^^^C. fsck 
^^^^D. fdisk 
} 
 
item 2.4/2/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Which of the following command lines will produce an ad hoc 
    report on the total disk space used personally by the current 
    user? 
 
^^^^A. fsck ~ 
^^^^B. df ~/. 
^^^^C. quota --used 
^^^^D. du -hs ~ 
} 
 
item 2.4/2/3 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Which Linux command can be used to determine the available 
    space on local hard-disk partitions? 
 
^^^^A. free 
^^^^B. df 
^^^^C. du 
^^^^D. fdisk 
} 
//------------------------------------------------------------------- 
// Control filesystem mounting and unmounting 
 
item 2.4/3/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Please examine the exhibit for this question which displays 
    the actual '/etc/fstab' file for the system on which this 
    exam was created.  Which of the following lines in the file 
    causes a fixed and user-writeable partition to be mounted? 
 
^^^^A. Line 5 
^^^^B. Line 11 
^^^^C. Line 9 
^^^^D. Line 7 
} 
//------------------------------------------------------------------- 
// Set and view disk quota 
 
item 2.4/4/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Which Linux command can be used to limit the disk space 
    usage allowance of a particular user? Assume for this 
    question that quotas are enabled for the filesystem(s) in use 
    on the system in question. 
 
^^^^A. edquota 
^^^^B. setquota 
^^^^C. quotaon 
^^^^D. repquota 
} 
//------------------------------------------------------------------- 
// Use file permissions to control access to files 
 
item 2.4/5/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Suppose you have created a new application 'myapp', and 
    copied it to the directory '/usr/local/bin'.  You would like 
    all the users of the system to be able to run your 
    application.  Which of the following command lines would 
    allow the appropriate access? 
 
^^^^A. chmod o+x /usr/local/bin/myapp 
^^^^B. chgrp bin /usr/local/bin/myapp 
^^^^C. umask 0022 /usr/local/bin/myapp 
^^^^D. chown 755 /usr/local/bin/myapp 
} 
 
item 2.4/5/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Proper file security is particularly important for CGI 
    applications invoked over the web, given the diversity of 
    users.  Which of the command lines setup reasonable file 
    permissions for a CGI applications? Even though particular 
    web servers may require slightly different configurations, 
    you should be able to rule out all the wrong answers below. 
 
^^^^A. chmod a-x ~/www/cgi-bin/myapp.cgi 
^^^^B. chmod 075 ~/www/cgi-bin/myapp.cgi 
^^^^C. chmod 711 ~/www/cgi-bin/myapp.cgi 
^^^^D. chmod o+w ~/www/cgi-bin/myapp.cgi 
} 
//------------------------------------------------------------------- 
// Manage file ownership 
 
item 2.4/6/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Which Linux command is used to assign privileges over a 
    particular file to a designated user 
 
^^^^A. chroot 
^^^^B. chown 
^^^^C. assign 
^^^^D. chgrp 
} 
//------------------------------------------------------------------- 
// Create and change hard and symbolic links 
 
item 2.4/7/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    One advantage of hard links over symbolic links is: 
 
^^^^A. A hard link can span different filesystems 
^^^^B. A hard link does not become disconnected from the 
       underlying file if the file is moved. 
^^^^C. You can determine the inode used by a hard link, but not 
       for a symbolic link. 
^^^^D. A hard link allows you to change the permissions on the 
       underlying file. 
} 
//------------------------------------------------------------------- 
// Find system files and place files in the correct location 
 
item 2.4/8/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    According to the Linux filesystem hierarchy standard, which 
    of the following directories would be an appropriate location 
    for a user to install a shared application to? 
 
^^^^A. /sbin 
^^^^B. /dev/user/bin 
^^^^C. /usr/local/bin 
^^^^D. /etc/bin 
} 
//------------------------------------------------------------------- 
// Boot the system 
 
item 2.6/1/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Which of the following Linux command lines can be used to 
    examine kernel bootup messages after boot time? 
 
^^^^A. dmesg | less 
^^^^B. less /proc/kmsg 
^^^^C. bootlog -v 
^^^^D. vi /var/log/messages 
} 
 
item 2.6/1/2 
options 
    exhibit = "Ex_4" 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Please examine the exhibit for this question which displays 
    the file '/etc/lilo.conf'.  Assume that the 'lilo' command 
    has been run while this configuration file is as listed. 
    Which of the following statements correctly describes what 
    happens when this machine boots up? 
 
^^^^A. The system boots after a 20 second delay, and absent user 
       intervention the root filesystem is on /dev/hda10. 
^^^^B. The system boots after a 20 second delay, and absent user 
       intervention the root filesystem is on /dev/hda9. 
^^^^C. The system boots after 2 seconds delay, and absent user 
       intervention the root filesystem is on /dev/hda9. 
^^^^D. The system boots after a 200 second delay, and absent user 
       intervention the floppy disk is a fallback boot device. 
} 
//------------------------------------------------------------------- 
// Change runlevels and shutdown or reboot system 
 
item 2.6/2/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Which command line can be used to restart a running Linux 
    system immediately? 
 
^^^^A. restart --delay=0 
^^^^B. reboot -w 
^^^^C. halt -p 
^^^^D. shutdown -r now 
} 
//------------------------------------------------------------------- 
// Use and Manage Local System Documentation 
 
item 1.8/1/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Suppose that you know that a task deals with the general 
    concept "floozflam", but you are not certain what Linux 
    command(s) are available for working with floozflams.  Which 
    of the following Linux command lines would be the BEST first 
    step in finding out about available tools? 
 
^^^^A. man floozflam 
^^^^B. locate floozflam 
^^^^C. apropos floozflam 
^^^^D. whatis floozflam 
} 
 
item 1.8/1/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Suppose you know that an application 'someapp' is installed 
    on the current system.  You have already examine the man and 
    info pages for 'someapp', but are trying to find additional 
    information about 'someapp'.  Which of the following 
    directories is the BEST first place to look for further 
    documentation files? 
 
^^^^A. /usr/local/doc/someapp-2.37 
^^^^B. /usr/share/doc/someapp-2.37 
^^^^C. /etc/someapp-2.37/doc 
^^^^D. /etc/doc/someapp-2.37 
} 
 
item 1.8/1/3 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Which of the following Linux commands are you likely to use 
    to display hypertextual documentation on a command? 
 
^^^^A. info 
^^^^B. man 
^^^^C. whatis 
^^^^D. locate 
} 
//------------------------------------------------------------------- 
// Find Linux documentation on the Internet 
 
item 1.8/2/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Which of the following URLs is a BEST first internet site to 
    go to for information about how to perform an unfamiliar 
    Linux task? 
 
^^^^A. http://www.linuxman.com/ 
^^^^B. http://www.linuxhowto.net/ 
^^^^C. http://www.linuxtoday.com/ 
^^^^D. http://www.linuxdoc.org/ 
} 
//------------------------------------------------------------------- 
// Write System Documentation 
 
item 1.8/3/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Suppose you have created an application that you wish to 
    distribute to other users and system.  Your application 
    archive already contains the necessary executables, source 
    code, and configuration files.  But you would like to provide 
    user with a quick explanation of the purpose and requirements 
    of your application.  Which of the following filenames BEST 
    matches users' expectations about where first to look for 
    application documentation 
 
^^^^A. START 
^^^^B. README 
^^^^C. FIRST 
^^^^D. MAKEFILE 
} 
//------------------------------------------------------------------- 
// Manage users and group accounts and related system files 
 
item 2.11/1/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "A" 
question 
text{ 
    Which of the following Linux commands can be used to set an 
    expiration date for a user's password? 
 
^^^^A. chage 
^^^^B. vipw 
^^^^C. passwd 
^^^^D. usermod 
} 
 
item 2.11/1/2 
options 
    exhibit = "Ex_5" 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    The exhibit for this question contains a line from the file 
    '/etc/passwd'.  Which of the following statements is true, 
    based on the information in the exhibit? 
 
^^^^A. User John Doe belongs to the group with groupID 502. 
^^^^B. Shadow passwords are used on the current system. 
^^^^C. The username 'jdoe' belongs to the group 'jdoe'. 
^^^^D. Members of groupID 1000 can read directory /home/jdoe. 
} 
 
item 2.11/1/3 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Which Linux command can be used to create a new user account? 
 
^^^^A. newuser 
^^^^B. useradd 
^^^^C. mkuser 
^^^^D. usercfg 
} 
 
item 2.11/1/4 
options 
    exhibit = "  " 
    response_type = multiple alphabetic 
    correct_answer = "AD" 
question 
text{ 
    Which Linux command(s) can be used to modify the list of 
    groups a user belongs to? 
 
^^^^A. usermod 
^^^^B. groupadd 
^^^^C. groups 
^^^^D. gpasswd 
^^^^E. chgrp 
^^^^F. userinfo 
} 
//------------------------------------------------------------------- 
// Tune the user environment and system environment variables 
 
item 2.11/2/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Which Linux file can be used to configure the default bash 
    shell behavior for EVERY users on a system? 
 
^^^^A. /etc/skel/.bashrc 
^^^^B. /home/.bash_profile 
^^^^C. /etc/profile 
^^^^D. /etc/passwd 
} 
 
item 2.11/2/2 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Which of the following BEST describes the purpose of the 
    '/etc/skel' directory? 
 
^^^^A. The contents of the directory control the initialization of 
       the shell environment during each login. 
^^^^B. The contents of the directory determine the actions 
       performed during the system boot process. 
^^^^C. The contents of the directory provide a default 
       environment for newly created users. 
^^^^D. The contents of the directory list the background 
       processes that run during a user's session. 
} 
//------------------------------------------------------------------- 
// Configure and use system log files... 
 
item 2.11/3/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Which of the following command lines would allow you to 
    examine how many times remote users have opened secure shells 
    into the current system? 
 
^^^^A. dmesg | less 
^^^^B. less /proc/kmsg 
^^^^C. sshd --log | more 
^^^^D. vi /var/log/messages 
} 
//------------------------------------------------------------------- 
// Automate system administration tasks by scheduling jobs... 
 
item 2.11/4/1 
options 
    exhibit = "Ex_6" 
    response_type = alphabetic 
    correct_answer = "B" 
question 
text{ 
    Refer to the '/etc/crontab' file listed in the exhibit for 
    this question.  Which of the following statements is true? 
 
^^^^A. The script file '/etc/cron.special is run once a week, on 
       Mondays. 
^^^^B. The contents of the '/etc/cron.special directory are run 
       during January and June. 
^^^^C. During some parts of the year '/etc/cron.special' is run 
       one minute after '/etc/cron.weekly'. 
^^^^D. During the month of March, '/etc/cron.special' is run on 
       Mondays. 
} 
 
item 2.11/4/2 
options 
    exhibit = "Ex_7" 
    response_type = alphabetic 
    correct_answer = "D" 
question 
text{ 
    Based on the what the exhibit shows, which of the following 
    statements is the BEST assumption? 
 
^^^^A. When cron runs updatedb, confirmations are logged to the 
       root console. 
^^^^B. The /etc/crontab file is configured to automatically index 
       remote filesystems. 
^^^^C. cron runs updatedb at a high processor priority in 
       order to complete it quickly. 
^^^^D. The locate database is automatically refreshed on a daily 
       basis. 
} 
//------------------------------------------------------------------- 
// Maintain an effective data backup strategy 
 
item 2.11/5/1 
options 
    exhibit = "  " 
    response_type = alphabetic 
    correct_answer = "C" 
question 
text{ 
    Which of the following Linux commands can be used to 
    create backups of filesystems and directories? 
 
^^^^A. backup 
^^^^B. gzip 
^^^^C. tar 
^^^^D. archive 
} 
