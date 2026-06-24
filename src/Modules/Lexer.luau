--!strict
local Types = require("./Types.luau")
local Enums = require("./Enums.luau")

local function Reject(Reason: Types.Reason): nil
	print(string.format("[EPBBText > Lexer]: %s", Reason))
	return Reason
end

local Lexer: Types.LexerProperties = {} :: Types.LexerProperties

function Lexer.Lex(RawText: Types.RawText): (Types.Success, Types.TokenizedText?, Types.Reason?)
	return false, nil, Reject("Failed to tokenize input RawText. Preventing all further operations in this class.")
end

return Lexer
