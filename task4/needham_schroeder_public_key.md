# Public-Key Based Needham-Schroeder Protocol with KDC

## Initial State

- **KDC** stores all public keys: PK_A, PK_B, ... for all registered hosts
- Each host knows only its own private key (SK_A, SK_B, etc.)
- Everyone knows the KDC's public key: **PK_KDC**

## Protocol Steps

### Phase 1: Key Distribution (A obtains B's certified public key)

| Step | Message | Description |
|------|---------|-------------|
| 1 | A → KDC: `A, B` | A requests B's public key |
| 2 | KDC → A: `{B, PK_B}_{SK_KDC}` | KDC signs B's identity with its public key (certificate) |

### Phase 2: Key Distribution (B obtains A's certified public key)

| Step | Message | Description |
|------|---------|-------------|
| 3 | B → KDC: `B, A` | B requests A's public key |
| 4 | KDC → B: `{A, PK_A}_{SK_KDC}` | KDC signs A's identity with its public key (certificate) |

### Phase 3: Mutual Authentication (Challenge-Response)

| Step | Message | Description |
|------|---------|-------------|
| 5 | A → B: `{N_A, A}_{PK_B}` | A sends nonce N_A encrypted with B's public key |
| 6 | B → A: `{N_A, N_B, B}_{PK_A}` | B proves it decrypted N_A, sends own nonce N_B |
| 7 | A → B: `{N_B}_{PK_B}` | A proves it received N_B |

## Why This Works

1. **Steps 1-4**: The KDC acts as a trusted certificate authority. Its signature `{...}_{SK_KDC}` guarantees authenticity since only the KDC can sign with SK_KDC, and everyone can verify using PK_KDC.

2. **Step 5**: Only B can decrypt this message (using SK_B), so only B learns N_A.

3. **Step 6**: B proves knowledge of N_A. Including **B's identity** in this message is critical (Lowe's fix) to prevent reflection attacks.

4. **Step 7**: A proves knowledge of N_B, completing mutual authentication.

## Security Properties Achieved

- **Authentication**: Both parties are assured of each other's identity
- **Freshness**: Nonces N_A and N_B prevent replay attacks
- **No shared secrets needed**: Only public-key cryptography is used
- **Protection against MITM**: KDC's signatures bind identities to public keys

## Optional: Session Key Establishment

After authentication, A and B can derive a shared session key, e.g.:

- A generates session key K_AB
- A → B: `{K_AB}_{PK_B}`

Or they can use the nonces: `K_AB = hash(N_A || N_B)`
