"
A RwCluster has a name and a list of subclusters. 

A RwSubcluster has a name, and a collection of condition/packageAndProjectNames pairs. When a subcluster is loaded, the list of packageAndProjectNames associated with a condition  that evaluates to true are loaded. A packageOrPronectName may not be present in more than one packageAndProjectName list in a subcluster and a packageOrProjectName may not be referenced by more than one subcluster ... Essentially each packageorProject must be associated with a single, unique condition in a single subcluster. 

These restrictions are put into place, because it can become too difficult to manage the dependencies if a package shows up in multple subclusters ...

See class comment for RwLoadeSpecifictionV4_cluster for additional information.
"
Class {
	#name : 'RwCluster',
	#superclass : 'Object',
	#instVars : [
		'clusterName',
		'subclusterNames',
		'comment'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'instance creation' }
RwCluster class >> new [

	^ self basicNew initialize
]

{ #category : 'utilities' }
RwCluster class >> updateConditionExpression: baseExpression conditions: conditions [
	| expression expressionConditions |
	expressionConditions := conditions copyWithout: 'common'.
	expressionConditions isEmpty
		ifTrue: [ ^ baseExpression ].
	expression := baseExpression isEmpty
		ifTrue: [ baseExpression copy ]
		ifFalse: [ 
			baseExpression = 'common'
				ifTrue: [ String new ]
				ifFalse: [ baseExpression , ' & ' ] ].
	expressionConditions size > 1
		ifTrue: [ 
			expression size > 1
				ifTrue: [ expression := expression , ' (' ]
				ifFalse: [ expression := expression , '(' ] ].
	1 to: expressionConditions size - 1 do: [ :index | 
		"The conditions in the reciever are ored together"
		expression add: (expressionConditions at: index).
		expression add: ' | ' ].
	expression add: expressionConditions last.
	expressionConditions size > 1
		ifTrue: [ expression add: ')' ].
	^ expression
]

{ #category : 'exporting' }
RwCluster >> _exportToUrl: directoryUrl [
	| url |
	url := directoryUrl asRwUrl.
	url schemeName = 'file'
		ifTrue: [ 
			| fileRef |
			fileRef := url pathForDirectory asFileReference / self clusterName , 'ston'.
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
RwCluster >> addSubclusterNamed: aSubclusterName [
	(subclusterNames includes: aSubclusterName)
		ifFalse: [ subclusterNames add: aSubclusterName ]
]

{ #category : 'accessing' }
RwCluster >> clusterName [
	^clusterName
]

{ #category : 'accessing' }
RwCluster >> clusterName: object [
	clusterName := object
]

{ #category : 'accessing' }
RwCluster >> comment [
	^comment
]

{ #category : 'accessing' }
RwCluster >> comment: object [
	comment := object
]

{ #category : 'exporting' }
RwCluster >> exportToUrl: directoryUrl [
	^ self copy initializeForExport
		_exportToUrl: directoryUrl;
		yourself
]

{ #category : 'initialization' }
RwCluster >> initialize [
	subclusterNames := Array new.
]

{ #category : 'initialization' }
RwCluster >> initializeForExport [
]

{ #category : 'accessing' }
RwCluster >> subclusterNames [
	^subclusterNames
]

{ #category : 'accessing' }
RwCluster >> subclusterNames: object [
	subclusterNames := object
]
