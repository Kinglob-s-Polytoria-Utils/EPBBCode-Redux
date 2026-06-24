--!strict

local Types = {}

--[Types for readability]--
type ColumnNumber		= number
type RowNumber			= number
type MetadataEnum		= number
type TokenEnum			= number
type SegmentEnum		= number
type FolderOfImages	= Folder

export type Reason					= string
export type Success					= boolean

export type ParsedText			= {Segment}
export type TokenizedText		= {Token}

export type Metadata				= BoundFunctions | BoundImages | BoundImageSequences | BoundEvents
export type MetadataMap			= {[MetadataEnum]: Metadata}

--[Types for validity checks]--
export type ValidFunction		= PTFunction | PTCallback | () -> any
export type ValidEvent			= BindableEvent | NetworkEvent | PTSignal
export type ValidMetadata		= BoundImage | BoundImageSequence | BoundEvent | BoundFunction

--[Bound EPBBCode Metadata types]--
export type BoundImage = {
	Cache: UIImage,
	ImageAsset: PTImageAsset?
}
export type BoundImages = {[RowNumber]: {[ColumnNumber]: BoundImage}}

export type BoundImageSequence = {
	SequenceData: {PTImageAsset},
	Images: {UIImage},
	Cache: FolderOfImages
}
export type BoundImageSequences = {[RowNumber]: {[ColumnNumber]: BoundImageSequence}}

export type BoundFunction = {
	Call: ValidFunction,
	Payload: {any}?
}
export type BoundFunctions = {[RowNumber]: {[ColumnNumber]: BoundFunction}}

export type BoundEvent = {
	Event: ValidEvent,
	isNetwork: boolean
}
export type BoundEvents = {[RowNumber]: {[ColumnNumber]: BoundEvent}}

--[Custom data types for lexing, parsing and output]--
export type Token = {
	Type:						TokenEnum,
	Column:					ColumnNumber,
	Row:						RowNumber,
	ColumnLiteral:	number
}
export type Segment = {
	Type:						SegmentEnum,
	Text:						string,
	Offset:					number?,
	EPBBType:				number?,
	BindName:				string?
}

--[Lexer Type]--
export type LexerProperties	= {
	--[Methods]--
	Lex: (RawText: RawText) -> (Success, TokenizedText?, Reason?),
}

--[Parser Type]--
export type ParserProperties	= {
	--[Methods]--
	ParseRaw: (TokenizedText: TokenizedText) -> (Success, ParsedText?, MetadataMap? Reason?),
}

--[EPBBText Property types]--
export type ParsedText				= {Segment}
export type RawText						= string

--[EPBBText Type]--
export type EPBBTextProperties = {
	--[Public]--
	Raw: RawText,

	--[Private]--
	Metadata:	MetadataMap,	
	Parsed:		ParsedText,

	--[Methods]--
	--[Public]--
	New:			 (Raw: RawText)																-> (Success, EPBBTextProperties?, Reason?),
	UpdateRaw: (self: EPBBTextProperties, Raw: RawText)			-> (Success, EPBBTextProperties?, Reason?),
	Out:			 (self: EPBBTextProperties, Label: UILabel)		-> (CallBack: () -> (Success, string?, Reason?)),
	Bind:			 (
		self: EPBBTextProperties,
		Enum: MetadataEnum,
		Data: ValidMetadata,
		Name: string,
		Args: {any}?
	)																												-> (Success, Reason?)

}

return Types
