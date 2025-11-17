Extension { #name : 'RwAbstractRowanProjectLoadComponentV2' }

{ #category : 'visiting' }
RwAbstractRowanProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	"single condition ... string"

	| conditions |
	conditions := {}.
	self condition ifNotNil: [ :c | conditions add: c ].
	^ self acceptClusterVisitor: aVisitor withConditions: conditions
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
	^ aVisitor
		visitLoadComponent: self
		withConditions: conditions
		andExpression: expression
]
