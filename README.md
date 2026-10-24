# Assembly Projects

A collection of assembly language projects and laboratory exercises, with documentation on how each program works.

## Overview

This repository documents my work in assembly language for my computer architecture coursework. Each project sits in its own folder with the source code and a README that explains what the program does and how to run it. The goal is to show how high-level ideas such as menus, input validation, sorting, and arithmetic are built from low-level instructions.

## Projects

| Project | Description | Key Concepts |
|---------|-------------|--------------|
| [calculator](./calculator) | Menu-driven calculator that adds, subtracts, multiplies, and divides three signed two-digit numbers (-99 to 99) | Conditional jumps, input validation, signed arithmetic, calling C functions |
| [inventory-system](./inventory-system) | Console product inventory manager with add, delete, search, display, and edit functions (up to 20 products) | Parallel arrays, string copy and compare, bubble sort, array shifting, input buffer handling |

## Methodology

I followed the same process for each project:

1. **Define the problem.** Decide what the program must do, what inputs it accepts, and what output it should give.
2. **Plan the flow.** Sketch the menu and the order of steps before writing code, including what happens on invalid input.
3. **Choose the data layout.** Assembly has no structs or built-in data types, so I decided how to store the data in memory first. For example, the inventory system keeps product data in three arrays that share the same index.
4. **Write the code in NASM.** Organize the program into sections: `.data` for messages and prompts, `.bss` for variables, and `.text` for the instructions. Repeated logic is placed in helper routines.
5. **Assemble and link.** Build the source into an executable using NASM and a 32-bit C toolchain.
6. **Test with sample inputs.** Run the program, compare the output against hand-computed answers, and fix any mistakes.
7. **Document.** Write a README for each project with its features, build steps, and limitations.

### Tools Used

- **Assembler:** NASM (32-bit, `win32` format)
- **Linker:** GCC (MinGW) with `-m32`
- **Editor:** VS Code
- **Platform:** Windows, run from PowerShell

### Build and Run (general steps)

```bash
nasm -f win32 program.asm -o program.obj
gcc -m32 program.obj -o program.exe
./program.exe
```

Replace `program` with the file name of the project. Each project's README has its own exact steps.

## Results

### Calculator

The program runs as designed. It loops back to the menu after each operation and exits when `0` is chosen. Sample runs I checked by hand:

| Operation | Inputs | Program Output | Expected | Result |
|-----------|--------|----------------|----------|--------|
| Add | 33, 2, 3 | 38 | 38 | Pass |
| Subtract | 45, 34, 5 | 6 | 6 | Pass |

Other behavior built into the program:

- Numbers outside -99 to 99 are rejected and the user is asked again
- A divisor of 0 is rejected with an error message instead of crashing
- Division shows both the quotient and the remainder

**Lessons learned:** Working in assembly made it clear how much a high-level language does automatically. Every comparison, jump, and function call has to be written out step by step, and the stack must be cleaned up after each call to `printf` and `scanf`. Signed division also required `cdq` to extend the sign before using `idiv`.

### Inventory System

The program manages up to 20 products, each with a name, quantity (0 to 99), and price. It supports:

- **Add:** with duplicate-name checking
- **Delete:** by name, or all zero-stock items in one pass
- **Search:** by name, or list low-stock items (quantity below 5)
- **Display:** in the order added, or sorted by quantity using a bubble sort
- **Edit:** update the name, quantity, and price of an existing item
- **Validation:** rejects non-numeric input and out-of-range values

Sample output after adding one product (Laptop, quantity 10, price 45000):

```
=============================================================
Product             |  Quantity  |   Price    |   Total
=============================================================
Laptop              | 10         | 45000      | 450000
=============================================================
OVERALL TOTAL: 450000
=============================================================
```

The per-item total (10 x 45000 = 450000) and the overall inventory value are computed correctly.

**Lessons learned:** Without structs, parallel arrays were the way to keep each product's data together, and every operation (sorting, deleting) had to move all three arrays in step. Leftover Enter keypresses in the input buffer caused skipped inputs until I added a routine to flush the buffer. Writing string copy, string compare, and bubble sort by hand showed how much library code normally hides this work.

**Known limitations:** Product names cannot contain spaces, names over 20 characters are not truncated, editing does not check for duplicate names, and data is not saved after the program exits.

## Repository Structure

```
assembly-projects/
├── README.md
├── .gitignore
├── calculator/
│   ├── calculator.asm
│   └── README.md
└── inventory-system/
    ├── inventory.asm
    └── README.md
```

## Notes

- Compiled files (`.obj`, `.exe`, `.lst`, `.map`, `.o`, `.com`) are excluded through `.gitignore`, so only source code is tracked.
- Projects are written for 32-bit Windows using the `_printf` and `_scanf` symbol names.

## Author

Michelle Tercero
