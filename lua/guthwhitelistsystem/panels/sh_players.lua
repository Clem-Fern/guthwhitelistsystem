if SERVER then

    -- WHITELIST JOB
    util.AddNetworkString( "guthwhitelistsystem:SetWhitelist" )
    net.Receive( "guthwhitelistsystem:SetWhitelist", function( _, ply )
        if not ply or not ply:IsValid() then return end
        if not ply:WLIsAdmin() then return end

        local id = net.ReadString() or ply:SteamID()
        local job = net.ReadUInt( guthwhitelistsystem.JobIDBit )
        local bool = net.ReadBool()
        guthwhitelistsystem:WLSetPlayerJobWhitelist(id, job, bool, ply )
    end )

end

if not CLIENT then return end

guthwhitelistsystem.setPanel( guthwhitelistsystem.getLan( "Players" ), "icon16/user_gray.png", 1, function( sheet, w, h )

    local pnlP = vgui.Create( "DPanel", sheet ) -- panel players

    local ply = LocalPlayer()
    local steamID_target = ply:SteamID()

    local panel = vgui.Create("DPanel", pnlP) 
    panel:Dock( LEFT )
    panel:SetWidth( 250 )
    panel:DockMargin( 10, 10, 0, 10 )

    local listP = vgui.Create( "DListView", panel )
    local steamIDfield = vgui.Create("DTextEntry", panel)

    local listJ = vgui.Create( "DListView", pnlP )
    local jobChoice = vgui.Create( "DComboBox", pnlP )

    --  > List of Players
        listP:Dock( FILL )
        listP:SetMultiSelect( false )
        listP:AddColumn( guthwhitelistsystem.getLan( "Players" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "SteamID" ) )

        function listP:Actualize()
            listP:Clear()
            for _, v in pairs( player.GetAll() ) do
                listP:AddLine( v:Name(), v:SteamID() )
            end
        end

        listP:Actualize()

        function listP:OnRowSelected()
            local steamid = listP:GetLines()[listP:GetSelectedLine() or 1]:GetValue( 2 )
            local trg = player.GetBySteamID( steamid )
            if trg then
                steamID_target = steamid 
                listJ:Actualize()
            end

            surface.PlaySound( "UI/buttonclick.wav" )
        end
        function listP:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlP )

            local n = m:AddOption( guthwhitelistsystem.getLan( "Copy Name" ), function()
                SetClipboardText( line:GetColumnText( 1 ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyName" )):format( steamID_target ), 3, Color( 210, 210, 210 ) )
            end )
            n:SetIcon( "icon16/page_copy.png" )

            local sid = m:AddOption( guthwhitelistsystem.getLan( "Copy SteamID" ), function()
                SetClipboardText( line:GetColumnText( 2 ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopySteamID" )):format( steamID_target ), 3, Color( 210, 210, 210 ) )
            end )
            sid:SetIcon( "icon16/page_copy.png" )

            local nsid = m:AddOption( guthwhitelistsystem.getLan( "Copy NameSteamID" ), function()
                SetClipboardText( ("%s : %s"):format( line:GetColumnText( 1 ), line:GetColumnText( 2 ) ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyNameSteamID" )):format( steamID_target ), 3, Color( 210, 210, 210 ) )
            end )
            nsid:SetIcon( "icon16/page_copy.png" )

            m:Open()
        end

    --  > steamID field
        steamIDfield:Dock( BOTTOM )
        steamIDfield:DockMargin(0, 3, 0, 0)
        steamIDfield:SetPlaceholderText( "Player SteamID...." )

        local function validSteamID(steamid)
            local result
            local status, exception = pcall(function()
                findedSteamId = string.sub(steamid, string.find(steamid, "STEAM_%d:%d:%d%d%d%d%d%d%d%d+"))
                if( steamid == findedSteamId ) then result = findedSteamId end
            end)
            return result
        end

        function steamIDfield:OnChange()
            // valid steam id
            if steamIDfield:GetValue():len() < 18 then
                steamID_target = "none"
                listJ:Clear()
                return
            end
            local steamid = validSteamID(steamIDfield:GetValue())
            if not steamid or steamid:len() < 18 then
                steamID_target = "none"
                listJ:Clear()
                return
            end
            steamID_target = steamid
            listJ:Actualize()
        end

        function steamIDfield:OnEnter()
            if steamIDfield:GetValue():len() < 18 then
                guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectTarget" ), 3, Color( 214, 45, 45 ) )
                steamID_target = "none"
                listJ:Clear()
                return
            end
		    steamIDfield:OnChange()
	    end

    --  > List of Jobs
        listJ:Dock( FILL )
        listJ:DockMargin( 10, 10, 10, 10 )
        listJ:SetMultiSelect( false )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Jobs" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Date" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Time" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "By" ) )
        function listJ:Actualize()
            listJ:Clear()

            if not steamID_target or steamID_target == "none" then return end

            for k, v in pairs( guthwhitelistsystem:WLGetPlayerWhitelists(steamID_target) ) do
                local txt = ("%s (%d)"):format( team.GetName( k ), k )
                if v.by and player.GetBySteamID( v.by ) then
                    local byP = player.GetBySteamID( v.by )
                    local by = ("%s(%s)"):format( byP:GetName(), byP:SteamID() )
                    listJ:AddLine( txt, v.date or "?", v.time or "?", by )
                else
                    listJ:AddLine( txt, v.date or "?", v.time or "?", v.by or "Unknow" )
                end
            end
        end
        function listJ:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlP )

            local remove = m:AddOption( guthwhitelistsystem.getLan( "RemoveWhitelist" ) , function()
                local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                if not id then return end
                id = tonumber( string.match( id, "(%d+)" ) )

                if not id then return end
                if not ply:WLIsAdmin() then
                    guthwhitelistsystem.panelNotif( pnlP, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ) , 3, Color( 214, 45, 45 ) )
                    return
                end
                if not steamID_target or steamID_target == "none" then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectTarget" ), 3, Color( 214, 45, 45 ) ) end
                
                net.Start( "guthwhitelistsystem:SetWhitelist" )
                    net.WriteString( steamID_target )
                    net.WriteUInt( id, guthwhitelistsystem.JobIDBit )
                    net.WriteBool( false )
                net.SendToServer()

                guthwhitelistsystem:WLSetPlayerJobWhitelist( steamID_target, id, false, LocalPlayer() )

                guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatRemoveWhitelist" )):format( team.GetName( id ), steamID_target) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/delete.png", (guthwhitelistsystem.getLan( "PanelUnwhitelisted" )):format( steamID_target, team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                timer.Simple( 0, function() self:Actualize() end )
            end )
            remove:SetIcon( "icon16/delete.png" )

            m:Open()
        end
        listJ:SelectFirstItem()

    --  > Choice of Jobs
        jobChoice:Dock( BOTTOM )
        jobChoice:DockMargin( 10, 0, 300, 10 )
        function jobChoice:Actualize()
            self:Clear()

            local i = 0
            for k, v in pairs( guthwhitelistsystem.wlJob or {} ) do
                local select = false
                if i == 0 then select = true end -- select the first job found
                jobChoice:AddChoice( team.GetName( k ), k, select, "icon16/briefcase.png" )
                i = i + 1
            end
            if i == 0 then
                jobChoice:AddChoice( guthwhitelistsystem.getLan( "Any" ), -1, true, "icon16/exclamation.png" )
            end
        end
        function jobChoice:OnSelect()
            surface.PlaySound( "UI/buttonclick.wav" )
        end
        jobChoice:Actualize()

    local addButton = vgui.Create( "DImageButton", pnlP )
        addButton:SetPos( 380, 401 )
        addButton:SetSize( 16, 16 )
        addButton:SetImage( "icon16/add.png" )
        function addButton:DoClick()
            surface.PlaySound( "UI/buttonclickrelease.wav" )

            if not ply:WLIsAdmin() then
                guthwhitelistsystem.panelNotif( pnlP, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                return
            end

            local _, id = jobChoice:GetSelected()
            if not id or id == -1 then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectJob" ), 3, Color( 214, 45, 45 ) ) end
            if not steamID_target or steamID_target == "none" then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectTarget" ), 3, Color( 214, 45, 45 ) ) end
            if guthwhitelistsystem:WLGetPlayerJobWhitelist(steamID_target, id ) then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", (guthwhitelistsystem.getLan( "PanelAlreadyWhitelist" )):format( steamID_target, team.GetName( id ) ), 3, Color( 214, 45, 45 ) ) end

            net.Start( "guthwhitelistsystem:SetWhitelist" )
                net.WriteString( steamID_target )
                net.WriteUInt( id, guthwhitelistsystem.JobIDBit )
                net.WriteBool( true )
            net.SendToServer()

            guthwhitelistsystem:WLSetPlayerJobWhitelist(steamID_target, id, true, LocalPlayer() )

            guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatAddWhitelist" )):format( team.GetName( id ), steamID_target ) )
            guthwhitelistsystem.panelNotif( pnlP, "icon16/accept.png", (guthwhitelistsystem.getLan( "PanelWhitelisted" )):format( steamID_target, team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

            timer.Simple( 0, function() listJ:Actualize() end )
        end

    local refreshButton = vgui.Create( "DImageButton", pnlP )
        refreshButton:SetPos( 400, 401 )
        refreshButton:SetSize( 16, 16 )
        refreshButton:SetImage( "icon16/arrow_refresh.png" )
        function refreshButton:DoClick()
            surface.PlaySound( "UI/buttonclickrelease.wav" )

            jobChoice:Actualize()
            guthwhitelistsystem.panelNotif( pnlP, "icon16/arrow_refresh.png", guthwhitelistsystem.getLan( "PanelRefreshJob" ), 3, Color( 45, 174, 45 ) )
        end

    -- error
    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelDarkRP" ), -1, Color( 214, 45, 45 ) )
    else -- info
        guthwhitelistsystem.panelNotif( pnlP, "icon16/information.png", guthwhitelistsystem.getLan( "PanelWelcome" ), 3, Color( 45, 45, 214 ) )
    end

    return pnlP

end )
