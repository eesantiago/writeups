# Turtels All The Way Down

* **Category**: Forensics
* **Points**: 100
* **Challenge**: Early this morning, a breach occurred on the server hosting our next-gen drone development repository. It is your job to figure out what was taken: challenge.zip
* **Hint #1**: Our analysts are using IRC to share information and investigate this breach
* **Hint #2**: Everything you need lives within these PCAP's, you simply need to carve out the relevant files
* **Hint #3**: These ZIPS appear to have been generated with 7z
* **Hint #4**: FTP is a simple text-based protocol, with passive binary streams for file transfers

<br />

After unzipping challenge.zip, we are given challenge.pcap.  Looking thought the pcap, the IRC chat is supposed to have more information about the breach.  Lets find the IRC traffic and use the Follow > TCP stream in Wireshark:

<br />

![IRC](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/turtles_all_the_way_down/screenshots/IRC.JPG)

<br /> 

Now we know that there is an encrypted file containing a pcap of the breach called *jlngsr* that is being hosted on a webserver and the password to the file is *dronehack2019*.  Lets look at HTTP objects in wireshark to see if we can extract the encrypted file:

<br />

![objects](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/turtles_all_the_way_down/screenshots/objects.JPG)

<br />

One of hints states that the encrypted zip file was generated with `7z`, so lets change *jlngsr* to *jlngsr.7z* and use 7z to unzip the pcap file:
```
mv jlngsr jlngsr.7z

7z e jlngsr.7z

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=en_US.UTF-8,Utf16=on,HugeFiles=on,64 bits,4 CPUs Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz (506E3),ASM,AES-NI)

Scanning the drive for archives:
1 file, 4264 bytes (5 KiB)

Extracting archive: jlngsr.7z

ERRORS:
Unexpected end of archive

WARNING:
jlngsr.7z
Can not open the file as [7z] archive
The file is open as [zip] archive

--
Path = jlngsr.7z
Open WARNING: Can not open the file as [7z] archive
Type = zip
ERRORS:
Unexpected end of archive
Physical Size = 4264

    
Enter password (will not be echoed):
                   

Archives with Errors: 1

Open Errors: 1
```

<br />

After opening up *capture.pcap* in wireshark, we can see there is unencrypted FTP traffic.  Lets again follow the TCP stream and look at the commands run on the FTP server:

<br />

![ftp](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/turtles_all_the_way_down/screenshots/ftp.JPG)

<br />

We can see the client attempting to download a copy of the file *flag.zip*.  Looking at the final packets in the pcap, we see the data containing being transfered from the FTP server to the client:

<br />

![flag](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/turtles_all_the_way_down/screenshots/flag.JPG)

<br /> 

## Flag: ACI{df249275e2acff50bd5ea272934}
