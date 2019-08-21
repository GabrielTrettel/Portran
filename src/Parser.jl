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

    t = next!(tokens)
    if t.id == RESERVED_WORD && t.text == "programa"
        t = next!(tokens)
        if t.id == IDENTIFIER
            bloco!(tokens, env)
        else
            error("AS: Parsing Error - Expecting name of program")
        end
    else
        error("AS: Parsing Error - Expecting PROGRAMA")
    end

    t = next!(tokens)

    if t.id != EOF
        error("AS: Program finished but file has content")
    end
end



function declare!(tokens::Tokens, env)
    t = next!(tokens)
    current_declared_vars::Array{var_state} = []

    while t.id == IDENTIFIER || iscoma(t)
        push!(current_declared_vars, var_state(t.text))
        t = next!(tokens)
    end

    if iscolon(t)
        t = next!(tokens)
        if t.id == TYPE
            map(x->x.type=t.text, current_declared_vars)
        else
            error("AS: $(t.text) is not a correct TYPE")
        end

        t = next!(tokens)
        if isperiod(t)
            # Returned with success
            for state in current_declared_vars
                env[state.name] = state
            end

        else
            error("AS: $(t.text) Not an end of line.")
        end
    else
        error("AS: $(t.text) Not correct DECLARE stmt")
    end
end



function bloco!(tokens::Tokens, env)
    #TODO onde fica o corpo do programa.
    #     Tudo que vem entre [declare, fimprog)

    t = next!(tokens)

    if t.id==RESERVED_WORD && t.text=="declare"
        declare!(tokens, env)
    end
end


function cmd_leia!(tokens::Tokens, env)
    #TODO leia(var).
end


function cmd_escreva!(tokens::Tokens, env)
    #TODO escreva(var).
    1
end


function cmd_attr!(tokens::Tokens, env)
    #TODO var := literal | expressão
    1
end


function par_expr!(tokens::Tokens, env)
    #TODO

end
