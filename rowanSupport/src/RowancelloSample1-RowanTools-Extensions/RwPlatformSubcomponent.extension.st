Extension { #name : 'RwPlatformSubcomponent' }

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor [
	"condition is an array"

	^ aVisitor visitSubcomponent: self withConditions: self condition copy
]

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
	"condition is an array"
"
	| conditions |
	conditions := accumulatedConditions copy.
	self condition do: [:each |
		(conditions includes: each) ifFalse: [ conditions add: each ]].
	^ aVisitor
		visitSubcomponent: self
		withConditions: conditions
"
]

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"condition is an array"

	| conditions |
	conditions := accumulatedConditions copy.
	self condition do: [:each |
		(conditions includes: each) ifFalse: [ conditions add: each ]].
	^ aVisitor
		visitSubcomponent: self
		withConditions: conditions
]
