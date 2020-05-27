#!/usr/bin/python3

import socket 
import base64

socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

socket.connect(('challenge.acictf.com', 20163))

reply = socket.recv(4096)

problem = (reply.split(b'------------------------------------------------------------------------------')[1])

src_base = (problem[2:5])
dst_base = (problem[9:12])
src_data = (problem[14:])

print (src_base)
print (dst_base)
print (src_data.strip())

if 'raw' in src_base:
   if 'b64' in dst_base:
      #done
      src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'hex' in dst_base:
      hex = int(src_data, base=16)
      socket.send(hex)
   elif 'dec' in dst_base:
      src_data_bytes = src_data.ecode('ascii')
      decimal = int(src_data_bytes, base=10)
      socket.send(decimal)
   elif 'oct' in dst_base:
      octal = int(src_data, base=8)
      socket.send(octal)
   elif 'bin' in dst_base:
      binary = int(src_data, base=2)
      socket.send(binary)
       
###Base64 ->###

elif 'b64' in src_base:
   if 'raw' in dst_base:
      #src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'hex' in dst_base:
      #hex = int(src_data, base=16)
      #socket.send(hex)
   elif 'dec' in dst_base:
      decimal = int(src_data, base=10)
      socket.send(decimal)
   elif 'oct' in dst_base:
      octal = int(src_data, base=8)
      socket.send(octal)
   elif 'bin' in dst_base:TypeError: a bytes-like object is required, not 'str'

      binary = int(src_data, base=2)
      socket.send(binary)

###Hex ->###

elif 'hex' in src_base:
   if 'b64' in dst_base:
      # not the right answer
      src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'raw' in dst_base:
      #hex = int(src_data, base=16)
      #socket.send(hex)
   elif 'dec' in dst_base:
      decimal = int(src_data, base=10)
      socket.send(decimal)
   elif 'oct' in dst_base:
      octal = int(src_data, base=8)
      socket.send(octal)
   elif 'bin' in dst_base:TypeError: a bytes-like object is required, not 'str'

      binary = int(src_data, base=2)
      socket.send(binary)

## Decimal ##

elif 'dec' in src_base:
   if 'b64' in dst_base:
      #src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'raw' in dst_base:
      hex = int(src_data, base=16)
      socket.send(hex)
   elif 'hex' in dst_base:
      #done 
      decimal = int(src_data)
      hex = hex(decimal)
      socket.send(hex[2:])
   elif 'oct' in dst_base: 
      #done 
      decimal = int(src_data)
      octal = oct(decimal)
      socket.send(octal[2:])
   elif 'bin' in dst_base:
      #done
      decimal = int(src_data)
      bin = bin(decimal)
      socket.send(bin[2:])

## Octal ##

elif 'hex' in src_base:
   if 'b64' in dst_base:
      #src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'raw' in dst_base:
      #hex = int(src_data, base=16)
      #socket.send(hex)
   elif 'dec' in dst_base:
      decimal = int(src_data, base=10)
      socket.send(decimal)
   elif 'oct' in dst_base:
      octal = int(src_data, base=8)
      socket.send(octal)
   elif 'bin' in dst_base:TypeError: a bytes-like object is required, not 'str'

      binary = int(src_data, base=2)
      socket.send(binary)

## binary ##

else 'hex' in src_base:
   if 'b64' in dst_base:
      #src_data_bytes = src_data.ecode('ascii')
      base64 = base64.b64encode(src_data_bytes)
      socket.send(base64)
   elif 'raw' in dst_base:
      #hex = int(src_data, base=16)
      #socket.send(hex)
   elif 'dec' in dst_base:
      decimal = int(src_data, base=10)
      socket.send(decimal)
   elif 'oct' in dst_base:
      octal = int(src_data, base=8)
      socket.send(octal)
   elif 'bin' in dst_base:TypeError: a bytes-like object is required, not 'str'

      binary = int(src_data, base=2)
      socket.send(binary)


exit()

#socket.send(b'x')

reply2 = socket.recv(2096)

print (reply2)
