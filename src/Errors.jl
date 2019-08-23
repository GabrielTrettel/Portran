
include("Styles.jl")


import Base.error
function Base.error(err_msg::String, t::Token)
    s = max(1,t.line-3)
    lines = readlines(file_to_parse)[s:t.line]

    code = ""
    ln = 0
    for (i,l) in enumerate(lines)
        ln = "  $(i+s-1).  "
        code *= "$ln$l\n"
    end
    code = code[1:end-1]
    println(code)

    println(" "^(t.col-3+length(ln))*"^^^^^")

    println("$CRED"*"$err_msg at line $(t.line):$(t.col)")
    println("Compilation failed$CEND")


    error("void")
end
