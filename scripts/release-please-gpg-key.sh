#!/usr/bin/env bash
#MISE description "Generate/export the release-please GPG signing key"
#USAGE flag "--print" help="Print key material and secret values to stdout"
set -euo pipefail

name="release-please-signer"
email="293262735+release-please-signer@users.noreply.github.com"
uid="${name} <${email}>"
output_dir="${RELEASE_PLEASE_GPG_OUTPUT_DIR:-}"
print_values="false"

if [[ ${usage_print:-false} == "true" ]]; then
  print_values="true"
fi

usage() {
  printf 'Usage: %s [--print]\n' "${0##*/}"
  printf '\n'
  printf 'Generates a release-please GPG signing key if one does not exist, then exports:\n'
  printf '  RELEASE_PLEASE_GPG_PRIVATE_KEY\n'
  printf '  RELEASE_PLEASE_GPG_KEY_ID\n'
  printf '  RELEASE_PLEASE_GPG_PASSPHRASE, if RELEASE_PLEASE_GPG_PASSPHRASE is set\n'
  printf '\n'
  printf 'Environment:\n'
  printf '  RELEASE_PLEASE_GPG_PASSPHRASE   Optional passphrase for a new key\n'
  printf '  RELEASE_PLEASE_GPG_OUTPUT_DIR   Optional output directory; defaults to a new temp directory\n'
  printf '\n'
  printf 'Use --print only if you intentionally want key material printed to stdout.\n'
}

while (($#)); do
  case "$1" in
    --print)
      print_values="true"
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if ! command -v gpg >/dev/null 2>&1; then
  printf 'gpg is required but was not found in PATH.\n' >&2
  exit 1
fi

if [[ -z $output_dir ]]; then
  output_dir="$(mktemp -d "${TMPDIR:-/tmp}/release-please-signer.XXXXXX")"
else
  mkdir -p "$output_dir"
fi
chmod 700 "$output_dir"

fingerprint_for_email() {
  gpg --list-secret-keys --with-colons "$email" 2>/dev/null | awk -F: '$1 == "fpr" {print $10; exit}' # spellchecker:disable-line
}

fingerprint="$(fingerprint_for_email || true)"

if [[ -z $fingerprint ]]; then
  printf 'No existing secret key found for %s. Generating one now.\n' "$uid" >&2
  if [[ -n ${RELEASE_PLEASE_GPG_PASSPHRASE+x} ]]; then
    gpg --batch --pinentry-mode loopback --passphrase "$RELEASE_PLEASE_GPG_PASSPHRASE" \
      --quick-generate-key "$uid" rsa4096 sign 2y
  else
    gpg --batch --pinentry-mode loopback --passphrase '' \
      --quick-generate-key "$uid" rsa4096 sign 2y
  fi
  fingerprint="$(fingerprint_for_email)"
else
  printf 'Using existing secret key for %s.\n' "$uid" >&2
fi

private_key_file="${output_dir}/release-please-private-key.asc"
public_key_file="${output_dir}/release-please-public-key.asc"
key_id_file="${output_dir}/release-please-key-id.txt"

private_key_tmp="${private_key_file}.tmp"
secret_export_args=(--batch --yes --pinentry-mode loopback)
if [[ -n ${RELEASE_PLEASE_GPG_PASSPHRASE+x} ]]; then
  secret_export_args+=(--passphrase "$RELEASE_PLEASE_GPG_PASSPHRASE")
else
  secret_export_args+=(--passphrase '')
fi

if ! gpg "${secret_export_args[@]}" --armor --export-secret-keys "$fingerprint" >"$private_key_tmp"; then
  rm -f "$private_key_tmp"
  if [[ -z ${RELEASE_PLEASE_GPG_PASSPHRASE+x} ]]; then
    printf '\nFailed to export the secret key. If the existing key is passphrase-protected, rerun with:\n' >&2
    printf '  RELEASE_PLEASE_GPG_PASSPHRASE=<passphrase> mise run release:signing-key\n' >&2
  fi
  exit 1
fi
mv "$private_key_tmp" "$private_key_file"
gpg --armor --export "$fingerprint" >"$public_key_file"
printf '%s\n' "$fingerprint" >"$key_id_file"
chmod 600 "$private_key_file" "$key_id_file"
chmod 644 "$public_key_file"

printf '\nGenerated/exported release-please signer values.\n'
printf '\nFiles:\n'
printf '  private key: %s\n' "$private_key_file"
printf '  public key:  %s\n' "$public_key_file"
printf '  key id:      %s\n' "$key_id_file"
printf '  cleanup:     rm -rf %q\n' "$output_dir"

printf '\nGitHub repository secret commands:\n'
printf '  gh secret set RELEASE_PLEASE_GPG_PRIVATE_KEY < %q\n' "$private_key_file"
printf "  gh secret set RELEASE_PLEASE_GPG_KEY_ID --body \"\$(<%q)\"\n" "$key_id_file"
if [[ -n ${RELEASE_PLEASE_GPG_PASSPHRASE+x} ]]; then
  printf '  gh secret set RELEASE_PLEASE_GPG_PASSPHRASE --body %q\n' "$RELEASE_PLEASE_GPG_PASSPHRASE"
else
  printf '  # RELEASE_PLEASE_GPG_PASSPHRASE is not needed; generated/using an unprotected key.\n'
fi

printf '\nAdd this public key to GitHub for release-please-signer:\n'
printf '  %s\n' "$public_key_file"

if [[ $print_values == "true" ]]; then
  printf '\nRELEASE_PLEASE_GPG_KEY_ID:\n'
  printf '%s\n' "$fingerprint"
  printf '\nRELEASE_PLEASE_GPG_PRIVATE_KEY:\n'
  cat "$private_key_file"
  printf '\nRELEASE_PLEASE_GPG_PUBLIC_KEY:\n'
  cat "$public_key_file"
  if [[ -n ${RELEASE_PLEASE_GPG_PASSPHRASE+x} ]]; then
    printf '\nRELEASE_PLEASE_GPG_PASSPHRASE:\n'
    printf '%s\n' "$RELEASE_PLEASE_GPG_PASSPHRASE"
  fi
fi
