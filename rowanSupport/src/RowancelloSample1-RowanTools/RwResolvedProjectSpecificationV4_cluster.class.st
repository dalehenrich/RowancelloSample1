Class {
	#name : 'RwResolvedProjectSpecificationV4_cluster',
	#superclass : 'RwResolvedProjectSpecificationV2',
	#instVars : [
		'projectClusters'
	],
	#category : 'Rowan-DefinitionsV2'
}

{ #category : 'accessing' }
RwResolvedProjectSpecificationV4_cluster >> _projectClusters: object [
	"project clusters should not be accessed directly -- Rowan private state"

	projectClusters := object
]
