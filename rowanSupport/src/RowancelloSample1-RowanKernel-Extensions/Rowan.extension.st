Extension { #name : 'Rowan' }

{ #category : '*rowancellosample1-rowankernel-extensions' }
Rowan class >> newV4_clusterProjectNamed: projectName [
	"Create a new project that uses project spec and component classes that are compatible with Rowan v4 clusters"

	^ self platform newV4_clusterProjectNamed: projectName
]
