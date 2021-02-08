require "import"

minicrypto = {}
 
local insert, concat, modf, tostring, char = table.insert, table.concat, math.modf, tostring, string.char

local function numberToBinStr(x)
    local ret = {}
    while x~=1 and x~=0 do
        insert(ret, 1, x%2)
        x=modf(x/2)
    end
    insert(ret, 1, x)
    for i = 1, 8 - #ret do 
       insert(ret, 1, 0)
    end
    return concat(ret)
end
 
local function computeBinaryKey(str)
    local t = {}
    for i = #str, 1, -1 do 
        insert(t, numberToBinStr(str:byte(i,i)))
    end
    return concat(t)
end
 
local binaryKeys = setmetatable({}, {__mode = "k"})
 
local function binaryKey(key)
    local v = binaryKeys[key]
    if v == nil then
        v = computeBinaryKey(key)
        binaryKeys[key] = v 
    end
    return v
end
 
local function initialize_state(key)
    local S = {}; for i = 0, 255 do S[i] = i end
    key = binaryKey(key)
 
    local j = 0
    for i = 0, 255 do 
        local idx = (i % #key) +1
        j = (j + S[i] + tonumber(key:sub(idx, idx))) % 256
        S[i], S[j] = S[j], S[i]
    end
    S.i = 0
    S.j = 0
    return S
end
 
local function encrypt_one(state, byt)
    state.i = (state.i+1) % 256
    state.j = (state.j + state[state.i]) % 256
    state[state.i], state[state.j] = state[state.j], state[state.i]
    local K = state[(state[state.i] + state[state.j]) % 256]
    return K ~ byt
end
 
function minicrypto.encrypt(text, key)
    local state = initialize_state(key)
    local encrypted = {}
    for i = 1, #text do 
        encrypted[i] = ("%02X"):format(encrypt_one(state, text:byte(i,i)))
    end
    return concat(encrypted)
end
 
function minicrypto.decrypt(text, key)
    local state = initialize_state(key)
    local decrypted = {}
    for i = 1, #text, 2 do 
        insert(decrypted, char(encrypt_one(state, tonumber(text:sub(i, i+1), 16))))
    end
    return concat(decrypted)
end