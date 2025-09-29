Extension { #name : 'RwAbstractResolvedObjectV2' }

{ #category : 'instance creation' }
RwAbstractResolvedObjectV2 class >> newV4_cluster [
	"Create a new project that uses project spec and cluster classes that are default for Rowan v4 clusters"

	^ self basicNew initializeV4_cluster
]

{ #category : 'initialization' }
RwAbstractResolvedObjectV2 >> initializeV4_cluster [
	"Create a new project that uses Rowan v4 cluster  project spec and cluster classes "

	self initialize.
	projectSpecification := RwProjectSpecificationV4_cluster_2 new.
	loadSpecification := RwLoadSpecificationV4_cluster new.
]
