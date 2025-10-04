Extension { #name : 'RwSimpleProjectLoadComponentV2' }

{ #category : 'conversion' }
RwSimpleProjectLoadComponentV2 >> populateClustersForProject: aResolvedProject [ 
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

	| theCluster theSubcluster |
	theCluster := aResolvedProject addClusterNamed: self name comment: self comment.
		self halt:
		'the following is not correct'.
	theSubcluster := aResolvedProject addSubclusterNamed: self name toClusterNamed: self clusterName.
]
