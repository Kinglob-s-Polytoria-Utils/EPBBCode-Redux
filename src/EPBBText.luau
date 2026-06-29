--!strict
local Types						= require(script.Types)
local EPBBEnums				= require(script.EPBBEnums)
local Lexer						= require(script.Lexer)

local function Reject(Reason: Types.Reason): string
	print(string.format("[EPBBText]: %s", tostring(Reason)))
	return Reason
end

local function GetCharacterRow(Column: number, LabelSize: Vector2): number
	return 0
end

local function OffsetToRelative(Offset: Vector2): Vector2
	return Vector2.Zero
end

local function GetImagePositionRelative(Column: number, Row: number, Image: UIImage, Label: UILabel): Vector2
	return Vector2.Zero
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
	if not TokenizedText or #TokenizedText < 1 then return false, nil, Reject("TokenizedText is nil or empty.") end

	self.Raw = Raw :: Types.RawText
	self.Paused = false
	self.TypewriterDelay = TypewriterDelay :: number
	self.Tokens = TokenizedText :: Types.TokenizedText
	self.MetadataMap = {} :: Types.MetadataMap
	self.ActiveMetadata = {} :: Types.ActiveMetadata

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

function EPBBTextClass:HandleMetadata(MetadataToken: Types.Token, Label: UILabel): (Types.Success, thread?, Types.Reason?)
	local Metadata: Types.MetadataMap = self.Metadata
	local Enum: number = MetadataToken.MetadataEnum
	local MetadataCategory: Types.Metadata = Metadata[Enum]

	local TargetMetadata: Types.ValidMetadata = MetadataCategory[MetadataToken.BoundName]

	if Enum == EPBBEnums.MetadataEnum.Function then
		TargetMetadata.Call(TargetMetadata.Payload or nil)
	elseif Enum == EPBBEnums.MetadataEnum.Image then
		local Row: number = GetCharacterRow(MetadataToken.Column)
		local Position: Vector2 = GetImagePositionRelative(MetadataToken.Column, Row, TargetMetadata.Cache, Label)
		local Image: UIImage = TargetMetadata.Cache:Clone()
		Image.Position = Position
		Image.Name = MetadataToken.BoundName
		Image.Parent = world.PlayerGUI
		self.ActiveMetadata[#self.ActiveMetadata + 1] = Image
	elseif Enum == EPBBEnums.MetadataEnum.ImageSequence then
		-- TODO:	return a thread that switches between each image in order, include this in the output schedular
		--				also add the created thread and all the images to ActiveMetadata for cleanup

	elseif Enum == EPBBEnums.MetadataEnum.Event then
		if TargetMetadata.IsNetwork then 
			TargetMetadata.Event.InvokeServer(TargetMetadata.NetworkMessage or nil)
		else
			TargetMetadata.Event.Invoke(TargetMetadata.BindableMessage)
		end
	end

	return true
	--return false, Reject("Failed to handle metadata '" .. BoundName .. "'")
end

--[[
	Cleans up all metadata that was fired at the time of calling the function.
	Expected to be used if you're in a situation where you need to clear up
	images from tags.
]]
function EPBBTextClass:Cleanup(): (Types.Success, Types.Reason?)
	return false, Reject("Failed to cleanup metadata.")
end

function EPBBTextClass:Out(
	Callback: Types.OutputCallback,
	isTypewriter: boolean?,
	haveGibberishPostText: boolean?,
	Label: UILabel?
): (Types.Success, Types.Reason?)

	local Tokens: Types.TokenizedText = self.Tokens
	local shouldWait: boolean = true
	local OutputString: string = ""

	local OutputThread = coroutine.create(function(): (Types.Success, Types.Reason?)
		local TokenPos: number = 1

		while TokenPos < #Tokens  do
			local Token: Types.Token = Tokens[TokenPos]

			if Token.Type == EPBBEnums.TokenEnum.Text then
				OutputString = OutputString .. Token.Text
				shouldWait = true
			elseif Token.Type == EPBBEnums.TokenEnum.BB_Tag then
				OutputString = OutputString .. Token.Text
			elseif Token.Type == EPBBEnums.TokenEnum.Offset_Text then
				local OutputStringFirst: string = OutputString:sub(1, #OutputString - Token.Offset :: number)
				local OutputStringSecond: string = OutputString:sub(#OutputStringFirst, -1)
				OutputString = OutputStringFirst .. Token.Text .. OutputStringSecond
				shouldWait = true
			elseif Token.Type == EPBBEnums.TokenEnum.EPBB_Tag then
				local MetadataSuccess: Types.Success, MetadataReason: Types.Reason? = self:HandleMetadata(Token, UILabel)
				if not MetadataSuccess then return false, Reject(MetadataReason :: string) end
				if Token.MetadataType == (EPBBEnums.MetadataEnum.Image or EPBBEnums.MetadataEnum.ImageSequence) then shouldWait = true end
			end

			if Callback then Callback(OutputString) end

			TokenPos += 1
			coroutine.yield()
		end

		return true
	end)

	while true do 
		if self.Paused then
			while self.Paused do wait(0.1) end
		end

		if shouldWait then	
			shouldWait = false
			wait(self.TypewriterDelay)
		end

		local ResumeSuccess: Types.Success, ResumeReason: Types.Reason? = coroutine.resume(OutputThread)
		if not ResumeSuccess then return false, Reject(ResumeReason :: string) end
	end

	return false, Reject("Ended output process abruptly.")
end

return EPBBTextClass
