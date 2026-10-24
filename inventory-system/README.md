# Product Inventory System (x86 NASM Assembly)

A console-based product inventory manager written in 32-bit x86 assembly (NASM syntax). It uses the C standard library (`printf`, `scanf`, `getchar`) for input and output, and implements everything else by hand, including string copy and compare, a bubble sort, and array shifting.

## Features

- **Add product**: name, quantity, and price, with duplicate-name checking
- **Delete product**
  - Delete by name
  - Delete all zero-stock products in one pass
- **Search product**
  - Search by name
  - List low-stock items (quantity below 5)
- **Display products**
  - Unsorted, in the order they were added
  - Sorted by quantity, ascending (bubble sort)
- **Edit product**: update the name, quantity, and price of an existing item
- **Table output** with per-item totals (quantity x price) and an overall inventory value
- **Input validation** for non-numeric input and out-of-range values

## Limits and Rules

| Item | Rule |
|---|---|
| Maximum products | 20 |
| Product name | Up to 20 characters, a single word with no spaces |
| Quantity | Integer from 0 to 99 |
| Price | Non-negative integer |

## Requirements

- [NASM](https://www.nasm.us/) assembler
- A 32-bit GCC toolchain, such as [MinGW](https://www.mingw-w64.org/) with 32-bit support, to link against the C runtime
- Windows (the code uses underscore-prefixed symbols such as `_main` and `_printf`, which is the 32-bit Windows convention)

## Build and Run

```
nasm -f win32 inventory.asm -o inventory.obj
gcc -m32 inventory.obj -o inventory.exe
inventory.exe
```

## Usage

When the program starts, it shows the main menu:

```
--- MAIN MENU ---
[1] Add Product
[2] Delete Product
[3] Search Product
[4] Display Products
[5] Edit Product
[6] Exit
```

Type the number of an option and press Enter. Options 2, 3, and 4 open a submenu. Choose `[3] Back to Main Menu` in any submenu to return.

### Example session

```
Enter choice: 1
Enter product name (max 20 chars): Laptop
Enter quantity (0-99): 10
Enter price (integer): 45000

Product added successfully!
```

Displaying the list then looks like this:

```
=============================================================
Product             |  Quantity  |   Price    |   Total
=============================================================
Laptop              | 10         | 45000      | 450000
=============================================================
OVERALL TOTAL: 450000
=============================================================
```

## How It Works

- **Parallel arrays**: assembly has no structs, so product data is stored in three arrays that share an index: `product_names`, `quantities`, and `prices`. Index `i` in each array describes the same product.
- **Buffer flushing**: after reading a number, the Enter keypress stays in the input buffer. The `flush_buffer` routine clears it so that the next string read doesn't get skipped.
- **Deleting**: removing an item shifts every later item one position left, then decrements `product_count`.
- **Sorting**: a bubble sort on quantity that swaps the quantity, the price, and the name string together so the rows stay matched.

## Known Limitations

- Product names can't contain spaces, because input is read with `scanf("%s")`.
- Names longer than 20 characters aren't truncated and can overflow the name buffer.
- Editing a product doesn't check whether the new name duplicates another product.
- The data isn't saved. Everything is lost when the program exits.

## Project Structure

```
.
├── inventory.asm   # Source code
├── README.md
└── .gitignore
```