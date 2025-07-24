if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.load()
    Player = {}
    Player.x = 400
    Player.y = 300
    Player.size = 20
    Player.speed = 2

    Red = {255,0,0}
    Green = {0, 255, 0}
    Blue = {0, 0, 255}
    White = {255,255,255}
    Black = {0, 0, 0}

    Window = {}
    Window.limitRight = 800
    Window.limitUpLeft = 0
    Window.limitDown = 600
end



function love.update(dt)
    
    if love.keyboard.isDown("w") and Player.y ~= Window.limitUpLeft then
        Player.y = Player.y - Player.speed
    elseif love.keyboard.isDown("s") and Player.y ~= Window.limitDown then
        Player.y = Player.y + Player.speed
    elseif love.keyboard.isDown("a") and Player.x ~= Window.limitUpLeft then
        Player.x = Player.x - Player.speed
    elseif love.keyboard.isDown("d") and Player.x ~= Window.limitRight then
        Player.x = Player.x + Player.speed
    end
end




function love.draw()
    love.graphics.setColor(Green)
    love.graphics.rectangle("fill",0 , 0, 800, 600)
    love.graphics.setColor(White)
    love.graphics.circle("fill", Player.x, Player.y, Player.size)
    love.graphics.setColor(Black)
    love.graphics.print(Player.x .. ", " .. Player.y, 400, 400)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end