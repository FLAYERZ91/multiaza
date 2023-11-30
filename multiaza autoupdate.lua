script_name('Multi_Aza')
script_version("30.11.2023")
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/FLAYERZ91/multiaza/main/version.json?token=GHSAT0AAAAAACK7TXVY6W7BXKJ5DYHYHB2UZLIMNOQ" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://raw.githubusercontent.com/FLAYERZ91/multiaza/main/multiaza%20autoupdate.lua?token=GHSAT0AAAAAACK7TXVYFH4QWFPZQI3NOEUIZLIMNCA"
        end
    end
end

local encoding = require "encoding"
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

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    sampAddChatMessage(' MultiAza {ffffff}| Version: {f1c232}beta 0.1{ffffff} | Author: {f1c232}flayer {ffffff}| Команда для информации: {F1C232}/zaza', 0xf1c232)
    sampAddChatMessage(' MultiAza {FFFFFF}| Version: {f1c232}beta 0.2{ffffff} | Author: {f1c232}flayer {ffffff}| Команда для информации: {f1c232}/zaza', -1)
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
