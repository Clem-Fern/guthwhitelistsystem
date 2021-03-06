guthwhitelistsystem.languages = guthwhitelistsystem.languages or {}

local l = "en"
guthwhitelistsystem.languages[l] = {}
local function setLan( id, txt )
    guthwhitelistsystem.languages[l][id] = txt
end

--  > language configuration <  --

setLan( "NotifNotWhitelist", "You are not whitelisted !" )

setLan( "Players", "Players" )
setLan( "SteamID", "SteamID" )
setLan( "Jobs", "Jobs" )
setLan( "Date", "Date" )
setLan( "Time", "Time" )
setLan( "By", "By" )
setLan( "Any", "Any" )
setLan( "Whitelist ?", "Whitelist ?" )
setLan( "Yes !", "Yes !" )
setLan( "No !", "No !" )

setLan( "Copy Name", "Copy Name" )
setLan( "CopyName", "You copied name of %s !" )
setLan( "Copy SteamID", "Copy SteamID" )
setLan( "CopySteamID", "You copied SteamID of %s !" )
setLan( "Copy NameSteamID", "Copy Name & SteamID" )
setLan( "CopyNameSteamID", "You copied name and SteamID of %s !" )
setLan( "RemoveWhitelist", "Remove whitelist" )
setLan( "ActivateWhitelist", "Activate whitelist" )
setLan( "WhitelistRemove", "Whitelist Remove" )
setLan( "WhitelistAdd", "Whitelist Add" )
setLan( "DesactivateWhitelist", "Desactivate whitelist" )

setLan( "ChatRemoveWhitelist", "You removed whitelist of %s to %s !" )
setLan( "ChatGetRemoveWhitelist", "You get unwhitelisted of %s by %s !" )
setLan( "ChatAddWhitelist", "You added whitelist of %s to %s !" )
setLan( "ChatGetAddWhitelist", "You get whitelisted of %s by %s !" )
setLan( "ChatActivateWhitelist", "You activated whitelist to %s !" )
setLan( "ChatDesactivateWhitelist", "You desactived whitelist to %s !" )
setLan( "ChatNotAdmin", "You don't have enought privileges !" )
setLan( "ChatOpen", "Panel open !" )
setLan( "ChatClose", "Panel close !" )

setLan( "PanelNotAdmin", "You're not an administrator !" )
setLan( "PanelUnwhitelisted", "%s has been unwhitelisted from %s !" )
setLan( "PanelUnwhitelistJob", "You unwhitelisted the job %s !" )
setLan( "PanelWhitelisted", "%s has been whitelisted to %s !" )
setLan( "PanelWhitelistJob", "You whitelisted the job %s !" )
setLan( "PanelUncorrectJob", "You must select a correct job !" )
setLan( "PanelUncorrectTarget", "You must select a correct target !" )
setLan( "PanelNotWhitelisted", "This job is not whitelisted !" )
setLan( "PanelAlreadyWhitelist", "%s has already been whitelisted %s !" )
setLan( "PanelRefreshJob", "You refreshed the job whitelist choices !" )
setLan( "PanelDarkRP", "This panel can only work in the DarkRP gamemode !" )
setLan( "PanelWelcome", "Welcome to the Guthen Whitelist Panel !" )
