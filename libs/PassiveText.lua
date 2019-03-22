_meta = _meta or {}
_meta.PassiveText = {}
_meta.PassiveText.__class = 'passive_text'
_meta.PassiveText.__methods = {}

function PassiveText(args) -- constructs the object, but does not initialize it
	local pt = {}
	pt._track = {}
	pt._track._class = 'passive text'

	pt._track._x = args.x
	pt._track._y = args.y
	pt._track._var = args.var
	
	pt._track._align = args.align:lower() or 'left'
	
	return setmetatable(pt, _meta.PassiveText)	
end

_meta.PassiveText.__methods['draw'] = function(pt) -- Finishes initialization and draws the graphics
	local self = tostring(pt)
	
	windower.text.create(self)
	windower.text.set_font(self, 'Helvetica')
	windower.text.set_stroke_color(self, 127, 18, 97, 136)
	windower.text.set_stroke_width(self, 1)
	windower.text.set_color(self, 255, 253, 252, 250)
	windower.text.set_font_size(self, 10)
	
	windower.text.set_location(self, pt._track._x, pt._track._y)
	windower.text.set_right_justified(self, pt._track._align == 'right')
	windower.text.set_text(self, 'RH Weaponskill: %s':format(_G[pt._track._var] or 'None'))--pt._track._var or 'None')
	windower.text.set_visibility(self, true)
	
	print(windower.text.get_extents(self))
	print(windower.text.get_location(self))
	
	UI.register_update_object(pt)
end

_meta.PassiveText.__methods['update'] = function(pt)
	windower.text.set_text(tostring(pt), 'RH Weaponskill: %s':format(_G[pt._track._var] or 'None'))
end

_meta.PassiveText.__index = function(pt, k)
    if type(k) == 'string' then
		
        local lk = k:lower()
		
		return _meta.PassiveText.__methods[lk]
    end
end