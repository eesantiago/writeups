# WORK IN PROGRESS

# Boot Riddle

* **Category**: Forensics
* **Points**: 100
* **Challenge**: Lets make some yummy cookies! Maybe you can even find some extra tasty ones: http://challenge.acictf.com:27734.
* **Hint #1**: If only we could inspect the device's memory while it is running...
* **Hint #2**: You can control the value so select all you want.
* **Hint #3**: If you need an endpoint for a callback, postb.in is a useful resource. You could also run a simple server on the competition's shell server using a command like python -m SimpleHTTPServer.

<br />

First lets navigate to the challenge in a web browser:
```
http://challenge.acictf.com:27734.
```
![cookiemonster]()

Based on the name of the challenge and some of the hints, we can assume that we are going to [tealling cookies via XSS](https://www.openlearning.com/u/ivanteong/blog/StealingCookiesViaXssUsingPhpOrRequestbin/).  Lets submit a cookie to the cookie monster (random name and ingredients) and capture the request in burpsuite:

<br />

![burp1]()

<br />

There are two parameters potentially vulnerable to XSS, *name* and *ingredients*.  Lets try toto use a simple JavaScript alert to see if the site is vulnerable to Reflected XSS:
```
<script>alert("XSS!")</script>
```

<br /> 

Now place the JavaScript alert in place of one of the ingredients in burpsuite: 
```
name=Sugar&ingredients=<script>alert("XSS!")</script>&ingredients=sugar&ingredients=eggs&ingredients=Add+ingredient
```

<br /> 

Forward the POST and we get an alert message on the next page:

<br /> 

![burp2]()

<br /> 

Now that we know the site is vulnerable to XSS, we can use that to obtain the admin session cookie.  When we slected submit cookie for approval we recived another alert message and a statement saying taht the cookie monster is viewing our cookie.  That will be the point where we should get the cookie.



### Method #1 - PostBin

Use postb.in to received the admin cookie from the victims browser.  



