module TokenDefinition

export Token,
       Tokens,
       next_token,
       TokenIDS,
       IDENTIFIER,
       ASSIGN,
       INT_NUMBER,
       FLOAT_NUMBER,
       OPERATOR,
       RESERVED_WORD,
       PUNCTUATION,
       CHAR,
       STRING,
       TYPE,
       INVALID,
       WHITESPACE,
       EOF

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
   EOF            = -1
end # enum


mutable struct Token
    id   :: TokenIDS
    text :: String
    span :: Tuple{Integer, Integer}
    # line ::
    function Token(id=TokenIDS.INVALID, txt="", span=(0, 0))
        new(id, txt, span)
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

function next_token(t::Tokens)
   if t.total >= pos return TokenIDS.EOF end

   t.pos += 1
   return tokes[pos]
end

# Base.show is invoked in Atom and @show
Base.show(io::IO, t::Token) = println(io, "`$(t.text)` is $(t.id) start: $(t.span[1]) end: $(t.span[2])")
# Base.println is invoked in println call
Base.println(t::Token) = println("`$(t.text)` is $(t.id) start: $(t.span[1]) end: $(t.span[2])")

end # module
