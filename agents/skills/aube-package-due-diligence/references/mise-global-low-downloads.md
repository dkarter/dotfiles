# Mise Global Npm Low Downloads

Use when `mise use -g npm:<package>` or `mise install npm:<package>` fails with `ERR_AUBE_LOW_DOWNLOAD_PACKAGE` and verbose output shows `aube add --global <package>@<version>`.

Key rule: `aube add --global` reads user config, not repo `aube-workspace.yaml`. Persist fixes with `aube config set --location user`, which writes `~/.config/aube/config.toml`.

1. Confirm keys:

```bash
aube config explain allowedUnpopularPackages
aube config explain trustPolicyExclude
```

2. Inspect the direct package:

```bash
aube view <package>@<version> --json
git ls-remote --tags <repo-url>
git ls-remote <repo-url> <gitHead>
```

3. Probe next gates without editing config:

```bash
AUBE_ALLOWED_UNPOPULAR_PACKAGES='<package>' aube add --global <package>@<version>
```

4. If trust downgrades appear, inspect exact versions and retry with temporary excludes:

```bash
aube view <dep>@<version> --json
AUBE_ALLOWED_UNPOPULAR_PACKAGES='<package>' AUBE_TRUST_POLICY_EXCLUDE='<dep>@<version>,<dep2>@<version>' aube add --global <package>@<version>
```

5. Persist only after evidence is acceptable:

```bash
aube config set --location user allowedUnpopularPackages '["<package>"]'
aube config set --location user trustPolicyExclude '["<dep>@<version>", "<dep2>@<version>"]'
```

6. Verify through mise:

```bash
mise use -g npm:<package>
mise exec -- <bin> --version
```

Use `allowedUnpopularPackages` for low-download exceptions. Do not set `lowDownloadThreshold = 0` unless the user explicitly wants to disable the gate broadly.
