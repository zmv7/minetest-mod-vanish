invis = {}
invisibility = {}

-- [function] Get visible
function invis.get(name)
  if type(name) == "userdata" then
    name = player:get_player_name()
  end

  return invisibility[name]
end

-- [function] Toggle invisibility
function invis.toggle(player, toggle)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local prop
  local name      = player:get_player_name()
  invisibility[name] = toggle

  if toggle == true then
    -- Hide player and nametag
    prop = {
      visual_size = {x = 0, y = 0},
      collisionbox = {-0.01, 0, -0.01, 0.01, 0, 0.01},
      show_on_minimap = false,
      pointable = false,
    }
    --player:set_nametag_attributes({
      --color = {a = 0},
    --})
		status = minetest.colorize("#F00"," vanished")
  else
    -- Show player and nametag
    prop = {
			visual_size = {x = 1, y = 1},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			show_on_minimap = true,
			pointable = true,
		}
		--player:set_nametag_attributes({
		--	color = {a = 35},
		--})
		status = minetest.colorize("#0F0"," unvanished")
  end

  -- Update properties
  player:set_properties(prop)
  return minetest.colorize("#FF0","-!- "..name)..status
end

-- [register] Privilege
minetest.register_privilege("vanish", "Allow use of /vanish command")

-- [register] Command
minetest.register_chatcommand("vanish", {
  description = "Make yourself or another player invisibility",
  params = "<name>",
  privs = {vanish=true},
  func = function(name, param)
    if minetest.get_player_by_name(param) then
      name = param
    elseif param ~= "" then
      return false, "Invalid player \""..param.."\""
    end

    return true, invis.toggle(name, not invisibility[name])
  end,
})
