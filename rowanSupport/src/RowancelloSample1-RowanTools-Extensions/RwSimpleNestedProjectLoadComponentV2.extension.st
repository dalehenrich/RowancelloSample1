Extension { #name : 'RwSimpleNestedProjectLoadComponentV2' }

{ #category : 'accessing' }
RwSimpleNestedProjectLoadComponentV2 >> clusterCondition [
	^ self condition
]

{ #category : 'accessing' }
RwSimpleNestedProjectLoadComponentV2 >> populateClustersForProject: aResolvedProject [
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

super populateClustersForProject: aResolvedProject .
GsFile gciLogServer: 'populate: ', self name.
false ifTrue: [ 		"I am a subcluster too"
	self populateSubclustersForProject: aResolvedProject conditions: self clusterCondition clusterName: self name
	]
]

{ #category : 'accessing' }
RwSimpleNestedProjectLoadComponentV2 >> populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName [
	"A RwSimpleProjectLoadComponent can be used as a load component OR subcomponent"
	"create a subcluster to hold the condition, packageNames, and projectNames for the components in this project; ignore  conditionalPackageMapSpecs for now; pre and post load doits ..."

	super populateSubclustersForProject: aResolvedProject conditions: conditions clusterName: clusterName.
	"I am a cluster as well"
	self populateClustersForProject: aResolvedProject .
]
