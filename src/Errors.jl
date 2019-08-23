
include("Styles.jl")

import Base.error
function Base.error(err_msg::String, t::Token)
    println("$CRED"*"Compilation failed")
    println("$err_msg at line $(t.line):$(t.col)")
    error("void")
end
