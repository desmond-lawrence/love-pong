local G = love.graphics
local A = love.audio
local K = love.keyboard
local windowW, windowH = G.getDimensions()
local game = { isPaused = false, isOver = false, score = 0 }
local ball = { x = 0, y = 0, angle = 0, size = 20, velocity = 5 }
local paddle = { x = 0, y = 0, w = 20, h = 80, speed = 10, radius = 0 }
local bonk = A.newSource("audio/bonk.ogg", "static")
local pauseFont = G.newFont(50)
local scoreFont = G.newFont(30)

--- moving the paddle up and setting the minimum y value to 0
function paddle:up()
    self.y = math.max(0, self.y - self.speed)
end

--- moving the paddle down and setting the maximum y value to the window height - the paddle's height
function paddle:down()
    self.y = math.min(windowH - paddle.h, self.y + self.speed)
end

--- Checks if the given x and y coordinates are within the bounds of the paddle.
--- @param x number The x coordinate to check.
--- @param y number The y coordinate to check.
--- @return boolean True if the coordinates are within the paddle's bounds, false otherwise.
function paddle:inside(x, y)
    return x >= self.x
        and y >= self.y
        and x <= self.x + self.w
        and y <= self.y + self.h
end


--- Reverses the angle of the ball when it collides with something.
--- This function is called when the ball collides with an object, such as a wall or the paddle.
--- The angle is updated by adding 180 degrees to the current angle, and then taking the modulus of 360 to keep the angle within the range of 0 to 360 degrees.
function ball:collide()
    self.angle = (self.angle + 90) % 360
    bonk:seek(0)
    bonk:play()
end

--- updating the ball position based on the velocity
--- do collision detection
function ball:update()
    local radians = math.rad(self.angle)
    local newX = self.x + (self.velocity * math.cos(radians))
    local newY = self.y + (self.velocity * math.sin(radians))

    -- check for collision with right wall
    if newX >= windowW then
        self:collide()
        game.score = game.score + 1
    end

    -- check for collision with bottom wall
    if newY >= windowH then
        self:collide()
    end

    -- check for collision with top wall
    if newY <= 0 then
        self:collide()
    end

    -- check for collision with paddle
    if paddle:inside(newX, newY) then
        self:collide()
    end

    radians = math.rad(self.angle)
    newX = newX + (self.velocity * math.cos(radians))
    newY = newY + (self.velocity * math.sin(radians))

    self.x = newX
    self.y = newY
end

function love.load()
    -- centering the ball on the screen
    ball.x = windowW / 2
    ball.y = windowH / 2

    math.randomseed(os.time())
    ball.angle = math.random(359)

    -- setting the paddle's radius to half it's width
    paddle.radius = paddle.w * 0.5
    paddle.x = paddle.w * 2
    paddle.y = ball.y - (paddle.h * 0.5)
end

function love.update()
    if game.isPaused then return end

    if K.isDown("up") then
        paddle:up()
    elseif K.isDown("down") then
        paddle:down()
    end

    ball:update()
end

function love.draw()
    -- setting the color to white
    G.setColor(1, 1, 1)

    -- drawing the ball
    G.circle("fill", ball.x, ball.y, ball.size / 2, 20)

    -- drawing the paddle
    G.rectangle("fill", paddle.x, paddle.y, paddle.w, paddle.h, paddle.radius, paddle.radius)

    -- drawing the score
    G.setFont(scoreFont)
    G.print("Score: ".. game.score, 10, 10)

    if game.isPaused then
        G.setFont(pauseFont)
        G.print("Paused", windowW / 2, windowH / 2)
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        game.isPaused = not game.isPaused
    end
end
