# Man-in-the-Middle Attack in Key Exchange

## Scenario

Two participants, Bob and Alice, perform a key exchange:

1. Alice asks Bob for his public key (k_b)
2. Bob sends his public key to Alice
3. Alice creates a secret key (k_ab), encrypts it with Bob's public key, and sends it to Bob
4. Bob decrypts the secret key using his private key

## Vulnerability

The MITM vulnerability is in **step 2: when Bob sends his public key to Alice**.

## Attack Sequence

1. Alice asks Bob for his public key
2. **Mallory intercepts** and receives Bob's real public key (k_b)
3. **Mallory sends her own public key (k_m) to Alice**, pretending to be Bob
4. Alice creates secret key k_ab and encrypts it with k_m (thinking it's k_b)
5. **Mallory intercepts**, decrypts k_ab using her private key
6. **Mallory re-encrypts k_ab with Bob's real public key (k_b)** and forwards it to Bob
7. Bob decrypts successfully with his private key

Now Mallory knows k_ab, and both Alice and Bob think they've established a secure channel.

## Root Problem

There's no authentication of the public key. Alice has no way to verify that the key she received actually belongs to Bob.

## Solutions

- **Certificates** signed by a trusted Certificate Authority (CA)
- **Pre-shared knowledge** of public keys (out-of-band verification)
- **Web of trust** (PGP model)
- **Key fingerprint verification** (e.g., comparing fingerprints over a phone call)
