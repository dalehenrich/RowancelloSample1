Extension { #name : 'RwPlatformSubcomponent' }

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor [
	"condition is an array"

	| accumulatedConditionExpression conditions |
    self halt: 'Use RwCluster>>updateConditionExpression:conditions:'.
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

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditionExpression [
	"condition is an array"

	| newAccumulatedConditionExpression |
	newAccumulatedConditionExpression := RwCluster
		updateConditionExpression: accumulatedConditionExpression copy
		conditions: (self condition ifNil: [ 'common' ] ifNotNil: [ :c | c ]).
	^ aVisitor
		visitSubcomponent: self
		withAccumulatedConditions: newAccumulatedConditionExpression
]

{ #category : 'accessing' }
RwPlatformSubcomponent >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
	"if conditions is nil, no coditions"
	"condition is an array"
    self halt: 'Use RwCluster>>updateConditionExpression:conditions:'.
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
    self halt: 'Use RwCluster>>updateConditionExpression:conditions:'.
	conditions := accumulatedConditions copy.
	self condition do: [:each |
		(conditions includes: each) ifFalse: [ conditions add: each ]].
	^ aVisitor
		visitSubcomponent: self
		withConditions: conditions
]
