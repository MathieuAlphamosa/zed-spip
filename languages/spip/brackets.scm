; Bracket pairs for SPIP constructs

; Loop pairs
(loop_open) @open
(loop_close) @close

; Loop conditional pairs
(loop_conditional_open) @open
(loop_conditional_close) @close

; Conditional brackets
(conditional_open) @open
(conditional_close) @close

; Curly braces (criteria, params, filters)
("{" @open
 "}" @close)

; Balise parentheses
("(#" @open
 ")" @close)
