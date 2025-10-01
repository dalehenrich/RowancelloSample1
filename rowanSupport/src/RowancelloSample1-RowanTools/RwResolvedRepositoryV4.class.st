Class {
	#name : 'RwResolvedRepositoryV4',
	#superclass : 'RwResolvedRepositoryV2',
	#instVars : [
		'projectClusters'
	],
	#category : 'RowancelloSample1-RowanTools'
}

{ #category : 'accessing' }
RwResolvedRepositoryV4 >> _projectClusters: object [
	"project clusters should not be accessed directly -- Rowan private state"

	projectClusters := object
]
