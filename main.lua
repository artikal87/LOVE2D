if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.load()
    Player = {
    x = 400,
    y = 300,
    size = 20,
    velocity = 200,
    direction = "E",
    pieceGap = 4,
    pieceCount = 15
    }

    count = 0
    updateDelay = 0.2

    Player.totalGap = Player.size + Player.pieceGap
    Player.lastPiece = Player.pieceCount

    FirstLoad = true
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

]]

SnakeObject = {
    speed = 3,
    direction = "E",
    shapes = {},
    shapeX = {},
    shapeY = {}
}

function SnakeObject:Shapes() 
    if FirstLoad == true then
        for i=1, Player.pieceCount do
            love.graphics.setColor(White)
                if i == 1 then
                    self.shapeX[i] = Player.x --table of coords will keep track of snake pieces
                    self.shapeY[i] = Player.y
                    self.shapes[1] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i], Player.size, Player.size)
                else
                    self.shapeX[i] = self.shapeX[i-1] - Player.totalGap
                    self.shapeY[i] = self.shapeY[i-1]
                    self.shapes[i] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i],Player.size,Player.size)
                end
        end
        FirstLoad = false

    else
        
        for i=1, Player.pieceCount do
            love.graphics.setColor(White)
            if i == Player.lastPiece then
                self.shapeX[i] = self.shapeX[1] + Player.totalGap
                self.shapes[i] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i], Player.size, Player.size)
                if Player.lastPiece ~=1 then
                    Player.lastPiece = Player.lastPiece - 1
                else
                    Player.lastPiece = Player.pieceCount
                end
            else
                self.shapeX[i] = self.shapeX[i]
                self.shapes[i] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i], Player.size, Player.size)
            end
            --[[
            if i == 1 then
                self.shapes[self.pieceCount] = love.graphics.rectangle("fill",Player.x, Player.y,Player.size,Player.size)
            elseif i ~= 1 and  i ~= self.pieceCount then
                self.shapes[i] = love.graphics.rectangle("fill",Player.x - Player.totalGap * (i-1), Player.y,Player.size,Player.size)
            end
            ]]
        end
    end
end

function love.update(dt)

    count = count + dt

    if Player.x > Window.limitRight then
        Player.x = Window.limitUpLeft
    end
    if count > updateDelay then
        Player.x = Player.x + Player.totalGap
        count = 0
    end
    if love.keyboard.isDown("w") and Player.y > Window.limitUpLeft then
    end

    if love.keyboard.isDown("s") and Player.y < Window.limitDown then  
    end

    if love.keyboard.isDown("a") and Player.x > Window.limitUpLeft then  
    end
    
    if love.keyboard.isDown("d") and Player.x < Window.limitRight then
    end
    DeltaTime = dt
end

function love.draw()
    love.graphics.setColor(Green)
    love.graphics.rectangle("fill",0 , 0, 800, 600)
    SnakeObject:Shapes()
    love.graphics.setColor(Black)
    love.graphics.print(Player.x .. ", " .. Player.y .. " DT: " .. DeltaTime, 400, 400)
    love.graphics.print(count, 400, 500)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end