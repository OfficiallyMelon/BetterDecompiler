-- made by @officiallymelon for celery :3
--[[
    BetterDecompiler:
    Uses your standard executor decompile function,
    Passes through an AI (such as gpt-3.5 or gpt-4),
    Returns cleaned variable and func named output.

    Usage:

    decompile(script_instance, bool_value, custom_url)

    script_instance: being the LocalScript you want to decompile.
    bool_value: (true or false) whether you want BetterDecompiler enabled or not 
    custom_url: (url string) whether you want to use a custom link (or port) for the AI. OPTIONAL PARAMETER
]]

local BetterDecompiler = {}

-- Alias the original decompile function
local originalDecompile = decompile

-- Sends request to our local port :3
function BetterDecompiler.cleanScript(uncleanScript, custom_url)
    local HttpService = game:GetService("HttpService")
    local url = custom_url or "http://localhost:5000/fix_script"
    
    local requestBody = {
        script = uncleanScript
    }
    
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local jsonBody = HttpService:JSONEncode(requestBody)
    
    local success, response = pcall(function()
        local result = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = jsonBody
        })
        
        if result and result.StatusCode == 200 then
            local resultData = HttpService:JSONDecode(result.Body)
            return resultData.fixed_script
        else
            warn("Request failed with status code: " .. (result and result.StatusCode or "unknown"))
            warn("Response body: " .. (result and result.Body or "no response body"))
        end
    end)
    
    if not success then
        warn("An error occurred: " .. response)
    end
    
    return uncleanScript -- Return original script if cleaning fails
end


function BetterDecompiler.decompile(scr, boolval, custom_url)
    local success, srcScript = pcall(function()
        return originalDecompile(scr) -- returns our decompiled script
    end)
    
    if success and boolval then
        success, srcScript = pcall(function()
            return BetterDecompiler.cleanScript(srcScript, custom_url) -- adds function and variables names
        end)
        
        if not success then
            warn("Clean Script Error: " .. srcScript)
        end
    elseif not success then
        warn("Decompiler Error: " .. srcScript)
    end
    
    return srcScript
end

return BetterDecompiler
