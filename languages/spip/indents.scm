; Auto-indentation rules for SPIP templates

; Indent after opening a loop
(loop_open) @indent

; Outdent at loop close
(loop_close) @outdent

; Indent after loop conditional open
(loop_conditional_open) @indent

; Outdent at loop conditional close
(loop_conditional_close) @outdent

; Loop alternative: outdent from "if" block, then indent for "else" block
(loop_alternative) @outdent
(loop_alternative) @indent
