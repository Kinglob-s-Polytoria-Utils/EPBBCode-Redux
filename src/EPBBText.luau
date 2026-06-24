--!strict
local Types		= require("./Modules/Types.luau")
local Enums		= require("./Modules/Enums.luau")
local Parser	= require("./Modules/Parser.luau")
local Lexer		= require("./Modules/Lexer.luau")

local function Reject(Reason: Types.Reason): nil
	print(string.format("[EPBBText]: %s", Reason))
	return Reason
end

local EPBBText: Types.EPBBTextProperties = {} :: Types.EPBBTextProperties
EPBBText.__index = EPBBText

function EPBBText.New(Raw: Types.RawText): (Success, EPBBTextProperties?, Reason?)
	local self = setmetatable({}, EPBBText)

	self.RawText: Types.RawText = Raw or ""
	local 
		TokenizationSuccess: Types.Success,
		TokenizedText: Types.TokenizedText? 
	= Lexer.Tokenize(self.RawText)
	if not TokenizationSuccess then return false, nil, Reject("Failed to tokenize the input raw text.")

	local 
		ParseSuccess: Types.Success,
		ParsedText: Types.ParsedText?,
		MetadataMap: Types.MetadataMap?
	= Parser.Parse(TokenizedText)
	if not ParseSuccess then return false, nil, nil, Reject("Failed to parse tokenized text.")

	return true, self	
end

return EPBBText
