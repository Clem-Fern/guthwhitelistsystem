if SERVER then

    util.AddNetworkString( "guthwhitelistsystem:SetJobWhitelist" )
    net.Receive( "guthwhitelistsystem:SetJobWhitelist", function( _, ply )
        if not ply or not ply:IsValid() then return end
        if not ply:WLIsAdmin() then return end

        local job = net.ReadUInt( guthwhitelistsystem.JobIDBit )
        local bool = net.ReadBool()
        guthwhitelistsystem:WLSetJobWhitelist( job, bool or false)
    end )

end

if not CLIENT then return end

guthwhitelistsystem.setPanel( guthwhitelistsystem.getLan( "Jobs" ), "icon16/briefcase.png", 2, function( sheet )

    local pnlJ = vgui.Create( "DPanel", sheet ) -- panel jobs
    local ply = LocalPlayer()

    local targetJobId

    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlJ, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelDarkRP" ), -1, Color( 214, 45, 45 ) )
    end

    local listJ = vgui.Create( "DListView", pnlJ )
    local listP = vgui.Create("DListView", pnlJ) 

    --  > Jobs Whitelist
        listJ:Dock( LEFT )
        listJ:DockMargin( 5, 5, 0, 5 )
        listJ:SetWidth(150)
        listJ:SetMultiSelect( false )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Jobs" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Whitelist ?" ) )
        function listJ:Actualize()
            self:Clear()

            for k, v in pairs( RPExtraTeams or {} ) do
                if k == GAMEMODE.DefaultTeam then continue end -- can't whitelist the DefaultTeam

                local wl = guthwhitelistsystem:WLGetJobWhitelist( k )
                listJ:AddLine( ("%s (%d)"):format( team.GetName( k ), k ), guthwhitelistsystem.getLan( wl.active and "Yes !" or "No !" ) )
            end
        end
        function listJ:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlJ )

            if line:GetValue( 2 ) == guthwhitelistsystem.getLan( "No !" ) then
                local add = m:AddOption( guthwhitelistsystem.getLan( "ActivateWhitelist" ), function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, guthwhitelistsystem.JobIDBit )
                        net.WriteBool( true )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, false )

                    guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatActivateWhitelist" )):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/accept.png", (guthwhitelistsystem.getLan( "PanelWhitelistJob" )):format( team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

                    self:Actualize()
                    listP:Actualize()
                end )
                add:SetIcon( "icon16/accept.png" )
            else
                local remove = m:AddOption( guthwhitelistsystem.getLan( "DesactivateWhitelist" ), function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )

                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, guthwhitelistsystem.JobIDBit )
                        net.WriteBool( false )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, false, false )

                    guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatDesactivateWhitelist" )):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/delete.png", (guthwhitelistsystem.getLan( "PanelUnwhitelistJob" )):format( team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                    self:Actualize()
                end )
                remove:SetIcon( "icon16/delete.png" )
            end

            m:Open()
        end
        function listJ:OnRowSelected()
            local id = string.match( listJ:GetLines()[listJ:GetSelectedLine() or 1]:GetValue( 1 ), "(%(%d+%))$" )
            if not id then return end
            targetJobId = tonumber( string.match( id, "(%d+)" ) )

            listP:Actualize()
            surface.PlaySound( "UI/buttonclick.wav" )
        end
        listJ:Actualize()

    --  > Job Whitelisted Player
        listP:Dock( FILL )
        listP:DockMargin( 5, 5, 5, 5 )
        listP:AddColumn( guthwhitelistsystem.getLan( "Players" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "SteamID" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "Date" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "Time" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "By" ) )

        function listP:Actualize()
            self:Clear()

            if not targetJobId then return end

            for playerWhitelist,_ in pairs(guthwhitelistsystem.wl) do
                local wl = guthwhitelistsystem:WLGetPlayerJobWhitelist( playerWhitelist , targetJobId)
                if wl then
                    local playerName
                    if playerWhitelist and player.GetBySteamID( playerWhitelist ) then
                        local P = player.GetBySteamID( playerWhitelist )
                        playerName = P:GetName()
                    else
                        playerName = "Offline"
                    end

                    local by
                    if wl.by and player.GetBySteamID( wl.by ) then
                        local byP = player.GetBySteamID( wl.by )
                        by = ("%s(%s)"):format( byP:GetName(), byP:SteamID() )
                    else
                        by = wl.by or "Unknow"
                    end
                    
                    listP:AddLine( playerName, playerWhitelist, wl.date or "?", wl.time or "?", by )

                end
            end
        end

        function listP:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlJ )

            local n = m:AddOption( guthwhitelistsystem.getLan( "Copy Name" ), function()
                SetClipboardText( line:GetColumnText( 1 ) )
                guthwhitelistsystem.panelNotif( pnlJ, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyName" )):format( line:GetColumnText( 2 ) ), 3, Color( 210, 210, 210 ) )
            end )
            n:SetIcon( "icon16/page_copy.png" )

            local sid = m:AddOption( guthwhitelistsystem.getLan( "Copy SteamID" ), function()
                SetClipboardText( line:GetColumnText( 2 ) )
                guthwhitelistsystem.panelNotif( pnlJ, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopySteamID" )):format( line:GetColumnText( 2 ) ), 3, Color( 210, 210, 210 ) )
            end )
            sid:SetIcon( "icon16/page_copy.png" )

            local nsid = m:AddOption( guthwhitelistsystem.getLan( "Copy NameSteamID" ), function()
                SetClipboardText( ("%s : %s"):format( line:GetColumnText( 1 ), line:GetColumnText( 2 ) ) )
                guthwhitelistsystem.panelNotif( pnlJ, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyNameSteamID" )):format( line:GetColumnText( 2 ) ), 3, Color( 210, 210, 210 ) )
            end )
            nsid:SetIcon( "icon16/page_copy.png" )

            local remove = m:AddOption( guthwhitelistsystem.getLan( "RemoveWhitelist" ) , function()

                if not ply:WLIsAdmin() then
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ) , 3, Color( 214, 45, 45 ) )
                    return
                end

                if not targetJobId then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectTarget" ), 3, Color( 214, 45, 45 ) ) end
                
                local id = line:GetValue( 2 )
                if not id then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectJob" ), 3, Color( 214, 45, 45 ) ) end

                net.Start( "guthwhitelistsystem:SetWhitelist" )
                    net.WriteString( id )
                    net.WriteUInt( targetJobId, guthwhitelistsystem.JobIDBit )
                    net.WriteBool( false )
                net.SendToServer()

                guthwhitelistsystem:WLSetPlayerJobWhitelist( id, targetJobId, false, LocalPlayer() )

                guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatRemoveWhitelist" )):format( team.GetName( targetJobId ), id) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/delete.png", (guthwhitelistsystem.getLan( "PanelUnwhitelisted" )):format( id, team.GetName( targetJobId ) ), 3, Color( 214, 45, 45 ) )

                timer.Simple( 0, function() self:Actualize() end )
            end )
            remove:SetIcon( "icon16/delete.png" )

            m:Open()
        end

    

    return pnlJ

end )
