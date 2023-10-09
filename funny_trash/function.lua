CS_TEAM_NONE = 0
CS_TEAM_SPECTATOR = 1
CS_TEAM_T = 2
CS_TEAM_CT = 3
HP_BONUS_HS = 35
HP_BONUS_BODY = 20
HP_BONUS_HS_VIP = 45
HP_BONUS_BODY_VIP = 30
CHAT_TYPE_NOTIFY = 1
CHAT_TYPE_CONSOLE = 2
CHAT_TYPE_TALK = 3
CHAT_TYPE_CENTER = 4
WEAPON_PISTOLS = {
"weapon_deagle",
"weapon_elite",
"weapon_fiveseven",
"weapon_glock",
"weapon_hkp2000",
"weapon_p250",
"weapon_tec9",
"weapon_usp_silencer",
"weapon_cz75a",
"weapon_revolver",
}
WEAPON_EZNAME_FULLNAME = {
"bizon",
"mac10",
"mp7",
"mp9",
"p90",
"ump45",
"ak47",
"aug",
"famas",
"galilar",
"m4a4",
"m4a1_silencer",
"m4a1",
"a1",
"sg556",
"awp",
"g3sg1",
"ssg08",
"scar20",
"mag7",
"nova",
"sawedoff",
"xm1014",
"m249",
"negev",
"deagle",
"elite",
"fiveseven",
"glock",
"hkp2000",
"p250",
"tec9",
"usp_silencer",
"cz75a",
"revolver",
"kevlar",
"he",
"molotov",
}
PLAYER_SAVE_WEAPON_TABLE = {}
function SplitString(inputStr, sep)
    if sep == nil then
        return nil
    end
    local t={}
    for str in string.gmatch(inputStr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
function AddHealthPoint(player, isHeadShot)
    local nowhealtPoint = luaApi_GetPlayerHealth(player)
    local newHp = nowhealtPoint;
    if isHeadShot == 1 then
        newHp = nowhealtPoint + HP_BONUS_HS
    else
        newHp = nowhealtPoint + HP_BONUS_BODY
    end
    if newHp >= 100 then
        newHp = 100
    end
	luaApi_SetPlayerHealth(player, newHp)
end
function AddArmor(player, isHeadShot)
    local nowhealtPoint = luaApi_GetPlayerArmorValue(player)
    local newHp = nowhealtPoint;
    if isHeadShot == 1 then
        newHp = nowhealtPoint + HP_BONUS_HS
    else
        newHp = nowhealtPoint + HP_BONUS_BODY
    end
    if newHp >= 100 then
        newHp = 100
    end
	luaApi_SetPlayerArmorValue(player, newHp)
end
function GivePlayerWeapon(player, weaponName)
    local isSuccess = luaApi_GivePlayerWeapon(player, weaponName)
    print("isSuccess: " .. tostring(isSuccess))
end
function IsWeaponInPistolList(weaponName)
    for index, name in pairs(WEAPON_PISTOLS) do
        if name == weaponName then
            return true
        end
    end
    return false
end
function PlayerHaveSomeItem(playerIndex,ItemName)
    local playerWeapons = luApi_GetPlayerAllWeaponIndex(playerIndex)
    --lazy ,fix me
    for i, weaponIndex in ipairs(playerWeapons) do
        local weaponInfo = luaApi_GetPlayerWeaponInfo(playerIndex, weaponIndex)
        if weaponInfo.isSuccess then
            if ItemName == weaponInfo.weaponName then
                return true
            end
        end
    end
    return false
end
function RemovePlayerALLWeaponExcludeNade(playerIndex)
    local playerWeapons = luApi_GetPlayerAllWeaponIndex(playerIndex)
    --lazy ,fix me
    for i, weaponIndex in ipairs(playerWeapons) do
        local weaponInfo = luaApi_GetPlayerWeaponInfo(playerIndex, weaponIndex)
        if weaponInfo.isSuccess then
            if WeaponSimpleNameIsNade(weaponInfo.weaponName) == false and WeaponSimpleNameIsKnifeOrHealthItem(weaponInfo.weaponName) == false then
                luaApi_RemovePlayerWeapon(playerIndex, weaponIndex)
            end
        end
    end
end
function RemovePlayerALLWeaponExcludeKnife(playerIndex)
    local playerWeapons = luApi_GetPlayerAllWeaponIndex(playerIndex)
    --lazy ,fix me
    for i, weaponIndex in ipairs(playerWeapons) do
        local weaponInfo = luaApi_GetPlayerWeaponInfo(playerIndex, weaponIndex)
        if weaponInfo.isSuccess then
            if WeaponSimpleNameIsKnifeOrHealthItem(weaponInfo.weaponName) == false then
                luaApi_RemovePlayerWeapon(playerIndex, weaponIndex)
            end
        end
    end
end
function ExistsIntable(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
function WeaponSimpleNameIsNade(weaponSimpleName)
    if weaponSimpleName == "weapon_molotov" or weaponSimpleName == "weapon_hegrenade" then
        return true
    end
    return false
end
function WeaponSimpleNameIsKnifeOrHealthItem(weaponSimpleName)
    if weaponSimpleName == "weapon_knife_t" or weaponSimpleName == "weapon_c4" or weaponSimpleName == "weapon_knife_ct" or weaponSimpleName == "weapon_knife" or  weaponSimpleName == "weapon_healthshot" then
        return true
    end
    return false
end
function SendMessageToAll(player, message, hubType)
    luaApi_SendToPlayerChat(player, hubType, message)
end
