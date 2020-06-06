
# No Escape

* **Category**: Web Security
* **Points**: 60
* **Challenge**: Since in-person events are currently banned, some magician we've never heard of is trying to sell us on the idea of a "digital" magic show where the magician logs in using an impossible password. For added assurances, one lucky audience member is able to login and see the hash of the password as proof the password is impossible. We're willing to bet the secret to this magic trick is not all that complicated. http://challenge.acictf.com:10952
* **Hint #1**: Inexperienced web application developers don't always esacpe/sanitize user inputs in there database query strings. This frequently allows SQL injection attacks that result in unintended behavior.
* **Hint #2**: The developer was pretty new, so just causing the query to error out may get you more information for the exploit. What happens when you use a single ' or " in each of the login fields?
* **Hint #3**: You'll need to login as a specific user. If you're new to SQL syntax, this might be useful resource for understanding the intended query and how you can manipulate it for your purposes.

<br />

Navigating to the website, we are presented with a prompt for a username and passsword:

<br />

![site]()

<br />

Based on the hints that we have been given, we can assume that this website is vulnerable to SQL injection.  [Single and double quotes](https://www.netsparker.com/blog/web-security/fragmented-sql-injection-attacks/) are used as string delimiters. They are used both at the beginning and the end of a string. This is why when a single or double quote is injected into a query, the query breaks and throws an error. Let's try this in the username and password fields:

<br />

![quotes]()

<br />

We get an error with our username `'` and a hash of the password.  We can user `--` to comment out the password portion of the SQL statement and login with user*admin* by using the statement `admin'--`:

<br />

![admin]()

<br />

Now we have a hint that we should try to login with houdini.  Use `houdini;--` to do this:

<br />

![flag]()

<br />

## Flag: ACI{fd35465a027eeee3be0249d9f86}
