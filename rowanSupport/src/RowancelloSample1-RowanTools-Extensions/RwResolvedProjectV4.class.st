Class {
	#name : 'RwResolvedProjectV4',
	#superclass : 'RwResolvedProjectV2',
	#instVars : [
		'projectClusters'
	],
	#category : 'Rowan-DefinitionsV2'
}

{ #category : 'instance creation' }
RwResolvedProjectV4 class >> newV4_cluster [
	"Create a new project that uses project spec and cluster classes that are default for Rowan v4 clusters"

	^ self basicNew initializeV4
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> _projectClusters [
self halt: 'need to define the project cluster implementation class'.
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> _projectClusters: object [
	"project clusters should not be accessed directly -- Rowan private state"

	projectClusters := object
]

{ #category : 'initialization' }
RwResolvedProjectV4 >> initialize [

	self initializeV4
]

{ #category : 'initialization' }
RwResolvedProjectV4 >> initializeV4 [

	super initializeV4.
	projectDefinition := RwProjectDefinition new.
	projectClusters := "RwProjectClusterDefinition new" nil.
]

{ #category : 'copying' }
RwResolvedProjectV4 >> postCopy [
	super postCopy.
	projectDefinition := projectDefinition copy.
	projectClusters := projectClusters copy
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> projectDefinition [
	^ RwResolvedProjectV2 new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		yourself
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> projectSpecification [
	^ RwResolvedProjectSpecificationV2 new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		yourself
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> repository [
	^ RwResolvedRepositoryV2 new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		yourself
]
