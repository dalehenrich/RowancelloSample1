Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'visiting' }
RwBasicProjectLoadComponentV2 >> acceptClusterVisitor: aVisitor [
	^ aVisitor visitLoadComponent: self
]
