Class {
	#name : 'RwSubclusterV2',
	#superclass : 'Object',
	#instVars : [
		'subclusterName',
		'packageNames',
		'projectNames',
		'comment',
		'condition'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'exporting' }
RwSubclusterV2 >> _exportToUrl: directoryUrl [
	| url |
	url := directoryUrl asRwUrl.
	url schemeName = 'file'
		ifTrue: [ 
			| fileRef |
			fileRef := url pathForDirectory asFileReference / self subclusterName , 'ston'.
			fileRef parent ensureCreateDirectory.
			fileRef
				writeStreamDo: [ :stream | 
					| string |
					string := STON toStringPretty: self.
					stream
						truncate;
						nextPutAll: string.
					^ self ] ].
	^ nil	"otherwise a noop"
]

{ #category : 'accessing' }
RwSubclusterV2 >> addPackagesNamed: packagesNamed [
	packagesNamed
		do: [ :each | 
			(self packageNames includes: each)
				ifFalse: [ packageNames add: each ] ]
]

{ #category : 'accessing' }
RwSubclusterV2 >> addProjectsNamed: projectsNamed [
	projectsNamed
		do: [ :each | 
			(self projectNames includes: each)
				ifFalse: [ projectNames add: each ] ]
]

{ #category : 'accessing' }
RwSubclusterV2 >> addProjectsNamed: projectsNamed condition: conditionExpression [
	| ar |
	ar := self conditionalProjectMap
		at: conditionExpression
		ifAbsentPut: [ Array new ].
	projectsNamed
		do:
			[ :each | 
			(ar includes: each)
				ifFalse: [ ar add: each ] ]
]

{ #category : 'accessing' }
RwSubclusterV2 >> comment [
	^comment
]

{ #category : 'accessing' }
RwSubclusterV2 >> comment: object [
	comment := object
]

{ #category : 'accessing' }
RwSubclusterV2 >> condition [
	^condition
]

{ #category : 'accessing' }
RwSubclusterV2 >> condition: aString [
	aString isString
		ifFalse: [ self error: 'The condition is expected to be an expression string' ].
	condition := aString
]

{ #category : 'exporting' }
RwSubclusterV2 >> exportToUrl: directoryUrl [
	^ self copy initializeForExport
		_exportToUrl: directoryUrl;
		yourself
]

{ #category : 'initialization' }
RwSubclusterV2 >> initializeForExport [
]

{ #category : 'accessing' }
RwSubclusterV2 >> packageNames [
	^packageNames ifNil: [ packageNames := Array new ]
]

{ #category : 'accessing' }
RwSubclusterV2 >> projectNames [
	^projectNames ifNil: [ projectNames := Array new ]
]

{ #category : 'accessing' }
RwSubclusterV2 >> subclusterName [
	^subclusterName
]

{ #category : 'accessing' }
RwSubclusterV2 >> subclusterName: object [
	subclusterName := object
]
