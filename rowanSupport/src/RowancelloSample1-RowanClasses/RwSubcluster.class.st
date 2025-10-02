"
A RwSubcluster has a name, and a collection of condition/packageAndProjectNames pairs. When a subcluster is loaded, the list of packageAndProjectNames associated with a condition  that evaluates to true are loaded. A packageOrPronectName may not be present in more than one packageAndProjectName list in a subcluster and a packageOrProjectName may not be referenced by more than one subcluster ... Essentially each packageorProject must be associated with a single, unique condition in a single subcluster. 

These restrictions are put into place, because it can become too difficult to manage the dependencies if a package shows up in multple subclusters ...

See class comment for RwLoadeSpecifictionV4_cluster and RwCluster for additional information.
"
Class {
	#name : 'RwSubcluster',
	#superclass : 'Object',
	#instVars : [
		'subclusterName',
		'comment',
		'conditionalPackageMap',
		'conditionalProjectMap'
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
RwSubcluster >> addPackagesNamed: packageNames condition: conditionExpression [
	| ar |
	ar := self conditionalPackageMap
		at: conditionExpression
		ifAbsentPut: [ Array new ].
	packageNames
		do: [ :each | 
			(ar includes: each)
				ifFalse: [ ar add: each ] ]
]

{ #category : 'accessing' }
RwSubcluster >> addProjectsNamed: projectNames condition: conditionExpression [
	| ar |
	ar := self conditionalProjectMap
		at: conditionExpression
		ifAbsentPut: [ Array new ].
	projectNames
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
RwSubcluster >> conditionalPackageMap [
	^conditionalPackageMap ifNil: [  conditionalPackageMap := Dictionary new ]
]

{ #category : 'accessing' }
RwSubcluster >> conditionalProjectMap [
	^conditionalProjectMap  ifNil: [  conditionalProjectMap := Dictionary new ]
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
RwSubcluster >> subclusterName [
	^subclusterName
]

{ #category : 'accessing' }
RwSubcluster >> subclusterName: object [
	subclusterName := object
]
