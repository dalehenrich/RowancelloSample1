Extension { #name : 'RwLoadComponent' }

{ #category : 'visiting' }
RwLoadComponent >> acceptClusterVisitor: aVisitor [
	"no conditions"
	^ self
		acceptClusterVisitor: aVisitor
		withAccumulatedConditions: 'common'
		conditions: {'common'}
]

{ #category : 'visiting' }
RwLoadComponent >> acceptClusterVisitor: aVisitor withAccumulatedConditions: accumulatedConditions conditions: conditions [
	"if conditions is nil, no comditions"
	"no conditions"
	self halt: '???'.
"
	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
"
]

{ #category : 'visiting' }
RwLoadComponent >> acceptClusterVisitor: aVisitor withConditions: accumulatedConditions [
	"no conditions"

	^ aVisitor visitLoadComponent: self withConditions: accumulatedConditions
]

{ #category : 'extensions' }
RwLoadComponent >> populateClustersForProject: aResolvedProject [
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

	| theCluster  clusterName |
	clusterName := self name.
	theCluster := aResolvedProject
		addClusterNamed: clusterName
		comment: self comment.
	self componentNames
		do: [ :componentName | 
			| aComponent |
			aComponent := aResolvedProject componentNamed: componentName.
			aComponent
				populateSubclustersForProject: aResolvedProject
				clusterName: clusterName ]
]
