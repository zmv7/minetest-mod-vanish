local s = core.get_mod_storage()
vanish = {}
vanish.vanished = {}
vanish.on = function(player)
	vanish.vanished[player:get_player_name()] = true
	player:set_properties({
		visual = "",
		--collisionbox = {-0.01, 0, -0.01, 0.01, 0, 0.01},
		show_on_minimap = false,
		pointable = false,
	})
	player:set_nametag_attributes({color={a=0},text = " "})
end
vanish.off = function(player)
	vanish.vanished[player:get_player_name()] = nil
	local name = player:get_player_name()
	if not name then return end
	player:set_properties({
			 	visual = "mesh",
	 			--collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			 	show_on_minimap = true,
		 		pointable = true,
  		})
	if core.get_modpath("nick_prefix") then
		nick_prefix.update_ntag(name)
	else
		player:set_nametag_attributes({color={a=255,r=255,g=255,b=255},text = name})
	end
end

core.register_privilege("vanish","Allows to make players invisible")
core.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not name then return end
	local isinvis = s:get_string(name)
	if isinvis == "1" then
		core.after(0.1,function()
			vanish.on(player)
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
		local isinvis = s:get_string(param)
		if isinvis == "1" then
			s:set_string(param,"")
			if player then
				vanish.off(player)
			end
			return true, "-!- "..param.." unvanished"
		else
			s:set_string(param,"1")
			if player then
				vanish.on(player)
			end
			return true, "-!- "..param.." vanished"
		end
end})

core.register_chatcommand("vanished",{
	description = "Show list of vanished players",
	privs = {vanish=true},
	func = function(name,param)
		local out = {}
		local tabl = s:to_table().fields
		for nick,val in pairs(tabl) do
			table.insert(out,nick)
		end
	table.sort(out)
		return true, "Vanished: "..table.concat(out,", ")
end})
