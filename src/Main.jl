module MainComp

export main

include("Portran.jl")
include("Styles.jl")

function main()
    file_to_parse = ARGS[1]

    io = read(file_to_parse, String)

    tks = tokenise(io)

    # env = nothing
    # try
    env = syntactic_parse(tks)
    println("$(CGREEN)Compilation succeed!! $CEND")
    # catch

    # end
    transpile(tks, env)

end # function main

end # Module

using .MainComp
main()
