#!/usr/bin/env python3

import sys
import re
from pathlib import Path


OPCODES = {
    "r":    0b000000,
    "addi": 0b001000,
    "lw":   0b100011,
    "sw":   0b101011,
    "beq":  0b000100,
    "j":    0b000010,
}


FUNCTS = {
    "add": 0b100000,
    "sub": 0b100010,
    "and": 0b100100,
    "or":  0b100101,
    "slt": 0b101010,
}


def reg_number(reg: str) -> int:
    reg = reg.strip()

    if reg.startswith("$"):
        reg = reg[1:]

    if reg.startswith("r"):
        reg = reg[1:]

    num = int(reg)

    if not 0 <= num <= 31:
        raise ValueError(f"Bad register number: {reg}")

    return num


def parse_imm(value: str) -> int:
    value = value.strip()

    if value.startswith("0x"):
        return int(value, 16)

    if value.startswith("-0x"):
        return -int(value[1:], 16)

    return int(value, 10)


def encode_r_type(name: str, args: list[str]) -> int:
    rd = reg_number(args[0])
    rs = reg_number(args[1])
    rt = reg_number(args[2])

    opcode = OPCODES["r"]
    shamt = 0
    funct = FUNCTS[name]

    return (
        (opcode << 26)
        | (rs << 21)
        | (rt << 16)
        | (rd << 11)
        | (shamt << 6)
        | funct
    )


def encode_i_type(name: str, args: list[str], labels: dict[str, int], pc: int) -> int:
    opcode = OPCODES[name]

    if name == "addi":
        rt = reg_number(args[0])
        rs = reg_number(args[1])
        imm = parse_imm(args[2]) & 0xFFFF

    elif name in ("lw", "sw"):
        rt = reg_number(args[0])

        match = re.fullmatch(
            r"(-?\d+|0x[0-9a-fA-F]+|-0x[0-9a-fA-F]+)\((\$?r?\d+)\)",
            args[1]
        )

        if not match:
            raise ValueError(f"Bad memory operand: {args[1]}")

        imm = parse_imm(match.group(1)) & 0xFFFF
        rs = reg_number(match.group(2))

    elif name == "beq":
        rs = reg_number(args[0])
        rt = reg_number(args[1])

        label = args[2]

        if label not in labels:
            raise ValueError(f"Unknown label: {label}")

        target_pc = labels[label]
        offset = target_pc - (pc + 1)

        imm = offset & 0xFFFF

    else:
        raise ValueError(f"Unsupported instruction: {name}")

    return (
        (opcode << 26)
        | (rs << 21)
        | (rt << 16)
        | imm
    )


def encode_j_type(name: str, args: list[str], labels: dict[str, int]) -> int:
    opcode = OPCODES[name]

    label = args[0]

    if label not in labels:
        raise ValueError(f"Unknown label: {label}")

    addr = labels[label] & 0x03FFFFFF

    return (opcode << 26) | addr


def clean_line(line: str) -> str:
    line = line.split("#")[0]
    line = line.split("//")[0]
    return line.strip()


def split_instruction(line: str):
    line = line.replace(",", " ")
    parts = line.split()

    if not parts:
        return None, []

    return parts[0].lower(), parts[1:]


def read_program(lines: list[str]):
    labels = {}
    instructions = []

    pc = 0

    for line in lines:
        line = clean_line(line)

        if not line:
            continue

        while ":" in line:
            label, rest = line.split(":", 1)

            label = label.strip()

            labels[label] = pc

            line = rest.strip()

            if not line:
                break

        if line:
            instructions.append(line)
            pc += 1

    return labels, instructions


def assemble(lines: list[str]) -> list[int]:
    labels, instructions = read_program(lines)

    machine_code = []

    for pc, line in enumerate(instructions):
        name, args = split_instruction(line)

        if name in FUNCTS:
            code = encode_r_type(name, args)

        elif name in ("addi", "lw", "sw", "beq"):
            code = encode_i_type(name, args, labels, pc)

        elif name == "j":
            code = encode_j_type(name, args, labels)

        else:
            raise ValueError(f"Unknown instruction: {line}")

        machine_code.append(code)

    return machine_code


def main():

    if len(sys.argv) != 2:
        print("Usage:")
        print("  python3 asm_to_mem.py filename")
        sys.exit(1)

    filename = sys.argv[1]

    script_dir = Path(__file__).resolve().parent
    root_dir = script_dir.parent

    data_dir = root_dir / "data"

    asm_path = data_dir / f"{filename}.asm"
    mem_path = data_dir / f"{filename}.mem"

    if not asm_path.exists():
        print(f"ERROR: File not found:")
        print(f"  {asm_path}")
        sys.exit(1)

    with open(asm_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    machine_code = assemble(lines)

    with open(mem_path, "w", encoding="utf-8") as f:
        for code in machine_code:
            f.write(f"{code:08X}\n")

    print(f"ASM: {asm_path}")
    print(f"MEM: {mem_path}")
    print(f"Instructions: {len(machine_code)}")


if __name__ == "__main__":
    main()