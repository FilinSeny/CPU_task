addi r1, r0, 10
addi r2, r0, 3

add  r3, r1, r2
sw   r3, 0(r0)
lw   r3, 0(r0)

sub  r3, r1, r2
sw   r3, 4(r0)
lw   r3, 4(r0)

and  r3, r1, r2
sw   r3, 8(r0)
lw   r3, 8(r0)

or   r3, r1, r2
sw   r3, 12(r0)
lw   r3, 12(r0)

slt  r3, r2, r1
sw   r3, 16(r0)
lw   r3, 16(r0)

beq  r3, r0, fail1
addi r1, r1, 1

beq  r1, r2, fail2
addi r2, r2, 2

j done

fail1:
addi r1, r0, 0

fail2:
addi r2, r0, 0

done:
j done