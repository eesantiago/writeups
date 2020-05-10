# Recovery and Identification

* **Category:** Miscellaneous
* **Points:** 150
* **Challenge:** Given two out of three disk images used in a RAID array, see if you can recover the data: disk1.img.xz disk2.img.xz

<br /> 

First lets decompress both images:
```
xz --decompress disk1.img.xz
xz --decompress disk2.img.xz
```

<br />

Use [losetup](https://unix.stackexchange.com/questions/302766/persistent-use-of-loop-block-device-in-mdadm) to associate the loop devices with our image files which will be used to build to RAID array:
```
losetup loop1 disk1.img
losetup loop2 disk2.img 
```

<br /> 

Now we create a third phony disk image that will be used to complete the RAID 5 array"
```
truncate -s 1G 3.img

losetup loop3 3.img
```

<br /> 

Now we use `mdadm` to create our virtual RAID array:
```
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/loop{1,2,3}
```

<br />

Now for the tricky part, stop the array and detach the phony image file from loop3:
```
mdadm --stop /dev/md0

losetup -d /dev/loop3
```

<br />

Now assemble the RAID useing the `--run` flag which forces mdadm to [assmble the RAID array without all the devices:](https://superuser.com/questions/962395/assemble-3-drive-software-raid5-with-one-disk-missing)
```
mdadm --assemble --run /dev/md0 /dev/loop1 /dev/loop2

mdadm -D /dev/md0

           Version : 1.2
     Creation Time : Thu Apr 30 17:37:56 2020
        Raid Level : raid5
        Array Size : 405504 (396.00 MiB 415.24 MB)
     Used Dev Size : 202752 (198.00 MiB 207.62 MB)
      Raid Devices : 3
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Thu Apr 30 17:37:59 2020
             State : clean, degraded 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : an0nym0us3:0  (local to host an0nym0us3)
              UUID : fb18e7ce:c2081e07:cc637c26:8212dc17
            Events : 18

    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       7        2        1      active sync   /dev/loop2
       -       0        0        2      removed
```

<br />

Now mount the share and look through the files:
```
mount /dev/md0 /mnt/recovery/

root@an0nym0us3:/mnt/recovery# ls -la

drwxr-xr-x 4 root root  1024 Apr 23 21:58 .
drwxr-xr-x 3 root root  4096 Apr 30 17:46 ..
drwxr-xr-x 2 root root  1024 Apr 23 21:58 images
drwx------ 2 root root 12288 Apr 23 21:58 lost+found

root@an0nym0us3:/mnt/recovery/images# ls 
0.tar.gz.bz2  2.tar.gz.bz2  4.tar.gz.bz2  6.tar.gz.bz2  8.tar.gz.bz2
1.tar.gz.bz2  3.tar.gz.bz2  5.tar.gz.bz2  7.tar.gz.bz2  9.tar.gz.bz2

root@an0nym0us3:/mnt/recovery/images# bunzip2 *
root@an0nym0us3:/mnt/recovery/images# gunzip *

file *

0.tar: data
1.tar: data
2.tar: data
3.tar: data
4.tar: data
5.tar: data
6.tar: data
7.tar: data
8.tar: data
9.tar: data
```

<br /> 

Finally, use strings on all the data files and search for *ACI* to get the flag:
```
strings * | grep ACI

)
k9]5\
xL(Du
HjUI
	WG|d
ACI{472f690f147f10063f2514322ef}
|u{z
e,#G
T.,%L
Zv%N
```

<br /> 

## Flag: ACI{472f690f147f10063f2514322ef}
