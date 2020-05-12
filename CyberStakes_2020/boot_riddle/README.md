# Boot Riddle

* **Category**: Forensics
* **Points**: 100
* **Challenge**: This floppy disk image boots, but instead of a flag we see some silly riddle...
* **Hint #1**: If only we could inspect the device's memory while it is running...
* **Hint #2**: QEMU's monitor or Bochs' debugger might be useful to read up on.

<br />  

Similar to the challenge Boot Camp, boot up the floppy image with the QEMU emulator: 

```
qemu-system-i386 floppy.img
```
<br />  

![riddle](https://github.com/EESantiago/Writeups/blob/master/CyberStakes_2020/boot_riddle/screenshots/riddle.png)
<br />  
<br />  

So the riddle points to a location in memory where the flagis.  We can access this location in memory using the [QEMU monitor](http://people.redhat.com/pbonzini/qemu-test-doc/_build/html/topics/pcsys_005fmonitor.html) to save a memory dump starting at the address in the riddle, 0x7DC0: 
```
memsave 0x7DC0 4096 outfile.mem
```
<br />  
Now open the file and we get the flag:
<br />  

## ACI{REALmode}
