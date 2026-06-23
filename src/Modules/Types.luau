--!strict

local Types = {}

--[Types for readability]--
type ColumnNumber		= number
type RowNumber			= number
type MetadataEnum		= number
type TokenEnum			= number
type SegmentEnum		= number
type FolderOfImages	= Folder
type Reason					= string
type Success				= boolean

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

--[Binder Type]--

--[Lexer Type]--

--[Parser Type]--

--[EPBBText Property types]--
export type EPBBTextMetadata	= {[MetadataEnum]: Metadata}
export type ParsedText				= {Segment}
export type RawText						= string

--[EPBBText Type]--
export type EPBBTextProperties = {
	--[Public]--
	Raw: RawText,

	--[Private]--
	read Metadata: EPBBTextMetadata,	
	read Parsed:		ParsedText,

	--[Methods]--
	--[Public]--
	New:			 (Raw: RawText)																-> (EPBBTextProperties, Success, Reason?),
	UpdateRaw: (self: EPBBTextProperties, Raw: RawText)			-> (EPBBTextProperties, Success, Reason?),
	Out:			 (self: EPBBTextProperties, Label: UILabel)		-> (CallBack: () -> (string, Success, Reason?)),
	Bind:			 (
		self: EPBBTextProperties,
		Enum: MetadataEnum,
		Data: ValidMetadata,
		Name: string,
		Args: {any}?
	)																												-> (Success, Reason?)

}

return Types
