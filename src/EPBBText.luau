--!strict
local Types		= require("./Modules/Types.luau")
local EPBBEnums		= require("./Modules/Enums.luau")
local Lexer		= require("./Modules/Lexer.luau")

local function Reject(Reason: Types.Reason): string
	print(string.format("[EPBBText]: %s", tostring(Reason)))
	return Reason
end

local EPBBText: Types.EPBBTextProperties = {} :: Types.EPBBTextProperties
EPBBText.__index = EPBBText

function EPBBText.New(Raw: Types.RawText): (Types.Success, Types.EPBBTextProperties?, Types.Reason?)
	local self: Types.EPBBTextProperties = setmetatable({}, EPBBText) :: Types.EPBBTextProperties

	local 
		TokenizationSuccess: Types.Success,
		TokenizedText: Types.TokenizedText?
	= Lexer.Tokenize(Raw)
	if not TokenizationSuccess then return false, nil, Reject("Failed to tokenize the input raw text.") end
	
	self.Raw: Types.RawText = Raw
	self.Tokens: Types.TokenizedText = TokenizedText

	return true, self	
end

function EPBBText:UpdateRaw(Raw: Types.RawText): (Types.Success, Types.Reason)
	return false, Reject("Failed to update raw text.")
end

function EPBBText:Bind(
		Enum: Types.MetadataEnum,
		Data: Types.ValidMetadata,
		Name: string,
		Args: { any }?
): (Types.Success, Types.Reason)
	return false, Reject("Failed to bind metadata to EPBBText instance.")
end

function EPBBText.Out(
	self: Types.EPBBTextProperties,
	Label: UILabel, 
	Callback: Types.OutputCallback,
	isTypewriter: boolean?,
	haveGibberishPretext: boolean?
): (Types.Success, Types.Reason?)

	local OutputThread = coroutine.create(function()
		while true do

			coroutine.yield()
		end
	end)

	while true do 

	end

	return false, Reject("Ended output process abruptly.")
end

return EPBBText
