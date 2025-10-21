Extension { #name : 'RwSubcomponent' }

{ #category : 'accessing' }
RwSubcomponent >> clusterConditionExpression: conditions [
	| expression |
	expression := String new.
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		expression add: ' & ' ].
	expression add: self condition.
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
RwSubcomponent >> populateSubclustersForProject: aResolvedProject clusterName: clusterName [
	"create a subcluster to hold the cpackageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits ..."
	"the clusterPath will provide the list of conditionals that should be anded together when creating the condtion expression for the cluster"

	| theCluster theSubcluster |
	theCluster := aResolvedProject clusterNamed: clusterName.
	theSubcluster := aResolvedProject
		addSubclusterNamed: self name
		toClusterNamed: clusterName
		comment:
			'subcluster containing package and required project details'.
	theSubcluster
		addProjectsNamed: self projectNames;
		addPackagesNamed: self packageNames;
		yourself.
	^ theCluster
]

{ #category : 'accessing' }
RwSubcomponent >> populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName [
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits ..."

	"the clusterPath will provide the list of conditionals that should be anded together when creating the condtion expression for the cluster"

	| theCluster theSubcluster conditionExpression |
	theCluster := aResolvedProject clusterNamed: clusterName.
	theSubcluster := aResolvedProject
		addSubclusterNamed: self name
		toClusterNamed: clusterName
		comment:
			'subcluster containing the conditional package and required project details'.
	conditionExpression  := self clusterConditionExpression: conditions.
	theSubcluster
		addProjectsNamed: self projectNames condition: conditionExpression;
		addPackagesNamed: self packageNames condition: conditionExpression;
		yourself.
	^ theCluster
]
