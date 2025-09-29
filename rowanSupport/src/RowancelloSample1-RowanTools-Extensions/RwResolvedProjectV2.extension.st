Extension { #name : 'RwResolvedProjectV2' }

{ #category : 'cluster' }
RwResolvedProjectV2 >> addClusterNamed: aClusterName comment: aString [
	"add a new instance of RwCluster to the project clusters and add the clusterName
		to the load spec (i.e., it will be loaded when the load spec is loaded)"

	self loadSpecification addClusterNamed: aClusterName.
	self _projectSpecification useV4ClusterClasses
		ifTrue: [ ^ self _projectClusters addClusterNamed: aClusterName comment: aString ]
		ifFalse: [ 
			^ self  error:  self _projectSpecification projectName, ' does not support clusters.']
]

{ #category : 'initialization' }
RwResolvedProjectV2 >> initializeV4 [
	"repository must be explicitly created"

	projectDefinition := RwProjectDefinition new.
	projectSpecification := RwProjectSpecificationV4_cluster_2 new.
	loadSpecification := RwLoadSpecificationV4_cluster new.
]
