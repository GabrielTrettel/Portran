include("Token.jl")

isio(tk::Token) = tk.id == RESERVED_WORD && (tk.text == "imprime" || tk.text == "leia")

function hasio(tks::Tokens)::Bool
    for tk in tks.tokens
        if isio(tk)
            return true
        end # if
    end # for
    false
end # function


function transpile(tks::Tokens, file_name::AbstractString)
    file = open(file_name, "w")

    if hasio(tks)
        write(file, "#include <stdio.h>\n\n")
    end # if

    write(file, "int main(void) {\n\t")

    # for tk in tks.tokens
    #
    # end # for

    write(file, "\n}")

    close(file)

    println("$(CGREEN)Compilation succeed!! $CEND")
end # function
