include("Token.jl")

const RESERVEDWORDS  = Set(["programa", "declare", "escreva", "leia", "fimprog"])
const CONTROL_FLUX   = Set(["se", "entao", "senao", "fimse", "enquanto", "faca", "fimenq", "durante"])
const BOOL_VALUE     = Set(["Verdadeiro", "Falso", "V", "F"])
const TYPE_NAMES     = Set(["int", "real", "char", "texto", "boleano"])
const BLANKS         = Set([' ', '\n', '\t', '\r'])
const OPERATORS      = Set(["+", "-", "*", "/", "^", "==", "!=", "<", ">", "<=", ">=", "||", "!", "&&"])
const SEPARATORS     = Set(['(', ')', ';', ',', ':'])

isboolliteral(s::String)  = s in BOOL_VALUE
isblank(c::Char)          = c in BLANKS
isseparator(c::Char)      = c in SEPARATORS
isoperator(s::String)     = s in OPERATORS
isreservedword(s::String) = s in RESERVEDWORDS
iscontrolflux(s::String)  = s in CONTROL_FLUX
istype(s::String)         = s in TYPE_NAMES

const IDENTIFIER_REGEX   = r"[A-Za-z_]+[A-Za-z-]*[0-9]*"

mutable struct Source
    orig::String
    src::String
    curr_pos::Integer

    function Source(src)
        new(src, src, 1)
    end # function
end # struct

function next_token(s::Source, line::Integer) :: Token
    chars = collect(s.src)

    for (i, char) in enumerate(chars)
        if s.curr_pos > length(s.orig) break end # if

        pos = s.curr_pos

        res = if isblank(char)
            Token(WHITESPACE, string(char), (pos, pos), line)
        elseif char == '-' || isdigit(char)
            parse_number(s.src[i:end], pos, line)
        elseif char == '\''
            parse_char(s.src[i:end], pos, line)
        elseif char == '\"'
            parse_str(s.src[i:end], pos, line)
        elseif char == '#'
            parse_comment(s.src[i:end], pos, line)
        elseif char == ':'
            if i < length(chars)
                if chars[i+1] == '='
                    Token(ASSIGN, ":=", (pos,pos+1), line)
                else
                    Token(PUNCTUATION, string(char), (pos, pos), line)
                end # if
            end # if
        elseif isseparator(char)
            Token(PUNCTUATION, string(char), (pos, pos), line)
        else
            parse_rest(s.src[i:end], pos, line)
        end # if

        final = res.span[2]

        s.curr_pos = final + 1
        s.src = s.orig[s.curr_pos:end]

        return res
    end # for
    Token(EOF, "", (s.curr_pos, s.curr_pos), line)
end # function

function parse_number(src::String, pos::Integer, line::Integer)::Token
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
                    return parse_rest(src, pos, line)
                end # if
            else
                return parse_rest(src, pos, line)
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
        return Token(FLOAT_NUMBER, String(vec_chars), (pos, pos+len), line)
    else
        return Token(INT_NUMBER, String(vec_chars), (pos, pos+len), line)
    end # if
end # function

function parse_char(src::String, pos::Integer, line::Integer)::Token
    chars = collect(src)

    if chars[3] != '\''
        return Token(INVALID, src[1:3], (pos, pos+2), line)
    end # if

    return Token(CHAR, src[1:3], (pos, pos+2), line)
end # function

function parse_str(src, pos, line)::Token
    chars = collect(src)
    finish = 0
    for (index, char) in enumerate(chars)
        if char == '\"' && index != 1
            finish = index
            break
        end # if
    end # for

    if last(src[1:finish]) != '\"'
        return Token(INVALID, src[1:finish], (pos, pos+finish), line)
    end # if

    # return Token(STRING, String(vec_chars), (pos, pos+len))
    return Token(STRING, src[1:finish], (pos, pos+finish), line)
end # function

function parse_rest(src, pos, line)::Token
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
        return Token(RESERVED_WORD, str, (pos, pos+len), line)
    elseif iscontrolflux(str)
        return Token(CFLUX, str, (pos, pos+len), line)
    elseif isboolliteral(str)
        return Token(BOOL, str, (pos, pos+len), line)
    elseif istype(str)
        return Token(TYPE, str, (pos, pos+len), line)
    elseif isoperator(str)
        return Token(OPERATOR, str, (pos, pos+len), line)
    elseif occursin(IDENTIFIER_REGEX, str)
        m = match(IDENTIFIER_REGEX, str)
        if len+1 == length(m.match)
            return Token(IDENTIFIER, m.match, (pos, pos+len), line)
        else
            return Token(INVALID, m.match, (pos, pos+length(m.match)-1), line)
        end # if
    else
        return Token(INVALID, str, (pos, pos+len), line)
    end # if
end # function

function tokenise(src::String)::Tokens
    i = 0
    source = Source(src)
    vec_tokens :: Array{Token} = []
    line = 1
    coll = 1
    while true
        token = next_token(source, line)
        token.col = coll

        coll += length(token.text)

        if token.id == WHITESPACE && token.text == "\n"
            line += 1
            coll = 1
        end # if
        if token.id == EOF
            push!(vec_tokens, token)
            break
        end # if
        push!(vec_tokens, token)
        i += 1
    end # while

    filter!(x -> x.id != WHITESPACE, vec_tokens)

    Tokens(vec_tokens)
end # function
