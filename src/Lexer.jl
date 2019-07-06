module AnalisadorLexico

include("Token.jl")
using .TokenDefinition

const RESERVEDWORDS  = Set(["progra", "declare","escreva","leia", "fimprog"])
const LETTERS        = Set('a':'z')
const BLANKS         = Set([' ', '\n', '\t', '\r'])
const OPERATORS      = Set(['+', '-', '*', '/', '^'])
const DIGITS         = Set('0':'9')

isLetter(c::Char)       = c in LETTERS
isBlank(c::Char)        = c in BLANKS
isOperator(c::Char)     = c in OPERATORS
isDigit(c::Char)        = c in DIGITS
isReservedWord(c::Char) = c in RESERVEDWORDS


end
