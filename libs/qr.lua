function read_qr(image_path)
    local command = [[py ..\\python\\qr.py "]] .. image_path
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    if result then
        return result
    else
        return error("Failed to decode")
    end
end