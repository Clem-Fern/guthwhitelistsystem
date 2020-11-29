guthwhitelistsystem.wl = guthwhitelistsystem.wl or {}
guthwhitelistsystem.wlJob = guthwhitelistsystem.wlJob or {}

local Player = FindMetaTable( "Player" )

if SERVER and guthlogsystem then guthlogsystem.addCategory( "guthwhitelistsystem", Color( 142, 68, 173 ) ) end

--  > Make some players meta

function Player:WLIsAdmin()
    return guthwhitelistsystem.AdminRanks[self:GetUserGroup()]
end

--  > Make some functions

function guthwhitelistsystem:WLSetPlayerJobWhitelist( steamid, job, bool, by )
    if not job or not isnumber( job ) then return error( "#1 argument must be valid and be a number !", 2 ) end
    if job == GAMEMODE.DefaultTeam then return end -- can't whitelist the DefaultTeam
    if not guthwhitelistsystem.wl[steamid] then -- create player table if not existing
        guthwhitelistsystem.wl[steamid] = {}
    end
    if guthwhitelistsystem.wl[steamid][job] and bool == true then return end -- don't make modification (time & date) if you are already whitelist

    by = by and by:IsPlayer() and by:SteamID() or not by == nil and by or "Unknow"

    if bool == true then
        guthwhitelistsystem.wl[steamid][job] =
            {
                date = os.date( "%d/%m/%Y", os.time() ),
                time = os.date( "%H:%M:%S", os.time() ),
                by = by,
            }
    elseif bool == false then
        guthwhitelistsystem.wl[steamid][job] = nil
    end

    if SERVER then
        for _, v in pairs( player.GetAll() ) do
            if not v:WLIsAdmin() then continue end
            v:WLSendData()
        end
        --  >   guthlogsystem
        if guthlogsystem then
            local whitelist = bool and "whitelisted" or "unwhitelisted"
            local msg = by and ("by ?%s?"):format( by ) or ""
            guthlogsystem.addLog( "guthwhitelistsystem", ("%s has been %s to &%s& %s"):format(guthwhitelistsystem, whitelist, team.GetName( job ), msg ) )
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s to %s by %s !"):format( job, team.GetName( job ), steamid, tostring( bool ), by ) )
end

function guthwhitelistsystem:WLGetPlayerJobWhitelist( steamid, job )
    local wl = guthwhitelistsystem.wl[steamid == "NULL" and "BOT" or steamid]
    return wl and wl[job] or false
end

function guthwhitelistsystem:WLGetPlayerWhitelists(steamid)
    return guthwhitelistsystem.wl[steamid == "NULL" and "BOT" or steamid] or {}
end

function guthwhitelistsystem:WLSetJobWhitelist( job, bool )
    if not job or not isnumber( job ) then return error( "#1 argument must be valid and be a number !", 2 ) end
    if job == GAMEMODE.DefaultTeam then return end -- can't whitelist the DefaultTeam
    if not guthwhitelistsystem.wlJob[job] then
        guthwhitelistsystem.wlJob[job] = {}
    end

    if bool then
        guthwhitelistsystem.wlJob[job] =
            {
                active = isbool( bool ) and bool or false,
            }
    else
        guthwhitelistsystem.wlJob[job] = nil
        for v,_ in pairs( guthwhitelistsystem.wl ) do
            local wl = guthwhitelistsystem.wl[v]
            if wl and wl[job] then wl[job] = nil end
        end
    end

    if SERVER then
        for _, v in pairs( player.GetAll() ) do
            if not v:WLIsAdmin() then continue end
            v:WLSendData()
        end
        --  >   guthlogsystem
        if guthlogsystem then
            local whitelist = bool and "whitelisted" or "unwhitelisted"
            guthlogsystem.addLog( "guthwhitelistsystem", ("&%s& has been %s %s"):format( team.GetName( job ), whitelist) )
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s !"):format( job, team.GetName( job ), tostring( bool ) ) )
end

function guthwhitelistsystem:WLGetJobWhitelist( job )
    return guthwhitelistsystem.wlJob[job] or {}
end
