Extension { #name : 'RwLoadComponent' }

{ #category : 'accessing' }
RwLoadComponent >> clusterCondition [
	^ 'common'
]

{ #category : 'extensions' }
RwLoadComponent >> populateClustersForProject: aResolvedProject [
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

	| theCluster  clusterName |
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
