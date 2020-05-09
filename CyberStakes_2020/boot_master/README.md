# Boot Master - 75 points

## Challenge: We found another floppy disk image, but we can't get this one to boot like we did the last one. The disk had been sitting around for a while so we're wondering if some of the data was corrupted. Any ideas?
<br />


So we know that the disk image will not boot, lets take a look at it in hexdump:
```
hexdump -C floppy.img

00000000  b4 0e e8 68 00 e8 41 00  e8 62 00 fa f4 bb 32 66  |...h..A..b....2f|
00000010  b9 73 61 ba 6c 69 be 6f  62 bf 6f 74 88 f8 cd 10  |.sa.li.ob.ot....|
00000020  88 e8 cd 10 88 f0 cd 10  88 d0 cd 10 88 c8 cd 10  |................|
00000030  88 d8 cd 10 89 f3 89 f9  88 f8 cd 10 88 c8 cd 10  |................|
00000040  88 d8 cd 10 88 e8 cd 10  c3 31 c9 b0 20 cd 10 41  |.........1.. ..A|
00000050  83 f9 20 7c f6 b0 41 cd  10 b0 43 cd 10 b0 49 cd  |.. |..A...C...I.|
00000060  10 b0 7b cd 10 e8 a5 ff  b0 7d cd 10 c3 31 c9 b0  |..{......}...1..|
00000070  0a cd 10 41 83 f9 0c 7c  f6 c3 00 00 00 00 00 00  |...A...|........|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 51 aa  |..............U.|
00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00168000
```
<br />

Further analysis of the master boot record (MBR) [magic number (bytes)](http://mbrwizard.com/thembr.php) indicates that the final two bytes of the MBR must be the hex value '55 AA', making it a valid MBR. An invalid magic number indicates a corrupt or missing MBR, therefore these bytes are critical to booting the disk.  I opened the image in bless and changed the '51 aa' to '55 aa':
<br />

![bless](https://github.com/EESantiago/Writeups/blob/master/CyberStakes_2020/boot_master/screenshots/bless.png)

<br />
<br />

Now try to boot up the image using QEMU:

```
qemu-system-i386 floppy.img
```
<br />

![QEMU](https://github.com/EESantiago/Writeups/blob/master/CyberStakes_2020/boot_master/screenshots/QEMU.png)

<br />
<br />

## ACI{fails2boot}

