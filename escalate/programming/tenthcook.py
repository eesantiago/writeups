#!/usr/bin/python3

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect(("172.30.75.139",1392))

# Problem #1

challenge_1 = s.recv(1024) + s.recv(1024) + "\n"
#challenge_1_2 = s.recv(1024)

print (challenge_1)

hex = challenge_1.split(': ')[1]

decimal = int(hex, 16)
 
s.send(bytes(decimal))

challenge_2 = s.recv(1024) 

print (challenge_2)

exit


