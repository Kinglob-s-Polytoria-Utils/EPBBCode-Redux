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

function EPBBTextClass.New(Raw: Types.RawText, TypewriterDelay: number): (Types.Success, Types.EPBBText?, Types.Reason?)
	local self: Types.EPBBText = setmetatable(
		{} :: Types.EPBBTextProperties, 
		EPBBTextClass
	)

	local 
		TokenizationSuccess: Types.Success,
		TokenizedText: Types.TokenizedText?
	= Lexer.Tokenize(Raw)
	if not TokenizationSuccess then return false, nil, Reject("Failed to tokenize the input raw text.") end
	
	self.Raw = Raw :: Types.RawText
	self.Paused = false
	self.TypewriterDelay = TypewriterDelay :: number
	self.Tokens = TokenizedText :: Types.TokenizedText

	return true, self	
end

function EPBBTextClass:UpdateRaw(Raw: Types.RawText): (Types.Success, Types.Reason?)
	return false, Reject("Failed to update raw text.")
end

function EPBBTextClass:UpdateDelay(TypewriterDelay: number): (Types.Success, Types.Reason?)
	return false, Reject("Failed to update typewriter delay.")
end

function EPBBTextClass:Pause(): (Types.Success, Types.Reason?)
	self.Paused = true
	return true
end

function EPBBTextClass:Unpause(): (Types.Success, Types.Reason?)
	self.Paused = false
	return true
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
	self: Types.EPBBText,
	Label: UILabel, 
	Callback: Types.OutputCallback,
	isTypewriter: boolean?,
	haveGibberishPretext: boolean?
): (Types.Success, Types.Reason?)
	local shouldWait: boolean = true
	local OutputString: string = ""

	local OutputThread = coroutine.create(function()
		local TokenPos: number = 1
		while TokenPos < #self.Tokens  do
			local Token: Types.Token = self.Tokens[TokenPos]

			-- add token handling here
			
			coroutine.yield()
		end
	end)

	while true do 
		if self.Paused then
			while self.Paused do wait(0.1) end
		end

		if shouldWait then wait(self.TypewriterDelay) end

		if Callback then Callback(OutputString) end

		local ResumeSuccess: Types.Success, ResumeReason: Types.Reason? = coroutine.resume(OutputThread)
		if not ResumeSuccess then return false, Reject(ResumeReason :: string) end
	end

	return false, Reject("Ended output process abruptly.")
end

return EPBBTextClass
