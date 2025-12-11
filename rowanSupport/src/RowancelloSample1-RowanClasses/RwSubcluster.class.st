Class {
	#name : 'RwSubcluster',
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
RwSubcluster >> _exportToUrl: directoryUrl [
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
RwSubcluster >> addPackagesNamed: packagesNamed [
	packagesNamed
		do: [ :each | 
			(self packageNames includes: each)
				ifFalse: [ packageNames add: each ] ]
]

{ #category : 'accessing' }
RwSubcluster >> addProjectsNamed: projectsNamed [
	projectsNamed
		do: [ :each | 
			(self projectNames includes: each)
				ifFalse: [ projectNames add: each ] ]
]

{ #category : 'accessing' }
RwSubcluster >> addProjectsNamed: projectsNamed condition: conditionExpression [
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
RwSubcluster >> comment [
	^comment
]

{ #category : 'accessing' }
RwSubcluster >> comment: object [
	comment := object
]

{ #category : 'accessing' }
RwSubcluster >> condition [
	^condition
]

{ #category : 'accessing' }
RwSubcluster >> condition: aString [
	aString isString
		ifFalse: [ self error: 'The condition is expected to be an expression string' ].
	condition := aString
]

{ #category : 'exporting' }
RwSubcluster >> exportToUrl: directoryUrl [
	^ self copy initializeForExport
		_exportToUrl: directoryUrl;
		yourself
]

{ #category : 'initialization' }
RwSubcluster >> initializeForExport [
]

{ #category : 'accessing' }
RwSubcluster >> packageNames [
	^packageNames ifNil: [ packageNames := Array new ]
]

{ #category : 'accessing' }
RwSubcluster >> projectNames [
	^projectNames ifNil: [ projectNames := Array new ]
]

{ #category : 'accessing' }
RwSubcluster >> subclusterName [
	^subclusterName
]

{ #category : 'accessing' }
RwSubcluster >> subclusterName: object [
	subclusterName := object
]
