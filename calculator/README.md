# Simple Calculator (x86 Assembly)

A menu-driven calculator written in 32-bit x86 assembly (NASM syntax). It performs addition, subtraction, multiplication, and division on **three signed two-digit numbers** (-99 to 99).

## Features

- Menu-driven interface that keeps running until you choose Exit
- Works with **three** numbers per operation
- Supports negative numbers
- Input validation: rejects numbers outside -99 to 99 and asks again
- Division by zero protection: asks for a new divisor instead of crashing
- Division shows both the **quotient** and the **remainder**

## Menu Options

| Choice | Operation | How it works |
|--------|-----------|--------------|
| `0` | Exit | Prints a thank-you message and ends the program |
| `1` | Add | `num1 + num2 + num3` |
| `2` | Subtract | `num1 - num2 - num3` |
| `3` | Multiply | `num1 * num2 * num3` |
| `4` | Divide | `(num1 / num2) / num3`, with quotient and remainder shown after each step |

Any other menu choice simply shows the menu again.

## Sample Run

```
==== SIMPLE CALCULATOR by Michelle Tercero ====
[0] Exit
[1] Add
[2] Subtract
[3] Multiply
[4] Divide
Enter choice: 1
==== ADDITION ====
Enter the first number (-99 to 99): 33
Enter the second number (-99 to 99): 2
Enter the third number (-99 to 99): 3
Sum: 38
```

## Requirements

- [NASM](https://www.nasm.us/) assembler
- A 32-bit C toolchain such as MinGW-w64 (`gcc`), used to link against `printf` and `scanf`
- Windows (the code uses the `_printf` / `_scanf` symbol names)

## How to Build and Run

Open a terminal in the project folder and run:

```bash
nasm -f win32 calculator.asm -o calculator.obj
gcc -m32 calculator.obj -o calculator.exe
./calculator.exe
```

In PowerShell, use `.\calculator.exe` to run it.

## Project Structure

```
calculator/
├── calculator.asm   # Source code
└── README.md        # Project documentation
```

## How the Code Is Organized

- **`.data` section:** all text messages, prompts, and the `%d` format string
- **`.bss` section:** reserved memory for the three inputs, the menu choice, and the results
- **`_main`:** prints the welcome message and runs the menu loop
- **`.add`, `.subtract`, `.multiply`:** each one reads three numbers, calculates, and prints the result
- **`.divide`:** reads the numbers one at a time, rejects a divisor of 0, and divides in two steps using `cdq` and `idiv` (signed division)
- **`get_three_numbers`:** a helper routine that reads and validates three inputs for add, subtract, and multiply

## Concepts Practiced

- Calling C library functions (`printf`, `scanf`) from assembly
- Conditional jumps and loops for menus and input validation
- Signed arithmetic with `add`, `sub`, `imul`, `cdq`, and `idiv`
- Reusing code with a helper subroutine

## Known Limitations

- Division uses whole numbers only, so results are truncated toward zero (for example, `7 / 2` gives quotient `3`, remainder `1`)
- Entering letters or symbols instead of numbers is not handled
- Results of multiplication can go beyond two digits, for example `99 * 99 * 99 = 970299`

## Author

Michelle Tercero