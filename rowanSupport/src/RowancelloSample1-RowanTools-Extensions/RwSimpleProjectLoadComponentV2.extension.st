Extension { #name : 'RwSimpleProjectLoadComponentV2' }

{ #category : 'accessing' }
RwSimpleProjectLoadComponentV2 >> clusterCondition [
	^ self condition
]

{ #category : 'extensions' }
RwSimpleProjectLoadComponentV2 >> clusterConditionExpression: conditions [
	| expression |
	expression := String new.
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		expression add: ' & ' ].
	expression add: self condition.
	^ expression
]

{ #category : 'extensions' }
RwSimpleProjectLoadComponentV2 >> populateClustersForProject: aResolvedProject [ 
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

{ #category : 'extensions' }
RwSimpleProjectLoadComponentV2 >> populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName [
	"A RwsimpleProjectLoadComponent can be used as a load component OR subcomponent"
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
