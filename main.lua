if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.draw()
    love.graphics.print("Hello world",400,400)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end