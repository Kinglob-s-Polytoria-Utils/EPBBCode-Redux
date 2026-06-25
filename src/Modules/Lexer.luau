--!strict
local Types			= require("./Types.luau")
local EPBBEnums = require("./Enums.luau")

local function Reject(Reason: Types.Reason): Types.Reason
	print(string.format("[EPBBText > Lexer]: %s", Reason))
	return Reason
end

local Lexer: Types.LexerProperties = {} :: Types.LexerProperties

function Lexer.Tokenize(RawText: Types.RawText): (Types.Success, Types.TokenizedText?, Types.Reason?)
	local TextLength: number = #RawText
	local State: number = EPBBEnums.LexerStateEnum.Text

	local Index: number = 1
	local Column: Types.ColumnNumber = 1

	while Index <= TextLength do
		local 
			BB_Open_Start:	number?, 
			BB_Open_End:		number?
		= RawText:find(Types.BB_Open, Index, true)

		local
			EPBB_Open_Start: number?,
			EPBB_Open_End:	 number?
		= RawText:find(Types.EPBB_Open, Index, true)

		if Index == BB_Open_Start then
			State = EPBBEnums.LexerStateEnum.BB_Open
		elseif Index == EPBB_Open_Start then
			State = EPBBEnums.LexerStateEnum.EPBB_Open
		elseif BB_Open_End and Index >= BB_Open_End then
			State = EPBBEnums.LexerStateEnum.Offset_Text
			-- Check if the BB close tag index is at the current index
		elseif EPBB_Open_End and Index >= EPBB_Open_End then
			State = EPBBEnums.LexerStateEnum.Offset_Text
			-- Check if the EPBB close tag index is at the current index		
		end
		
		if State == EPBBEnums.LexerStateEnum.Text then

		elseif State == EPBBEnums.LexerStateEnum.Offset_Text then
		
		elseif State == EPBBEnums.LexerStateEnum.BB_Open then

		elseif State == EPBBEnums.LexerStateEnum.BB_Close then

		elseif State == EPBBEnums.LexerStateEnum.EPBB_Open then

		elseif State == EPBBEnums.LexerStateEnum.EPBB_Close then

		end

	end

	return false, nil, Reject("Failed to tokenize input RawText. Preventing all further operations in this class.")
end

return Lexer
