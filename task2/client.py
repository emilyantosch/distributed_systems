import zmq
def client():
    context = zmq.Context()
    socket = context.socket(zmq.SUB)
    socket.connect("tcp://localhost:12345")
    socket.setsockopt(zmq.SUBSCRIBE, b"TIME")

    for i in range(5):
        time = socket.recv()
        print(time.decode())

client()
