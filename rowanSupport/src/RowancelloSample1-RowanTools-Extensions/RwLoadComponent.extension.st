Extension { #name : 'RwLoadComponent' }

{ #category : 'accessing' }
RwLoadComponent >> clusterCondition [
	^ 'common'
]

{ #category : 'accessing' }
RwLoadComponent >> clusterConditionExpression: conditions [
	| expression |
	expression := String new.
	1 to: conditions size do: [ :index | 
		expression add: (conditions at: index).
		expression add: ' & ' ].
	expression add: self clusterCondition.
	^ expression
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
self halt.
	self componentNames
		do: [ :componentName | 
			| aComponent |
			aComponent := aResolvedProject componentNamed: componentName.
			aComponent
				populateSubclustersForProject: aResolvedProject
				conditions: {(self clusterCondition)}
				clusterName: clusterName ]
]

{ #category : 'accessing' }
RwLoadComponent >> populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName [
	"A RwSimpleProjectLoadComponent can be used as a load component OR subcomponent"
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
	^ theCluster
]
