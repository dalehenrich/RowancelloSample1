Extension { #name : 'RwBasicProjectLoadComponentV2' }

{ #category : 'copying' }
RwBasicProjectLoadComponentV2 >> populateCluster: aCluster fromProject: aResolvedProject script: superDoitScript [
	"create a subcluster to hold the condition, packageNames, and projectNames; ignore  conditionalPackageMapSpecs for now; pre and post load doits"

	aCluster comment: self comment.
]
