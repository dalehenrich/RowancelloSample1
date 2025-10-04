Class {
	#name : 'RwResolvedProjectV4',
	#superclass : 'RwResolvedProjectV2',
	#instVars : [
		'projectClusters'
	],
	#category : 'Rowan-DefinitionsV2'
}

{ #category : 'instance creation' }
RwResolvedProjectV4 class >> basicLoadSpecification: anRwLoadSpecificationV2 [
	"
		Create a new instance of the receiver based on anRwLoadSpecificationV2.
		Return an instance of the receiver that is ready to be resolved (cloned to disk)
	"

	| loadSpecification projectDefinition pDict |
	loadSpecification := anRwLoadSpecificationV2 copy.
	(pDict := SymbolDictionary new) at: #'name' put: loadSpecification projectName.
	(projectDefinition := RwProjectDefinition basicNew)
		properties: pDict;
		packages: Dictionary new;
		projectDefinitionSourceProperty:
				RwLoadedProject _projectModifiedProjectSourceValue.
	^ self basicNew
		_projectDefinition: projectDefinition;
		_projectComponents: RwResolvedProjectComponentsV2 new;
		_projectClusters:
				(RwResolvedProjectClusters new
						projectName: loadSpecification projectName;
						yourself);
		_loadSpecification: loadSpecification;
		yourself
]

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

{ #category : 'private' }
RwResolvedProjectV4 >> _projectSpecification [
	"project specification should not be accessed directly -- Rowan private state"

	"lazy initialization, since project specification must be read from disk during resolve
		if it is present on disk"

	^ projectSpecification
		ifNil: [ 
			| projectSpecFileRef pName |
			projectSpecFileRef := self repositoryRoot / self projectSpecFile.
			pName := self projectName.	"projectSpecification is involved in default logic for projectName"
			projectSpecification := projectSpecFileRef exists
				ifTrue: [ (RwSpecification fromFile: projectSpecFileRef) copyAsV4_cluster]
				ifFalse: [ 
					Rowan projectTools trace trace: '--- creating new project spec. The project spec file ', projectSpecFileRef pathString printString, ' does not exist'.
					RwProjectSpecificationV4_cluster new ].
			projectSpecification
				projectName: pName;
				yourself ]
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

	packageNames
		do: [ :packageName | 
			self
				packageNamed: packageName
				ifAbsent: [ 
					| package |
					package := RwPackageDefinition newNamed: packageName.
					self _projectDefinition
						_addPackage: package
						ifPresent: [ 
							"no problem ... just update the component"
							 ] ] ].
	self _projectSpecification useV4ClusterClasses
		ifTrue: [ 
			^ self _projectClusters
				addPackagesNamed: packageNames
				toSubclusterNamed: subclusterName
				condition: conditionExpression ]
		ifFalse: [ 
			^ self
				error:
					self _projectSpecification projectName , ' does not support subclusters.' ]
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
		yourself.
	"for now"
	projectComponents := RwResolvedProjectComponentsV2 new
]

{ #category : 'copying' }
RwResolvedProjectV4 >> postCopy [
	super postCopy.
	projectDefinition := projectDefinition copy.
	projectClusters := projectClusters copy
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> projectDefinition [
	^ RwResolvedProjectV4 new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		_projectComponents: projectComponents;	"for the time being ... doing translation of components to clusters so having both is convenient"
		yourself
]

{ #category : 'exporting' }
RwResolvedProjectV4 >> projectRoots [
	^ {(self clustersRoot).
	(self packagesRoot).
	(self specsRoot).
	(self projectsRoot)}
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> projectSpecification [
	^ RwResolvedProjectSpecificationV4_cluster new
		_projectDefinition: projectDefinition;
		_projectRepository: projectRepository;
		_loadSpecification: loadSpecification;
		_projectSpecification: projectSpecification;
		_projectClusters: projectClusters;
		yourself
]

{ #category : 'accessing' }
RwResolvedProjectV4 >> requiredProjectRoots [

	^ {(self clustersRoot).
	(self packagesRoot).
	(self specsRoot).
	(self projectsRoot)}
]
