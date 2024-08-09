local G = love.graphics
local K = love.keyboard
local windowW, windowH = G.getDimensions()
local ball = { x = 0, y = 0, speed = 5, size = 20 }
local paddle = { x = 0, y = 0, w = 20, h = 80, speed = 10, radius = 0 }

--- moving the paddle up and setting the minimum y value to 0
function paddle:up()
    self.y = math.max(0, self.y - self.speed)
end

--- moving the paddle down and setting the maximum y value to the window height - the paddle's height
function paddle:down()
    self.y = math.min(windowH - paddle.h, self.y + self.speed)
end

function love.load()
    -- centering the ball on the screen
    ball.x = windowW / 2
    ball.y = windowH / 2

    -- setting the paddle's radius to half it's width
    paddle.radius = paddle.w * 0.5
    paddle.x = paddle.w * 2
    paddle.y = ball.y - (paddle.h * 0.5)
end

function love.update()
    if K.isDown("up") then
        paddle:up()
    elseif K.isDown("down") then
        paddle:down()
    end
end

function love.draw()
    -- setting the color to white
    G.setColor(1, 1, 1)

    -- drawing the ball
    G.circle("fill", ball.x, ball.y, ball.size / 2, 20)

    -- drawing the paddle
    G.rectangle("fill", paddle.x, paddle.y, paddle.w, paddle.h, paddle.radius, paddle.radius)
end
