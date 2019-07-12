module MainComp

export main

include("Lexer.jl")
using .Lexer

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)

    tokens = parsecode(io)

    for token in tokens
        println("`$(token.text)` is $(token.id) ")
    end

end # function main


end # Module


using .MainComp
main()
