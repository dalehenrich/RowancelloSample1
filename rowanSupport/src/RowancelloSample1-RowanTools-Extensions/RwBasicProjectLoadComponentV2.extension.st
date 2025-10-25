Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"no condition"

	^ self acceptClusterVisitor: aVisitor withConditions: {}
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"no condition"

	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
]
