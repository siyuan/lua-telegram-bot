--[[

bot-example.lua - Example code provided with the lua-telegram-bot library.

Copyright (C) 2016 @cosmonawt

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

]]

-- pass token as command line argument or insert it into code
local token = arg[1] or "134452794:AAFmTkfgaLU58OJh7hxL3tMytcBB5A0cKpo"

-- create and configure new bot with set token
local bot, extension = require("lua-bot-api").configure(token)

-- override onMessageReceive function so it does what we want
extension.onMessageReceive = function (msg)
	print("New Message by " .. msg.from.first_name)
	words = {}
	for word in msg.text:gmatch("%S+") do table.insert(words, word) end
	if (words[1] == "/print") then
		if (words[2]) then
			bot.sendMessage(msg.chat.id, words[2])
		else
			bot.sendMessage(msg.chat.id, "你想说啥")
		end
	else
		bot.sendMessage(msg.chat.id, "不知道你在说什么")
	end
end

-- This runs the internal update and callback handler
-- you can even override run()
extension.run()
