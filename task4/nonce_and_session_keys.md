# Nonce and Session Keys Explained

## What is a Nonce?

A **nonce** (Number used ONCE) is a random or pseudo-random value that is used exactly once in a cryptographic protocol.

### Purpose of Nonces

| Threat | How Nonce Prevents It |
|--------|----------------------|
| **Replay attacks** | Attacker can't reuse old messages because each session has unique nonces |
| **Freshness guarantee** | Proves a message was created recently, not replayed from the past |
| **Challenge-response** | "I sent you N_A, only the real B can decrypt and return it" |

### Example

```
1. A → B: {N_A, A}_{PK_B}     # A's challenge: "decrypt this nonce"
2. B → A: {N_A, N_B}_{PK_A}   # B proves it knows N_A, sends own challenge
3. A → B: {N_B}_{PK_B}        # A proves it knows N_B
```

If an attacker replays message 1 tomorrow, B will respond with a **new** N_B. The attacker can't complete step 3 because they don't have SK_A to decrypt it.

---

## What is a Session Key?

A **session key** is a temporary symmetric key used to encrypt communication for a single session.

### Why Use Session Keys?

| Reason | Explanation |
|--------|-------------|
| **Performance** | Symmetric encryption (AES) is ~100-1000x faster than asymmetric (RSA) |
| **Forward secrecy** | If a session key is compromised, only that session is affected |
| **Limited exposure** | Short-lived keys reduce the window for attacks |
| **Less data per key** | Encrypting less data with each key makes cryptanalysis harder |

### Typical Workflow

```
Phase 1: Authentication (slow, asymmetric crypto)
   A <-> B: Use public keys to authenticate and exchange session key K_AB

Phase 2: Communication (fast, symmetric crypto)
   A -> B: {message}_K_AB    # Encrypted with shared session key
   B -> A: {response}_K_AB   # Same key for both directions

Phase 3: Session ends
   K_AB is discarded, never used again
```

### Analogy

Think of it like a hotel:

- **Public/private keys** = Your ID card (permanent, used to check in)
- **Session key** = Room key card (temporary, used for actual access)
- **Nonce** = Unique reservation number (proves this is a fresh booking, not a replay)
