## WORK IN PROGRESS

[traceback]()

## Enumeration 

Start with a detailed nmap scan:

```
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
```

Lets check out the webserver in a browser:
```
http://10.10.10.181/
```
[webserver]()

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
(webshells)[]

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
[smevk]()

I tried the credentials admin:admin and was able to login:

[portal]()

Looks like we can upload a reverse php shell to this location.  Lets use the 





