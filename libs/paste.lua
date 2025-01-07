local ffi = require("ffi")

ffi.cdef[[
    int OpenClipboard(void* hwnd);
    int CloseClipboard();
    void* GetClipboardData(unsigned int uFormat);
    int IsClipboardFormatAvailable(unsigned int uFormat);
    void* GlobalLock(void* hMem);
    int GlobalUnlock(void* hMem);
]]

local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

local CF_TEXT = 1

function pasteFromClipboard()
    -- Open the clipboard
    if user32.OpenClipboard(nil) == 0 then
        error("Failed to open clipboard")
    end

    -- Check if the clipboard contains CF_TEXT (text)
    if user32.IsClipboardFormatAvailable(CF_TEXT) == 0 then
        user32.CloseClipboard()
        error("Clipboard does not contain text")
    end

    -- Get the clipboard data
    local hGlobal = user32.GetClipboardData(CF_TEXT)
    if hGlobal == nil then
        user32.CloseClipboard()
        error("Failed to get clipboard data")
    end

    -- Lock the global memory
    local globalLock = kernel32.GlobalLock(hGlobal)
    if globalLock == nil then
        user32.CloseClipboard()
        error("Failed to lock global memory")
    end

    -- Read the text from the clipboard
    local text = ffi.string(globalLock)

    -- Unlock the global memory
    kernel32.GlobalUnlock(hGlobal)

    -- Close the clipboard
    user32.CloseClipboard()

    return text
end