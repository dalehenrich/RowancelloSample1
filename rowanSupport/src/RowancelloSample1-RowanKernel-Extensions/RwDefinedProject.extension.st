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
			concreteProject := RwResolvedProjectV2 newV4_cluster
				projectName: self name;
				yourself ]
]
