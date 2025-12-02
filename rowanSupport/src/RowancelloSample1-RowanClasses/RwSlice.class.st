Class {
	#name : 'RwSlice',
	#superclass : 'Object',
	#instVars : [
		'sliceName',
		'comment',
		'clusters'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'accessing' }
RwSlice >> addClusterNamed: aClusterName [
	(self clusters includes: aClusterName)
		ifFalse: [ self clusters add: aClusterName ]
]

{ #category : 'accessing' }
RwSlice >> clusters [
	^clusters ifNil: [ clusters := Array new ]
]

{ #category : 'accessing' }
RwSlice >> clusters: newValue [
	clusters := newValue

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
	clusters := Array new.
]

{ #category : 'accessing' }
RwSlice >> sliceName [
	^sliceName

]

{ #category : 'accessing' }
RwSlice >> sliceName: newValue [
	sliceName := newValue

]
