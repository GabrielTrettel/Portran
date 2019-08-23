module MainComp

export main

include("Portran.jl")
include("Styles.jl")

function main()
    file_to_parse = ARGS[1]
    c_file_name = file_to_parse[1:end-3] * "c"

    io = read(file_to_parse, String)

    tks = tokenise(io)

    # for token in tks.tokens
    #     println("$CRED",token)
    # end # for

    # print("$CEND \n\n")
    try
        syntactic_parse(tks)
        transpile(tks, c_file_name)
        println("$(CGREEN)Compilation succeed!! $CEND")
    catch
    end



end # function main
end # Module

using .MainComp
main()
