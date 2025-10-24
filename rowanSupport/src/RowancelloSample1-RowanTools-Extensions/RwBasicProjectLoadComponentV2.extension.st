Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	^ self acceptClusterVisitor: aVisitor withConditions: {}
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	self conditionalPackageMapSpecs isEmpty
		ifFalse: [ self halt: 'here are our conditions?' ].
	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
]
