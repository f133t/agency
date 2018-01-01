
# Agency

Constructs and assigns Missions

## Usage

* manual construction of identites
* identities -> sessions -> redis
* profiles -> enqueue
* extractor workers pull from queue, select identity from rotating ring
  * if identity is non-functional, record error, invalidate identity, re-enqueue
* after attempt with valid identity:
  * enqueue job with profile data
  * increment postprocessor job counter
  * decrement extractor job counter
* postprocessor worker pulls raw data and converts it into a usable format, then outputs to disk.

## Guts

### Redis

* `session-ring = []`
  * A list of email addresses which is rotated
* `session-hash:<email> = {session}`
  * An expiring dictionary of sessions, keyed by email address

### Identity

#### Insert a new identity session

This will sign in via the socks proxy, using the provided user-agent string, then
serialize the resulting session in redis, in the structures listed above.

```bash
rails r bin/add_session.rb \
  --email user@example.com \
  --password s3cr3t123 \
  --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Internet Exploder Gold" \
  --socks-proxy 11.22.33.44:56789
```
