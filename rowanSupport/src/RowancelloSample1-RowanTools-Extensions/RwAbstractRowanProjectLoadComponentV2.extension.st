Extension { #name : 'RwAbstractRowanProjectLoadComponentV2' }

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"single condition ... string"

	| accumulatedConditionExpression conditions |
	conditions := {}.
	accumulatedConditionExpression := String new.
	self condition ifNotNil: [ :c | 
		accumulatedConditionExpression add: c.
		conditions add: c].
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: accumulatedConditionExpression
		 conditions: conditions
]

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditionExpression [ 
	"single condition ... string"
	|  conditions newAccumulatedConditionExpression |
	conditions := {}.
	newAccumulatedConditionExpression := accumulatedConditionExpression copy.
	self condition ifNotNil: [ :c | 
		conditions add: c].
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: newAccumulatedConditionExpression
		 conditions: conditions
]

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditionExpression conditions: conditions [
	"single condition ... string"
	| expression |
	expression := accumulatedConditionExpression size > 1
		ifTrue: [ '(' , accumulatedConditionExpression , ') & (' ]
		ifFalse: [ String new ].

	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		index < conditions size
			ifTrue: [ expression add: ' | ' ] ].
	conditions size > 1
		ifTrue: [ expression add: ')' ].
	accumulatedConditionExpression size > 1
		ifTrue: [ expression add: ')' ].
	^ aVisitor visitLoadComponent: self withAccumulatedConditions: expression
]
