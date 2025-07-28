if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.load()
    Player = {
    x = 400,
    y = 300,
    size = 20,
    velocity = 200,
    direction = "W",
    pieceGap = 4,
    pieceCount = 2
    }

    count = 0
    updateDelay = 0.5

    SnakeObject.frontShape = 1
    Player.totalGap = Player.size + Player.pieceGap
    Player.lastShape = Player.pieceCount

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

    SnakeObject:ShapeCoOrds(true)

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
    shapes = {},
    shapeX = {},
    shapeY = {},
    frontShape = 0,
    xGap = 0,
    yGap = 0
}

function SnakeObject:ShapeCoOrds(firstCheck)
    if Player.direction == "W" then
        self.xGap = -Player.totalGap
        self.yGap = 0
    elseif Player.direction == "N" then
        self.xGap = 0
        self.yGap = -Player.totalGap
    elseif Player.direction == "E" then
        self.xGap = Player.totalGap
        self.yGap = 0
    elseif Player.direction == "S" then
        self.xGap = 0
        self.yGap = Player.totalGap
    end
    
    if firstCheck == true then
        for i=1, Player.pieceCount do
            if i == 1 then
                self.shapeX[i] = Player.x
                self.shapeY[i] = Player.y
            else
                self.shapeX[i] = self.shapeX[i-1] + self.xGap
                self.shapeY[i] = self.shapeY[i-1] + self.yGap
            end
        end
    else
        for i=1, Player.pieceCount do
            love.graphics.setColor(White)
            if i == Player.lastShape then -- last shape is the piece count by default and then counts down
                
                if Player.lastShape == Player.pieceCount then -- If the last shape is the piece count, i.e. the highest number, make it 1, as it can't go any higher
                    self.frontShape = 1
                else
                    self.frontShape = i + 1 -- else increase the front shape's number by 1
                end

                self.shapeY[i] = self.shapeY[self.frontShape] + self.yGap
                self.shapeX[i] = self.shapeX[self.frontShape] + self.xGap
                
                if Player.lastShape ~=1 then
                    Player.lastShape = Player.lastShape - 1
                else
                    Player.lastShape = Player.pieceCount
                end
            end

            if self.shapeX[i] > Window.limitRight then
                self.shapeX[i] = Window.limitUpLeft
            elseif self.shapeX[i] < Window.limitUpLeft then
                self.shapeX[i] = Window.limitRight
            elseif self.shapeY[i] > Window.limitDown then
                self.shapeY[i] = Window.limitUpLeft
            elseif self.shapeY[i] < Window.limitUpLeft then
                self.shapeY[i] = Window.limitDown
            end
        end
    end
end

function SnakeObject:Shapes() 
    for i=1, Player.pieceCount do -- draw the square
        love.graphics.setColor(White)
        self.shapes[i] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i], Player.size, Player.size)
    end
end

function CheckForInput()
    if love.keyboard.isDown("w") and Player.direction ~= "S" and Player.direction ~= "N" then
        Player.direction = "N"
    elseif love.keyboard.isDown("s") and Player.direction ~= "S" and Player.direction ~= "N" then
        Player.direction = "S"
    elseif love.keyboard.isDown("a") and Player.direction ~= "W" and Player.direction ~= "E" then
        Player.direction = "W"    
    elseif love.keyboard.isDown("d") and Player.direction ~= "W" and Player.direction ~= "E" then
        Player.direction = "E"    
    end


end

function love.update(dt)
    count = count + dt
    CheckForInput()
    if count > updateDelay then
        SnakeObject:ShapeCoOrds(false)
        count = 0
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
    for i=1,Player.pieceCount do
        love.graphics.print(SnakeObject.shapeX[i], 100, i * 100)
    end
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end