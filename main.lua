local file = require("libs.file")
local copy = require("libs.copy")
local paste = require("libs.paste")
local qr = require("libs.qr")
local submit2 = false
local filepath = nil

function love.load()
    button = {
        width = 125,
        height = 50,
        color = {144 / 255, 213 / 255, 255 / 255},
        round = 5,
        text = "Submit"
    }

    pasteBtn = {
        width = 50,
        height = 50,
        color = {128 / 255, 128 / 255, 128 / 255},
        round = 3,
        text = "Paste"
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
    pasteBtn.x = textinput.x + (pasteBtn.width / 2) + textinput.width
    pasteBtn.y = textinput.y
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

function drawPasteBtn()
    love.graphics.setColor(pasteBtn.color)
    love.graphics.rectangle("fill", pasteBtn.x, pasteBtn.y, pasteBtn.width, pasteBtn.height, pasteBtn.round)
    local lfont = love.graphics.newFont(17)
    love.graphics.setFont(lfont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(pasteBtn.text, pasteBtn.x + (5 / 2), pasteBtn.y * 1.05)
end

function drawTextInput()
    love.graphics.setColor(textinput.color)
    love.graphics.rectangle("fill", textinput.x, textinput.y, textinput.width, textinput.height, textinput.round)
    love.graphics.setColor(1, 1, 1)
    
    local lfont = love.graphics.newFont(16)
    love.graphics.setFont(lfont)
    
    local textToDraw = textinput.text
    local maxWidth = textinput.width - 10
    local clippedText = lfont:getWidth(textToDraw) > maxWidth and textToDraw:sub(1, math.floor(maxWidth / lfont:getWidth("a"))) .. "…" or textToDraw
    
    love.graphics.printf(clippedText, textinput.x + 5, textinput.y + (textinput.height - lfont:getHeight()) / 2, maxWidth, "left")

    if isFocused then
        local cursorX = textinput.x + 5 + lfont:getWidth(textinput.text)
        love.graphics.line(cursorX, textinput.y + 5, cursorX, textinput.y + textinput.height - 5)
    end
end

function submit()
    love.graphics.setColor(1,1,1)
    local rtext = "Copied to clipboard!"
    filepath = textinput.text
    if file.exists(filepath) then
        copyToClipboard(read_qr(filepath))
        love.graphics.print(rtext, love.graphics.getWidth() / 2.5, 0 + 40)
    else
        rtext = "File does not exist"
        love.graphics.print(rtext, love.graphics.getWidth() / 2.5, 0 + 40)
    end
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
            submit2 = true
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

    if btn == 1 then
        if hover(pasteBtn.x, pasteBtn.y, pasteBtn.width, pasteBtn.height) then
            textinput.text = pasteFromClipboard()
        end
    end
end

function love.keypressed(k, scancode, isrepeat)
    if k == "escape" then
        love.event.quit()
    end

    if k == "capslock" then
        capsLock = not capsLock
        return
    end

    if k == "lshift" or k == "rshift" then
        shiftPressed = true
        return
    end
    if isFocused then
        if k == "backspace" then
            textinput.text = textinput.text:sub(1, -2)
        elseif k == "space" then
            textinput.text = textinput.text .. " "
        else
            local char = k

            if shiftPressed or capsLock then
                char = char:upper()
            else
                char = char:lower()
            end

            textinput.text = textinput.text .. char
        end
    end
end

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
    drawPasteBtn()
    if submit2 then
        submit()
    end
end