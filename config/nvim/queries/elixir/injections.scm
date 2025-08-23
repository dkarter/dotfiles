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


; the following is taken from elixir-tools.nvim

(call
  target: ((identifier) @_identifier (#eq? @_identifier "execute"))
  (arguments
    (string
      (quoted_content) @sql)))

(call (dot left: (alias) @_alias (#eq? @_alias "Repo") right: (identifier) @_identifier (#eq? @_identifier "query!")) (arguments (string (quoted_content) @sql))) @foo

((call
   target: (dot
             left: (alias) @_mod (#eq? @_mod "EEx")
             right: (identifier) @_func (#eq? @_func "function_from_string"))
   (arguments
     (string
       (quoted_content) @eex))))

