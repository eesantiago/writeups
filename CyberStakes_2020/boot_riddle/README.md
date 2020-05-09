# Boot Riddle - 100 points

### Challenge: This floppy disk image boots, but instead of a flag we see some silly riddle...
<br />  

Similar to the challenge Boot Camp, up the floppy image 

```
qemu-system-i386 floppy.img
```
<br />  

![riddle](https://github.com/EESantiago/Writeups/blob/master/CyberStakes_2020/boot_riddle/screenshots/riddle.png)
<br />  
<br />  

So the riddle points to a location in memory where the flag.  We can do this using [QEMU monitor](http://people.redhat.com/pbonzini/qemu-test-doc/_build/html/topics/pcsys_005fmonitor.html) to save create a memory dump starting at the address in the riddle, 0x7DC0: 
```
memsave 0x7DC0 4096 outfile.mem
```
<br />  
Now open the file and we get the flag:
<br />  

# ACI{REALmode}
