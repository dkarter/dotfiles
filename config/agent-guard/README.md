# Credential guard

Shared redaction for agent tool output. The guard first masks credential fields,
authorization headers, cookies, private keys, and common token formats without
entropy or confidence thresholds. It then scans remaining text with Betterleaks
1.9 (installed globally and for this repository through mise).

Betterleaks' `--redact` redacts its report, **not its input**. The guard uses the
redacted report's line ranges to mask entire affected lines, including multipart
credential components, while preserving surrounding lines. Reports stay in a
captured pipe; no report files or scanner logs are exposed to agents. Provider
validation is explicitly disabled: credentials are never tested against live
APIs.

Scanning uses the guard's configuration and working directory, not a project's
configuration, ignore files, or inline allow comments. Only PATH is inherited.
A mandatory sentinel finding checks that stdin was scanned rather than silently
skipped as binary; its prepended line is removed from the final output.
Missing binaries, timeouts (5 seconds), oversized reports (16 MiB), and malformed
reports withhold the complete string instead of returning unscanned output.
Scanning is synchronous to preserve the existing shared adapter API and incurs
one scanner process per structured result, rather than per string field. Text
fields are batched using their line counts to map masked lines back into the
original structure. Empty results and credential-only objects need no scanner.
Standalone calls to `redactCredentials` still use one process per call. No
credential-bearing text is cached between calls.

Run the shared tests with:

```sh
bun test config/agent-guard
```

This is defense in depth, not permission to read credentials. No scanner can
identify every possible secret.
