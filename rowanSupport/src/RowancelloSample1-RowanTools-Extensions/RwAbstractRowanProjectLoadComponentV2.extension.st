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
	|  conditions |
	conditions := {}.
	self condition ifNotNil: [ :c | 
		conditions add: c].
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: accumulatedConditionExpression
		 conditions: conditions
]

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditionExpression conditions: conditions [
	"single condition ... string"
	|   expression |
	expression := RwCluster
		updateConditionExpression: accumulatedConditionExpression copy
		conditions: conditions.
	^ aVisitor visitLoadComponent: self withAccumulatedConditions: expression
]
