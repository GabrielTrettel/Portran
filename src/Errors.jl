

import Base.error

function Base.error(err_msg::String, t::Token)
    error("$err_msg at line $(t.line):$(t.span[1])")
end
