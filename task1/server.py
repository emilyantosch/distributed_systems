from socket import socket, AF_INET, SOCK_STREAM
import datetime

s = socket(AF_INET, SOCK_STREAM)
s.bind(("127.0.0.1", 8080))
s.listen(5)
(conn, addr) = s.accept()
while True:
    data = conn.recv(1024)
    if not data:
        break
    msg = data.decode()
    if msg == "send time":
        now = datetime.datetime.now().__str__()
        conn.send(now.encode())
conn.close()
