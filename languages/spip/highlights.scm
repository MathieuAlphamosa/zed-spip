; SPIP syntax highlighting for Zed
; Maps tree-sitter-spip nodes to standard Zed theme captures.

; ── Comments ──────────────────────────────────────────────────
(comment) @comment

; ── Loops (Boucles) ──────────────────────────────────────────
(loop_open) @keyword
(loop_close) @keyword
(loop_conditional_open) @keyword
(loop_conditional_close) @keyword
(loop_alternative) @keyword

(loop_open
  name: (loop_name) @label)
(loop_close
  name: (loop_name) @label)
(loop_conditional_open
  name: (loop_name) @label)
(loop_conditional_close
  name: (loop_name) @label)
(loop_alternative
  name: (loop_name) @label)

(loop_open
  type: (loop_type) @type)

; ── Criteria ─────────────────────────────────────────────────
(criteria
  value: (criteria_value) @attribute)

; ── Include ──────────────────────────────────────────────────
(include_tag) @keyword.import
(include_param_block
  params: (include_params) @string.special)

; ── Balises (Tags) ───────────────────────────────────────────
(balise
  name: (balise_name) @function)
(balise_shorthand
  name: (balise_name) @function)
(balise
  namespace: (balise_namespace) @namespace)

; ── Balise parameters ────────────────────────────────────────
(balise_params) @string

; ── Filters ──────────────────────────────────────────────────
(filter
  name: (filter_name) @function.method)

; Special filters |oui and |non
((filter
  name: (filter_name) @function.builtin)
  (#match? @function.builtin "^(oui|non)$"))

(filter_params) @string

; ── Multilingual ─────────────────────────────────────────────
(multi_block) @string.special.symbol
(lang_code) @constant
(lang_code_brace) @constant
(multi_text) @string

(translation) @string.special.symbol

; ── Conditional brackets ─────────────────────────────────────
(conditional_open) @punctuation.bracket
(conditional_close) @punctuation.bracket

; ── Delimiters ───────────────────────────────────────────────
"[(#REM)" @comment
"<BOUCLE_" @keyword
"</BOUCLE_" @keyword
"<B_" @keyword
"</B_" @keyword
"<//B_" @keyword
"<INCLURE" @keyword.import
"(#" @punctuation.special
"#" @punctuation.special
")" @punctuation.special
"|" @punctuation.delimiter
"{" @punctuation.bracket
"}" @punctuation.bracket
"<multi>" @keyword
"</multi>" @keyword
"<:" @keyword
":>" @keyword
