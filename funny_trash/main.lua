require("function")
PLAYER_NUMBERS = 0
PLAYER_RESPAWN_TABLES = {}
IS_START_GAME = true
local g_hostname_var = nil
local g_hostport_var = nil
function OnPlayerConnect(Player, playerSlot, playerName, xuid, SteamId, IpAddress, isBot)
    if isBot == true then
        return
    end
    luaApi_SentToAllPlayerChat("玩家 \7[" .. playerName .. "]\1 加入了服务器", CHAT_TYPE_TALK)
    PLAYER_NUMBERS = PLAYER_NUMBERS + 1
end

function OnPlayerDisconnect(Player, playerSlot, playerName, xuid, SteamId, IpAddress, isBot)
    if isBot == true then
        return
    end
    luaApi_SentToAllPlayerChat("玩家 \7[" .. playerName .. "]\1 受不了,离开了服务器", CHAT_TYPE_TALK)
    PLAYER_NUMBERS = PLAYER_NUMBERS - 1
    if PLAYER_NUMBERS == 0 then
        IS_START_GAME = false
    end
    if ExistsIntable(PLAYER_RESPAWN_TABLES, Player) == true then
        PLAYER_RESPAWN_TABLES[Player] = nil
    end
end

function OnPlayerDeath(victim, killer, isHeadShot)
    if victim == killer then
        return
    end
    if GAME_MODE == 9 or GAME_MODE == 8 or GAME_MODE == 1 then
        if GAME_MODE == 8 and PLAYER_RESPAWN_TABLES[victim] <= 0 then
            return
        end
        if GAME_MODE == 8 then
            PLAYER_RESPAWN_TABLES[victim] = PLAYER_RESPAWN_TABLES[victim] - 1
        end
        local timerTable = {
            needRespawnPlayerIndex = victim,
        }
        luaApi_CreateTimer(3, false, false, timerTable, Timer_RespawnPlayer)
    end
    if GAME_MODE == 4 then
        luaApi_MakePlayerCurrentWeaponDrop(killer)
    end
end

function OnPlayerChat(Player, ChatType, text)
    local lowerString = text:lower()
    local firstChar = lowerString:sub(1, 1)
    if firstChar ~= '.' and firstChar ~= '!' then
        return false
    end
    if GAME_MODE == 5 then
        if lowerString == ".ranshaoping" then
            RemovePlayerALLWeaponExcludeKnife(Player)
            GivePlayerWeapon(Player, "molotov")
            return true
        end
    end
    if GAME_MODE == 2 then
        if lowerString == ".woyaoshoulei" then
            RemovePlayerALLWeaponExcludeKnife(Player)
            GivePlayerWeapon(Player, "he")
            return true
        end
    end

    if lowerString == ".http" then
        luaApi_HttpAsyncGet("http://key08.com/", "", 30, "test Metadata")
        return true
    elseif lowerString == ".convar" then
        local hostname = luaApi_GetConVarString(g_hostname_var)
        print("hostname: " .. hostname)
        local hostport = luaApi_GetConVarInt(g_hostport_var)
        print("hostport: " .. tostring(hostport))
        return true
    end

    return false
end

HITGROUP_HEAD = 1
function OnPlayerHurt(userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup)
    if attacker == userid then
        return
    end
    if GAME_MODE == 11 then
        if hitgroup ~= HITGROUP_HEAD then
            luaApi_SetPlayerHealth(userid, 100)
        end
    end
end

function Timer_Ad(paramsTable)
    luaApi_SentToAllPlayerChat("欢迎来到 \7[垃圾佬]\1 服务器,这边禁止打架",
        CHAT_TYPE_TALK)
end

function Timer_RespawnPlayer(paramsTable)
    local player = paramsTable.needRespawnPlayerIndex
    if luaApi_CheckPlayerIsInServer(player) == false then
        return
    end
    luaApi_RespawnPlayerInDeathMatch(player)
end

function Timer_CheckPlayerWeapon(paramsTable)
    if GAME_MODE == 2 then
        local allPlayerIndexTable = luaApi_GetAllPlayerIndex()
        for _, playerIndex in pairs(allPlayerIndexTable) do
            if luaApi_CheckPlayerIsAlive(playerIndex) == true then
                if PlayerHaveSomeItem(playerIndex, "weapon_hegrenade") == false then
                    RemovePlayerALLWeaponExcludeNade(playerIndex)
                    GivePlayerWeapon(playerIndex, "he")
                end
            end
        end
    elseif GAME_MODE == 5 then
        local allPlayerIndexTable = luaApi_GetAllPlayerIndex()
        for _, playerIndex in pairs(allPlayerIndexTable) do
            if luaApi_CheckPlayerIsAlive(playerIndex) == true then
                if PlayerHaveSomeItem(playerIndex, "weapon_molotov") == false then
                    RemovePlayerALLWeaponExcludeNade(playerIndex)
                    GivePlayerWeapon(playerIndex, "molotov")
                end
            end
        end
    end
end

function Timer_OnPlayerSpawn(paramsTable)
    local playerIndex = paramsTable._playerIndex
    if GAME_MODE == 11 then
        luaApi_SendToPlayerChat(playerIndex, CHAT_TYPE_CENTER, "当前buff: \7只能打头\1")
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    elseif GAME_MODE == 10 then
        luaApi_SetPlayerHealth(playerIndex, 200)
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    elseif GAME_MODE == 9 then
        luaApi_SendToPlayerChat(playerIndex, CHAT_TYPE_CENTER, "当前buff: \7死了马上复活\1")
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    elseif GAME_MODE == 8 then
        if PLAYER_RESPAWN_TABLES[playerIndex] == nil then
            PLAYER_RESPAWN_TABLES[playerIndex] = 3
        end
        PLAYER_RESPAWN_TABLES[playerIndex] = 3
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    elseif GAME_MODE == 6 then
        RemovePlayerALLWeaponExcludeKnife(playerIndex)
        GivePlayerWeapon(playerIndex, "scar20")
        luaApi_ChangePlayeriAccount(playerIndex, 0)
    elseif GAME_MODE == 5 then
        RemovePlayerALLWeaponExcludeKnife(playerIndex)
        GivePlayerWeapon(playerIndex, "molotov")
        luaApi_ChangePlayeriAccount(playerIndex, 0)
    elseif GAME_MODE == 3 then
        RemovePlayerALLWeaponExcludeKnife(playerIndex)
        luaApi_GivePlayerWeapon(playerIndex, "awp")
        luaApi_ChangePlayeriAccount(playerIndex, 0)
    elseif GAME_MODE == 2 then
        RemovePlayerALLWeaponExcludeKnife(playerIndex)
        GivePlayerWeapon(playerIndex, "he")
        luaApi_ChangePlayeriAccount(playerIndex, 0)
    elseif GAME_MODE == 1 then
        luaApi_SetPlayerHealth(playerIndex, 1)
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    end
    local hubtype = CHAT_TYPE_CENTER
    if GAME_MODE == 0 then
        SendMessageToAll(playerIndex, "当前buff: 没有buff", hubtype)
    elseif GAME_MODE == 1 then
        SendMessageToAll(playerIndex, "当前buff: \7所有人都一滴血,死了马上复活(1秒)\1", hubtype)
    elseif GAME_MODE == 2 then
        SendMessageToAll(playerIndex, "当前buff: \7全员手雷而且没有武器\1", hubtype)
    elseif GAME_MODE == 3 then
        SendMessageToAll(playerIndex, "当前buff: \7只能用AWP和刀\1", hubtype)
    elseif GAME_MODE == 4 then
        SendMessageToAll(playerIndex, "当前buff: \7打人丢枪\1", hubtype)
        luaApi_ChangePlayeriAccount(playerIndex, 16000)
    elseif GAME_MODE == 5 then
        SendMessageToAll(playerIndex, "当前buff: \7全员燃烧瓶没有武器\1", hubtype)
    elseif GAME_MODE == 6 then
        SendMessageToAll(playerIndex, "当前buff: \7全员只能使用连狙\1", hubtype)
    elseif GAME_MODE == 7 then
        SendMessageToAll(playerIndex, "当前buff: \7随机重力\1", hubtype)
    elseif GAME_MODE == 8 then
        SendMessageToAll(playerIndex, "当前buff: \7每人三次复活机会(1秒)\1", hubtype)
    elseif GAME_MODE == 9 then
        SendMessageToAll(playerIndex, "当前buff: \7死了马上复活(1秒)\1", hubtype)
    elseif GAME_MODE == 10 then
        SendMessageToAll(playerIndex, "当前buff: \7所有人200血\1", hubtype)
    elseif GAME_MODE == 11 then
        SendMessageToAll(playerIndex, "当前buff: \7只能打头\1", hubtype)
    end
end

function OnPlayerSpawn(playerIndex)
    --这个位置玩家没有完全重生...
    if IS_START_GAME == false then
        return
    end
    local parmas = {
        _playerIndex = playerIndex
    }
    luaApi_CreateTimer(0.1, false, false, parmas, Timer_OnPlayerSpawn)
end

function OnRoundStart(timelimit)
    if IS_START_GAME == false then
        return
    end
    print("Round Start")
    math.randomseed(os.time())
    GAME_MODE = math.random(0, 11)
    print("GAME_MODE: " .. GAME_MODE)
    if GAME_MODE == 7 then
        local randGravity = math.random(10, 800)
        local stringCommand = "sv_gravity " .. tostring(randGravity)
        luaApi_RunServerCommand(stringCommand)
    end
end

function OnRoundEnd(winnerTeam, intReason, strMessage)
    print("Round End")
    if IS_START_GAME == false then
        IS_START_GAME = true
        SendMessageToAll("垃圾佬游戏即将开始....", CHAT_TYPE_CENTER)
    end
    if GAME_MODE == 3 then
        for playerIndex, _ in pairs(PLAYER_RESPAWN_TABLES) do
            PLAYER_RESPAWN_TABLES[playerIndex] = 0
        end
    end
    if GAME_MODE == 7 then
        luaApi_RunServerCommand("sv_gravity 800")
    end
end

function OnHttpRequest(url, metadata, respon, statucode)
    print("OnHttpRequest")
    print("url is " .. tostring(url))
    print("metadata is " .. tostring(metadata))
    print("respon is " .. tostring(respon))
    print("statucode is " .. tostring(statucode))
    return true
end

function Main()
    ListenToGameEvent("player_connect", OnPlayerConnect)
    ListenToGameEvent("player_disconnect", OnPlayerDisconnect)
    ListenToGameEvent("player_spawn", OnPlayerSpawn)
    ListenToGameEvent("round_start", OnRoundStart)
    ListenToGameEvent("round_end", OnRoundEnd)
    ListenToGameEvent("player_chat", OnPlayerChat)
    ListenToGameEvent("player_hurt", OnPlayerHurt)
    ListenToGameEvent("player_death", OnPlayerDeath)
    ListenToGameEvent("http_request", OnHttpRequest)

    g_hostname_var = luaApi_GetConVarObject("hostname")
    g_hostport_var = luaApi_GetConVarObject("hostport")

    luaApi_CreateTimer(30.0, true, true, {}, Timer_Ad)
    luaApi_RunServerCommand("mp_warmuptime 60")
    luaApi_RunServerCommand("mp_limitteams 3")
    luaApi_RunServerCommand("mp_buytime 300")
    local parmas = {}
    luaApi_CreateTimer(3, true, true, parmas, Timer_CheckPlayerWeapon)
end
