Class {
	#name : 'RwPrjWriteToolV4',
	#superclass : 'RwPrjWriteToolV2',
	#category : 'RowancelloSample1-RowanTools'
}

{ #category : 'write' }
RwPrjWriteToolV4 >> writeResolvedProject: resolvedProject [
	"write project artifacts, EXCEPT load spec as the load spec is typically modified during load.
		The load spec should be written shortly after being read from disk AFTER any
		intentional changes have been made"

	Rowan projectTools createV2
		createResolvedProjectRepository: resolvedProject repository.
	resolvedProject
		exportProjectSpecification;
		exportProjects;
		exportClusters;
		exportPackages
]
