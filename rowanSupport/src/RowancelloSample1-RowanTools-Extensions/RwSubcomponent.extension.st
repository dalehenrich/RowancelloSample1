Extension { #name : 'RwSubcomponent' }

{ #category : 'accessing' }
RwSubcomponent >> clusterCondition: conditions [
	| expression |
	expression := 'common' copy.
	1 to: conditions size do: [ :index | 
		index = 1
			ifFalse: [ expression add: ' & ' ].
		expression add: (conditions at: index) ].
	^ expression
]

{ #category : 'accessing' }
RwSubcomponent >> populateClustersForProject: aResolvedProject [
	"I should be populated by the explicit traversal of the components in the load component ... so do a sanity check ... and skip"

	aResolvedProject
		subclusterNamed: self name
		ifAbsent: [ 
			self
				error:
					'The subcluster named ' , self name , ' should have already been created' ]
]

{ #category : 'accessing' }
RwSubcomponent >> populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName [
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits ..."

	"the clusterPath will provide the list of conditionals that should be anded together when creating the condtion expression for the cluster"

	| theCluster theSubcluster |
	theCluster := aResolvedProject clusterNamed: clusterName.
	theSubcluster := aResolvedProject
		addSubclusterNamed: self name
		toClusterNamed: clusterName
		comment:
			'subcluster containing the conditional package and required project details'.
	theSubcluster
		addProjectsNamed: self projectNames condition: self clusterCondition;
		addPackagesNamed: self packageNames condition: self clusterCondition;
		yourself.
	^ theCluster
]
