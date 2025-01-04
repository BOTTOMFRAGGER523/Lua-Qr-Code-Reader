file = {
    exists = function (filepath)
        local f = io.open(filepath, "r")
        if f then
            f:close()
            print(filepath .. " Exists")
            return true
        else
            print(filepath .. "Doesnt exist")
            return false
        end
    end,
}

return file