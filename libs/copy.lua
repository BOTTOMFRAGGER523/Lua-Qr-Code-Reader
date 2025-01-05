local ffi = require("ffi")

ffi.cdef[[
    int OpenClipboard(void* hwnd);
    int EmptyClipboard();
    void* SetClipboardData(unsigned int uFormat, void* hMem);
    int CloseClipboard();
    void* GlobalAlloc(unsigned int uFlags, size_t dwBytes);
    void* GlobalLock(void* hMem);
    int GlobalUnlock(void* hMem);
    void* memcpy(void* dest, const void* src, size_t n);
]]

local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

local CF_TEXT = 1
local GMEM_MOVEABLE = 0x0002

function copyToClipboard(text)
    if not text then return end

    -- Open the clipboard
    if user32.OpenClipboard(nil) == 0 then
        error("Failed to open clipboard")
    end

    -- Clear the clipboard
    user32.EmptyClipboard()

    -- Allocate global memory for the text
    local size = #text + 1
    local hGlobal = kernel32.GlobalAlloc(GMEM_MOVEABLE, size)
    if hGlobal == nil then
        user32.CloseClipboard()
        error("Failed to allocate global memory")
    end

    -- Copy the text into the allocated memory
    local globalLock = kernel32.GlobalLock(hGlobal)
    ffi.copy(globalLock, text, size)
    kernel32.GlobalUnlock(hGlobal)

    -- Set the clipboard data
    if user32.SetClipboardData(CF_TEXT, hGlobal) == nil then
        user32.CloseClipboard()
        error("Failed to set clipboard data")
    end

    -- Close the clipboard
    user32.CloseClipboard()
end
