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
end # function

function hasio(tks::Tokens)::Bool
    for tk in tks.tokens
        if isio(tk)
            return true
        end # if
    end # for
    false
end # function


function transpile(tks::Tokens, file_name::AbstractString)
    tokens = tks.tokens
    file = open(file_name, "w")

    write(file, "#include <stdbool.h>\n")
    if hasio(tks)
        write(file, "#include <stdio.h>\n\n")
    end # if

    write(file, "int main(void) {\n\t")

    for (i, tk) in enumerate(tokens)
        if isdeclare(tk)
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
            println(type)
            println(arr_ident)
            write(file, type_p2c(type)*" ")
            write(file, join(arr_ident, ", ")*";\n\t")
        end # if
    end # for

    write(file, "\n}")

    close(file)
end # function
