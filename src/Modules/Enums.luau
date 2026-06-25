--!strict

export type MetadataEnum = {
	Function: number,
	Event: number,
	Image: number,
	ImageSequence: number
}

export type SegmentEnum = {
	Text: number,
	Offset_Text: number,
	BB_Open: number,
	BB_Close: number,
	EPBB_Open: number,
	EPBB_Close: number
}

export type TokenEnum = {
	Text: number,
	Offset_Text: number,
	BB_Tag: number,
	EPBB_Tag: number,
}

export type LexerStateEnum = {
	Text: number,
	Offset_Text: number,
	BB_Open: number,
	BB_Close: number,
	EPBB_Open: number,
	EPBB_Close: number
}

export type EPBBEnums = {
	MetadataEnum: MetadataEnum,
	SegmentEnum: SegmentEnum,
	TokenEnum: TokenEnum,
	LexerStateEnum: LexerStateEnum
}

local EPBBEnums: EPBBEnums = {
	MetadataEnum = {
		Function			= 1,
		Event					= 2,
		Image					= 3,
		ImageSequence = 4
	},
	SegmentEnum = {
		Text				= 1,
		Offset_Text = 2,
		BB_Open			= 3,
		BB_Close		= 4,
		EPBB_Open		= 5,
		EPBB_Close	= 6
	},
	TokenEnum = {
		Text				= 1,
		Offset_Text	= 2,
		BB_Tag			= 3,
		EPBB_Tag		= 4
	},
	LexerStateEnum = {
		Text				= 1,
		Offset_Text	= 2,
		BB_Open			= 3,
		BB_Close		= 4,
		EPBB_Open		= 5,
		EPBB_Close	= 6
	}
} :: EPBBEnums

return EPBBEnums
