--!strict
local Types = require("./Types.luau")
local EPBBEnums = require("./Enums.luau")

local function Reject(Reason: Types.Reason): Types.Reason
	print(string.format("[EPBBText > Lexer]: %s", Reason))
	return Reason
end

local function GetLength(Start: number?, End: number?): number?
	if typeof(Start) ~= "number" or typeof(End) ~= "number" then
		return nil
	end
	return End - Start + 1
end

local Lexer: Types.LexerProperties = {} :: Types.LexerProperties

function Lexer.Tokenize(RawText: Types.RawText): (Types.Success, Types.TokenizedText?, Types.Reason?)
	local TextLength: number = #RawText
	local State: number = EPBBEnums.LexerStateEnum.Text
	local TokenizedText: Types.TokenizedText = {} :: Types.TokenizedText

	local Index: number = 1 -- Current position in the RawText

	local Column: number = 1 -- Projected position in the finished output RawText.
	-- This is so that metadata fires properly, and so that offsets
	-- can be moved to their expected columns.

	while Index <= TextLength do
		local BB_Open_Start: number?, BB_Open_End: number? = RawText:find(Types.BB_Open, Index)
		local BB_Close_Start: number?, BB_Close_End: number? = RawText:find(Types.BB_Close, Index)
		local EPBB_Open_Start: number?, EPBB_Open_End: number? = RawText:find(Types.EPBB_Open, Index)
		local EPBB_Close_Start: number?, EPBB_Close_End: number? = RawText:find(Types.EPBB_Close, EPBB_Open_End)

		if EPBB_Open_Start and not EPBB_Close_Start then return false, nil, Reject("Could not find valid EPBB closing tag after finding valid EPBB opening tag.") end

		if Index == BB_Open_Start then
			State = EPBBEnums.LexerStateEnum.BB_Open
		elseif Index == EPBB_Open_Start then
			State = EPBBEnums.LexerStateEnum.EPBB_Open
		elseif Index > (EPBB_Close_End :: number or BB_Close_End :: number) then
			State = EPBBEnums.LexerStateEnum.Offset_Text
		else
			State = EPBBEnums.LexerStateEnum.Text
		end


		--[REGULAR]--
		if State == EPBBEnums.LexerStateEnum.Text then
			TokenizedText[#TokenizedText + 1] = {
				Type = EPBBEnums.TokenEnum.Text,
				Column = Column,
				ColumnLiteral = Index,
			} :: Types.Token

			Index += 1
			Column += 1

		--[OFFSET]--
		elseif State == EPBBEnums.LexerStateEnum.Offset_Text then
			local BB_Close_Length: number? = GetLength(BB_Close_Start, BB_Close_End)
			if typeof(BB_Close_Length) ~= "number" then
				return false, nil, Reject("BBCode closing tag was found invalid.")
			end

			TokenizedText[#TokenizedText + 1] = {
				Type = EPBBEnums.TokenEnum.Offset_Text,
				Text = RawText:sub(Index, Index),
				Offset = -BB_Close_Length,
				Column = Column,
				ColumnLiteral = Index,
			} :: Types.Token

			Column += BB_Close_Length
			Index += BB_Close_Length

		--[BB OPEN]--
		elseif State == EPBBEnums.LexerStateEnum.BB_Open then
			local BB_Open_Length: number? = GetLength(BB_Open_Start, BB_Open_End)
			if typeof(BB_Open_Length) ~= "number" then return false, nil, Reject("BBCode opening tag was found invalid.") end

			TokenizedText[#TokenizedText + 1] = {
				Type = EPBBEnums.TokenEnum.BB_Tag,
				Text = RawText:sub(BB_Open_Start :: number, BB_Open_End),
				Column = Column,
				ColumnLiteral = Index,
			} :: Types.Token

			Column += BB_Open_Length
			Index += BB_Open_Length

		--[BB CLOSE]--
		elseif State == EPBBEnums.LexerStateEnum.BB_Close then
			local BB_Close_Length: number? = GetLength(BB_Close_Start, BB_Close_End)
			if typeof(BB_Close_Length) ~= "number" then return false, nil, Reject("BBCode closing tag was found invalid.") end

			TokenizedText[#TokenizedText + 1] = {
				Type = EPBBEnums.TokenEnum.BB_Tag,
				Text = RawText:sub(BB_Close_Start :: number, BB_Close_End),
				Column = Column,
				ColumnLiteral = Index
			} :: Types.Token
			
			Column += BB_Close_Length
			Index += BB_Close_Length

		--[EPBB OPEN]--
		elseif State == EPBBEnums.LexerStateEnum.EPBB_Open then

		--[EPBB CLOSE]--
		elseif State == EPBBEnums.LexerStateEnum.EPBB_Close then

		end
	end

	return false, nil, Reject("Failed to tokenize input RawText. Preventing all further operations in this class.")
end

return Lexer
