include("Token.jl")

istype(tk::Token)      = tk.id == TYPE
isident(tk::Token)     = tk.id == IDENTIFIER
isdeclare(tk::Token)   = tk.id == RESERVED_WORD && tk.text == "declare"
isimprime(tk::Token)   = tk.id == RESERVED_WORD && tk.text == "imprime"
isleia(tk::Token)      = tk.id == RESERVED_WORD && tk.text == "leia"
isassign(tk::Token)    = tk.id == ASSIGN
isse(tk::Token)        = tk.id == CFLUX && tk.text == "se"
issenao(tk::Token)     = tk.id == CFLUX && tk.text == "senao"
isenquanto(tk::Token)  = tk.id == CFLUX && tk.text == "enquanto"
isfaca(tk::Token)      = tk.id == CFLUX && tk.text == "faca"
isdurante(tk::Token)   = tk.id == CFLUX && tk.text == "durante"
issemicolon(tk::Token) = tk.id == PUNCTUATION && tk.text == ";"
isio(tk::Token)        = tk.id == RESERVED_WORD && (tk.text == "imprime" || tk.text == "leia")

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

function type2fmt(typestr::AbstractString)::String
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


function transpile(tks::Tokens, file_name::AbstractString, env::Dict)
    tokens = tks.tokens
    file = open(file_name, "w")

    write(file, "#include <stdbool.h>\n")
    if hasio(tks)
        write(file, "#include <stdio.h>\n\n")
    end # if

    write(file, "int main(void) {\n\t")

    for i in 1:length(tokens)
        if isdeclare(tokens[i])
            arr_ident = []
            type = ""
            j = 1
            while !issemicolon(tokens[i+j])
                if isident(tokens[i+j])
                    push!(arr_ident, tokens[i+j].text)
                end # if
                if istype(tokens[i+j])
                    type = tokens[i+j].text
                end # if
                j += 1
            end # while
            write(file, type_p2c(type)*" ")
            write(file, join(arr_ident, ", ")*";\n\t")
            i += j

        elseif isleia(tokens[i])
            arr_vars = []
            j = 1
            while !issemicolon(tokens[i+j])
                if isident(tokens[i+j])
                    push!(arr_vars, tokens[i+j].text)
                end # if
                j += 1
            end # while
            write(file, "scanf(\"")
            types = []
            for var in arr_vars
                if var in keys(arr_vars)
                    x = type2fmt(env[var]["type"])
                    push!(types, x)
                end # if
            end # for

            println(types)

            write(file, join(types, " ")*"\", &"*join(arr_vars, ", &")*");\n")
            i += j
        end # if
    end # for

    write(file, "\n}")

    close(file)
end # transpile
