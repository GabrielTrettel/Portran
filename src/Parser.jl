
# include("Token.jl")
# using .TokenDefinition
# using .TokenDefinition : Token, TokenIDS, IDENTIFIER, ASSIGN, INT_NUMBER, FLOAT_NUMBER,OPERATOR,RESERVED_WORD,PUNCTUATION,INVALID,Tokens
# include("Portran.jl")

# export syntactic_parse
include("Token.jl")

iscolon(t::Token) = t.id==PUNCTUATION && t.text==":"
iscoma(t::Token)  = t.id==PUNCTUATION && t.text==","
isperiod(t::Token)= t.id==PUNCTUATION && t.text=="."

mutable struct var_state
    name        :: String
    initialized :: Bool
    type        :: String
    value       :: String
    function var_state(name, init=true, type="", value="")
        new(name, init, type, value)
    end
end


function syntactic_parse(tokens::Tokens)
    env = Dict()

    t = next_token!(tokens)
    if t.id == RESERVED_WORD && t.text == "programa"
        t = next_token!(tokens)
        if t.id == RESERVED_WORD && t.text == "declare"
            declare!(tokens, env)
        else
            error("AS: Parsing Error - Expecting ID")
        end
    else
        error("AS: Parsing Error - Expecting PROGRAMA")
    end

    t = next_token!(tokens)
    if t.id != EOF
        error("AS: Program finished but file has content")
    end
end



function declare!(tokens::Tokens, env)
    t = next_token!(tokens)
    current_declared_vars = []

    while t.id == IDENTIFIER || iscoma(t)
        push!(current_declared_vars, var_state(t.text))
        t = next_token!(tokens)
    end

    if iscolon(t)
        t = next_token!(tokens)
        if t.id == TYPE
            map(x->x.type=t.text, current_declared_vars)
        else
            error("AS: $(t.text) is not a correct TYPE")
        end

        t = next_token!(tokens)
        if isperiod(t)
            map!(x->push!(env, x.name=>x), current_declared_vars)
            bloco(tokens, env)
        else
            error("AS: $(t.text) Not an end of line.")
        end
    else
        error("AS: $(t.text) Not correct DECLARE stmt")
    end
end



function bloco(tokens::Tokens, env)
    #TODO
    1
end
