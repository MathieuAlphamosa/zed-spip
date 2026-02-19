; Auto-indentation rules for SPIP templates

; Indent after opening a loop
(loop_open) @indent

; Dedent at loop close
(loop_close) @dedent

; Indent after loop conditional open
(loop_conditional_open) @indent

; Dedent at loop conditional close
(loop_conditional_close) @dedent

; Loop alternative: dedent from "if" block, then indent for "else" block
(loop_alternative) @dedent
(loop_alternative) @indent
