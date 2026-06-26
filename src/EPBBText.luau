--!strict
local Types		= require("./Modules/Types.luau")
local EPBBEnums		= require("./Modules/Enums.luau")
local Lexer		= require("./Modules/Lexer.luau")

local function Reject(Reason: Types.Reason): nil
	print(string.format("[EPBBText]: %s", Reason))
	return Reason
end

local EPBBText: Types.EPBBTextProperties = {} :: Types.EPBBTextProperties
EPBBText.__index = EPBBText

function EPBBText.New(Raw: Types.RawText): (Types.Success, Types.EPBBTextProperties?, Types.Reason?)
	local self: Types.EPBBTextProperties = setmetatable({}, EPBBText) :: Types.EPBBTextProperties

	self.RawText: Types.RawText = Raw or ""
	local 
		TokenizationSuccess: Types.Success,
		TokenizedText: Types.TokenizedText? 
	= Lexer.Tokenize(self.RawText)
	if not TokenizationSuccess then return false, nil, Reject("Failed to tokenize the input raw text.") end

	return true, self	
end

return EPBBText
