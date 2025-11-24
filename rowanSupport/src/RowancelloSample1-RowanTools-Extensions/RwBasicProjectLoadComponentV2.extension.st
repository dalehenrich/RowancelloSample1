Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"no condition"

	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: 'common'
		conditions: {'common'}
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
	"if conditions is nil, no coditions"
self halt: '1. conditions no longer needed?'.
	^ aVisitor visitLoadComponent: self withAccumulatedConditions: accumulatedConditions
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"no condition"

	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
]
