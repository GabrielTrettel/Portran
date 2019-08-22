@enum TokenIDS begin
   IDENTIFIER     = 0
   ASSIGN         = 1
   INT_NUMBER     = 2
   FLOAT_NUMBER   = 3
   OPERATOR       = 4
   RESERVED_WORD  = 5
   PUNCTUATION    = 6
   CHAR           = 7
   STRING         = 8
   TYPE           = 9
   INVALID        = 10
   WHITESPACE     = 11
   CFLUX          = 12
   BOOL           = 13
   EOF            = -1
end # enum


mutable struct Token
    id   :: TokenIDS
    text :: String
    span :: Tuple{Integer, Integer}
    line :: Integer
    function Token(id=INVALID, txt="", span=(0, 0), line=1)
        new(id, txt, span, line)
    end # function
end # struct


mutable struct Tokens
   tokens :: Array{Token}
   pos    :: Integer
   total  :: Integer
   function Tokens(tks::Array{Token})
      new(tks, 0, length(tks))
   end
end

function next!(t::Tokens)
   t.pos += 1
   v = t.tokens[ t.pos ]
   println("$CGREEN $v $CEND")

   if v.id == INVALID
      error("Invalid token $(v.text)", v)
   end

   if t.pos == t.total
      return t.tokens[ t.pos ]
   end

   return v
end


next(t::Tokens)      = t.tokens[(t.pos + 1)]
previous(t::Tokens)  = t.tokens[(t.pos - 1)]
current(t::Tokens)   = t.tokens[t.pos]
roll_back(t::Tokens) = t.pos -= 1

# Base.show is invoked in Atom and @show
Base.show(io::IO, t::Token) = println(io, "`$(t.text)` is $(t.id) start: $(t.span[1]) end: $(t.span[2]) at line $(t.line)")
# Base.println is invoked in println call
Base.println(t::Token) = println("`$(t.text)` is $(t.id) start: $(t.span[1]) end: $(t.span[2]) at line $(t.line)")
