; if the combined injection fails, try this instead
; (text) @yaml

; combined injection:
((text) @injection.content
  (#set! injection.language "yaml")
  (#set! injection.combined))
