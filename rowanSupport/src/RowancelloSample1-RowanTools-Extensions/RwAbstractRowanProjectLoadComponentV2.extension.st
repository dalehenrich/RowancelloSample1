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

	| conditions |
	conditions := accumulatedConditions copy.
	(conditions includes: self condition) ifFalse: [ conditions add: self condition].
	^ aVisitor
		visitLoadComponent: self
		withConditions: conditions
]
