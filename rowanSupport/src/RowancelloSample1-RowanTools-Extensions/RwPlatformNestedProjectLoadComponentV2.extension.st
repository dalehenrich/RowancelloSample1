Extension { #name : 'RwPlatformNestedProjectLoadComponentV2' }

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"condition is an array"

	| accumulatedConditionExpression conditions |
	conditions := self conditions.
	accumulatedConditionExpression := conditions size > 1
		ifTrue: [ '(' copy ]
		ifFalse: [ String new ].
	1 to: conditions size do: [ :index | 
		accumulatedConditionExpression add: (conditions at: index).
		index < conditions size
			ifTrue: [ accumulatedConditionExpression add: ' | ' ] ].
	conditions size > 1
		ifTrue: [ accumulatedConditionExpression add: ')' ].
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: accumulatedConditionExpression
		conditions: conditions
]

{ #category : 'visiting' }
RwPlatformNestedProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditionExpression conditions: conditions [
	"condition is an array"

	| newAccumulatedConditionExpression |
	aVisitor currentClusterStack isEmpty
		ifTrue: [ 
			self halt: 'is the right thing to do?'.
			^ aVisitor visitLoadComponent: self withConditions: accumulatedConditionExpression ].
	newAccumulatedConditionExpression := accumulatedConditionExpression copy.
	^ aVisitor
		visitSubcomponent: self
		withAccumulatedConditions: newAccumulatedConditionExpression
		withConditions: conditions
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
	expression := '(' copy.
	1 to: conditions size do: [ :index | 
		"The incoming conditions are anded together"
		expression add: (conditions at: index).
		index < conditions size
			ifTrue: [ expression add: ' & ' ]
			ifFalse: [ expression add: ') & (' ] ].
	1 to: self condition size - 1 do: [ :index | 
		"The conditions in the reciever are ored together"
		expression add: (self condition at: index).
		expression add: ' | ' ].
	expression add: self condition last.
	conditions size > 1
		ifTrue: [ expression add: ')' ].
GsFile gciLogServer: '2. ', name, '  (clusterConditionExpression:) ', expression printString.
	^ expression
]
