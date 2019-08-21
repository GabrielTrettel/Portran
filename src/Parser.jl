include("Token.jl")

iscolon(t::Token) = t.id==PUNCTUATION && t.text==":"
iscoma(t::Token)  = t.id==PUNCTUATION && t.text==","
isperiod(t::Token)= t.id==PUNCTUATION && t.text=="."

mutable struct var_state
    name   :: String
    init   :: Bool
    type   :: String
    value  :: String
    function var_state(name, init=false, type="", value="")
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
            return

        else
            error("AS: $(t.text) Not an end of line.")
        end
    else
        error("AS: $(t.text) Not correct DECLARE stmt")
    end
end



function bloco!(tokens::Tokens, env)
    t = next!(tokens)

    if t.id==RESERVED_WORD && t.text=="declare"
        declare!(tokens, env)

    elseif t.id==RESERVED_WORD && t.text=="leia"
        cmd_leia!(tokens, env)

    elseif t.id==RESERVED_WORD && t.text=="escreva"
        cmd_escreva(tokens, env)

    elseif t.id==IDENTIFIER
        cmd_attr!(tokens, env)
    end

    if t.text!="fimprog"
        bloco!(tokens, env)
    end
end


function cmd_leia!(tokens::Tokens, env)
    @show t = next!(tokens)

    if t.id==PUNCTUATION && t.text=="("
        t = next!(tokens)
        if t.id==IDENTIFIER
            if haskey(env, t.text)
                env[t.text].init = true
            else
                error("AS: Trying to read from indeclared var $(t.text)")
            end # env

        else # id
            error("AS: Values inside 'leia' command must be a variable, not $(t.text)")
        end # id
        t = next!(tokens)
        if t.id!=PUNCTUATION && t.text==")"
            error("AS: Missing closing parenthesis in 'leia' stmt")
        end # )

        t = next!(tokens)
        if !isperiod(t) error("AS: Missing period") end
    else # (
        error("AS: Missing open parenthesis in 'leia' stmt")
    end # (
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
    1
end
