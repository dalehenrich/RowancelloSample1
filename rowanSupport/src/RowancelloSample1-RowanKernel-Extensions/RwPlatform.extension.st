Extension { #name : 'RwPlatform' }

{ #category : '*rowancellosample1-rowankernel-extensions' }
RwPlatform >> newV4_clusterProjectNamed: projectName [
	"Create a new project that uses project spec and cluster classes that are compatible with Rowan v4 clusters"

	^ RwDefinedProject newV4_clusterNamed: projectName
]
