--!strict
local Types		= require("./Modules/Types.luau")
local Enums		= require("./Modules/Enums.luau")
local Parser	= require("./Modules/Parser.luau")
local Lexer		= require("./Modules/Lexer.luau")
local Binder	= require("./Modules/Binder.luau")

local EPBBCode: Types.EPBBCodeProperties = {} :: Types.EPBBCodeProperties
EPBBCode.__index = EPBBCode

return EPBBCode
