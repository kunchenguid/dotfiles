# HTTP Protocol Evolution

HTTP has evolved through three major generations, each solving critical performance limitations of its predecessor. Understanding the differences is essential for choosing the right optimization strategies.

## HTTP/1.1: The Workaround Era

HTTP/1.1 (1997, RFC 2616; updated in 2014, RFC 7230-7235) introduced persistent connections and pipelining over the original HTTP/1.0 model, but its fundamental constraint remains: **one request-response pair at a time per TCP connection**.

### Key features

**Keep-alive connections:** HTTP/1.0 opened a new TCP connection for every request. HTTP/1.1 defaults to persistent connections (`Connection: keep-alive`), reusing the same TCP connection for multiple sequential requests. This eliminates repeated TCP and TLS handshakes.

**Pipelining (failed experiment):** HTTP/1.1 specified pipelining -- sending multiple requests without waiting for responses. In practice, pipelining was never widely adopted because:
- Responses must arrive in the same order as requests (HOL blocking)
- Many proxies and servers handled it incorrectly
- A slow response blocks all subsequent responses
- Browsers disabled it by default

### Performance workarounds for HTTP/1.1

Because HTTP/1.1 cannot multiplex, developers invented workarounds:

| Workaround | How It Works | Trade-off |
|-----------|-------------|-----------|
| **Domain sharding** | Split resources across 4-6 subdomains to open more parallel connections | More DNS lookups, TCP handshakes, and memory usage |
| **File concatenation** | Bundle many JS/CSS files into one to reduce requests | Cache invalidation -- one change invalidates the entire bundle |
| **CSS sprites** | Combine many small images into one spritesheet | Complex to maintain; unused pixels waste bandwidth |
| **Inlining** | Embed small resources (CSS, images as data URIs) directly in HTML | Cannot be cached independently; increases HTML size |
| **Cookie-free domains** | Serve static assets from a domain without cookies | Cookies sent on every request to the main domain add overhead |

**These workarounds become anti-patterns in HTTP/2.** Domain sharding defeats multiplexing. Concatenation prevents granular caching. Sprites add unnecessary complexity.

### When HTTP/1.1 is still relevant

- Legacy infrastructure that cannot upgrade
- Environments where HTTP/2 proxying introduces bugs
- Simple APIs with few concurrent requests
- Very small sites where the overhead of HTTP/2 setup is not justified

## HTTP/2: Multiplexing and Binary Framing

HTTP/2 (2015, RFC 7540; updated as RFC 9113) is a binary protocol that multiplexes many requests and responses over a single TCP connection.

### Core concepts

**Binary framing layer:** HTTP/2 wraps HTTP semantics in a binary frame format. Headers and data are sent as separate frame types, enabling interleaving. This is invisible to application code -- the same HTTP methods, status codes, and headers are used.

**Streams, messages, and frames:**
- **Stream:** A bidirectional flow of frames within a connection, identified by an integer ID
- **Message:** A complete HTTP request or response, composed of one or more frames
- **Frame:** The smallest unit of communication (HEADERS frame, DATA frame, etc.)

Multiple streams share one TCP connection, and frames from different streams can be interleaved. This eliminates the need for multiple connections.

### Key performance features

**Multiplexing:** Unlimited concurrent streams over one TCP connection. A browser can request CSS, JS, images, and API data simultaneously without waiting for any single response to complete. This eliminates HTTP/1.1's HOL blocking at the application layer.

**Header compression (HPACK):** HTTP headers are repetitive -- `User-Agent`, `Cookie`, `Accept-Encoding` are sent identically on every request. HPACK compresses headers using:
- A static dictionary of common header name-value pairs
- A dynamic dictionary that learns session-specific headers
- Huffman encoding for values

Real-world compression: **85-95% reduction** in header overhead. For API-heavy applications sending large cookies or authorization tokens on every request, this is significant.

**Stream prioritization:** Clients can signal the relative importance of streams using dependency trees and weights. A well-configured priority scheme ensures:
- CSS and fonts load before images
- Above-fold resources load before below-fold
- Critical API calls complete before prefetched data

In practice, priority implementation varies across servers and CDNs. Test your specific infrastructure.

**Server Push:** The server can proactively send resources the client has not yet requested. When a browser requests `index.html`, the server can push `style.css` and `app.js` alongside the HTML response.

Caveats with Server Push:
- The browser may already have the resource cached, wasting bandwidth
- No reliable mechanism for the client to cancel a push it does not need
- Complex to configure correctly
- **Largely deprecated in practice** -- Chrome removed support in 2022
- Use `103 Early Hints` instead: the server sends a `103` informational response with `Link` headers before the final response, allowing the browser to begin fetching hinted resources immediately

### Migration from HTTP/1.1 to HTTP/2

**Remove anti-patterns:**
1. **Remove domain sharding** -- consolidate resources onto one origin; multiple connections defeat multiplexing
2. **Stop concatenating files** -- serve individual modules for granular caching
3. **Eliminate sprites** -- individual images multiplex efficiently
4. **Remove data URI inlining** -- let resources be cached independently

**Add new optimizations:**
1. **Prioritize critical resources** -- configure stream priorities or use `fetchpriority` attribute
2. **Use `103 Early Hints`** -- hint critical resources before the server finishes processing
3. **Reduce origin count** -- fewer origins means fewer TCP/TLS handshakes
4. **Leverage connection coalescing** -- HTTP/2 can reuse a connection for multiple hostnames if they share a TLS certificate and resolve to the same IP

### HTTP/2 limitations

**TCP head-of-line blocking:** Although HTTP/2 eliminates application-layer HOL blocking, it inherits TCP's transport-layer HOL blocking. A single lost TCP packet stalls all multiplexed streams until the packet is retransmitted. Under packet loss (mobile networks, congested links), HTTP/2 over one TCP connection can perform worse than HTTP/1.1 over six connections.

This fundamental limitation motivated HTTP/3.

## HTTP/3 and QUIC: UDP-Based Transport

HTTP/3 (2022, RFC 9114) runs over QUIC (RFC 9000), a transport protocol built on UDP. QUIC integrates transport and encryption into a single layer, eliminating the TCP+TLS stack.

### Why QUIC exists

QUIC solves three problems that cannot be fixed in TCP:

1. **Transport-layer HOL blocking:** QUIC provides independent streams. A lost packet on one stream does not block other streams. Each stream has its own loss recovery.

2. **Connection establishment latency:** QUIC combines the transport handshake with the cryptographic handshake (always TLS 1.3) in a single round trip. For returning visitors, **0-RTT resumption** sends application data in the very first packet.

3. **Connection migration:** TCP connections are identified by a 4-tuple (source IP, source port, destination IP, destination port). Changing networks (e.g., WiFi to cellular) breaks the connection. QUIC connections are identified by a connection ID, allowing seamless migration across network changes.

### QUIC architecture

```
HTTP/3       (application semantics)
QUIC         (transport: streams, flow control, loss recovery, encryption)
UDP          (minimal transport: no handshake, no ordering, no reliability)
IP           (network layer)
```

Key differences from HTTP/2 over TCP+TLS:
- **Always encrypted** -- QUIC mandates TLS 1.3; no cleartext mode
- **Userspace implementation** -- runs in application space, not the OS kernel; faster iteration and deployment
- **Improved loss recovery** -- more accurate RTT measurement, better loss detection
- **Flow control** -- per-stream and connection-level, preventing one stream from starving others

### 0-RTT Connection Resumption

For returning visitors, QUIC can send application data in the first packet using previously established cryptographic parameters:

- First visit: 1-RTT handshake (same as TLS 1.3)
- Subsequent visits: 0-RTT -- data flows immediately

**Replay attack risk:** 0-RTT data can be replayed by an attacker. Only use 0-RTT for idempotent requests (GET, HEAD). Servers must implement replay protection for non-idempotent operations.

### Connection Migration

When a mobile user switches from WiFi to cellular, TCP connections break because the source IP changes. The user experiences a full reconnection: new DNS lookup, new TCP handshake, new TLS handshake.

QUIC connections survive network changes because they are identified by a connection ID rather than IP/port tuples. The connection seamlessly continues on the new network path with a path validation step.

### Deploying HTTP/3

**Server support:** Enable QUIC on your server or CDN. Major CDNs (Cloudflare, Fastly, AWS CloudFront, Akamai) support HTTP/3.

**Advertisement:** HTTP/3 is advertised via the `Alt-Svc` HTTP header:
```
Alt-Svc: h3=":443"; ma=86400
```

The browser first connects via HTTP/2 (TCP), receives the `Alt-Svc` header, and then migrates subsequent requests to HTTP/3 (QUIC). This provides a graceful upgrade path.

**Firewall considerations:** QUIC uses UDP port 443. Some networks and firewalls block UDP traffic. Browsers fall back to HTTP/2 over TCP when QUIC is unavailable.

## Choosing the Right Protocol

| Factor | HTTP/1.1 | HTTP/2 | HTTP/3 |
|--------|---------|--------|--------|
| **Multiplexing** | None (1 request per connection) | Full (unlimited streams over 1 TCP) | Full (unlimited streams over QUIC) |
| **HOL blocking** | Application layer (per connection) | TCP layer (all streams blocked) | None (per-stream recovery) |
| **Handshake latency** | TCP (1 RTT) + TLS (1-2 RTT) | Same as HTTP/1.1 | QUIC+TLS (1 RTT; 0-RTT resumption) |
| **Header compression** | None | HPACK (static + dynamic tables) | QPACK (similar to HPACK, adapted for QUIC) |
| **Connection migration** | No | No | Yes (connection ID based) |
| **Encryption** | Optional | Practically required (browsers enforce) | Always (TLS 1.3 mandatory) |
| **Best for** | Legacy; simple APIs | General web; most sites today | Mobile users; lossy networks; real-time |

### Migration strategy

1. **Enable HTTP/2** on all web servers and CDNs (this should already be done)
2. **Remove HTTP/1.1 workarounds** (domain sharding, concatenation, sprites)
3. **Enable HTTP/3** on CDN first (lowest risk, highest mobile traffic benefit)
4. **Advertise HTTP/3** via `Alt-Svc` headers
5. **Monitor** connection protocol distribution and performance metrics per protocol
6. **Test under packet loss** to validate HTTP/3 benefits for mobile users

## Protocol-Specific Optimization Checklist

### HTTP/2 optimizations
- [ ] Single connection per origin (remove domain sharding)
- [ ] Individual resource serving (stop concatenating)
- [ ] Stream priority configuration on server
- [ ] `103 Early Hints` for critical resources
- [ ] Connection coalescing with wildcard certificates
- [ ] HTTP/2 push removed (use Early Hints instead)

### HTTP/3 optimizations
- [ ] QUIC enabled on CDN or origin
- [ ] `Alt-Svc` header advertising HTTP/3
- [ ] 0-RTT enabled for idempotent requests
- [ ] UDP 443 allowed through firewalls
- [ ] Fallback to HTTP/2 tested and verified
- [ ] Connection migration tested on mobile

## Measuring Protocol Performance

Use the Navigation Timing and Resource Timing APIs to measure protocol-level performance:

```javascript
// Check protocol used
const entries = performance.getEntriesByType('resource');
entries.forEach(entry => {
  console.log(entry.name, entry.nextHopProtocol);
  // 'h2' for HTTP/2, 'h3' for HTTP/3
});

// Connection timing breakdown
const nav = performance.getEntriesByType('navigation')[0];
console.log('DNS:', nav.domainLookupEnd - nav.domainLookupStart);
console.log('TCP:', nav.connectEnd - nav.connectStart);
console.log('TLS:', nav.connectEnd - nav.secureConnectionStart);
console.log('TTFB:', nav.responseStart - nav.requestStart);
```

Understanding protocol capabilities and constraints is essential for choosing the right optimizations. An optimization that helps on HTTP/1.1 may be neutral or harmful on HTTP/2, and the reverse is also true.
