@enum TokenIDS begin
   IDENTIFIER     = 0
   ASSIGN         = 1
   INT_NUMBER     = 2
   FLOAT_NUMBER   = 3
   OPERATOR       = 4
   RESERVED_WORD  = 5
   PUNCTUATION    = 6
   INVALID        = 7
   EOF            = -1
   TYPE           = 10
end # enum


mutable struct Token
    id   :: TokenIDS
    text :: String
    function Token(id=INVALID, txt="")
        new(id, txt)
    end # function
end # struct


mutable struct Tokens
   tokens :: Array{Token}
   pos    :: Integer
   total  :: Integer
   function Tokens(tks::Array{Token})
      new(tks, 1, length(tks))
   end
end

function next_token!(t::Tokens)
   v = t.tokens[ t.pos ]
   printstyled(v; color=:red)

   if t.pos == t.total
      return t.tokens[ t.pos ]
   end
   t.pos += 1

   return v
end

# Base.show is invoked in Atom and @show
Base.show(io::IO, t::Token) = println(io, "`$(t.text)` is $(t.id)")
# Base.println is invoked in println call
Base.println(t::Token) = println("`$(t.text)` is $(t.id)")
