Extension { #name : 'RwPlatformSubcomponent' }

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor [
	"condition is an array"

	^ aVisitor visitSubcomponent: self withConditions: self condition copy
]

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"condition is an array"

	^ aVisitor
		visitSubcomponent: self
		withConditions: (accumulatedConditions copy addAll: self condition)
]
