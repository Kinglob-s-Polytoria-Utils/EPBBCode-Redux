--!strict
local Types = require("./Types.luau")
local Enums = require("./Enums.luau")

local function Reject(Reason: Types.Reason): Types.Reason
	print(string.format("[EPBBText > Parser]: %s", Reason))
	return Reason
end

local Parser: Types.ParserProperties = {} :: Types.ParserProperties

function Parser.Parse(
	TokenizedText: Types.TokenizedText
): (Types.Success, Types.ParsedText?, Types.MetadataMap?, Types.Reason?)
	return false, nil, nil, Reject("Failed to parse tokenized input.")
end

return Parser
