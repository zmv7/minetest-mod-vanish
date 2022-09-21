local list = core.get_mod_storage()
local function invis_on(player)
    player:set_properties({
        visual = "",
        collisionbox = {-0.01, 0, -0.01, 0.01, 0, 0.01},
        show_on_minimap = false,
        pointable = false,
    })
    player:set_nametag_attributes({color={a=0},text = " "})
end
local function invis_off(player)
    local name = player:get_player_name()
    if not name then return end
    player:set_properties({
		     	visual_size = {x = 1, y = 1, z = 1},
     			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		     	show_on_minimap = true,
	     		pointable = true,
  		})
    if core.get_modpath("ranks") then
        local rank,color = ranks.get_rank(name)
        if rank and color then
            player:set_nametag_attributes({color={a=255,r=255,g=255,b=255},text = core.colorize(color,rank).." "..name})
        else
            player:set_nametag_attributes({color={a=255,r=255,g=255,b=255},text = name})
        end
    else
        player:set_nametag_attributes({color={a=255,r=255,g=255,b=255},text = name})
    end
end
core.register_privilege("vanish","Allows to make players invisible")
core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if not name then return end
    local isinvis = list:get_string(name)
    if isinvis == "1" then
        core.after(0.1,function()
            invis_on(player)
        end)
    end
end)
core.register_chatcommand("vanish",{
    description = "Toggle invisibility of player",
    privs = {vanish=true},
    params = "<name>",
    func = function(name,param)
        if param == "" then param = name end
        local player = core.get_player_by_name(param)
        local isinvis = list:get_string(param)
        if isinvis == "1" then
            list:set_string(param,"")
            if player then
                invis_off(player)
            end
            return true, "-!- "..param.." unvanished"
        else
            list:set_string(param,"1")
            if player then
                invis_on(player)
            end
            return true, "-!- "..param.." vanished"
        end
end})
      
core.register_chatcommand("vanished",{
    description = "Show list of vanished players",
    privs = {vanish=true},
    func = function(name,param)
        local msg = "Vanished: "
        local tabl = list:to_table().fields
        for nick,val in pairs(tabl) do
            msg = msg..nick..", "
        end
        return true, msg:sub(1,-3)
end})
