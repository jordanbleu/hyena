---Draws text but inverted.  https://devforum.play.date/t/is-there-a-simpler-way-to-change-font-colour-than-this/3894/2
---I think this is hacky but idk what else to do.
---@param x any
---@param y any
---@param text any
function playdate.graphics.drawTextInverted(x,y,text)

	local gfx = playdate.graphics
	local original_draw_mode = gfx.getImageDrawMode()
	gfx.setImageDrawMode( playdate.graphics.kDrawModeInverted )
	gfx.drawText(x,y,text)
	gfx.setImageDrawMode( original_draw_mode )
end
