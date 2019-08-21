module MainComp

export main

include("Lexer.jl")
using .Lexer

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)

    # printstyled(io; color=:green)

    tks = tokenise(io)

    for token in tks.tokens
        println(token)
    end # for
end # function main


end # Module


using .MainComp
main()
