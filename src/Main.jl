module MainComp

export main

include("Portran.jl")

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)


    tks = tokenise(io)

    for token in tks.tokens
        println(token)
    end # for

    syntactic_parse(tks)

end # function main


end # Module


using .MainComp
main()
