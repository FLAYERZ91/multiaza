script_name('Multi_Aza')
script_version("1.5")

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require "inicfg"
local keys = require 'vkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
require "lib.moonloader"
local ev = require 'samp.events'
local poff = false
local poff_m4 = false
local poff_sh = false
local poff_ri = false
local deagle = false
local inicfg = require "inicfg"
local cfg = "moonloader\\config\\multiaza.ini"
local cfgfile = 'multiaza.ini'
local cfg1 = inicfg.load({
    allaza = {
        tocraftsh=5,
        craftdeagle=5,
        tocraftm4=5,
        tocraftdeagle=5,
        craftri=1,
        craftsh=5,
        tocraftri=1,
        craftm4=5
    }
}, cfgfile)
if not doesFileExist('moonloader/config/'..cfgfile) then inicfg.save(cfg1, cfgfile) end

update_state = false

local script_version = 5
local script_version_text = "1.5"

local update_url = "https://raw.githubusercontent.com/FLAYERZ91/multiaza/main/update.ini"
local update_path = getWorkingDirectory().."/update.ini"

local script_url = "https://raw.githubusercontent.com/FLAYERZ91/test1/main/autoupdate.lua"
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage(' MultiAza {ffffff}| Version: {f1c232}beta 1.0{ffffff} | Author: {f1c232}flayer {ffffff}| Команда для информации: {F1C232}/zaza', 0xf1c232)
    sampRegisterChatCommand('ade', cmd_deaza)
    sampRegisterChatCommand('am4', cmd_m4aza)
    sampRegisterChatCommand('ari', cmd_riaza)
    sampRegisterChatCommand('ash', cmd_shaza)
    sampRegisterChatCommand('zaza', cmd_zaza)
    sampRegisterChatCommand('ainfo', cmd_infoaza)
    sampRegisterChatCommand('ahelp', cmd_ahelp)
    sampRegisterChatCommand('offaza', function()
		deagle = not deagle
        if deagle == false then
            thisScript():pause()
        elseif deagle == true then
            thisScript():resume()
        end
		sampAddChatMessage(' MultiAza {ffffff}| Скрипт '..(deagle and 'выключен' or 'включен'), 0xf1c232)
	end)
    lua_thread.create(deagle())

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname()

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.version) > script_version then
                sampAddChatMessage('Available update'..updateIni.info.version_text, -1)
                update_state = true
            end
        end
    end)
    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage('script upd', -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end

function deagle()
    while true do
        wait(1)
        ammo_deagle = getAmmoInCharWeapon(PLAYER_PED, 24)
        local ccfg = inicfg.load(nil, cfg)
        _, pedid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local gg_tocraftdeagle = tonumber(ccfg.allaza.tocraftdeagle)
        local gg_craftdeagle = tonumber(ccfg.allaza.craftdeagle)
        local x = string.format("", ammo_deagle, gg_tocraftdeagle, gg_craftdeagle)
        if poff == false then
            prevammo_deagle = getAmmoInCharWeapon(PLAYER_PED, 24)
            if prevammo_deagle == gg_tocraftdeagle then
                sampSendChat(string.format('/sellgun deagle %d 100 %d', gg_craftdeagle, pedid))
                wait(555)
                nowammo_deagle = getAmmoInCharWeapon(PLAYER_PED)
                if prevammo_deagle == nowammo_deagle then
                    poff = true
                    sampAddChatMessage(' MultiAza {ffffff}| Ошибка. Код: {f1c232}0', 0xf1c232)
                end
            end
        end
        
        ammo_m4 = getAmmoInCharWeapon(PLAYER_PED, 31)
        local gg_tocraftm4 = tonumber(ccfg.allaza.tocraftm4)
        local gg_craftm4 = tonumber(ccfg.allaza.craftm4)
        local z = string.format("", ammo_m4, gg_tocraftm4, gg_craftm4)
        if poff_m4 == false then
            prevammo_m4 = getAmmoInCharWeapon(PLAYER_PED, 31)
            if prevammo_m4 == gg_tocraftm4 then
                sampSendChat(string.format('/sellgun m4 %d 100 %d', gg_craftm4, pedid))
                wait(555)
                nowammo_m4 = getAmmoInCharWeapon(PLAYER_PED)
                if prevammo_m4 == nowammo_m4 then
                    poff_m4 = true
                    sampAddChatMessage(' MultiAza {ffffff}| Ошибка. Код: {f1c232}1', 0xf1c232)
                end
            end
        end

        ammo_sh = getAmmoInCharWeapon(PLAYER_PED, 25)
        local gg_tocraftsh = tonumber(ccfg.allaza.tocraftsh)
        local gg_craftsh = tonumber(ccfg.allaza.craftsh)
        local y = string.format("", ammo_sh, gg_tocraftsh, gg_craftsh)
        if poff_sh == false then
            prevammo_sh = getAmmoInCharWeapon(PLAYER_PED, 25)
            if prevammo_sh == gg_tocraftsh then
                sampSendChat(string.format('/sellgun shotgun %d 100 %d', gg_craftsh, pedid))
                wait(555)
                nowammo_sh = getAmmoInCharWeapon(PLAYER_PED)
                if prevammo_sh == nowammo_sh then
                    poff_sh = true
                    sampAddChatMessage(' MultiAza {ffffff}| Ошибка. Код: {f1c232}2', 0xf1c232)
                end
            end
        end

        ammo_ri = getAmmoInCharWeapon(PLAYER_PED, 33)
        local gg_tocraftri = tonumber(ccfg.allaza.tocraftri)
        local gg_craftri = tonumber(ccfg.allaza.craftri)
        local y = string.format("", ammo_sh, gg_tocraftri, gg_craftri)
        if poff_ri == false then
            prevammo_ri = getAmmoInCharWeapon(PLAYER_PED, 33)
            if prevammo_ri == gg_tocraftri then
                wait(777)
                sampSendChat(string.format('/sellgun rifle %d 100 %d', gg_craftri, pedid))
                wait(555)
                nowammo_ri = getAmmoInCharWeapon(PLAYER_PED)
                if prevammo_ri == nowammo_ri then
                    poff_ri = true
                    sampAddChatMessage(' MultiAza {ffffff}| Ошибка. Код: {f1c232}3', 0xf1c232)
                end
            end
        end
    end
end

function cmd_deaza(arg)
	if #arg == 0 then 
		sampAddChatMessage(" MultiAza {ffffff}| Используй {fff2cc}/ade {ffffff}[Патроны для крафта] [Количество патрон крафта]", 0xf1c232)
	else
		var1, var2 = string.match(arg, "(.+) (.+)")
		local ccfg = inicfg.load(nil, cfg)
		ccfg.allaza.tocraftdeagle = var1
		ccfg.allaza.craftdeagle = var2
		local scfg = inicfg.save(ccfg, cfg)
		sampAddChatMessage(" MultiAza {ffffff}| Сохранил | {fff2cc}[Deagle] {FFFFFF}Патроны для крафта: {fff2cc}"..ccfg.allaza.tocraftdeagle.." {FFFFFF}& Кол-во патрон крафта: {fff2cc}"..ccfg.allaza.craftdeagle, 0xf1c232)
	end
end

function cmd_m4aza(arg)
	if #arg == 0 then 
		sampAddChatMessage(" MultiAza {ffffff}| Используй {fff2cc}/am4 {ffffff}[Патроны для крафта] [Количество патрон крафта]", 0xf1c232)
	else
		var1, var2 = string.match(arg, "(.+) (.+)")
		local ccfg = inicfg.load(nil, cfg)
		ccfg.allaza.tocraftm4 = var1
		ccfg.allaza.craftm4 = var2
		local scfg = inicfg.save(ccfg, cfg)
		sampAddChatMessage(" MultiAza {ffffff}| Сохранил | {fff2cc}[M4] {FFFFFF}Патроны для крафта: {fff2cc}"..ccfg.allaza.tocraftm4.." {FFFFFF}& Кол-во патрон крафта: {fff2cc}"..ccfg.allaza.craftm4.."", 0xf1c232)
	end
end

function cmd_shaza(arg)
	if #arg == 0 then 
		sampAddChatMessage(" MultiAza {ffffff}| Используй {fff2cc}/ash {ffffff}[Патроны для крафта] [Количество патрон крафта]", 0xf1c232)
	else
		var1, var2 = string.match(arg, "(.+) (.+)")
		local ccfg = inicfg.load(nil, cfg)
		ccfg.allaza.tocraftsh = var1
		ccfg.allaza.craftsh = var2
		local scfg = inicfg.save(ccfg, cfg)
		sampAddChatMessage(" MultiAza {ffffff}| Сохранил | {fff2cc}[Shotgun] {FFFFFF}Патроны для крафта: "..ccfg.allaza.tocraftsh.." & Кол-во патрон крафта: "..ccfg.allaza.craftsh.."", 0xf1c232)
	end
end

function cmd_riaza(arg)
	if #arg == 0 then 
		sampAddChatMessage(" MultiAza {ffffff}| Используй {fff2cc}/ari {ffffff}[Патроны для крафта] [Количество патрон крафта]", 0xf1c232)
	else
		var1, var2 = string.match(arg, "(.+) (.+)")
		local ccfg = inicfg.load(nil, cfg)
		ccfg.allaza.tocraftri = var1
		ccfg.allaza.craftri = var2
		local scfg = inicfg.save(ccfg, cfg)
		sampAddChatMessage(" MultiAza {ffffff}| Сохранил | {fff2cc}[Rifle] {FFFFFF}Патроны для крафта: {fff2cc}"..ccfg.allaza.tocraftri.." {FFFFFF}& Кол-во патрон крафта: {fff2cc}"..ccfg.allaza.craftri.."", 0xf1c232)
	end
end

function cmd_ahelp()
    sampAddChatMessage(' MultiAza {ffffff}| Помощь по скрипту:', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Патроны для крафта - это количество патрон в обойме при которых будет происходить крафт', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Кол-во патрон - это количество патрон которые будут крафтиться', 0xf1c232)
end

function cmd_zaza()
    sampAddChatMessage(' MultiAza {ffffff}| {ffffff}Скрипт сделан для канала {f1c232}@etstoorg8888', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/ade{ffffff} - настройка AntiZeroAmmo для оружия {f1c232}Deagle', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/am4{ffffff} - настройка AntiZeroAmmo для оружия {f1c232}M4', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/ash{ffffff} - настройка AntiZeroAmmo для оружия {f1c232}Shotgun', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/ari{ffffff} - настройка AntiZeroAmmo для оружия {f1c232}Rifle', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/offaza{ffffff} - включение/отключение скрипта', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/ainfo{ffffff} - выводит информацию актуальных настроек AntiZeroAmmo', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| {fff2cc}/ahelp{ffffff} - выводит в чат информацию о переменных которые вводятся в командах AntiZeroAmmo', 0xf1c232)
end

function cmd_infoaza()
    local ccfg = inicfg.load(nil, cfg)
    sampAddChatMessage(' MultiAza {ffffff}| Актуальные настройки из конфига:', 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Настройки {fff2cc}Deagle{ffffff}: Патроны для крафта {fff2cc}'..ccfg.allaza.tocraftdeagle..'{ffffff} & Кол-во патрон: {fff2cc}'..ccfg.allaza.craftdeagle, 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Настройки {fff2cc}M4{ffffff}: Патроны для крафта: {fff2cc}'..ccfg.allaza.tocraftm4..'{ffffff} & Кол-во патрон: {fff2cc}'..ccfg.allaza.craftm4, 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Настройки {fff2cc}Shotgun{ffffff}: Патроны для крафта: {fff2cc}'..ccfg.allaza.tocraftsh..'{ffffff} & Кол-во патрон: {fff2cc}'..ccfg.allaza.craftsh, 0xf1c232)
    sampAddChatMessage(' MultiAza {ffffff}| Настройки {fff2cc}Rifle{ffffff}: Патроны для крафта: {fff2cc}'..ccfg.allaza.tocraftri..'{ffffff} & Кол-во патрон: {fff2cc}'..ccfg.allaza.craftri, 0xf1c232)
end

function ev.onServerMessage(color, text)
    if text:find(' Осталось материалов') then
        deagle = false
    end
    if text:find(' У вас недостаточно материалов') then
        deagle = false
        sampAddChatMessage(' MultiAza {ffffff}| Скрипт был отключен из-за нехватки материалов', 0xf1c232)
        sampAddChatMessage(' MultiAza {ffffff}| Для включения скрипта напишите - {fff2cc}/offaza', 0xf1c232)
    end
    if text:find(' материалов с собой') then
        deagle = false
        sampAddChatMessage(' MultiAza {ffffff}| Скрипт был автоматически включен из-за пополнения материалов', 0xf1c232)
    end
    if text:find(' Вам недоступная данная команда') then
        deagle = false
        sampAddChatMessage(' MultiAza {ffffff}| Не могу скрафтить. Скрипт был отключен', 0xf1c232)
        sampAddChatMessage(' MultiAza {ffffff}| Для включения скрипта напишите - {fff2cc}/offaza', 0xf1c232)
    end
    if text:find(' Запрещено крафтить оружие') then
        deagle = false
        sampAddChatMessage(' MultiAza {ffffff}| Не могу скрафтить. Скрипт был отключен', 0xf1c232)
        sampAddChatMessage(' MultiAza {ffffff}| Для включения скрипта напишите - {fff2cc}/offaza', 0xf1c232)
    end
end
