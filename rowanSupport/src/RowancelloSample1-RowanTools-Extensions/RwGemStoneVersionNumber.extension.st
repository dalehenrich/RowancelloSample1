Extension { #name : 'RwGemStoneVersionNumber' }

{ #category : 'ston' }
RwGemStoneVersionNumber class >> fromSton: stonReader [
	^ self fromString: stonReader parseListSingleton
]

{ #category : 'ston' }
RwGemStoneVersionNumber >> stonOn: stonWriter [
	stonWriter writeObject: self listSingleton: self asString
]
