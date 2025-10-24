Extension { #name : 'RwPlatformNestedProjectLoadComponentV2' }

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	^ aVisitor
		visitSubcomponent: self
		withConditions: self condition copy
]

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	^ aVisitor
		visitSubcomponent: self
		withConditions: (accumulatedConditions copy addAll: self condition)
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
