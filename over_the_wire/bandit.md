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
