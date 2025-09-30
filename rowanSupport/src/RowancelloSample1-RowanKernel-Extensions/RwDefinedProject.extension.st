Extension { #name : 'RwDefinedProject' }

{ #category : 'instance creation' }
RwDefinedProject class >> newV4_clusterNamed: aName [
	"Create a new project that uses project spec and cluster classes that are compatible with Rowan v4 clusters"

	^ self new
		initializeForName: aName;
		_concreteProjectV4_cluster;
		yourself
]

{ #category : 'private' }
RwDefinedProject >> _concreteProjectV4_cluster [
	"Create a new project that uses project spec and component classes that are compatible with Rowan v4"

	^ concreteProject
		ifNil: [ 
			concreteProject := RwResolvedProjectV4 newV4_cluster
				projectName: self name;
				yourself ]
]

{ #category : 'clusters' }
RwDefinedProject >> addClusterNamed: clusterName [
	"add a new instance of RwCluster to the project clusters and add the clusterName
		to the load spec (i.e., it will be loaded when the load spec is loaded)"

	^ self addClusterNamed: clusterName comment: ''
]

{ #category : 'clusters' }
RwDefinedProject >> addClusterNamed: componentName comment: aString [
	"add a new instance of RwCluster to the project clusters and add the clusterName
		to the load spec (i.e., it will be loaded when the load spec is loaded)"

	^ self _concreteProject addClusterNamed: componentName comment: aString
]

{ #category : 'clusters' }
RwDefinedProject >> addPackagesNamed: packageNames toSubclusterNamed: subclusterName [
	"add the named packages to the given subcluster"

	^ self _concreteProject addPackagesNamed: packageNames toSubclusterNamed: subclusterName condition: 'true'
]

{ #category : 'clusters' }
RwDefinedProject >> addPackagesNamed: packageNames toSubclusterNamed: subclusterName condition: conditionExpression [
	"add the named packages to the given subcluster"

	^ self _concreteProject addPackagesNamed: packageNames toSubclusterNamed: subclusterName condition: conditionExpression
]

{ #category : 'clusters' }
RwDefinedProject >> addProjectsNamed: projectNames toSubclusterNamed: subclusterName [
	"add the named projects to the given subcluster"

	^ self _concreteProject addProjectsNamed: projectNames toSubclusterNamed: subclusterName  condition: 'true'
]

{ #category : 'clusters' }
RwDefinedProject >> addProjectsNamed: projectNames toSubclusterNamed: subclusterName condition: conditionExpression [
	"add the named projects to the given subcluster"

	^ self _concreteProject addProjectsNamed: projectNames toSubclusterNamed: subclusterName condition: conditionExpression
]

{ #category : 'clusters' }
RwDefinedProject >> addSubclusterNamed: subclusterNamed toClusterNamed: clusterName [
	"add a new instance of RwCluster to the project clusters and add the clusterName
		to the load spec (i.e., it will be loaded when the load spec is loaded)"

	^ self addSubclusterNamed: subclusterNamed toClusterNamed: clusterName comment: ''
]

{ #category : 'clusters' }
RwDefinedProject >> addSubclusterNamed: subclusterNamed toClusterNamed: clusterName comment: aString [
	"add a new instance of RwSubcluster to the project subclusters"

	^ self _concreteProject addSubclusterNamed: subclusterNamed toClusterNamed: clusterName comment: aString
]
