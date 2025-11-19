Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"no condition"

	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: {}
		conditions: {}
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
"
	""no condition""

	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
"
]

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"no condition"

	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
]
