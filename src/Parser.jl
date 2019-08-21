module Parser

include("Token.jl")
using .TokenDefinition

export syntactic_parse

iscolon(t::Token) = t.id==TokensIDS.PUNCTUATION && t.text==":"
iscoma(t::Token)  = t.id==TokensIDS.PUNCTUATION && t.text==","
isperiod(t::Token)= t.id==TokensIDS.PUNCTUATION && t.text=="."

mutable struct var_state
    name        :: String
    initialized :: Bool
    type        :: String
    value       :: String
    function state(name, init=true, type="", value="")
        new(name, init, type, value)
    end
end


function syntactic_parse(tokens::Tokens)
    env = Dict()

    t = next_token(tokens)
    if t.id == TokenIDS.RESERVERD_WORD && t.text == "programa"
        t = next_token(tokens)
        if t.id == TokenIDS.ID
            declare!(tokens, env)
        else
            error("AS: Parsing Error - Expecting ID")
        end
    else
        error("AS: Parsing Error - Expecting PROGRAMA")
    end

    t = next_token(tokens)
    if t.id != TokenIDS.EOF
        error("AS: Program finished but file has content")
    end
end



function declare!(tokens::Tokens, env)
    t = next_token(tokens)
    if t.id == TokenIDS.RESERVED_WORD && t.text == "declare"
        t = next_token(tokens)
        current_declared_vars = []

        while t.id == TokensIDS.ID || iscoma(t)
            push!(current_declared_vars, var_state(t.text))
            t = next_token(tokens)
        end

        if iscolon(t)
            t = next_token(tokens)
            if t.id == TokensIDS.TYPE
                map(x->x.type=t.text, current_declared_vars)
            else
                error("AS: $(t.text) is not a correct TYPE")
            end

            t = next_token(tokens)
            if isperiod(t)
                map!(x->push!(env, x.name=>x), current_declared_vars)
                bloco(tokens, env)
            else
                error("AS: $(t.text) Not an end of line.")
            end
        else
            error("AS: $(t.text) Not a correct in DECLARE stmt")
        end

    else
        error("AS: Not an valid DECLARE stmt")
    end
end



function bloco(tokens::Tokens, env)
    #TODO
    1
end

end # module
