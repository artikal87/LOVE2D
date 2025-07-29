if arg[2] == "debug" then 
    require("lldebugger").start()
end

function love.load()
    count = 0
    updateDelay = 0.1

    SnakeObject.frontShape = 1
    Player.totalGap = Player.size + Player.pieceGap
    Player.lastShape = Player.pieceCount

    FirstLoad = true
    Red = {255,0,0}
    Green = {0, 255, 0}
    Blue = {0, 0, 255}
    White = {255,255,255}
    Black = {0, 0, 0}

    GameState = "menu"

    SnakeObject:ShapeCoOrds(true)

end

Player = {
x = 400,
y = 300,
size = 20,
velocity = 200,
direction = "W",
pieceGap = 5,
pieceCount = 9
}

function CreateWindow()
    local window = {
        w = 800,
        h = 600,
        gridMultiple = 25,
    }
    window.limitRight = window.w --- Player.size
    window.limitUpLeft = 0 --+ Player.size
    window.limitDown = window.h --- Player.size
    return window
end

Win = CreateWindow()

FoodObject = {
size = 20,
}

function FoodObject:GetCoOrds()
n = Win.gridMultiple * (math.fmod(math.random(Win.w),Win.gridMultiple))
return n
end

FoodObject.x = FoodObject:GetCoOrds()
FoodObject.y = FoodObject:GetCoOrds()

function FoodObject:Shapes()
    love.graphics.setColor(Black)
    self.shapes = love.graphics.rectangle("fill",self.x, self.y, self.size, self.size)
end

--[[
Snake moves at a constant pace in random direction
user input changes direction 
turns on coords that intersect with input
user pressed S at 4,2
moving west: x - 1 per frame
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
    frontShape = 1,
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
    
    --if firstCheck == true then
    if firstCheck == true then
        for i=1, Player.pieceCount do
            if i == 1 then
                self.shapeX[i] = Player.x
                self.shapeY[i] = Player.y
            else
                self.shapeX[i] = self.shapeX[i-1] - self.xGap
                self.shapeY[i] = self.shapeY[i-1] - self.yGap
            end
        end
    else
        -- run function
          -- all coords set once
          -- move last shape
          -- last becomes first
          -- last = last - 1, unless last = 1, in which case last becomes piece count
        self.shapeX[Player.lastShape] = self.shapeX[SnakeObject.frontShape] + self.xGap
        self.shapeY[Player.lastShape] = self.shapeY[SnakeObject.frontShape] + self.yGap
        
        SnakeObject.frontShape = Player.lastShape

        if self.shapeX[Player.lastShape] > Win.limitRight then
            self.shapeX[Player.lastShape] = Win.limitUpLeft
        elseif self.shapeX[Player.lastShape] < Win.limitUpLeft then
            self.shapeX[Player.lastShape] = Win.limitRight
        elseif self.shapeY[Player.lastShape] > Win.limitDown then
            self.shapeY[Player.lastShape] = Win.limitUpLeft
        elseif self.shapeY[Player.lastShape] < Win.limitUpLeft then
            self.shapeY[Player.lastShape] = Win.limitDown
        end

        if Player.lastShape ~= 1 then
            Player.lastShape = Player.lastShape - 1
        else
            Player.lastShape = Player.pieceCount
        end

    end

end

function SnakeObject:Shapes() 
    for i=1, Player.pieceCount do -- draw the square
        love.graphics.setColor(White)
        self.shapes[i] = love.graphics.rectangle("fill",self.shapeX[i], self.shapeY[i], Player.size, Player.size)
    end
end

function SnakeObject:AddNewPiece()
    Player.pieceCount = Player.pieceCount + 1
    self.shapeX[Player.pieceCount] = self.shapeX[Player.piececount - 1] - self.xGap
    self.shapeY[Player.pieceCount] = self.shapeY[Player.piececount - 1] - self.xGap
    
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

function CheckForCollisions()
    if SnakeObject.shapeX[SnakeObject.frontShape] == FoodObject.x and SnakeObject.shapeY[SnakeObject.frontShape] == FoodObject.y then
        
        FoodObject.x = FoodObject:GetCoOrds()
        FoodObject.y = FoodObject:GetCoOrds()
    end
end

function love.update(dt)
    count = count + dt
    CheckForInput()
    CheckForCollisions()
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
    FoodObject:Shapes()
    love.graphics.setColor(Black)
    love.graphics.print("Player x: " .. ", " .. "Player y: " .. Player.y, 400, 400)
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