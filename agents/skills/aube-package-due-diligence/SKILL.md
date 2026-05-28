---
name: aube-package-due-diligence
description: Investigate aube package-manager trust, provenance, advisory, or install failures before adding bypasses or package exceptions. Use when `aube install`, `aube add`, `aube audit`, or `mise install` with `npm.package_manager = "aube"` fails on trust policy, provenance, advisories, lifecycle scripts, low downloads, lockfile drift, or another supply-chain gate; also use before adding `trustPolicyExclude`, turning `trustPolicy` off, allowing package builds, or accepting npm packages installed through mise.
---

# Aube Package Due Diligence

## Overview

Perform cautious, evidence-based due diligence before weakening an aube security gate. Prefer narrow, reversible exceptions only after verifying package identity, metadata, provenance, advisories, tarball contents, upstream source alignment, and the actual aube/mise install path.

## Rules

- Do not add an exclusion or disable a policy just because it unblocks install.
- Prefer `aube` commands over npm package-manager operations. Use `npm view` or `npm pack` only as registry inspection tools when aube lacks an equivalent, and say so.
- Keep exceptions scoped to the exact package version when possible, for example `tinyexec@1.2.2`, not `tinyexec`.
- Do not set `trustPolicy = off` unless the user explicitly accepts the broader risk.
- Do not approve lifecycle scripts with `--allow-build` until the package and script behavior are reviewed.
- Treat aube failures as signal. A bypass needs positive evidence, not just lack of known bad news.
- If evidence is weak, conflicting, or unavailable, stop and recommend waiting for a safer release or asking the maintainer to republish with stronger evidence.

## Workflow

1. Reproduce the failing path.
2. Identify the package, version, transitive path, and aube policy involved.
3. Inspect package metadata with aube.
4. Check advisories and aube security output.
5. Verify upstream source alignment.
6. Inspect the published tarball contents.
7. Decide whether a bypass is justified.
8. Apply the smallest safe change and document why.
9. Re-run install and repository checks.

## Reproduce

Run the exact command that failed. For mise-managed npm packages using aube, also run the narrow tool install if possible:

```bash
mise install --locked npm:<package>@<version> --verbose
```

Look for the underlying aube command in verbose output, for example `aube add --global <package>@<version>`. Identify whether the package is a direct mise tool, a root dependency, or a transitive dependency.

## Metadata Checks

Use aube first:

```bash
aube view <name>@<version> --json
aube view <name>@<previous-known-good-version> --json
aube config explain <setting>
```

Check and record:

- `name`, `version`, `repository`, `homepage`, `bugs`, `license`.
- `author`, `maintainers`, `_npmUser`, and whether ownership changed unexpectedly.
- `dist.integrity`, `dist.shasum`, `dist.signatures`, and `dist.attestations.provenance`.
- `gitHead` and whether it exists in the upstream repository.
- `scripts`, especially `preinstall`, `install`, `postinstall`, `prepare`, `prepack`, and `postpack`.
- `dependencies` and `optionalDependencies`; runtime dependency additions increase risk.
- Publish times for suspicious version jumps or rapid republish sequences when available.

For trust downgrades, compare the previous trusted version and failing version. A downgrade from trusted publisher to maintainer publish with registry signature and SLSA provenance may be acceptable only if the rest of the evidence is clean and the exception is exact-version scoped.

## Advisory Checks

Create an isolated temporary project outside the repo when auditing a single package. Use aube, not npm install:

```bash
aube install
aube audit --json
aube why <name>
```

If the policy failure prevents the isolated install, use a temporary environment variable rather than editing config:

```bash
AUBE_TRUST_POLICY_EXCLUDE=<name>@<version> aube install
```

Search upstream issues and advisories for security, malware, compromise, trusted publisher, provenance, and the exact version. Lack of reports is not proof of safety; treat it as one data point.

## Source And Tarball Checks

Verify the npm metadata `gitHead` against upstream:

```bash
git ls-remote --tags <repo-url>
git ls-remote <repo-url> <gitHead>
```

Inspect the package tarball. Use `aube pack` for local projects; for registry package tarballs, use registry inspection tools if aube has no direct pack-from-registry command. Verify the downloaded tarball integrity matches metadata before trusting contents.

Look for:

- Unexpected files, large binaries, minified blobs, or encoded payloads.
- New install scripts or script changes that execute during install.
- New runtime dependencies or exotic dependency sources.
- Network, credential, filesystem, shell, or obfuscation behavior unrelated to package purpose.
- Differences from the previous known-good tarball that are plausible for the release notes or commits.

For small packages, read the built output. For larger packages, sample entry points and new or changed files, then focus on suspicious files and install-time code.

## Decision Criteria

Accept a narrow exception only when most of these are true:

- Package identity, repository, and maintainer are expected.
- The failing version has registry signatures and preferably SLSA provenance.
- `gitHead` maps to the expected upstream repository and tag or commit.
- Aube audit reports no known vulnerabilities for the relevant package graph.
- Tarball contents are consistent with source and package purpose.
- No unexplained install scripts, binary payloads, obfuscated code, or dependency source changes exist.
- The exception can be scoped to an exact version.

Reject or pause when any of these are true:

- Maintainers, repository, tarball contents, or `gitHead` do not line up.
- The version adds install scripts, opaque binaries, credential access, or network behavior without clear need.
- Aube reports malicious, advisory, lifecycle, or exotic dependency findings that cannot be explained.
- Public issues suggest compromise or the maintainer is actively correcting a bad release.
- The only available fix is a broad policy disablement.

## Applying Changes

Prefer config in this order:

1. Pin to a safe version that satisfies the tool if one exists.
2. Add exact-version package exclusions, for example `trustPolicyExclude: ["name@1.2.3"]`.
3. Add exact package build approval only after reviewing lifecycle scripts.
4. Ask the user before broader package-name exclusions or policy disablement.

When editing config, add a short comment explaining the evidence and scope. Example:

```yaml
# tinyexec@1.2.2 moved from trusted-publisher metadata to maintainer publish
# with registry signature and SLSA provenance; keep this scoped to the exact version.
trustPolicyExclude:
  - tinyexec@1.2.2
```

After changes, run the original command and relevant repo checks:

```bash
mise install --locked
task ci:run
```

Use the repository's actual check commands when different.

## Report Template

Summarize the result clearly:

```markdown
Verdict: acceptable narrow exception / do not bypass / inconclusive

Evidence:

- Package/version/path: ...
- Aube policy triggered: ...
- Metadata/provenance: ...
- Advisory result: ...
- Source alignment: ...
- Tarball review: ...

Change:

- ...

Verification:

- ...

Residual risk:

- ...
```
