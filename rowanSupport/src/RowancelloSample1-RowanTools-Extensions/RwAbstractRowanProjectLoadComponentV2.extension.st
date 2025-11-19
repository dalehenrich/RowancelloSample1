Extension { #name : 'RwAbstractRowanProjectLoadComponentV2' }

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"single condition ... string"

	| accumulatedConditions conditions |
	accumulatedConditions := {}.
	conditions := {}.
	self condition ifNotNil: [ :c | conditions add: c ].
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: accumulatedConditions
		conditions: conditions
]

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
	"single condition ... string"

"
	| conditions expression |
	conditions := accumulatedConditions copy.
	expression := conditions size > 1
		ifTrue: [ '(' copy ]
		ifFalse: [ String new ].
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		index < conditions size
			ifTrue: [ expression add: ' & ' ] ].
	conditions size > 1
		ifTrue: [ expression add: ')' ].
GsFile gciLogServer: '1. ', projectName , ' (acceptClusterVisitor:withConditions: )  ', expression printString.
	^ aVisitor
		visitLoadComponent: self
		withConditions: conditions
		andExpression: expression
"
]

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"single condition ... string"

	| conditions expression |
	conditions := accumulatedConditions copy.
	expression := conditions size > 1
		ifTrue: [ '(' copy ]
		ifFalse: [ String new ].
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		index < conditions size
			ifTrue: [ expression add: ' & ' ] ].
	conditions size > 1
		ifTrue: [ expression add: ')' ].
GsFile gciLogServer: '1. ', projectName , ' (acceptClusterVisitor:withConditions: )  ', expression printString.
	^ aVisitor
		visitLoadComponent: self
		withConditions: conditions
		andExpression: expression
]
