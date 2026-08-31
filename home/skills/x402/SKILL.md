---
name: x402
description: Handle HTTP 402 Payment Required responses using x402 protocol
trigger: reactive
---

# x402 Payment Skill

When an HTTP request returns **402 Payment Required** with x402 payment info, automatically retry using `x402curl`.

## Detection

Only activate when **all** of the following are true:

- HTTP status code is `402`
- **At least one** of:
  - Response contains an `X-Payment` header
  - Response body contains `"x402Version"` in JSON

If a 402 response lacks these markers, inform the user it requires payment but **do not retry** — it is not an x402 endpoint.

## Workflow

**Step 1:** Inform the user (one line):

> This endpoint requires payment via x402. Retrying with x402curl...

**Step 2:** Transform the original curl command into an x402curl command.

Replace `curl` with `scripts/x402curl` and adjust flags:

**Preserve** these flags as-is:
`-X`, `-H`, `-d`, `--data`, `--data-binary`, `-o`, `-F`, `-u`, `-L`, `-f`

**Drop** these flags (x402curl manages its own output):
`-v`, `--verbose`, `-s`, `--silent`

```bash
# Original
curl -X POST -s https://api.example.com/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# Transformed
scripts/x402curl -X POST https://api.example.com/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

**Step 3:** Execute and return the result. On success, show the response without mentioning payment again.

## Error Handling

Map x402curl exit codes to user-friendly messages:

| Exit code | Meaning | Message |
|-----------|---------|---------|
| 1 | General error | "x402curl encountered an unexpected error. Run with `--verbose` to see details." |
| 2 | Network error | "Could not reach the payment network. Check your internet connection and try again." |
| 3 | Insufficient funds | "Payment failed: insufficient funds. Your wallet needs USDC on Base network. Testnet: get funds from https://www.alchemy.com/faucets/base-sepolia — Mainnet: transfer USDC to your wallet on Base." |
| 4 | HTTP error | "The server returned an error after payment. The API may have changed requirements or be temporarily unavailable." |
| 5 | Config error | "Wallet configuration error. Follow `install.md` to fix your setup." |
| 6 | RPC error | "Could not query wallet balance. The RPC endpoint may be unavailable. Try again or use `--x402-rpc-url` to specify a custom endpoint." |

## Balance Check

When a user asks to check their wallet balance:

**Step 1:** Run with defaults (Base mainnet USDC):
```bash
scripts/x402curl --x402-balance
```

**Step 2:** Show the result to the user.

**Step 3:** Ask: "Would you like to check a balance on a different network or token?"

If yes, ask for the RPC URL and token contract address. Then run:
```bash
scripts/x402curl --x402-balance --x402-rpc-url <url> --x402-token <address>
```

## Examples

### Simple GET

```bash
# 1. Original request returns 402
curl https://paid-api.example.com/data
# → 402 with X-Payment header

# 2. Retry with x402curl
scripts/x402curl https://paid-api.example.com/data
# → 200 with data
```

### POST with JSON body

```bash
# 1. Original
curl -X POST https://translate.example.com/v1 \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello", "target": "es"}'
# → 402 with x402Version in body

# 2. Retry
scripts/x402curl -X POST https://translate.example.com/v1 \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello", "target": "es"}'
# → 200 with translation
```

### File upload

```bash
# 1. Original
curl -X POST https://ocr.example.com/extract -F "file=@document.pdf"
# → 402

# 2. Retry
scripts/x402curl -X POST https://ocr.example.com/extract \
  -F "file=@document.pdf"
```

### Output to file

```bash
# 1. Original
curl -o result.json https://paid-api.example.com/report
# → 402

# 2. Retry
scripts/x402curl -o result.json https://paid-api.example.com/report
```
