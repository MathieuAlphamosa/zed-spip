; Inject HTML parsing into all `content` nodes.
; The `combined` directive merges disjoint content ranges into a single
; virtual document so that HTML parsing works correctly across SPIP
; constructs interspersed in the markup.

((content) @content
  (#set! injection.language "html")
  (#set! injection.combined))
