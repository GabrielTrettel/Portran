module TokenDefinition

export Token,
       TokenIDS,
       IDENTIFIER


@enum TokenIDS begin
   IDENTIFIER     = 0
   INT_NUMBER     = 1
   FLOAT_NUMBER   = 2
   OPERATOR       = 3
   RESERVERD_WORD = 4
   PONTUACTION    = 5
end


mutable struct Token
    id   :: Union{Int64, TokenIDS}
    text :: String
    function Token(id=0, txt="")
        new(id, txt)
    end
end

end #module
