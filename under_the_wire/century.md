https://underthewire.tech/century

### Century 0 -> 1
```
ssh century1@century.underthewire.tech
century1
```
### Century 1 -> 2
```
# Installed PowerShell Build Version
$PSVersionTable | findstr "BuildVersion"

# One line, must be combined and seperated by perionds
```
### Century 2 -> 3
View the contents of Desktop:
```
Get-ChildItem
```
Find the cmdlet similar to wget:
```
Get-Alias wget
Invoke-WebRequest
```
### Century 3 -> 4
```
(Get-ChildItem C:\users\century3\desktop | Measure-Object).count
```
### Century 4 -> 5
```
Get-ChildItem -Path C:\users\century4\desktop -Recurse
```
### Century 5 -> 6
View the contents of Desktop:
```
Get-ChildItem
```
Use the `Win32_NTDomain` method to obtain the short domain:
```
(Get-WmiObject -Class Win32_NTDomain).Description
```
### Century 6 -> 7
Count the number of directories on the user's desktop:
```
(Get-ChildItem -Path C:\users\century6\desktop -Directory | Measure-Object).Count
```
### Century 7 -> 8
Find the `readme` file in century7's user folder:
```
Get-ChildItem -Path C:\users\century7 -Name "readme*" -Recurse
Get-Content C:\users\century7\Downloads\Readme.txt
```
### Century 8 -> 9
Count unique entries within the file:
```
(Get-content .\unique.txt | Get-Unique | Measure-Object).Count
```
### Century 9 -> 10
Grab the 161st word from the file by splitting the words into newlines and indexing:
```
((Get-Content -Path C:\users\century9\desktop\Word_File.txt) -split '\s')[160]
```
### Century 10 -> 11
View the contents of Desktop:
```
Get-ChildItem
```
Grabe the 10th and 8th word of the Windows Update service description: 
```
((Get-CimInstance  win32_service | ?{$_.Name -eq 'wuauserv'} | select Description) -split '\s')[9,7]

# depricated
Get-WmiObject win32_service -filter "name='wuauserv'" | Select description
```
Century 11 -> 12
Discover hidden file in the specified directories, surpress errors for non-readable directories, and exclude desktop.ini:
```
Get-ChildItem -Path ("C:\users\century11\desktop", "C:\users\century11\contacts",  "C:\users\century11\documents", "C:\users\century11\downloads
", "C:\users\century11\favorites", "C:\users\century11\videos", "C:\users\century11\music")  -File -Recurse -Hidden -ErrorAction SilentlyContinue -Exclude 'desktop.ini'
```
Century 12 -> 13
Obatin the name and description of the domain controller:
```
Get-ADDomainController | Select-Object Name
Get-ADComputer -Filter {Name -eq "UTW"} -Property Description 
```
View the contents of Desktop:
```
Get-ChildItem
```
### Century 13 -> 14
```
Get-Content C:\users\century13\desktop\countmywords | Measure-Object -Word
```
### Century 14 -> 15
Search for the word 'polo' and use `\b` to specify a word boundary so only whole words are counted:
```
(Select-String -Path C:\users\century14\desktop\countpolos -Pattern \bpolo\b -AllMatches).Matches.Count
```
