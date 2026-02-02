#!/usr/bin/env python3
"""
Diffie-Hellman Key Exchange Server
Establishes a shared session key with a client using the Diffie-Hellman method.
"""

import socket
import random


def get_binary_representation(x: int) -> list[int]:
    """
    Extract the binary representation of x as a list of bits.

    Input: x > 0 integer
    Output: list x0, x1, ..., x_{l-1} where xi are the bits
    """
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
    """
    Compute g^x mod n using the square-and-multiply algorithm.

    This avoids excessively large intermediate results.

    Algorithm:
    1. z := 1
    2. for i := l-1 downto 0 do
    3.     z := z^2 mod n
    4.     if x_i = 1 then z := (z * g) mod n
    Output: z = g^x mod n
    """
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
    # Diffie-Hellman parameters (publicly known)
    # Using a smaller prime for demonstration - in practice use much larger primes
    n = 30113
    g = 52

    # Server's private key (random, kept secret)
    y = 12385

    # Compute server's public value: B = g^b mod p
    B = square_and_multiply(g, y, n)

    print("=" * 60)
    print("Diffie-Hellman Key Exchange - Server")
    print("=" * 60)
    print(f"Generator g: {g}")
    print(f"Prime p: {n}")
    print(f"Server private key b: {y}")
    print(f"Server public value B = g^b mod p: {B}")
    print("=" * 60)

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

            print("\n" + "=" * 60)
            print("KEY EXCHANGE COMPLETE")
            print("=" * 60)
            print(f"Shared session key K = A^b mod p:")
            print(f"{shared_key}")
            print("=" * 60)


if __name__ == "__main__":
    main()
