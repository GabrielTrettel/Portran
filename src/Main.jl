module MainComp

export main

include("Portran.jl")
include("Styles.jl")

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)

    tks = tokenise(io)

    # for token in tks.tokens
    #     println("$CRED",token)
    # end # for

    print("$CEND \n\n")
    syntactic_parse(tks)

end # function main
end # Module

using .MainComp
main()
