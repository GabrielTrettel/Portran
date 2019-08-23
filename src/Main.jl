module MainComp

export main

include("Portran.jl")
include("Styles.jl")

function main()
    file_to_parse = ARGS[1]
    io = read(file_to_parse, String)

    tks = tokenise(io)

    try
        syntactic_parse(tks)
        println("Compilation succeed")
    catch

    end

end # function main
end # Module

using .MainComp
main()
