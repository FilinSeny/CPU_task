addi r1, r0, 5
addi r2, r0, 10
add  r3, r1, r2
sw   r3, 0(r0)
lw   r1, 0(r0)
beq  r1, r3, skip
addi r1, r0, 0

skip:
j skip