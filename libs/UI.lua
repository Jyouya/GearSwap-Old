UI = {}
UI.mouse_listeners = {}
UI.update_objects = {}
UI.mouse_index = 1
UI.update_index = 1
UI.bound = {}
UI.bound.x = nil
UI.bound.y = {}
UI.bound.y.lower = 80
UI.bound.y.upper = 502
UI.nexttime = os.clock()
UI.delay = 1

require('coroutine')

require('IconPalette')
require('IconButton')
require('ToggleButton')
require('PassiveText')
require('TextCycle')

function UI.on_mouse_event(type, x, y, delta, blocked) -- sends incoming mouse events to any elements currently listening
	block = false
	--for i, listener in ipairs(UI.mouse_listeners) do
	for i, listener in pairs({table.unpack(UI.mouse_listeners)}) do
		block = listener:on_mouse(type, x, y, delta, blocked) or block
	end
	blocked = block
	return block
end

function UI.register_mouse_listener(obj) -- will technically overflow eventually.  I'm not really worried about that.
	UI.mouse_listeners[UI.mouse_index] = obj
	UI.mouse_index = UI.mouse_index + 1
	return UI.mouse_index - 1
end

function UI.unregister_mouse_listener(index)
	UI.mouse_listeners[index] = nil
end

function UI.on_prerender()
	local curtime = os.clock()
	if UI.nexttime + UI.delay <= curtime then
		UI.nexttime = curtime
		UI.delay = 1
		for i, object in pairs({table.unpack(UI.update_objects)}) do
			object:update()
		end
	end
end

function UI.register_update_object(obj)
	UI.update_objects[UI.update_index] = obj
	UI.update_index = UI.update_index + 1
	return UI.update_index - 1
end

function UI.unregister_update_object(index)
	UI.update_objects[index] = nil
end

windower.raw_register_event('mouse', UI.on_mouse_event)
windower.raw_register_event('prerender', UI.on_prerender)