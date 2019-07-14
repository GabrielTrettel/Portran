module Lexer

export parsecode

include("Token.jl")
using .TokenDefinition

const RESERVEDWORDS  = Set(["programa", "declare", "escreva", "leia", "fimprog", "inicio", "fim"])
const LETTERS        = Set('a':'z')
const BLANKS         = Set([' ', '\n', '\t', '\r'])
const OPERATORS      = Set(["+", "-", "*", "/", "^"])
const DIGITS         = Set('0':'9')
const SEPARATORS     = Set(['(', ')', '{', '}', '.', ',', ':'])
const SEP_STRING     = Set(["(", ")", "{", "}", ".", ",", ":"])

isassing(s::String)       = s == ":="
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
    end # if

    tokens = []
    vec_str::Array{String} = []

    # for sub_str in sub_strs
    chars = collect(code)
    vec_chars::Array{Char} = []
    len_chars = length(chars)

    for (index, char) in enumerate(chars)
        if isblank(char) || isspace(char)
            if isempty(vec_chars)
                continue
            else
                push!(vec_str, String(vec_chars))
                vec_chars = []
                continue
            end # if
        end # if

        if isseparator(char)
            # If we get to a separator, first we push to `vec_str` what we have
            # on `vec_chars` and reset `vec_chars`
            push!(vec_str, String(vec_chars))
            vec_chars = []


            if char == ':'
                # Check fisrt if we can check by index chars[index+1]
                if index < len_chars
                    if chars[index+1] == '='
                        push!(vec_chars, char)
                    else
                        push!(vec_str, string(char))
                    end # if
                else # otherwise it's a normal separator
                    push!(vec_str, string(char))
                end # if
            elseif char == '.'
                # Check fisrt if we can check by index chars[index+1]
                # if we can and it's a digit, that means that it's a
                # float number literal
                if index < len_chars
                    if isdigit(chars[index+1])
                        push!(vec_chars, char)
                    else
                        push!(vec_str, string(char))
                    end # if
                else
                    push!(vec_str, string(char))
                end # if
            else
                push!(vec_str, string(char))
            end # if
        else
            push!(vec_chars, char)
        end # if
    end # for
    # end # for

    for str in vec_str
        # At this point `str` is small enought to have one and only one match
        # in match expression
        if isreservedword(str)
            push!(tokens, Token(RESERVED_WORD, str))
        elseif isassing(str)
            push!(tokens, Token(ASSIGN, str))
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
        end # if
    end # for

    return tokens
end # function
end # module
