; extends

; this is a directive ^ use it to avoid clobbering existing injections coming
; from plugins.

; highlight custom sigils in Elixir

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "SQL")
 (#set! injection.language "sql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "GQL")
 (#set! injection.language "graphql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "JSON")
 (#set! injection.language "json"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "PS")
 (#set! injection.language "powershell"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "LIQUID")
 (#set! injection.language "liquid"))
