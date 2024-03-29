include("Token.jl")

istype(tk::Token)      = tk.id == TYPE
isident(tk::Token)     = tk.id == IDENTIFIER
issemicolon(tk::Token) = tk.id == PUNCTUATION && tk.text == ";"
isio(tk::Token)        = tk.id == RESERVED_WORD && (tk.text == "escreva" || tk.text == "leia")

global const T = "    "

function type_p2c(typestr::AbstractString)::String
    if typestr == "int" || typestr == "char"
        return typestr
    elseif typestr == "real"
        return "double"
    elseif typestr == "boleano"
        return "bool"
    elseif typestr == "texto"
        return "char*"
    end # if
end # type_p2c

function type2fmt(typestr)::String
    if typestr == "int"
        return "%d"
    elseif typestr == "real"
        return "%lf"
    elseif typestr == "boleano"
        return "%d"
    elseif typestr == "char"
        return "%c"
    elseif typestr == "texto"
        return "%s"
    else
        return "%p"
    end # if
end # type2fmt

function hasio(tks::Tokens)::Bool
    for tk in tks.tokens
        if isio(tk)
            return true
        end # if
    end # for
    false
end # hasio


function transpile(tks::Tokens, env::Dict, fname)
    txt = headers(tks)
    next!(tks)
    programm_name = next!(tks).text
    txt *= bloco2str!(tks, env, ["fimprog"], T)

    txt *= "\n}\n"
    write(fname, txt)
end # transpile


function bloco2str!(tokens::Tokens, env, expected_end, initial_char="")
    t = next!(tokens)
    text = ""
    if t.id==RESERVED_WORD && t.text=="declare"
        text = declare2str!(tokens, env, initial_char)

    elseif t.id==RESERVED_WORD && (t.text=="leia" || t.text=="escreva")
        text = cmd_io2str!(tokens, env, t.text, initial_char)

    elseif t.id==IDENTIFIER
        text = cmd_attr2atr!(tokens, env, initial_char)

    elseif t.id==CFLUX
        text = control_flux_parser2str!(tokens, env, initial_char)
    end

    if !any(x->x==t.text, expected_end)
        return text * bloco2str!(tokens, env, expected_end, initial_char)
    else
        return text
    end

end


function declare2str!(tks::Tokens, env, init_char)
    arr_ident = []
    type = ""
    txt = ""

    t = next!(tks)
    while !issemicolon(t)
        if isident(t)
            push!(arr_ident, t.text)
        end # if
        if istype(t)
            type = t.text
        end # if
        t = next!(tks)
    end # while

    txt *= init_char * type_p2c(type)*" "
    txt *= join(arr_ident, ", ") * ";\n"
    return txt
end


function headers(tks::Tokens)
    text = "#include <stdbool.h>\n"
    if hasio(tks)
        text *= "#include <stdio.h>\n\n"
    end # if
    text *= "int main(void) {\n"
    return text
end


function cmd_io2str!(tokens::Tokens, env, io, initial_char)
    text = ""
    next!(tokens) #(
    var = next!(tokens);
    if io == "leia"
        text *= initial_char*"scanf(\"$(type2fmt(type(env, var)))\", &$(var.text));\n"
    else # escreva
        if var.id==STRING
            text *= initial_char*"printf($(var.text));\n"
        else
            text *= initial_char*"printf(\"$(type2fmt(type(env, var)))\", $(var.text));\n"
        end
    end
    next!(tokens); next!(tokens); # );
    return text
end

function cmd_attr2atr!(tokens::Tokens, env, initial_char)
    var =  current(tokens);
    next!(tokens) #:=
    expr = expr2str!(tokens, env)

    text = initial_char*"$(var.text) = $expr;\n"
    return text
end

function expr2str!(tokens, env)
    expr = ""
    t = next!(tokens)

    if t.text==";"
        return expr
    elseif t.line!=previous(tokens).line
        roll_back(tokens)
        return expr
    end

    w = next(tokens).text==";" || t.line != next(tokens).line ? "" : " "

    text = t.text
    if t.id==BOOL
        text = text=="V" ? "true" : "false"
    end
    return expr * text * w * expr2str!(tokens, env)
end


function control_flux_parser2str!(tokens::Tokens, env, initial_char)
    text = ""
    t = current(tokens)
    if t.text == "se"
        text *= se2txt!(tokens, env, initial_char)
    elseif t.text == "enquanto"
        text *= enquanto2str!(tokens, env, initial_char)
    elseif t.text == "faca"
        text *= parse_faca!(tokens, env, initial_char)
    end
    return text
end

function se2txt!(tokens, env, initial_char)
    expr = expr2str!(tokens, env)

    text = initial_char*"if ($expr) {\n"

    text *= bloco2str!(tokens, env, ["fimse", "senao"], initial_char*T)

    if current(tokens).text == "senao"
        text *= initial_char*"} else {\n"
        text *= bloco2str!(tokens, env, ["fimse"], initial_char*T)
    end
    return text * initial_char*"}\n"
end

function enquanto2str!(tokens::Tokens, env, initial_char)
    expr = expr2str!(tokens, env)
    blk = bloco2str!(tokens, env, ["fimenq"], initial_char*T)
    text = initial_char*"while ($expr) {\n$blk"
    return text * initial_char*"}\n"
end


function parse_faca!(tokens, env, initial_char)
    blk = bloco2str!(tokens, env, ["durante"], initial_char*T)
    expr = expr2str!(tokens, env)
    return initial_char*"do {\n $blk$initial_char} while ($expr);\n"
end
