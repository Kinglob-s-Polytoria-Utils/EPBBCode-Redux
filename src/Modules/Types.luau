local Types = {}

--[Types for readability]--
type FolderOfImages = Folder

export type ColumnNumber = number
export type RowNumber = number
export type OutputCallback = (string) -> string

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

export type EPBBEnums = {
	MetadataEnum: MetadataEnum,
	TokenEnum: TokenEnum,
	LexerStateEnum: LexerStateEnum,
}

export type Reason = string
export type Success = boolean

export type RawText = string
export type TokenizedText = { Token }

export type Metadata = BoundFunctions | BoundImages | BoundImageSequences | BoundEvents
export type MetadataMap = { [number]: Metadata }

--[Types for validity checks]--
export type ValidFunction = PTFunction | PTCallback | () -> any
export type ValidEvent = BindableEvent | NetworkEvent | PTSignal
export type ValidMetadata = BoundImage | BoundImageSequence | BoundEvent | BoundFunction

--[Definitions for the tokenizer]--
Types.BB_Open				= "[.]"
Types.BB_Close			= "[/.]"

Types.EPBB_Open			= "<.>"
Types.EPBB_Close		= "</.>"

Types.Function			= "func"
Types.Event					= "event"
Types.Image					= "img"
Types.ImageSequence = "imgseq"

Types.GrepBoundName	= "'([^']+)'"

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
	BoundName: string?,
	Offset: number?,
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

--[EPBBText Type]--
export type EPBBTextProperties = {
	--[Public]--
	Raw: RawText,

	--[Private]--
	Metadata: MetadataMap,
	Tokens: TokenizedText,
	TypewriterDelay: number,
	Paused: boolean,

	--[Methods]--
	--[Public]--
	New: (Raw: RawText, TypewriterDelay: number) -> (Success, EPBBTextProperties?, Reason?),
	UpdateRaw: (self: EPBBText, Raw: RawText) -> (Success, Reason?),
	UpdateDelay: (self: EPBBText, TypewriterDelay: number) -> (Success, Reason?),

	Pause: (self: EPBBText) -> (Success, Reason?),
	Unpause: (self: EPBBText) -> (Success, Reason?),

	HandleMetadata: (self: EPBBText, Enum: number, BoundName: string) -> (Success, Reason?),

	Bind: (
		self: EPBBText,
		Enum: MetadataEnum,
		Data: ValidMetadata,
		Name: string,
		Args: { any }?
	) -> (Success, Reason?),
	Out: (self: EPBBTextProperties, Label: UILabel, Callback: OutputCallback, isTypewriter: boolean?, haveGibberishPostText: boolean?) -> (Success, Reason?)
}

export type EPBBText = typeof(setmetatable(
	{} :: EPBBTextProperties,
	{}
))

return Types
