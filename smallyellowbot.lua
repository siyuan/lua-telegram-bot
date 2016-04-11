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

--[[
Code Style:
  1. lowerCamelCase
  2. Indent 2 spaces
--]]
-- pass token as command line argument or insert it into code
local token = arg[1] or "134452794:AAFmTkfgaLU58OJh7hxL3tMytcBB5A0cKpo"

-- create and configure new bot with set token
local bot, extension = require("lua-bot-api").configure(token)

local lastCmd = {}
local forceReply = bot.generateForceReply(true, true)
local replyKeyboardHide = bot.generateReplyKeyboardHide(true, false)

function letterNumberUnderscore(str)
  words = {}
  for w in string.gmatch(str, "[%w_]+") do table.insert(words, w) end
  return words[1]
end
-- override onMessageReceive function so it does what we want
extension.onMessageReceive = function (msg)
  print("New Message by " .. msg.from.first_name)
  if (msg.from.username) then
    print("netx username " .. msg.from.username .. "xx")
  end
  cmd = {}

  if(msg.from.username and lastCmd[msg.from.username]) then
    bot.sendMessage(msg.chat.id, "么么哒成功", nil, nil, nil, nil, replyKeyboardHide)
    lastCmd["@" .. msg.from.username] = nil
    return
  elseif (lastCmd[msg.from.id]) then
    cmd[1] = lastCmd[msg.from.id]
    cmd[2] = msg.text
    lastCmd[msg.from.id] = nil
  else
    for word in msg.text:gmatch("%S+") do table.insert(cmd, word) end
  end

  replayName = (msg.from.username and ("@" .. msg.from.username .. " ") or msg.from.first_name)

  if (cmd[1] == "/print") then
    if (cmd[2]) then
      bot.sendMessage(msg.chat.id,
      replayName .. "说" .. cmd[2], nil, nil, nil, nil, nil)
    else
      lastCmd[msg.from.id] = "/print"
      bot.sendMessage(msg.chat.id, 
      replayName .. "你想说啥", nil, nil, nil, 
      msg.message_id, forceReply)
    end
  elseif (cmd[1] == "/memeda") then
    if (cmd[2]) then
      replykeyboard = bot.generateReplyKeyboardMarkup({{replayName .. "你快来，人家想要！"},{replayName .. "你走开！"}},
      true, true, true)
      print("11111 cmd[2]:" .. cmd[2] .. "xx")
      print("22222 cmd[2]:" .. letterNumberUnderscore(cmd[2]) .. "xx")
      lastCmd[letterNumberUnderscore(cmd[2])] = "replay@" .. cmd[1]
      bot.sendMessage(msg.chat.id,
      cmd[2] .. " " .. replayName .. "要么么哒你！", nil, nil, nil, nil, replykeyboard)
    else
      lastCmd[msg.from.id] = cmd[1]
      bot.sendMessage(msg.chat.id, 
      replayName .. "你想么么哒谁", nil, nil, nil, 
      msg.message_id, forceReply)
    end
  else
    bot.sendMessage(msg.chat.id, "不知道" .. replayName ..  "在说什么")
  end
end

-- This runs the internal update and callback handler
-- you can even override run()
extension.run()
