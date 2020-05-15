# That's More Than Enough

* **Category:** Forensics
* **Points:** 100
* **Challenge:** We think Jolly Jeff is up to no good. See if you can find the hidden message in his [JPEG Jammer](http://challenge.acictf.com:54803/jammer).
* **Hint #1:** Hex editors, such as bless or wxHexEditor, are great for viewing file contents. Install bless with "sudo apt install bless" or wxhexeditor with "sudo apt install wxhexeditor".
* **Hint #2:** Take a look at the JPEG file format specification.

<br />

First lets navigate to the JPEG Jammer in a web browser:
```
http://challenge.acictf.com:54803/jammer
```
![jammer]()

<br />

We can upload an [image](https://github.com/eesantiago/Writeups/blob/master/CyberStakes_2020/thats_more_than_enough/Capture-the-flag.jpg) to the JPEG Jammer and download the result.  I first used 'binwalk' on both the original image and the jammed image to see what the difference was:
```
binwalk Capture-the-flag.jpg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01


binwalk jammed.jpg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
85986         0x14FE2         JPEG image data, JFIF standard 1.01
```

<br />

Looks like another image has been embedded in our orginal image and begins at offset 0x14FE2.  Now we need to [extract the new image using dd](https://www.geeksforgeeks.org/working-with-magic-numbers-in-linux/).  First, lets look at the offset in hexdump:
```
hexdump -C jammed.jpg | grep -i '14fe'

00014fe0  ff d9 ff d8 ff e0 00 10  4a 46 49 46 00 01 01 00  |........JFIF....|
```

<br /> 

At the offset we can see the the trailer hex values 'FF D9' for the first image(our original image) followed by the header hex values 'FF D8 FF' for the new image, also referred to as the [magic bytes](https://en.wikipedia.org/wiki/List_of_file_signatures).  Now calculate the number of bits from the offset in decimal at which the jpeg file starts using python:
```
python

Python 2.7.18rc1 (default, Apr  7 2020, 12:05:55) 
[GCC 9.3.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> 0x14fe2
85986
```

<br />

Use the decimal offset and the 'dd' to extract the embedded jpeg:
```
dd if="jammed.jpg" bs=1 skip=85986 of="flag.jpg"
```

<br />

flag.jpg:
![flag]()

<br />

## Flag: ACI{2d990186dca8384adb00fcbf4af}
