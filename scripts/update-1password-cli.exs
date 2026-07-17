#!/usr/bin/env elixir

Mix.install([:req])

defmodule Update1PasswordCLI do
  @config_path Path.expand("../config/mise/config.toml", __DIR__)
  @signing_key_url "https://downloads.1password.com/linux/keys/1password.asc"
  @signing_key_fingerprint "3FEF9748469ADBE15DA7CA80AC2D62742012EA22"
  @artifacts [
    {"macos-x64", "op_darwin_amd64_vVERSION.zip"},
    {"macos-arm64", "op_darwin_arm64_vVERSION.zip"},
    {"linux-x64", "op_linux_amd64_vVERSION.zip"},
    {"linux-arm64", "op_linux_arm64_vVERSION.zip"}
  ]

  def run do
    version = System.fetch_env!("OP_VERSION")

    unless Regex.match?(~r/^[0-9A-Za-z.-]+$/, version) do
      raise "invalid 1Password CLI version: #{inspect(version)}"
    end

    directory = Path.join(System.tmp_dir!(), "update-1password-cli-#{System.unique_integer([:positive])}")
    File.mkdir_p!(directory)

    try do
      gnupg_home = import_signing_key(directory)
      contents = File.read!(@config_path)
      contents = replace_once(contents, ~r/(\[tools\."http:1password-cli"\]\nversion = ")[^"]+("\n)/, version)

      contents =
        Enum.reduce(@artifacts, contents, fn {platform, filename_template}, contents ->
          filename = String.replace(filename_template, "VERSION", version)
          digest = download_and_verify(filename, version, directory, gnupg_home)

          pattern =
            Regex.compile!(
              "^(#{Regex.escape(platform)} = \\{ url = \"[^\"]+\", checksum = \"sha256:)[0-9a-f]+(\" \\})$",
              "m"
            )

          replace_once(contents, pattern, digest)
        end)

      mode = File.stat!(@config_path).mode
      temporary_path = Path.join(Path.dirname(@config_path), ".config.toml.#{System.unique_integer([:positive])}")
      File.write!(temporary_path, contents)
      File.chmod!(temporary_path, mode)
      File.rename!(temporary_path, @config_path)
      IO.puts("Updated 1Password CLI to #{version} in #{@config_path}")
    after
      File.rm_rf!(directory)
    end
  end

  defp import_signing_key(directory) do
    key_path = Path.join(directory, "1password.asc")
    download!(@signing_key_url, key_path)
    gnupg_home = Path.join(directory, "gnupg")
    File.mkdir!(gnupg_home)
    File.chmod!(gnupg_home, 0o700)

    output =
      command!("gpg", [
        "--homedir",
        gnupg_home,
        "--batch",
        "--with-colons",
        "--import-options",
        "show-only",
        "--import",
        key_path
      ])

    fingerprints =
      output
      |> String.split("\n")
      |> Enum.filter(&String.starts_with?(&1, "fpr:")) # spellchecker:disable-line
      |> Enum.map(&(String.split(&1, ":") |> Enum.at(9)))

    unless @signing_key_fingerprint in fingerprints do
      raise "downloaded 1Password signing key has an unexpected fingerprint"
    end

    command!("gpg", ["--homedir", gnupg_home, "--batch", "--import", key_path])
    gnupg_home
  end

  defp download_and_verify(filename, version, directory, gnupg_home) do
    url = "https://cache.agilebits.com/dist/1P/op2/pkg/v#{version}/#{filename}"
    archive_path = Path.join(directory, filename)
    IO.puts("Downloading #{url}")
    download!(url, archive_path)

    verification_path = Path.join(directory, Path.rootname(filename))
    File.mkdir!(verification_path)

    {:ok, _files} =
      :zip.extract(String.to_charlist(archive_path),
        cwd: String.to_charlist(verification_path),
        file_list: [~c"op", ~c"op.sig"]
      )

    command!("gpg", [
      "--homedir",
      gnupg_home,
      "--batch",
      "--verify",
      Path.join(verification_path, "op.sig"),
      Path.join(verification_path, "op")
    ])

    archive_path
    |> File.read!()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp download!(url, path) do
    response = Req.get!(url)

    if response.status != 200 do
      raise "download failed with HTTP #{response.status}: #{url}"
    end

    File.write!(path, response.body)
  end

  defp replace_once(contents, pattern, replacement) do
    if length(Regex.scan(pattern, contents)) != 1 do
      raise "could not uniquely update #{Regex.source(pattern)}"
    end

    Regex.replace(pattern, contents, fn _, prefix, suffix -> prefix <> replacement <> suffix end)
  end

  defp command!(command, arguments) do
    case System.cmd(command, arguments, stderr_to_stdout: true) do
      {output, 0} -> output
      {output, status} -> raise "#{command} failed with status #{status}:\n#{output}"
    end
  end
end

Update1PasswordCLI.run()
