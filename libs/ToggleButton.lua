_meta = _meta or {}
_meta.ToggleButton = {}
_meta.ToggleButton.__class = 'toggle_button'
_meta.ToggleButton.__methods = {}

function ToggleButton(args) -- constructs the object, but does not initialize it
	local tb = {}
	tb._track = {}
	tb._track._class = 'toggle button'

	tb._track._x = args.x
	tb._track._y = args.y
	tb._track._var = args.var
	tb._track._state = _G[args.var]
	tb._track._iconDown = args.iconDown
	tb._track._iconUp = args.iconUp
	tb._track._mouse_event = nil
	tb._track._update_event = nil
	tb._track._suppress = false
	--tb._track._startPressed = args.startPressed
	if args.invert then
		tb._track._invert = true
	else
		tb._track._invert = false
	end
	tb._track._pressed = _G[tb._track._var] ~= tb._track._invert
	
	return setmetatable(tb, _meta.ToggleButton)	
end

_meta.ToggleButton.__methods['draw'] = function(tb) -- Finishes initialization and draws the graphics
	local self = tostring(tb)
	-- draw the button
	windower.prim.create(self)
	windower.prim.set_visibility(self, true)
	windower.prim.set_position(self, tb._track._x, tb._track._y)
	windower.prim.set_texture(self, windower.addon_path..'data/graphics/icon_button.png')
	windower.prim.set_fit_to_texture(self, true)
	-- blue square to darken the button when pressed
	local press = '%s press':format(self)
	windower.prim.create(press)
	windower.prim.set_visibility(press, _G[tb._track._var] ~= tb._track._invert) -- start pressed if var is true or inverted var is false
	windower.prim.set_position(press, tb._track._x + 3, tb._track._y + 3)
	windower.prim.set_color(press, 100, 0, 0, 127)
	windower.prim.set_size(press, 36, 36)

	-- draw the pressed and unpressed icons
	local name = '%s Up':format(self)
	windower.prim.create(name)
	windower.prim.set_visibility(name, not (_G[tb._track._var] ~= tb._track._invert))
	windower.prim.set_position(name, tb._track._x + 5, tb._track._y + 5)
	windower.prim.set_texture(name, '%sdata/graphics/%s':format(windower.addon_path,tb._track._iconUp))
	windower.prim.set_fit_to_texture(name, true)
	
	name = '%s Down':format(self, icon)
	windower.prim.create(name)
	windower.prim.set_visibility(name, _G[tb._track._var] ~= tb._track._invert)
	windower.prim.set_position(name, tb._track._x + 5, tb._track._y + 5)
	windower.prim.set_texture(name, '%sdata/graphics/%s':format(windower.addon_path, tb._track._iconDown))
	windower.prim.set_fit_to_texture(name, true)
	
	-- display the icon that is currently active
	--windower.prim.set_visibility('%s %s':format(self, ('Down' and tb._track._startPressed) or 'Up'), tb._track._var ~= tb._track._invert)
	tb._track._mouse_event = UI.register_mouse_listener(tb)
	tb._track._update_event = UI.register_update_object(tb)
end

_meta.ToggleButton.__methods['on_mouse'] = function(tb, type, x, y, delta, blocked)
	if type == 1 then
		if tb._track._suppress then
			tb._track._suppress = false
			return true
		end
		if x > tb._track._x and x < tb._track._x + 42 and y > tb._track._y and y < tb._track._y + 42 then
			if tb._track._pressed then
				tb:unpress()
				return true
			else
				tb:press()
				return true
			end
		end
	elseif type == 2 then
		if x > tb._track._x and x < tb._track._x + 42 and y > tb._track._y and y < tb._track._y + 42 then
			return true
		end
	end
end

_meta.ToggleButton.__methods['update'] = function (tb)
	if _G[tb._track._var] ~= tb._track._state then
		self = tostring(tb)
		windower.prim.set_visibility('%s Up':format(self), not (_G[tb._track._var] ~= tb._track._invert))
		windower.prim.set_visibility('%s Down':format(self), _G[tb._track._var] ~= tb._track._invert)
		windower.prim.set_visibility('%s press':format(self), _G[tb._track._var] ~= tb._track._invert)
		tb._track._state = _G[tb._track._var]
	end
end

_meta.ToggleButton.__methods['press'] = function(tb)
	-- visually depress the button
	tb._track._pressed = true
	windower.prim.set_visibility('%s press':format(tostring(tb)), true)
	windower.prim.set_visibility('%s Up':format(tostring(tb)), false)
	windower.prim.set_visibility('%s Down':format(tostring(tb)), true)
	_G[tb._track._var] = not tb._track._invert
	tb._track._state = not tb._track._invert
end

_meta.ToggleButton.__methods['unpress'] = function(tb)
	tb._track._pressed = false
	windower.prim.set_visibility('%s press':format(tostring(tb)), false)
	windower.prim.set_visibility('%s Down':format(tostring(tb)), false)
	windower.prim.set_visibility('%s Up':format(tostring(tb)), true)
	_G[tb._track._var] = tb._track._invert
	tb._track._state = tb._track._invert
end

_meta.ToggleButton.__index = function(tb, k)
    if type(k) == 'string' then
        local lk = k:lower()
		
		return _meta.ToggleButton.__methods[lk]
    end
end