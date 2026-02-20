; SPIP syntax highlighting for Zed

; ── Comments ──
(comment) @comment
"[(#REM)" @comment

; ── Loops (Boucles) ──
"<BOUCLE_" @keyword
"</BOUCLE_" @keyword
"<B_" @keyword
"</B_" @keyword
"<//B_" @keyword

(loop_open name: (loop_name) @label)
(loop_close name: (loop_name) @label)
(loop_conditional_open name: (loop_name) @label)
(loop_conditional_close name: (loop_name) @label)
(loop_alternative name: (loop_name) @label)
(loop_open type: (loop_type) @type)

; ── Criteria ──
(criteria value: (criteria_value) @attribute)

; ── Include ──
"<INCLURE" @keyword.import
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
(balise name: (balise_name) @function)
(balise_shorthand name: (balise_name) @function)
(balise namespace: (balise_namespace) @namespace)

; ── Balise parameters ──
(balise_params value: (param_content) @string)

; ── Filters ──
(filter name: (filter_name) @function.method)

; Special filters |oui and |non
((filter name: (filter_name) @function.builtin)
  (#match? @function.builtin "^(oui|non)$"))

(filter_params value: (param_content) @string)

; ── Conditional brackets ──
(conditional_open) @punctuation.bracket
(conditional_close) @punctuation.bracket

; ── Punctuation ──
"(#" @punctuation.special
"#" @punctuation.special
"|" @punctuation.delimiter
"{" @punctuation.bracket
"}" @punctuation.bracket
"/>" @punctuation.special
