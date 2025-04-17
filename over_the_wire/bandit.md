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
