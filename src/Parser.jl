include("Token.jl")
include("Errors.jl")

using JSON

const table = Dict("int"=>INT_NUMBER, "real"=>FLOAT_NUMBER, "char"=>CHAR, "texto"=>STRING, "boleano"=>BOOL)

iscolon(t::Token)   = t.id==PUNCTUATION && t.text==":"
iscoma(t::Token)    = t.id==PUNCTUATION && t.text==","
isperiod(t::Token)  = t.id==PUNCTUATION && t.text==";"
isassign(t::Token)  = t.id==ASSIGN && t.text==":="
isliteral(t::Token) = t.id==INT_NUMBER || t.id==FLOAT_NUMBER || t.id==CHAR || t.id==STRING

type_match(t::Token, lit::Token, env) = table[env[t.text].type] == lit.id


mutable struct var_state
    name   :: String
    init   :: Bool
    type   :: String # can be: 'int', 'real', 'char', 'texto', 'boleano'
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
            error("Parsing Error - Expecting name of program",t)
        end
    else
        error("Parsing Error - Expecting PROGRAMA",t)
    end

    t = next!(tokens)

    if t.id != EOF
        error("Program finished but file has content",t)
    end

    println(json(env, 4))
end



function declare!(tokens::Tokens, env)
    t = next!(tokens)
    current_declared_vars::Array{var_state} = []

    while t.id == IDENTIFIER || iscoma(t)
        if t.id == IDENTIFIER
            push!(current_declared_vars, var_state(t.text))
        end
        t = next!(tokens)
    end

    if iscolon(t)
        t = next!(tokens)
        if t.id == TYPE
            map(x->x.type=t.text, current_declared_vars)
        else
            error("$(t.text) is not a correct TYPE", t)
        end

        t = next!(tokens)
        if isperiod(t)
            # Returned with success
            for state in current_declared_vars
                env[state.name] = state
            end
            return

        else
            error("$(t.text) Not an end of line.", t)
        end
    else
        error("$(t.text) Not correct DECLARE stmt", t)
    end
end



function bloco!(tokens::Tokens, env)
    t = next!(tokens)

    if t.id==RESERVED_WORD && t.text=="declare"
        declare!(tokens, env)

    elseif t.id==RESERVED_WORD && (t.text=="leia" || t.text=="escreva")
        cmd_io!(tokens, env, t.text)

    elseif t.id==IDENTIFIER
        cmd_attr!(tokens, env)
    end

    if t.text!="fimprog"
        bloco!(tokens, env)
    end
end


function cmd_io!(tokens::Tokens, env, io)
    t = next!(tokens)
    if t.id==PUNCTUATION && t.text=="("
        t = next!(tokens)
        if t.id==IDENTIFIER
            if haskey(env, t.text)
                if io == "leia"
                    env[t.text].init = true
                else # escreva
                    if env[t.text].init == false
                        error("Trying to print uninitialized variable", t)
                    end
                end # io
            else
                error("AS:Trying to read from undeclared variable $(t.text)", t)
            end # env

        else # id
            error("Values inside '$io' command must be a variable, not $(t.text)", t)
        end # id
        t = next!(tokens)
        if t.id!=PUNCTUATION && t.text==")"
            error("Missing closing parenthesis in '$io' stmt", t)
        end # )

        t = next!(tokens)
        if !isperiod(t) error("Missing period", t) end
    else # (
        error("Missing open parenthesis in '$io' stmt", t)
    end # (
end


function cmd_attr!(tokens::Tokens, env)
    # var := literal | expressão
    variable = current(tokens)

    if haskey(env, variable.text)
        t = next!(tokens)
        if isassign(t)
            t = next!(tokens)
            if isliteral(t)
                if type_match(variable,t, env)
                    env[variable.text].value = t.text
                    env[variable.text].init = true
                else # not compatible types
                    error("Mismatching types between $(variable.text) and literal of type $(t.id)", t)
                end #type_match
            else # should be expr
                par_expr!(tokens, env)
            end # if is literal

            t = next!(tokens)
            if !isperiod(t) error("Missing period", t) end
        else # isn't assign symbol
            error("Assign symbol required", t)
        end #isassing

    else #not has key
        error("Undefined vaiable $(variable.text)", variable)
    end # haskey
end


function par_expr!(tokens::Tokens, env)
    #TODO
    1
end
