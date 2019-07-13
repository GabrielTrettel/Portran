module Lexer

export parsecode

include("Token.jl")
using .TokenDefinition

const RESERVEDWORDS  = Set(["programa", "declare", "escreva", "leia", "fimprog"])
const LETTERS        = Set('a':'z')
const BLANKS         = Set([' ', '\n', '\t', '\r'])
const OPERATORS      = Set(["+", "-", "*", "/", "^"])
const DIGITS         = Set('0':'9')
const SEPARATORS     = Set(['(', ')', '{', '}', '.', ',', ':'])
const SEP_STRING     = Set(["(", ")", "{", "}", ".", ",", ":"])

isblank(c::Char)          = c in BLANKS
isseparator(c::Char)      = c in SEPARATORS
isseparator(s::String)    = s in SEP_STRING
isoperator(s::String)     = s in OPERATORS
isreservedword(s::String) = s in RESERVEDWORDS

const IDENTIFIER_REGEX   = r"[A-Za-z_-]+[0-9]*"
const FLOAT_NUMBER_REGEX = r"[0-9]+\.[0-9]+"
const INT_NUMBER_REGEX   = r"[0-9]+"

function parsecode(code::String)::Array{Token}
    # Split all whitespaces
    sub_strs = split(code)

    if isempty(sub_strs)
        return []
    end

    tokens = []
    vec_str   = []

    for sub_str in sub_strs
        chars = collect(sub_str)

        vec_chars::Array{Char} = []
        len_chars = length(chars)
        for (index, char) in enumerate(chars)
            if isseparator(char) || isblank(char)
                # Check fisrt if we can check by index chars[index+1]
                # if we can and it's a digit, that means that it's a
                # float number literal, so we just push the char
                if index < len_chars
                    if isdigit(chars[index+1])
                        push!(vec_chars, char)
                    end
                else # It is a separator otherwise
                    push!(vec_str, String(vec_chars))
                    push!(vec_str, string(char))
                end
            else
                push!(vec_chars, char)
            end

            # If got to the end, push the rest
            if index == len_chars
                push!(vec_str, String(vec_chars))
            end
        end
    end

    for str in vec_str
        # At this point `str` is small enought to have one and only one match
        # in match expression
        if isreservedword(str)
            push!(tokens, Token(RESERVED_WORD, str))
        elseif isseparator(str)
            push!(tokens, Token(PUNCTUATION, str))
        elseif isoperator(str)
            push!(tokens, Token(OPERATOR, str))
        elseif occursin(IDENTIFIER_REGEX, str)
            m = match(IDENTIFIER_REGEX, str)
            push!(tokens, Token(IDENTIFIER, m.match))
        elseif occursin(FLOAT_NUMBER_REGEX, str)
            m = match(FLOAT_NUMBER_REGEX, str)
            push!(tokens, Token(FLOAT_NUMBER, m.match))
        elseif occursin(INT_NUMBER_REGEX, str)
            m = match(INT_NUMBER_REGEX, str)
            push!(tokens, Token(INT_NUMBER, m.match))
        else # If there is no match, defaults do INVALID Token
            push!(tokens, Token(INVALID, str))
        end
    end

    return tokens
end # function

# parsecode("leia 10 1.0\n ola_0123. i234.")

end # module
