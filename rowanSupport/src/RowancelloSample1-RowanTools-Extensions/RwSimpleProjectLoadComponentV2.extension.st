Extension { #name : 'RwSimpleProjectLoadComponentV2' }

{ #category : 'accessing' }
RwSimpleProjectLoadComponentV2 >> clusterCondition [
	^ self condition
]

{ #category : 'conversion' }
RwSimpleProjectLoadComponentV2 >> populateClustersForProject: aResolvedProject [ 
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

	| theCluster  clusterName |
self halt: self class name.
	clusterName := self name.
	theCluster := aResolvedProject
		addClusterNamed: clusterName
		comment: self comment.
	theCluster
		addProjectsNamed: self projectNames;
		addPackagesNamed: self packageNames;
		yourself.
	self componentNames
		do: [ :componentName | 
			| aComponent |
			aComponent := aResolvedProject componentNamed: componentName.
			aComponent
				populateSubclustersForProject: aResolvedProject
				conditions: {(self clusterCondition)}
				clusterName: clusterName ]
]
