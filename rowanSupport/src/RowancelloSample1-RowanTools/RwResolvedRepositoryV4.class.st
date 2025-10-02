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

{ #category : 'accessing' }
RwResolvedRepositoryV4 >> clustersRoot [
	^ self repositoryRoot / self _projectSpecification clustersPath
]

{ #category : 'accessing' }
RwResolvedRepositoryV4 >> projectRoots [
	^ {(self clustersRoot).
	(self packagesRoot).
	(self specsRoot).
	(self projectsRoot)}
]

{ #category : 'accessing' }
RwResolvedRepositoryV4 >> requiredProjectRoots [
	^ {(self clustersRoot).
	(self packagesRoot).
	(self specsRoot).
	(self projectsRoot)}
]
