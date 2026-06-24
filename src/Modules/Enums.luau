--!strict

export type EPBBEnums = {
	MetadataEnum = {number},
	SegmentEnum = {number},
	TokenEnum = {number}
}

local EPBBEnums: EPBBEnums = {
	MetadataEnum = {
		Function			= 1,
		Event					= 2,
		Image					= 3,
		ImageSequence = 4
	},
	SegmentEnum = {
		Character		= 1,
		BB_Open			= 2,
		BB_Close		= 3,
		EPBB_Open		= 4,
		EPBB_Close	= 5
	},
	TokenEnum = {
		Text				= 1,
		Metadata		= 2,
	}
}

return Enums
