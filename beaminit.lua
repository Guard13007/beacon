-- This file register beams nodes and particles
local colors = beacon.colors
local green_beam_climbable = beacon.config.green_beam_climbable
-- Register per color beam and base nodes
for _,color in ipairs(colors) do
	
	minetest.register_lbm({
		label = "Beacon without base cleanup for " .. color,
		name = "beacon:orphan_top_cleanup_" .. color,
		nodenames = {"beacon:"..color.."base"},
		run_at_every_load = true,
		action = function(pos, node)
			local node_under = minetest.get_node({ x=pos.x, y=pos.y-1, z=pos.z })
			if node_under.name ~= "beacon:" .. color and node_under.name ~= "ignore" then
				minetest.set_node(pos, { name="air" })
			end
		end
	})

	local beam_climbable = false
	if green_beam_climbable and color == 'green' then  beam_climbable = true end

	-- Base node
	minetest.register_node("beacon:"..color.."base", {
		visual_scale = 1.0,
		drawtype = "plantlike",
		tiles = {color.."base.png"},
		paramtype = "light",
		walkable = false,
		diggable = false,
		climbable = beam_climbable,
		light_source = 13,
		groups = {not_in_creative_inventory=1}
	})

	-- Beam node
	minetest.register_node("beacon:"..color.."beam", {
		visual_scale = 1.0,
		drawtype = "plantlike",
		tiles = {color.."beam.png"},
		paramtype = "light",
		walkable = false,
		diggable = false,
		climbable = beam_climbable,
		light_source = 50,
		groups = {not_in_creative_inventory=1}
	})

	-- Spawn Particles
	minetest.register_abm({
		nodenames = {"beacon:"..color.."base"}, --makes small particles emanate from the beginning of a beam
		interval = 1,
		chance = 2,
		action = function(pos, node)
			minetest.add_particlespawner(
				32, --amount
				4, --time
				{x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25}, --minpos
				{x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25}, --maxpos
				{x=-0.8, y=-0.8, z=-0.8}, --minvel
				{x=0.8, y=0.8, z=0.8}, --maxvel
				{x=0,y=0,z=0}, --minacc
				{x=0,y=0,z=0}, --maxacc
				0.5, --minexptime
				1, --maxexptime
				1, --minsize
				2, --maxsize
				false, --collisiondetection
				color.."particle.png" --texture
			)
		end,
	})

	-- --[[ Clean beam removal abm
	minetest.register_abm({
		nodenames = {"beacon:"..color.."beam"}, 
		interval = 1,
		chance = 2,
		action = function(pos, node)
			under_pos = {x=pos.x, y=pos.y-1, z=pos.z}
			local under_node = minetest.get_node(under_pos)
			if under_node and under_node.name == 'air' then
				minetest.set_node(pos, {name='air'})
			end
		end,
	})
	--]]


end 
