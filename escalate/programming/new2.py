
import ast

from pwn import *
#from functools import lru_cache

p = remote('172.30.75.139','1392')


one = p.recvline()  + p.recvline()  + p.recvline() + "\n"

print one


hex = one.split(': ')[1]

print hex

i = int(hex, 16)

#answer1 =(i)

#print answer1

print i

p.sendline(bytes(i))

two_line1 =  p.recvline()   
two_line2 =  p.recvline()
two_line3 =  p.recvline()
two_line4 =  p.recvline()

print  two_line1 + two_line2 + two_line3 + two_line4 + "\n"  

decimal = two_line3.split('. ')[1]

print decimal 

decimal_int = int(decimal)
binary = (bin(decimal_int))

answer2 = binary.split('b')[1]

print answer2

p.sendline(answer2)

three_line1 =  p.recvline()   
three_line2 =  p.recvline()
three_line3 =  p.recvline()
three_line4 =  p.recvline()
three_line5 =  p.recvline()

print  three_line1 + three_line2 + three_line3 + three_line4 + three_line5 + "\n"  

hex_values = three_line3.split(': ')[1]
print hex_values

hex1 = hex_values.split(' ')[0]

hex2 = hex_values.split(' ')[1]

hex1_dec = int(hex1, 16)
hex2_dec = int(hex2, 16) 
 
#product means multiply
product = hex1_dec * hex2_dec


print product 

p.sendline(product.encode('utf-8'))

four_line1 =  p.recvline()

print four_line1
