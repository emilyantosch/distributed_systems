#!/usr/bin/env python3
"""
Diffie-Hellman Key Exchange Client
Establishes a shared session key with a server using the Diffie-Hellman method.
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


def square_and_multiply(g: int, x: int, n: int) -> int:
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
    n = 30113
    g = 52

    # Client's private key (random, kept secret)
    x = 28654

    # Compute client's public value: A = g^a mod p
    A = square_and_multiply(g, x, n)

    print("=" * 60)
    print("Diffie-Hellman Key Exchange - Client")
    print("=" * 60)
    print(f"Generator g: {g}")
    print(f"Prime p: {n}")
    print(f"Client private key a: {x}")
    print(f"Client public value A = g^a mod p: {A}")
    print("=" * 60)

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

        print("\n" + "=" * 60)
        print("KEY EXCHANGE COMPLETE")
        print("=" * 60)
        print(f"Shared session key K = B^a mod p:")
        print(f"{shared_key}")
        print("=" * 60)


if __name__ == "__main__":
    main()
