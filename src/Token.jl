module TokenDefinition

export Token,
       TokenIDS,
       IDENTIFIER,
       ASSIGN,
       INT_NUMBER,
       FLOAT_NUMBER,
       OPERATOR,
       RESERVED_WORD,
       PUNCTUATION,
       INVALID

@enum TokenIDS begin
   IDENTIFIER     = 0
   ASSIGN         = 1
   INT_NUMBER     = 2
   FLOAT_NUMBER   = 3
   OPERATOR       = 4
   RESERVED_WORD  = 5
   PUNCTUATION    = 6
   INVALID        = 7
end # enum


mutable struct Token
    id   :: TokenIDS
    text :: String
    function Token(id=TokenIDS.INVALID, txt="")
        new(id, txt)
    end # function
end # struct


# Base.show is invoked in Atom and @show
Base.show(io::IO, t::Token) = println(io, "`$(t.text)` is $(t.id)")
# Base.println is invoked in println call
Base.println(t::Token) = println("`$(t.text)` is $(t.id)")

end # module
