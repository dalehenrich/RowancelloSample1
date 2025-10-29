Extension { #name : 'RwPlatformNestedProjectLoadComponentV2' }

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"condition is an array"

	^ aVisitor visitSubcomponent: self withConditions: self condition copy
]

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"condition is an array"

	| conditions |
	aVisitor currentClusterStack isEmpty
		ifTrue: [ 
			"if there is no current cluster, then this  guy should create a cluster"
			self halt: 'is the right thing to do?'.
			^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions ].
	conditions := accumulatedConditions copy.
	self condition do: [:each |
		(conditions includes: each) ifFalse: [ conditions add: each ]].
	^ aVisitor
		visitSubcomponent: self
		withConditions: conditions
]

{ #category : 'accessing' }
RwPlatformNestedProjectLoadComponentV2 >> clusterConditionExpression: conditions [
	| expression |
	expression := String new.
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		expression add: ' & ' ].
	1 to: self condition size - 1 do: [ :index | 
		expression add: (self condition at: index).
		expression add: ' & ' ].
	expression add: self condition last.
	^ expression
]
