
# Source local customizations
if ($env.config-path | path dirname | path join "env.local.nu" | path exists) { source ($env.config-path | path dirname | path join "env.local.nu") }
