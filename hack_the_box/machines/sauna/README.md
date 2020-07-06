# Sauna

* **Level**: Easy
* **Operating System**: Windows

<br />

Start off with a detailed nmap scan
```
nmap -sC -sV -Pn -p- 10.10.10.175


PORT      STATE SERVICE       VERSION
53/tcp    open  domain?
| fingerprint-strings:
|   DNSVersionBindReqTCP:
|     version
|_    bind
80/tcp    open  http          Microsoft IIS httpd 10.0
| http-methods:
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Egotistical Bank :: Home
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2020-02-16 10:59:13Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: EGOTISTICAL-BANK.LOCAL0., Site: Defaul>
445/tcp   open  microsoft-ds?
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: EGOTISTICAL-BANK.LOCAL0., Site: Defaul>
3269/tcp  open  tcpwrapped
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
9389/tcp  open  mc-nmf        .NET Message Framing
49667/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
49670/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49671/tcp open  msrpc         Microsoft Windows RPC
49681/tcp open  msrpc         Microsoft Windows RPC
49691/tcp open  msrpc         Microsoft Windows RPC
64562/tcp open  msrpc         Microsoft Windows RPC

1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerpri>
SF-Port53-TCP:V=7.70%I=7%D=2/15%Time=5E48AFB1%P=x86_64-pc-linux-gnu%r(DNSV
SF:ersionBindReqTCP,20,"\0\x1e\0\x06\x81\x04\0\x01\0\0\0\0\0\0\x07version\
SF:x04bind\0\0\x10\0\x03");
Service Info: Host: SAUNA; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 8h01m24s, deviation: 0s, median: 8h01m24s
| smb2-security-mode:
|   2.02:
|_    Message signing enabled and required
| smb2-time:
|   date: 2020-02-16 06:01:33
|_  start_date: N/A

```

<br />

Quite a few ports open.  Notice that we got the domain name, EGOTISTICAL-BANK.LOCAL.  We might need this later.  Let's start with the low hanging fruit and see if we can connect via SMB:
```
smbclient -L //10.10.10.175/ -U ""
smbclient -L //10.10.10.175/ -U "guest"%
```

<br />

Both of these attempts failed, so we cannot authenticate with a null session or guest account.   Let's try gather more information with enum4linux: 
```
enum4linux -A 10.10.10.172
```

<br />

Still did not get anything worthwhile.  Lets take a look at what the webserver is hosting:
```
http://10.10.10.175/
```
![website]()


<br />

Looks like a banking website.  I checked all of the links and found a page containing potential usernames:
```
http://10.10.10.175/about.html
```
![team]()

<br />

I compiled these usernames into a list using a [guide on active directory naming conventions](https://activedirectorypro.com/active-directory-user-naming-convention/), which breaks down three ways to organize names:
	1. Complete first name plus last name
	2. Initial of first name and complete last name 
	3. First three characters of the first name and first three of last name

I did each of these options with and without periods separating the first and last name.   So for Fergus Smith, his options looked like this 

	1. Fergus.Smith
	2. FergusSmith
	3. F.Smith
	4. Fsmith
	5. FerSmi
	6. Fer.Smi

Now do that for all six people.

Just to be sure that I did not miss any usernames, I used Cewl to scrape the website for potential usernames and passwords:
```
cewl -d 2 -m 5 -w cewl.txt http://10.10.10.175/index.html
```

<br />

Now I combined the cewl list with the user list that I made into a users.txt file.  Since port 88 is open, we know that this machine is running kerberos.  Therefore, we can try to brute-force kerberos authentication.  Kerberos pre-authentication failure is not logged in Active Directory with a normal Logon failure event (4625), but rather with specific logs to Kerberos pre-authentication failure (4771).  This will also verify if any usernames in our list are correct and if any of those accounts do not require pre-authentication, which can be useful to perform an [ASREPRoast attack](https://www.tarlogic.com/en/blog/how-to-attack-kerberos/).

