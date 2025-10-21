Extension { #name : 'RwPlatformNestedProjectLoadComponentV2' }

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
