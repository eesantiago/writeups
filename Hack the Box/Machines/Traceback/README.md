## WORK IN PROGRESS

[traceback]()

## Enumeration 

/
Start with a detailed nmap scan:

/
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


