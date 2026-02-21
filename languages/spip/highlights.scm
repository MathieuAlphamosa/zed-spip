; SPIP syntax highlighting for Zed
; IMPORTANT: Only use token-level or field-level captures.
; Never capture entire compound nodes like (loop_open) @keyword
; as this causes infinite memory consumption in Zed.

; ── Comments ──
(comment) @comment
"[(#REM)" @comment

; ── Loops (Boucles) ──
; All loop tokens share @keyword color
"<BOUCLE_" @keyword
"</BOUCLE_" @keyword
"<B_" @keyword
"</B_" @keyword
"<//B_" @keyword

(loop_open name: (loop_name) @keyword)
(loop_close name: (loop_name) @keyword)
(loop_conditional_open name: (loop_name) @keyword)
(loop_conditional_close name: (loop_name) @keyword)
(loop_alternative name: (loop_name) @keyword)

; Loop closing tokens
(loop_open ">" @keyword)
(loop_close ">" @keyword)
(loop_conditional_open ">" @keyword)
(loop_conditional_close ">" @keyword)
(loop_alternative ">" @keyword)

; Loop type stays distinct
(loop_open type: (loop_type) @type)
(loop_open "(" @keyword)
(loop_open ")" @keyword)

; ── Criteria ──
(criteria "{" @keyword)
(criteria "}" @keyword)
(criteria value: (criteria_value) @attribute)

; ── Include ──
"<INCLURE" @keyword.import
"/>" @keyword.import
(include_tag ">" @keyword.import)
(include_param_block "{" @keyword.import)
(include_param_block "}" @keyword.import)
(include_param_block params: (include_params) @string.special)

; ── Multilingual ──
"<multi>" @keyword
"</multi>" @keyword
(lang_code) @constant
(lang_code_brace) @constant
(multi_text) @string

; ── Translations ──
"<:" @keyword
":>" @keyword
(translation) @string.special.symbol

; ── Balises (Tags) ──
; #, (#, balise_name, namespace, ), [, ] all share @variable color
"(#" @variable
"#" @variable
(balise name: (balise_name) @variable)
(balise_shorthand name: (balise_name) @variable)
(balise namespace: (balise_namespace) @variable)
(balise_shorthand namespace: (balise_namespace) @variable)
(balise ")" @variable)

; ── Balise parameters ──
; {, } are @variable (part of the balise), content is @attribute
(balise_params "{" @variable)
(balise_params "}" @variable)
(balise_params value: (param_content) @attribute)

; ── Shorthand balise parameters ──
; {, } are @variable (part of the balise), content is @attribute
(shorthand_lbrace) @variable
(shorthand_params "}" @variable)
(shorthand_params value: (param_content) @attribute)

; ── Filters ──
"|" @punctuation.delimiter
(filter name: (filter_name) @function.method)

; Special filters |oui and |non
((filter name: (filter_name) @function.builtin)
  (#match? @function.builtin "^(oui|non)$"))

; Filter params: {, } use filter color, content uses @attribute
(filter_params "{" @function.method)
(filter_params "}" @function.method)
(filter_params value: (param_content) @attribute)

; ── Conditional brackets ──
; [ and ] around balises share the variable color
(conditional_open) @variable
(conditional_close) @variable
