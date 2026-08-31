# Network Fundamentals

Understanding the transport layer is the foundation of web performance optimization. Every HTTP request traverses DNS, TCP, and TLS before application data flows -- and each layer imposes latency costs.

## Latency Is the Bottleneck

The single most important insight in web performance: **latency, not bandwidth, is the constraining factor** for most web applications.

Bandwidth has grown dramatically over the past decade. A typical broadband connection delivers 50-100+ Mbps. But latency -- the time for a packet to travel from client to server and back (round-trip time, or RTT) -- is constrained by physics. Light in fiber travels at roughly 200,000 km/s. A packet from New York to London (~5,500 km) takes at minimum ~28ms one way, ~56ms RTT. Real-world RTTs are higher due to routing, queuing, and processing delays.

**Why this matters:** A typical web page requires dozens of network round trips during loading. If each round trip takes 50ms, 20 round trips add a full second of latency -- regardless of whether the connection is 10 Mbps or 100 Mbps. Reducing the number of round trips has a far greater impact than increasing bandwidth.

### The bandwidth-delay product

The bandwidth-delay product (BDP) represents the maximum amount of data in flight at any given time:

```
BDP = Bandwidth x RTT
```

A 10 Mbps connection with 100ms RTT has a BDP of ~122KB. This means at most 122KB can be in transit at once. If the TCP window is smaller than the BDP, the connection underutilizes available bandwidth. High-latency links (satellite, intercontinental) have large BDPs and are especially sensitive to window sizing.

## TCP Three-Way Handshake

Every new TCP connection begins with a three-way handshake:

1. **SYN** -- Client sends a synchronize packet to the server
2. **SYN-ACK** -- Server acknowledges and sends its own synchronize
3. **ACK** -- Client acknowledges; data transfer can begin

This handshake costs **one full RTT** before any application data flows. On a 100ms RTT connection, that is 100ms of pure overhead for every new TCP connection.

### Implications for web performance

- Each new connection to a different origin pays this cost
- HTTP/1.1 browsers open 6 connections per host -- 6 handshakes
- HTTP/2 uses a single connection per origin, paying the handshake cost once
- Connection reuse (`keep-alive`) amortizes the handshake cost across multiple requests

### TCP Fast Open (TFO)

TCP Fast Open allows data to be sent in the SYN packet itself, eliminating one RTT on subsequent connections. The server generates a cookie on the first connection; the client includes this cookie in future SYN packets along with data:

- First connection: normal three-way handshake (no savings)
- Subsequent connections: data sent with SYN, saving one RTT
- Server support required; not universally deployed
- Works best for short, repeated connections to the same server

## Congestion Control

TCP is a reliable, ordered, congestion-controlled protocol. It does not know the network capacity in advance, so it probes capacity through two mechanisms:

### Slow Start

A new TCP connection begins by sending a small number of segments (typically 10, or ~14KB). For each acknowledged segment, the sender doubles its congestion window. This exponential growth continues until packet loss occurs or a threshold is reached.

**The 14KB rule:** Because the initial congestion window is typically 10 segments (~14KB), the first round trip can deliver at most 14KB of data. This is why keeping the critical rendering payload (HTML + inline critical CSS) under 14KB is a high-leverage optimization -- it enables first paint in a single round trip after the TCP handshake.

```
Round 1: Send 10 segments (~14KB)
Round 2: Send 20 segments (~28KB)
Round 3: Send 40 segments (~56KB)
Round 4: Send 80 segments (~112KB)
...
```

It takes several round trips to ramp up to full link capacity. On a high-latency connection, this ramp-up period significantly delays large transfers.

### Congestion Avoidance

After slow start reaches a threshold (typically set by the first packet loss event), TCP switches to congestion avoidance: the window grows linearly (additive increase) rather than exponentially. On packet loss, the window is cut in half (multiplicative decrease). This AIMD (Additive Increase Multiplicative Decrease) algorithm is conservative by design.

### Modern congestion control algorithms

- **Cubic** (Linux default): More aggressive window growth, optimized for high-BDP links
- **BBR** (Bottleneck Bandwidth and Round-trip propagation time): Google's algorithm that models bandwidth and RTT explicitly rather than relying on packet loss as a signal. BBR can significantly improve throughput on high-latency, lossy links

**Server-side optimization:** Increasing the initial congestion window (`initcwnd`) to 10 segments is now standard. Some operators increase it further. Enabling BBR on servers serving global traffic can improve throughput by 5-15%.

## Head-of-Line Blocking

TCP guarantees ordered delivery. If packet 3 of 10 is lost, packets 4-10 are buffered at the receiver until packet 3 is retransmitted and arrives. This is **head-of-line (HOL) blocking**.

### Impact on HTTP

- **HTTP/1.1:** One request at a time per connection. A slow response blocks subsequent requests on that connection. Browsers use 6 connections as a workaround.
- **HTTP/2:** Multiple streams multiplexed over one TCP connection. A single lost TCP packet blocks ALL streams, not just the affected one. This is worse than HTTP/1.1's 6-connection model under packet loss.
- **HTTP/3 (QUIC):** Runs over UDP with per-stream loss recovery. A lost packet on stream A does not block streams B, C, or D. This eliminates transport-layer HOL blocking entirely.

HOL blocking is the primary technical motivation for HTTP/3's move to QUIC/UDP.

## TLS Handshake Optimization

TLS (Transport Layer Security) encrypts data in transit. The handshake establishes cryptographic parameters and adds latency on top of the TCP handshake.

### TLS 1.2 Handshake

The full TLS 1.2 handshake requires **2 additional round trips** after the TCP handshake:

1. ClientHello / ServerHello (key exchange parameters)
2. Certificate verification, key exchange completion
3. Client sends Finished, server sends Finished

Total for a new HTTPS connection: TCP handshake (1 RTT) + TLS 1.2 (2 RTTs) = **3 RTTs** before data flows.

### TLS 1.3 Handshake

TLS 1.3 reduces the handshake to **1 round trip** by combining key exchange and parameter negotiation into a single message. It also supports **0-RTT resumption** for returning visitors:

- **Full handshake:** 1 RTT (down from 2 in TLS 1.2)
- **0-RTT resumption:** Application data sent in the first message, no handshake delay (with replay attack caveats)

The savings are significant: on a 100ms RTT connection, TLS 1.3 saves 100-200ms per new connection compared to TLS 1.2.

### Session Resumption

Both TLS 1.2 and 1.3 support session resumption, which allows returning clients to skip parts of the handshake:

- **Session IDs** (TLS 1.2): Server stores session state; client presents the ID to resume
- **Session Tickets** (TLS 1.2/1.3): Server encrypts session state into a ticket the client stores and presents later; server is stateless
- **PSK (Pre-Shared Key)** (TLS 1.3): Enables 0-RTT data by using keys from a previous session

### OCSP Stapling

Certificate validation normally requires the browser to contact the Certificate Authority's OCSP responder -- another DNS lookup and HTTP request. **OCSP stapling** lets the server attach (staple) a signed, time-stamped OCSP response to the TLS handshake, eliminating this extra round trip.

Configuration (Nginx):
```nginx
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /path/to/chain.pem;
```

## DNS Resolution

Before any TCP connection begins, the browser must resolve the hostname to an IP address via DNS. This process involves:

1. Browser DNS cache (if the domain was recently resolved)
2. OS DNS cache
3. Router DNS cache
4. ISP recursive resolver
5. Authoritative nameserver (if not cached at any level)

### Latency impact

A DNS lookup adds **20-120ms** depending on cache state and resolver distance. For third-party resources (analytics, CDNs, ad networks), the browser encounters new domains that may not be cached.

### Optimization strategies

**dns-prefetch:** Resolve domains before the browser encounters requests to them:
```html
<link rel="dns-prefetch" href="https://cdn.example.com">
<link rel="dns-prefetch" href="https://api.example.com">
```

**preconnect:** Goes further -- resolves DNS, completes TCP handshake, and negotiates TLS:
```html
<link rel="preconnect" href="https://cdn.example.com">
```

**Minimize third-party origins:** Each unique origin requires at least a DNS lookup. Consolidating resources onto fewer origins reduces DNS overhead.

**TTL management:** Short DNS TTLs (under 60s) cause frequent re-resolution. For stable infrastructure, longer TTLs (300-3600s) reduce DNS overhead for repeat visitors.

## Practical Optimization Checklist

| Optimization | Impact | Implementation |
|-------------|--------|----------------|
| Enable TLS 1.3 | Save 1-2 RTTs per new connection | Server TLS configuration |
| Enable OCSP stapling | Eliminate 1 RTT for cert validation | Server TLS configuration |
| Increase initial cwnd to 10+ | More data in first RTT | `ip route change ... initcwnd 10` (Linux) |
| Enable TCP Fast Open | Save 1 RTT on repeat connections | Kernel parameter + server config |
| Use `preconnect` for critical origins | Eliminate handshake latency at request time | `<link rel="preconnect">` in HTML |
| Use `dns-prefetch` for third-party domains | Overlap DNS with other work | `<link rel="dns-prefetch">` in HTML |
| Consolidate to fewer origins | Fewer handshakes overall | Migrate resources to primary domain or CDN |
| Enable BBR congestion control | Better throughput on lossy/high-RTT links | `sysctl net.ipv4.tcp_congestion_control=bbr` |
| Serve from edge locations (CDN) | Lower RTT to users | CDN for static assets and cacheable responses |
| Monitor real-user latency | Identify bottlenecks users actually experience | Navigation Timing API, RUM tools |

## Key Metrics to Monitor

- **RTT (Round-Trip Time):** The fundamental unit of latency. Measure with `navigator.connection.rtt` or server-side instrumentation.
- **TTFB (Time to First Byte):** Includes DNS + TCP + TLS + server processing. Target < 800ms.
- **Connection time:** TCP + TLS handshake duration. Visible in the Performance API's `connectStart` to `secureConnectionStart` to `connectEnd`.
- **DNS time:** `domainLookupEnd - domainLookupStart` in the Resource Timing API.

Understanding these fundamentals is not optional -- they determine the lower bound of page load performance regardless of how well-optimized the application code is.
