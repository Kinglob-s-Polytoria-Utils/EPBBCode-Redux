--!strict
local Types		= require("./Modules/Types.luau")
local EPBBEnums		= require("./Modules/Enums.luau")
local Lexer		= require("./Modules/Lexer.luau")

local function Reject(Reason: Types.Reason): string
	print(string.format("[EPBBText]: %s", tostring(Reason)))
	return Reason
end

local EPBBTextClass = {}
EPBBTextClass.__index = EPBBTextClass

export type EPBBText = typeof(setmetatable(
	{} :: Types.EPBBTextProperties,
	EPBBTextClass
))

function EPBBTextClass.New(Raw: Types.RawText): (Types.Success, EPBBText?, Types.Reason?)
	local self: EPBBText = setmetatable(
		{} :: Types.EPBBTextProperties, 
		EPBBTextClass
	)

	local 
		TokenizationSuccess: Types.Success,
		TokenizedText: Types.TokenizedText?
	= Lexer.Tokenize(Raw)
	if not TokenizationSuccess then return false, nil, Reject("Failed to tokenize the input raw text.") end
	
	self.Raw = Raw :: Types.RawText
	self.Tokens = TokenizedText :: Types.TokenizedText

	return true, self	
end

function EPBBTextClass:UpdateRaw(Raw: Types.RawText): (Types.Success, Types.Reason)
	return false, Reject("Failed to update raw text.")
end

function EPBBTextClass:Bind(
		Enum: Types.MetadataEnum,
		Data: Types.ValidMetadata,
		Name: string,
		Args: { any }?
): (Types.Success, Types.Reason)
	return false, Reject("Failed to bind metadata to EPBBText instance.")
end

function EPBBTextClass.Out(
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

return EPBBTextClass
