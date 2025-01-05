local file = require("libs.file")
local copy = require("libs.copy")
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
        width = 125 + 50,
        height = 50,
        color = {128 / 255, 128 / 255, 128 / 255},
        text = "Enter the directory",
        round = 3
    }
    button.x = love.graphics.getWidth() / 2 - (button.width / 2)
    button.y = love.graphics.getHeight() / 2 - (button.height / 2) + button.height
    textinput.x = love.graphics.getWidth() / 2 - (textinput.width / 2)
    textinput.y = love.graphics.getHeight() / 2 - (textinput.height / 2) - textinput.height + 25
    font = love.graphics.newFont(30)
    rtext = ""
    isFocused = false
end

function drawButton()
    love.graphics.setColor(button.color)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, button.round)
    local lfont = love.graphics.newFont(25)
    love.graphics.setFont(lfont)
    love.graphics.setColor(0,0,0)
    love.graphics.print(button.text, button.x + (25 / 1.5), button.y + (25 / 3))
end

function drawTextInput()
    love.graphics.setColor(textinput.color)
    love.graphics.rectangle("fill", textinput.x, textinput.y, textinput.width, textinput.height, textinput.round)
    love.graphics.setColor(1, 1, 1)
    
    local lfont = love.graphics.newFont(16)
    love.graphics.setFont(lfont)
    
    -- Clip the text to fit within the textinput width
    local textToDraw = textinput.text
    local maxWidth = textinput.width - 10 -- Add padding inside the text box
    local clippedText = lfont:getWidth(textToDraw) > maxWidth and textToDraw:sub(1, math.floor(maxWidth / lfont:getWidth("a"))) .. "…" or textToDraw
    
    love.graphics.printf(clippedText, textinput.x + 5, textinput.y + (textinput.height - lfont:getHeight()) / 2, maxWidth, "left")

    if isFocused then
        local cursorX = textinput.x + 5 + lfont:getWidth(textinput.text)
        love.graphics.line(cursorX, textinput.y + 5, cursorX, textinput.y + textinput.height - 5)
    end
end

function submit()
    love.graphics.setColor(1,1,1)
    rtext = "Copied to clipboard!"
    love.graphics.print(rtext, love.graphics.getWidth() / 2.5, 0 + 40)
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

    if btn == 1 then
        if hover(textinput.x, textinput.y, textinput.width, textinput.height) then
            print("textinput clicked")
            isFocused = true
        else
            isFocused = false
        end
    end
end

function love.keypressed(k, scancode, isrepeat)
    if k == "escape" then
        love.event.quit()
    end

    -- Toggle CapsLock state when CapsLock key is pressed
    if k == "capslock" then
        capsLock = not capsLock
        return  -- Prevent adding "capslock" to the text input
    end

    -- Track Shift key state when Shift key is pressed
    if k == "lshift" or k == "rshift" then
        shiftPressed = true
        return  -- Prevent adding "shift" to the text input
    end

    if isFocused then
        -- Handle text input
        if k == "backspace" then
            -- Remove the last character
            textinput.text = textinput.text:sub(1, -2)
        elseif k == "return" then
            -- Optionally handle submission of the input (e.g., copy to clipboard)
            submit()
        elseif k == "space" then
            -- Add a space character
            textinput.text = textinput.text .. " "
        else
            -- Handle character input (only modify the behavior if Shift or CapsLock is pressed)
            local char = k

            -- If Shift is pressed or CapsLock is active, make the character uppercase
            if shiftPressed or capsLock then
                char = char:upper()
            else
                char = char:lower()
            end

            -- Append the character to the text input
            textinput.text = textinput.text .. char
        end
    end
end

-- Handle when Shift key is released
function love.keyreleased(k)
    if k == "lshift" or k == "rshift" then
        shiftPressed = false
    end
end



function love.draw()
    love.graphics.setBackgroundColor(0,0,135/255)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(font)
    love.graphics.print("Qr Code Reader", love.graphics.getWidth() / 2 / 1.4, 0 + (love.graphics.getHeight() / 3.2))
    drawButton()
    drawTextInput()
end