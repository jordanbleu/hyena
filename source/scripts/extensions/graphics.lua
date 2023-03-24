---Draws text but inverted.  https://devforum.play.date/t/is-there-a-simpler-way-to-change-font-colour-than-this/3894/2
---I think this is hacky but idk what else to do.
---@param x any
---@param y any
---@param text any
function playdate.graphics.drawTextBlack(x,y,text)

	local gfx = playdate.graphics
	local original_draw_mode = gfx.getImageDrawMode()
	gfx.setImageDrawMode( playdate.graphics.kDrawModeFillWhite )
	gfx.drawText(x,y,text)
	gfx.setImageDrawMode( original_draw_mode )
end

---Syntactic sugar method for retrieving localized text based on the global language code.
---@param key string the key within {language_code}.strings
---@return any the string from the strings file.
function playdate.graphics.getString(key)
    return playdate.graphics.getLocalizedText(key, GLOBAL_LANGUAGE_CODE)
end