.data
input_str:     .asciz "(()())"

stack:         .space 100          @ Stack space
stack_top:     .word 0             @ Stack top pointer (offset)

.text
.global _start

_start:
    LDR     r0, =input_str         @ r0 = pointer to input string
    LDR     r4, =stack             @ r4 = base of our stack
    MOV     r2, #0                 @ r2 = top of stack (offset)

loop:
    LDRB    r1, [r0], #1           @ Load char into r1, advance r0
    CMP     r1, #0                 @ End of string?
    BEQ     check_stack            @ If null terminator, go check stack

    CMP     r1, #'('
    BEQ     push_stack

    CMP     r1, #')'
    BEQ     pop_stack

    B       loop                   @ Ignore other characters

push_stack:
    STRB    r1, [r4, r2]           @ Store '(' at stack[r2]
    ADD     r2, r2, #1             @ Increment top
    B       loop

pop_stack:
    CMP     r2, #0                 @ Stack empty?
    BEQ     unbalanced             @ Can't pop from empty stack

    SUB     r2, r2, #1             @ Decrement top
    B       loop

check_stack:
    CMP     r2, #0
    BEQ     balanced
    B       unbalanced

balanced:
    MOV     r0, #1                 @ r0 = 1 means balanced
    B       end

unbalanced:
    MOV     r0, #0                 @ r0 = 0 means unbalanced

end:
    B       end                    @ Infinite loop to stop execution
