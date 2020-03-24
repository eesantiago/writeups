
# Work in progress

![OpenAdmin](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/ENXDIZYX0AAIur8.jpg)


## Enumeration

Start off with a detailed nmap scan:

![nmap](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/nmap.png)

Next lets navigate to the webserver in our browser to verify that this in fact the apache default page:

```
http://10.10.10.171/
```
![webserver]

As expexted we get the apache default page.  Let's enumerate futher using gobuster:
```
gobuster -w /usr/share/wordlists/dirb/common.txt -t 30 -k -x html,php,txt,asp,aspx -u http://10.10.10.171
```
![gobuster](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/gobuster.png)

Let's look at the music page:

Music:

![music](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/music.png)

I clicked 'login' and it sent me to this page http://10.10.10.171/ona/:

![ona](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/ona.png)

Looks like the web appliaction that is running is out of date.  Now click the "ONA" and "About":

![about](https://github.com/EESantiago/Writeups/blob/master/Hack%20the%20Box/OpenAdmin/Images/ona_about.png)


Lets see if there are any vulnerabilities for OpenNetAdmin:

![searchsploit]()

## Initial Foothold




