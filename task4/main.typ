#import "@preview/grape-suite:3.1.0": citation, german-dates, seminar-paper
#import "@preview/equate:0.3.2": equate
#import "@preview/frame-it:2.0.0": *
#import "@preview/codly:1.3.0": *
#show: codly-init.with()

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

#let (bsolution, code) = frames(
  bsolution: ("Lösung",),
  code: ("Code",),
)

#show: frame-style(styles.boxy)

#codly(languages: (
  java: (
    name: text(font: "JetBrainsMono NFM", " Java", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e738}", weight: "bold"),
    color: rgb("#CE412B"),
  ),
  c: (
    name: text(font: "JetBrainsMono NFM", " C", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e61e}", weight: "bold"),
    color: rgb("#5612EC"),
  ),
  python: (
    name: text(font: "JetBrainsMono NFM", " Python", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e73c}", weight: "bold"),
    color: rgb("#79C635"),
  ),
))

#import seminar-paper: definition, sidenote, todo
#import citation: *

#show: seminar-paper.project.with(
  title: "Einsendeaufgabe 4",
  subtitle: "Sicherheit",

  university: [FernUniversität in Hagen],
  faculty: [Fakultät für Mathematik und Informatik],
  docent: [Prof. Dr. Christian Icking],
  institute: [Kooperative Systeme],
  seminar: [Verteilte Systeme],
  show-declaration-of-independent-work: false,
  semester: german-dates.semester(datetime.today()),

  submit-to: [Eingereicht bei],
  submit-by: [Eingereicht durch],

  author: "Emily Lucia Antosch",
  email: "emilyluciaantosch@web.de",
  address: [
    Hamburg
  ],
)

= Aufgabe 4.1
Client:
```python
import socket
import random


def get_binary_representation(x: int) -> list[int]:
    if x <= 0:
        raise ValueError("x must be a positive integer")

    bits = []
    s = x
    while s > 0:
        xi = s % 2  # 0 or 1 for even or odd
        bits.append(xi)
        s = (s - xi) // 2  # integer division without remainder

    return bits  # bits[0] is LSB, bits[-1] is MSB


def square_and_multiply(g: int, x: int, n: int) -> int:
    # Get binary representation of x
    bits = get_binary_representation(x)
    l = len(bits)

    z = 1
    # Iterate from MSB (l-1) down to LSB (0)
    for i in range(l - 1, -1, -1):
        z = (z * z) % n  # z := z^2 mod n
        if bits[i] == 1:
            z = (z * g) % n  # z := (z * g) mod n

    return z


def main():
    # Diffie-Hellman parameters (publicly known, must match server)
    n = 27803
    g = 5

    # Client's private key (random, kept secret)
    x = 21131

    # Compute client's public value: A = g^a mod p
    A = square_and_multiply(g, x, n)

    print("Diffie-Hellman Key Exchange - Client")
    print(f"Generator g: {g}")
    print(f"Prime p: {n}")
    print(f"Client private key a: {x}")
    print(f"Client public value A = g^a mod p: {A}")

    # Connect to server via TCP
    host = "localhost"
    port = 12345

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client_socket:
        print(f"\nConnecting to server at {host}:{port}...")
        client_socket.connect((host, port))
        print("Connected!")

        # Send client's public value A to server
        client_socket.sendall(str(A).encode("utf-8"))
        print(f"Sent client's public value A: {A}")

        # Receive server's public value B
        data = client_socket.recv(4096)
        B = int(data.decode("utf-8"))
        print(f"\nReceived server's public value B: {B}")

        # Compute shared session key: K = B^a mod p
        shared_key = square_and_multiply(B, x, n)

        print("\n")
        print("KEY EXCHANGE COMPLETE")
        print(f"Shared session key K = B^a mod p:")
        print(f"{shared_key}")

if __name__ == "__main__":
    main()
```

Server:
```python
import socket
import random


def get_binary_representation(x: int) -> list[int]:
    if x <= 0:
        raise ValueError("x must be a positive integer")

    bits = []
    s = x
    while s > 0:
        xi = s % 2  # 0 or 1 for even or odd
        bits.append(xi)
        s = (s - xi) // 2  # integer division without remainder

    return bits  # bits[0] is LSB, bits[-1] is MSB


def square_and_multiply(g: int, y: int, n: int) -> int:
    # Get binary representation of x
    bits = get_binary_representation(y)
    l = len(bits)

    z = 1
    # Iterate from MSB (l-1) down to LSB (0)
    for i in range(l - 1, -1, -1):
        z = (z * z) % n  # z := z^2 mod n
        if bits[i] == 1:
            z = (z * g) % n  # z := (z * g) mod n

    return z


def main():
    n = 27803
    g = 5

    # Server's private key (random, kept secret)
    y = 17555

    # Compute server's public value: B = g^b mod p
    B = square_and_multiply(g, y, n)

    print("Diffie-Hellman Key Exchange - Server")
    print(f"Generator g: {g}")
    print(f"Prime p: {n}")
    print(f"Server private key b: {y}")
    print(f"Server public value B = g^b mod p: {B}")

    # Set up TCP server
    host = "localhost"
    port = 12345

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind((host, port))
        server_socket.listen(1)

        print(f"\nServer listening on {host}:{port}")
        print("Waiting for client connection...")

        conn, addr = server_socket.accept()
        with conn:
            print(f"Connected by {addr}")

            # Receive client's public value A
            data = conn.recv(4096)
            A = int(data.decode("utf-8"))
            print(f"\nReceived client's public value A: {A}")

            # Send server's public value B to client
            conn.sendall(str(B).encode("utf-8"))
            print(f"Sent server's public value B: {B}")

            # Compute shared session key: K = A^b mod p
            shared_key = square_and_multiply(A, y, n)

            print("\n")
            print("KEY EXCHANGE COMPLETE")
            print(f"Shared session key K = A^b mod p:")
            print(f"{shared_key}")


if __name__ == "__main__":
    main()
```

#bsolution[Lösung 3.1.2][
  1. 11134
  2. 6998
  3. 10141
  4. 27008
  5. 16185
]

#pagebreak()
= Aufgabe 3.2

#bsolution[Lösung 3.2][
  An dem Punkt, an dem Bob seinen öffentlichen Schlüssel an Alice schickt, kann die dritte Person sitzen, um die man-in-the-middle attack durchzuführen. Dabei wird der echte öffentliche Schlüssel $K_B+$ abgefangen. Ein anderer öffentlicher Schlüssel der dritten Person $K_m$ wird dann an Alice geschickt. Diese erstellt den gemeinsamen Schlüssel $K_"ab"$ und schickt diesen zurück. Dieser wird von der dritten Person entschlüsselt mit ihrem privaten Schlüssel (da sie ja ihren öffentlichen Schlüssel an Alice geschickt hat). Danach schickt die dritte Person Schlüssel weiter, den Bob dann mit seinem privaten Schlüssel entschlüsseln kann, da die dritte Person ihn mit seinem öffentlichen Schlüssel verschlüsselt hat. Nun hat die dritte Person den privaten Schlüssel für die gemeinsame Kommunikation und weder Bob noch Alice wissen dies.

]

= Aufgabe 3.3

#bsolution[Lösung 3.3][
  Der KDC kennt in dem System alle öffentlichen Schlüssel aller Teilnehmer($P_A$, $P_B$, ...). Jeder Teilnehmer kennt nur seinen eigenen privaten Schlüssel($S_A$, $S_B$). Alle Teilnehmer kennen den öffentlichen Schlüssel der KDC.

  Im folgenen wird eine Kommunikation zwischen Teilnehmer A und B dargestellt:
  1. A fragt $P_B$ von der KDC an. Die KDC signiert den Schlüssel mit seinem eigenen öffentlichen Schlüssel $P_"KDC"$.
  2. B tut nun das selbe für den öffentlichen Schlüssel von A.
  3. Nun führen A und B eine Challenge-Response aus:
    - A schickt eine Nonce $N_A$ an B, die mit dem öffentlichen Schlüssel von B verschlüsselt worden ist.
    - B entschlüsselt $N_A$ und verschlüsselt eine eigene Nonce, sowie die Nonce von A mit dem öffentlichen Schlüssel von A und schickt diesen an A.
    - Nun entschlüsselt A die Nonces, was A zeigt, dass die andere Seite tatsächlich B ist und schickt nun nur noch $N_B$ an B, die mit dem öffentlichen Schlüssel von B verschlüsselt worden ist, um zu beweisen, dass A auch tatsächlich A ist.
  4. (Optional) Um weitere Kommunikation weiterlaufen zu lassen, ohne die Authentification zu wiederholen, könnten sich A und B auf einen Sessionkey einigen (bspw. ein Hash aus den Nonces), die dann als gemeinsamer Schlüssel genutzt werden kann, um die Identität des anderne zu bestätigen.

]
