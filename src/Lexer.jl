module Lexer

export tokenise

include("Token.jl")
using .TokenDefinition

const RESERVEDWORDS  = Set(["programa", "declare", "escreva", "leia", "fimprog", "inicio", "fim", "se", "entao", "senao", "fimse"])
const TYPE_NAMES    = Set(["int", "real", "char", "texto", "boleano"])
const LETTERS        = Set('a':'z')
const BLANKS         = Set([' ', '\n', '\t', '\r'])
const OPERATORS      = Set(["+", "-", "*", "/", "^", "==", "!=", "<", ">", "<=", ">="])
const DIGITS         = Set('0':'9')
const SEPARATORS     = Set(['(', ')', '{', '}', '.', ','])
const SEP_STRING     = Set(["(", ")", "{", "}", ".", ","])

isassing(s::String)       = s == ":="
isblank(c::Char)          = c in BLANKS
isseparator(c::Char)      = c in SEPARATORS
isseparator(s::String)    = s in SEP_STRING
isoperator(s::String)     = s in OPERATORS
isreservedword(s::String) = s in RESERVEDWORDS
istype(s::String)         = s in TYPE_NAMES

const IDENTIFIER_REGEX   = r"[A-Za-z_-]+[0-9]*"
const CHAR_REGEX         = r"\'[A-Za-z0-9]\'"
const STRING_REGEX       = r"\".*\""
const FLOAT_NUMBER_REGEX = r"[0-9]+\.[0-9]+"
const INT_NUMBER_REGEX   = r"[0-9]+"

mutable struct Source
    orig::String
    src::String
    curr_pos::Integer

    function Source(src)
        new(src, src, 1)
    end # function
end # struct

function next_token(s::Source) :: Token
    chars = collect(s.src)

    for (i, char) in enumerate(chars)
        if s.curr_pos > length(s.orig) break end # if

        pos = s.curr_pos

        res = if isblank(char)
            # s.curr_pos += length(char)
            # s.src = s.orig[s.curr_pos:end]
            # continue
            Token(WHITESPACE, string(char), (pos, pos))
        elseif char == '-' || isdigit(char)
            parse_number(s.src[i:end], pos)
        elseif char == '\''
            parse_char(s.src[i:end], pos)
        elseif char == '\"'
            parse_str(s.src[i:end], pos)
        elseif char == '#'
            parse_comment(s.src[i:end], pos)
        elseif isseparator(char)
            Token(PUNCTUATION, string(char), (pos, pos))
        elseif char == ':'
            if i < length(chars)
                if chars[i+1] == '='
                    Token(ASSIGN, ":=", (pos,pos+1))
                elseif isblank(chars[i+1])
                    Token(PUNCTUATION, string(char), (pos, pos))
                else
                    Token(INVALID, char*chars[i+1], (pos, pos+1))
                end # if
            end # if
        else
            parse_rest(s.src[i:end], pos)
        end # if

        final = res.span[2]

        s.curr_pos = final + 1
        s.src = s.orig[s.curr_pos-1:end]

        return res
    end # for
    Token(EOF, "", (s.curr_pos, s.curr_pos))
end # function

function parse_number(src, pos)::Token
    chars = collect(src)
    vec_chars::Array{Char} = []

    has_dot = false

    for (i, char) in enumerate(chars)
        if isdigit(char)
            push!(vec_chars, char)
        elseif char == '-' && i == 1
            if i < length(chars)
                if isdigit(chars[i+1])
                    push!(vec_chars, char)
                else
                    return parse_rest(src, pos)
                end # if
            else
                return parse_rest(src, pos)
            end # if
        elseif char == '.'
            has_dot = true
            if i < length(chars)
                if isdigit(chars[i+1])
                    push!(vec_chars, char)
                end # if
            end # if
        else
            break
        end # if
    end # for

    len = length(vec_chars) - 1

    if has_dot
        return Token(FLOAT_NUMBER, String(vec_chars), (pos, pos+len))
    else
        return Token(INT_NUMBER, String(vec_chars), (pos, pos+len))
    end # if
end # function

function parse_char(src, pos)::Token
    chars = collect(src)

    if chars[3] != '\''
        return Token(INVALID, src[1:3], (pos, pos+2))
    end # if

    return Token(CHAR, src[1:3], (pos, pos+2))
end # function

function parse_str(src, pos)::Token
    chars = collect(src)
    vec_chars :: Array{Char} = []
    for (index, char) in enumerate(chars)
        if char == '\"' && index != 1
            push!(vec_chars, char)
            break
        end # if

        push!(vec_chars, char)
    end # for


    len = length(vec_chars) - 1

    if last(vec_chars) != '\"'
        return Token(INVALID, String(vec_chars), (pos, pos+len))
    end # if

    return Token(STRING, String(vec_chars), (pos, pos+len))
end # function

function parse_rest(src, pos)::Token
    chars = collect(src)
    vec_chars :: Array{Char} = []

    for char in chars
        if isblank(char) || isseparator(char)
            break
        end # if
        push!(vec_chars, char)
    end # for

    str = String(vec_chars)
    len = length(str) -1

    if isreservedword(str)
        return Token(RESERVED_WORD, str, (pos, pos+len))
    elseif istype(str)
        return Token(TYPE, str, (pos, pos+len))
    elseif isoperator(str)
        return Token(OPERATOR, str, (pos, pos+len))
    elseif occursin(IDENTIFIER_REGEX, str)
        m = match(IDENTIFIER_REGEX, str)
        if len+1 == length(m.match)
            return Token(IDENTIFIER, m.match, (pos, pos+len))
        else
            return Token(INVALID, m.match, (pos, pos+length(m.match)))
        end # if
    else
        return Token(INVALID, str, (pos, pos+len))
    end # if
end # function

function tokenise(src::String)::Tokens
    i = 0
    source = Source(src)
    vec_tokens :: Array{Token} = []

    while true
        token = next_token(source)
        if token.id == EOF || i > 100
            push!(vec_tokens, token)
            break
        end # if
        push!(vec_tokens, token)
        i += 1
    end # while

    filter!(x -> x.id != WHITESPACE, vec_tokens)

    Tokens(vec_tokens)
end # function

end # module
