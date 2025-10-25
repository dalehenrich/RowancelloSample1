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

	^ aVisitor
		visitLoadComponent: self
		withConditions:
			(accumulatedConditions copy
				add: self condition;
				yourself)
]
