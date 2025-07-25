if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.load()
    Player = {}
    Player.x = 400
    Player.y = 300
    Player.size = 20
    Player.velocity = 200
    Player.direction = "E"

    Red = {255,0,0}
    Green = {0, 255, 0}
    Blue = {0, 0, 255}
    White = {255,255,255}
    Black = {0, 0, 0}

    Window = {}
    Window.limitRight = 800 - Player.size
    Window.limitUpLeft = 0 + Player.size
    Window.limitDown = 600 - Player.size
    GameState = "menu"
end

--[[
Snake moves at a constant pace in random direction
user input changes direction 
turns on coords that intersect with input
user pressed S at 4,2
moving west: x + 1 per frame
user presses D: at 4,2: y + 1 per frame after 4,2


s = y + 1
coord list
s(1) 1,2  s(1) = s(1+1) 2,2 3,2
s(2) 2,2  s(2) = s(2+1) 3,2 4,2
s(3) 3,2  s(3) = s(3+1) 4,2 5,2
s(4) 4,2  s(4) = s(4+1) 5,2 5,3
s(5) 5,2  s(5) = s(5+t) 5,3 5,4

t = direction transformation OR current trajectory
pressing s: y+1
1 2 3 4 5 6
x x x x x x 1
- - - - - x 2
x x x x x x 3
x x x x x x 4
x x x x x x 5
x x x x x x 6

1 2 3 4 5 6
x x x x x x 1
x - - - - x 2
x x x x l x 3
x x x x x x 4
x x x x x x 5
x x x x x x 6

1 2 3 4 5 6
x x x x x x 1
x x - - - x 2
x x x x l x 3
x x x x l x 4
x x x x x x 5
x x x x x x 6

--]] 

PlayerMovement = {
    pieceCount = 2
}

function PlayerMovement:Logic()
    for 
end

function love.update(dt)


    if love.keyboard.isDown("w") and Player.y > Window.limitUpLeft then
        Player.y = Player.y - Player.velocity * dt
    end

    if love.keyboard.isDown("s") and Player.y < Window.limitDown then
        Player.y = Player.y + Player.velocity * dt
    end

    if love.keyboard.isDown("a") and Player.x > Window.limitUpLeft then
        Player.x = Player.x - Player.velocity * dt
    end
    
    if love.keyboard.isDown("d") and Player.x < Window.limitRight then
        Player.x = Player.x + Player.velocity * dt
    end
    DeltaTime = dt
end

function love.draw()
    love.graphics.setColor(Green)
    love.graphics.rectangle("fill",0 , 0, 800, 600)
    love.graphics.setColor(White)
    love.graphics.rectangle("fill",Player.x,Player.y,Player.size,Player.size)
    love.graphics.setColor(Black)
    love.graphics.print(Player.x .. ", " .. Player.y .. " DT: " .. DeltaTime, 400, 400)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end