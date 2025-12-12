Class {
	#name : 'RwSlice',
	#superclass : 'Object',
	#instVars : [
		'sliceName',
		'clusterNames',
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
]

{ #category : 'accessing' }
RwSlice >> sliceName [
	^sliceName

]

{ #category : 'accessing' }
RwSlice >> sliceName: newValue [
	sliceName := newValue

]
