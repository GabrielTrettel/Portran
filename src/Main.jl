module MainComp

export main

include("Portran.jl")
include("Styles.jl")

using JSON

function main()
    global file_to_parse = ARGS[1]
    file_name = file_to_parse[1:end-4]
    io = read(file_to_parse, String)

    try
        tks = tokenise(io)
        println(join(tks.tokens,"\n"))
        env = syntactic_parse(tks)
        write("$file_name.json", string(json(env, 4)))
        transpile(tks, env, file_name*".c")
        run(`gcc $file_name.c -o $file_name.exe`)
        run(`./$file_name.exe`)
    catch
    end
end # function main

end # Module

using .MainComp
main()
