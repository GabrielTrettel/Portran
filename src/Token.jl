module TokenDefinition

export Token,
       TokenIDS,
       IDENTIFIER,
       INT_NUMBER,
       FLOAT_NUMBER,
       OPERATOR,
       RESERVED_WORD,
       PUNCTUATION,
       INVALID

@enum TokenIDS begin
   IDENTIFIER     = 0
   INT_NUMBER     = 1
   FLOAT_NUMBER   = 2
   OPERATOR       = 3
   RESERVED_WORD  = 4
   PUNCTUATION    = 5
   INVALID        = 6
end


mutable struct Token
    id   :: Union{Int64, TokenIDS}
    text :: String
    function Token(id=0, txt="")
        new(id, txt)
    end
end


# Base.show is invoked in Atom and @show
Base.show(io::IO, t::Token) = println(io, "`$(t.text)` is $(t.id)")
# Base.println is invoked in println call
Base.println(t::Token) = println("`$(t.text)` is $(t.id)")

end
