# Portran

A little compiler project made to a four months Compilers class at Federal University of ABC

The name comes as a junction of the words `Portuguese` and `Fortran`, since the syntax was somewhat based of fortran syntax, but with Portuguese keywords

It compiles a simple programming language specification given to us to C-lang.

## Language Features
### Comments
Comments starts with `#`, there is only line comments

### Keywords
 * programa: Mark the start of a program
 * fimprog: Mark the end of the program
 * declare: Declare a variable
 * leia: Special function-like keyword to read user input
 * escreva: Special function-like keyword to write to stdout
 * se: Equivalent of a `if`
 * então: Equivalent of a `else`
 * fimse: Mark the end of a if-else-block
 * enquanto: Equivalent of `while`
 * fimenq: Mark the end of a while block
 * faca: (Faça) Mark the start of a do-while block
 * durante: The `while` part of the do-while block

### Primitive Types
 * int: Integer numbers, like `10`, `-3`, etc
 * real: Float numbers, like `1.0`, `3.4`, etc
 * char: Character, With single quote marks, like `'k'`
 * text: String, with double quote marks, like "Hello"
 * booleano: Bool type, With values equal to V, F, Verdaderio ou Falso

 All primitives have a literals

### Basic type inference on literals


## Authors
 * [Bruno Aristimunha](https://github.com/bruAristimunha)
 * [Eric Shimizu Karbstein](https://github.com/GrayJack)
 * [Gabriel Trettel](https://github.com/GabrielTrettel)

## Requirements
 * Julia >= 1.0.0

## Licensing
This software is licensed under the [MIT](./LICENSE) license.
