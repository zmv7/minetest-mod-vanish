invisibility = {}
local invisible = {}

-- [function] Get visible
function invisibility.get(name)
  if type(name) == "userdata" then
    name = player:get_player_name()
  end

  return invisible[name]
end

-- [function] Toggle invisible
function invisibility.toggle(player, toggle)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local prop
  local name      = player:get_player_name()
  invisible[name] = toggle

  if toggle == true then
    -- Hide player and nametag
    prop = {
      visual_size = {x = 0, y = 0},
      collisionbox = {-0.01, 0, -0.01, 0.01, 0, 0.01},
      show_on_minimap = false,
      pointable = false,
    }
    player:set_nametag_attributes({
      color = {a = 0, r = 255, g = 255, b = 255},
    })
  else
    -- Show player and nametag
    prop = {
			visual_size = {x = 1, y = 1},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			show_on_minimap = true,
			pointable = true,
		}
		player:set_nametag_attributes({
			color = {a = 255, r = 255, g = 255, b = 255},
		})
  end

  -- Update properties
  player:set_properties(prop)
end

-- [register] Privilege
minetest.register_privilege("vanish", "Allow use of /vanish command")

-- [register] Command
minetest.register_chatcommand("vanish", {
  description = "Make yourself or another player invisible",
  params = "<name>",
  privs = {vanish=true},
  func = function(name, param)
    if minetest.get_player_by_name(param) then
      name = param
    elseif param ~= "" then
      return false, "Invalid player \""..param.."\""
    end

    return true, invisibility.toggle(name, not invisible[name])
  end,
})
