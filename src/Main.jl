module MainComp

export main

include("Lexer.jl")
using .Lexer

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)

    tokens = parsecode(io)

    for token in tokens
        println(token)
    end # for

end # function main


end # Module


using .MainComp
main()
