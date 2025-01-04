local file = require("libs/file")
local filepath = nil

function love.load(args)
    button = {
        width = 125,
        height = 50,
        color = {144 / 255, 213 / 255, 255 / 255},
        round = 5,
        text = "Submit"
    }

    textinput = {
        width = button.width,
        height = button.height,
        color = {128 / 255, 128 / 255, 128 / 255},
        text = ""
    }
    button.x = love.graphics.getWidth() / 2 - (button.width / 2)
    button.y = love.graphics.getHeight() / 2 - (button.height / 2)
    font = love.graphics.newFont(30)
end

function drawButton()
    love.graphics.setColor(button.color)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, button.round)
    local lfont = love.graphics.newFont(25)
    love.graphics.setFont(lfont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(button.text, button.x + (25 / 1.5), button.y + (25 / 3))
end

function hover(x,y,width,height)
   local mouseX = love.mouse.getX()
   local mouseY = love.mouse.getY()

   return mouseX >= x and mouseX <= x + width and
          mouseY >= y and mouseY <= y + height
end

function love.update(dt)
end

function love.mousepressed(x,y,btn)
    if btn == 1 then
        if hover(button.x, button.y, button.width, button.height) then
            print("Button Clicked!")
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0,0,135/255)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(font)
    love.graphics.print("Qr Code Reader", love.graphics.getWidth() / 2 / 1.4, 0 + (love.graphics.getHeight() / 3.2))
    drawButton()
end