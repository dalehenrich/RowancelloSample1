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
	^ projectClusters
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> _projectClusters: object [
	"project clusters should not be accessed directly -- Rowan private state"

	projectClusters := object
]

{ #category : 'clusters' }
RwResolvedProjectV4 >> addClusterNamed: aClusterName comment: aString [
	"add a new instance of RwCluster to the project clusters and add the clusterName
		to the load spec (i.e., it will be loaded when the load spec is loaded)"

	self loadSpecification addClusterNamed: aClusterName.
	self _projectSpecification useV4ClusterClasses
		ifTrue: [ ^ self _projectClusters addClusterNamed: aClusterName comment: aString ]
		ifFalse: [ 
			^ self  error:  self _projectSpecification projectName, ' does not support clusters.']
]

{ #category : 'clusters' }
RwResolvedProjectV4 >> addPackagesNamed: packageNames toSubclusterNamed: subclusterName [
	"add the list of packagesNamed to the named subclusterName"

	self  addPackagesNamed: packageNames toSubclusterNamed: subclusterName condition: 'true'
]

{ #category : 'clusters' }
RwResolvedProjectV4 >> addPackagesNamed: packageNames toSubclusterNamed: subclusterName condition: conditionExpression [
	"add the list of packagesNamed to the named subclusterName"

	self _projectSpecification useV4ClusterClasses
		ifTrue: [ ^ self _projectClusters  addPackagesNamed: packageNames toSubclusterNamed: subclusterName  condition: conditionExpression ]
		ifFalse: [ 
			^ self  error:  self _projectSpecification projectName, ' does not support subclusters.']
]

{ #category : 'clusters' }
RwResolvedProjectV4 >> addProjectsNamed: projectNames toSubclusterNamed: subclusterName condition: conditionExpression [
	"add the list of packagesNamed to the named subclusterName"

	self _projectSpecification useV4ClusterClasses
		ifTrue: [ ^ self _projectClusters  addProjectsNamed: projectNames toSubclusterNamed: subclusterName  condition: conditionExpression ]
		ifFalse: [ 
			^ self  error:  self _projectSpecification projectName, ' does not support subclusters.']
]

{ #category : 'clusters' }
RwResolvedProjectV4 >> addSubclusterNamed: aSubclusterName toClusterNamed: clusterName comment: aString [
	"add a new instance of RwSubcluster to the project clusters"

	self _projectSpecification useV4ClusterClasses
		ifTrue: [ ^ self _projectClusters addSubclusterNamed: aSubclusterName toClusterNamed: clusterName comment: aString ]
		ifFalse: [ 
			^ self  error:  self _projectSpecification projectName, ' does not support subclusters.']
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> clustersRoot [
	^ self repositoryRoot / self _projectSpecification clustersPath
]

{ #category : 'actions' }
RwResolvedProjectV4 >> export [
	"export project artifacts, EXCEPT load spec as the load spec is typically modified during load.
		The load spec should be exported shortly after being read from disk AFTER any
		intentional changes have been made"

	Rowan projectTools writeV4 writeResolvedProject: self
]

{ #category : 'exporting' }
RwResolvedProjectV4 >> exportClusters [
	self _projectClusters export: self clustersRoot
]

{ #category : 'initialization' }
RwResolvedProjectV4 >> initialize [

	self initializeV4
]

{ #category : 'initialization' }
RwResolvedProjectV4 >> initializeV4 [
	super initializeV4.
	projectDefinition := RwProjectDefinition new.
	projectClusters := RwResolvedProjectClusters new
		projectName: self projectName;
		yourself
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
	^ RwResolvedRepositoryV4 new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		yourself
]
