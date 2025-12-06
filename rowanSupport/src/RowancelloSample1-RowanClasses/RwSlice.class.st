Class {
	#name : 'RwSlice',
	#superclass : 'Object',
	#instVars : [
		'sliceName',
		'clusterNames',
		'packageNames',
		'projectNames',
		'subclusterNames',
		'comment'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'instance creation' }
RwSlice class >> new [

	^ self basicNew initialize
]

{ #category : 'accessing' }
RwSlice >> addClusterNamed: aClusterName [
	(self clusterNames includes: aClusterName)
		ifFalse: [ self clusterNames add: aClusterName ]
]

{ #category : 'accessing' }
RwSlice >> addSubclusterNamed: aSubclusterName [
	(self subclusterNames includes: aSubclusterName)
		ifFalse: [ self subclusterNames add: aSubclusterName ]
]

{ #category : 'accessing' }
RwSlice >> clusterNames [
	^clusterNames
]

{ #category : 'accessing' }
RwSlice >> clusterNames: object [
	clusterNames := object
]

{ #category : 'accessing' }
RwSlice >> comment [
	^comment

]

{ #category : 'accessing' }
RwSlice >> comment: newValue [
	comment := newValue

]

{ #category : 'initialization' }
RwSlice >> initialize [
	clusterNames := Array new.
	subclusterNames := Array new.
	packageNames := Array new.
	projectNames := Array new
]

{ #category : 'accessing' }
RwSlice >> packageNames [
	^packageNames
]

{ #category : 'accessing' }
RwSlice >> packageNames: object [
	packageNames := object
]

{ #category : 'accessing' }
RwSlice >> projectNames [
	^projectNames
]

{ #category : 'accessing' }
RwSlice >> projectNames: object [
	projectNames := object
]

{ #category : 'accessing' }
RwSlice >> sliceName [
	^sliceName

]

{ #category : 'accessing' }
RwSlice >> sliceName: newValue [
	sliceName := newValue

]

{ #category : 'accessing' }
RwSlice >> subclusterNames [
	^subclusterNames
]

{ #category : 'accessing' }
RwSlice >> subclusterNames: object [
	subclusterNames := object
]
