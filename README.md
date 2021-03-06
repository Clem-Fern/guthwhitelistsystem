# guthwhitelistsystem
Garry's Mod job whitelist system for DarkRP.

Demonstration here : https://youtu.be/8DiL5qEkvcw

## How to install it ?

You just need to install it in your addons folder and to configure it in `lua/guthwhitelistsystem/sh_config.lua`.

## How to open the panel ?

Type in your console : `guthwhitelistsystem_panel`
(I recommand to you, to bind it to a key)

## Are there any functions dedicated to developers ?

Yes there are.

#### Players metafunctions :
```lua
--  > : Add/Remove the whitelist of a job to a specified player
--  > #jobId (number): the index of the job
--  > #bool (boolean): 'true' to add the whitelist and 'false' to remove it
--  > #by (optional) (player): Player who add the whitelist
--  > NOTE: Set the whitelist on CLIENT and SERVER because the changes are not networked
Player:WLSetJobWhitelist( jobId, bool, by )

--  > : Add/Remove the whitelist all to a specified player
--  > #bool (boolean): 'true' to add the whitelist all and 'false' to remove it
--  > #by (optional) (player): Player who add the whitelist all
Player:WLSetWhitelistAll( bool, by )

--  > : Return the whitelist information of a job, 'false' if the player is not whitelisted and a table if it is
--  > #jobId (number): the index of the job
Player:WLGetJobWhitelist( jobId )

--  > : Return all the whitelisted jobs of the player (table)
Player:WLGetWhitelists()

--  > : Return if the player is whitelist all
Player:WLIsWhitelistAll()

--  > : Return if the player is admin (defined by the 'sh_config.lua')
Player:WLIsAdmin()

--  > : Return if the player is VIP (defined by the 'sh_config.lua')
Player:WLIsVIP()
```

#### Others functions :
```lua
--  > : Set the whitelist of a specified job
--  > #jobId (number): the index of the job
--  > #bool (boolean): 'true' to add the whitelist and 'false' to remove it
--  > #vip (optional) (boolean): 'true' to add the whitelist to VIP only and 'false' to remove it
--  > NOTE: Set the whitelist on CLIENT and SERVER because the changes are not networked
guthwhitelistsystem:WLSetJobWhitelist( jobId, bool, vip )

--  > : Return the whitelist information of a job, a table is returned
--  > #jobId (number): the index of the job
guthwhitelistsystem:WLGetJobWhitelist( jobId )

--  > : Add a chat text to the specified player (if SERVER) or LocalPlayer (if CLIENT)
--  > #ply (Player): the specified player
--  > #msg (string): the message to display
guthwhitelistsystem.chat( ply, msg ) -- SERVER
guthwhitelistsystem.chat( msg ) -- CLIENT

--  > : Get current language text
--  > #id (string): the id of the text to return
guthwhitelistsystem.getLan( id )
```

## How can I contact you ?

Join my Discord : https://discord.gg/FZ9WVVe
