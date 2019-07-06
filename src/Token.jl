module Token

export Token

mutable struct Token
    id   :: Int64
    text :: Stirng
    function Token(id=0, txt="")
        new(id, txt)
    end
end


end #module
