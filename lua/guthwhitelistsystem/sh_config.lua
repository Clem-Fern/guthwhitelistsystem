AddCSLuaFile()

guthwhitelistsystem = guthwhitelistsystem or {}

--  > CONFIGURATION <  --

--  < In seconds, how many seconds it takes to make a save of whitelists
guthwhitelistsystem.TimerSaveTime   =   120

--  < In bits, (network optimisation), how much job ID is maximum in bits (don't touch it if
--  < you don't need/know). For example, 7 bits accept 127 in maximum and 0 in minimum. If you
--  < have more than 127 jobs, up this number.
guthwhitelistsystem.JobIDBit       =   8

--  < All the Admin ranks, they have access to whitelist panel (they can whitelist peoples and jobs)
guthwhitelistsystem.AdminRanks        =
                    {
                        ["superadmin"] = true,
                    }

--  < Language: choice between 'en' and 'fr'
guthwhitelistsystem.Language          =  "en"

--  < The chat command to enter to open the whitelist panel
guthwhitelistsystem.ChatCommand       =  "!whitelist"

print( "\tLoaded : sh_config.lua." )
