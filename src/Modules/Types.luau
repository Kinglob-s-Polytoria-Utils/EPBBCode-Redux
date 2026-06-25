--!nocheck
local Types = {}

--[Types for readability]--
type FolderOfImages = Folder

export type ColumnNumber = number
export type RowNumber = number
export type OutputCallback = () -> (Success, string?, Reason?)

export type MetadataEnum = {
	Function: number,
	Event: number,
	Image: number,
	ImageSequence: number,
}

export type TokenEnum = {
	Text: number,
	Offset_Text: number,
	BB_Tag: number,
	EPBB_Tag: number,
}

export type SegmentEnum = {
	Text: number,
	Offset_Text: number,
	BB_Open: number,
	BB_Close: number,
	EPBB_Open: number,
	EPBB_Close: number,
}

export type EPBBEnums = {
	MetadataEnum: MetadataEnum,
	SegmentEnum: SegmentEnum,
	TokenEnum: TokenEnum,
	LexerStateEnum: LexerStateEnum,
}

export type Reason = string
export type Success = boolean

export type RawText = string
export type ParsedText = { Segment }
export type TokenizedText = { Token }

export type Metadata = BoundFunctions | BoundImages | BoundImageSequences | BoundEvents
export type MetadataMap = { [MetadataEnum]: Metadata }

--[Types for validity checks]--
export type ValidFunction = PTFunction | PTCallback | () -> any
export type ValidEvent = BindableEvent | NetworkEvent | PTSignal
export type ValidMetadata = BoundImage | BoundImageSequence | BoundEvent | BoundFunction

--[Definitions for the tokenizer]--
Types.BB_Open = "[.]"
Types.BB_Close = "[/.]"

Types.EPBB_Open = "<.>"
Types.EPBB_Close = "</.>"

Types.Function = "func"
Types.Event = "event"
Types.Image = "img"
Types.ImageSequence = "imgseq"

--[Bound EPBBCode Metadata types]--
export type BoundImage = {
	Cache: UIImage,
	ImageAsset: PTImageAsset?,
}
export type BoundImages = { [RowNumber]: { [ColumnNumber]: BoundImage } }

export type BoundImageSequence = {
	SequenceData: { PTImageAsset },
	Images: { UIImage },
	Cache: FolderOfImages,
}
export type BoundImageSequences = { [RowNumber]: { [ColumnNumber]: BoundImageSequence } }

export type BoundFunction = {
	Call: ValidFunction,
	Payload: { any }?,
}
export type BoundFunctions = { [RowNumber]: { [ColumnNumber]: BoundFunction } }

export type BoundEvent = {
	Event: ValidEvent,
	isNetwork: boolean,
}
export type BoundEvents = { [RowNumber]: { [ColumnNumber]: BoundEvent } }

--[Custom data types for tokenizing, parsing, and outputting]--
export type Token = {
	Type: number,
	Column: ColumnNumber,
	ColumnLiteral: number,
	Text: string,
	MetadataType: number?,
	Offset: number?,
}
export type Segment = {
	Type: SegmentEnum,
	Text: string?,
	Offset: number?,
	EPBBType: number?,
	BindName: string?,
}

--[Lexer Type]--
export type LexerStateEnum = {
	Text: number,
	Offset_Text: number,
	BB_Open: number,
	BB_Close: number,
	EPBB_Open: number,
	EPBB_Close: number,
}

export type LexerProperties = {
	--[Methods]--
	Tokenize: (RawText: RawText) -> (Success, TokenizedText?, Reason?),
}

--[Parser Type]--
export type ParserProperties = {
	--[Methods]--
	Parse: (TokenizedText: TokenizedText) -> (Success, ParsedText?, MetadataMap?, Reason?),
}

--[EPBBText Type]--
export type EPBBTextProperties = {
	--[Public]--
	Raw: RawText,

	--[Private]--
	Metadata: MetadataMap,
	Parsed: ParsedText,

	--[Methods]--
	--[Public]--
	New: (Raw: RawText) -> (Success, EPBBTextProperties?, Reason?),
	UpdateRaw: (self: EPBBTextProperties, Raw: RawText) -> (Success, EPBBTextProperties?, Reason?),
	Bind: (
		self: EPBBTextProperties,
		Enum: MetadataEnum,
		Data: ValidMetadata,
		Name: string,
		Args: { any }?
	) -> (Success, Reason?),
	Out: (self: EPBBTextProperties, Label: UILabel) -> OutputCallback,
}

return Types
