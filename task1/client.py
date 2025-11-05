from socket import socket, AF_INET, SOCK_STREAM

s = socket(AF_INET, SOCK_STREAM)

s.connect(("127.0.0.1", 8080))
msg = "send time"
s.send(msg.encode())
data = s.recv(1024)
print(data.decode())
s.close()
