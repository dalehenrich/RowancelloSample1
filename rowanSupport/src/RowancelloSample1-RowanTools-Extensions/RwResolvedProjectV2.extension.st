Extension { #name : 'RwResolvedProjectV2' }

{ #category : 'initialization' }
RwResolvedProjectV2 >> initializeV4 [
	"repository must be explicitly created"

	projectDefinition := RwProjectDefinition new.
	projectSpecification := RwProjectSpecificationV4_cluster new.
	loadSpecification := RwLoadSpecificationV4_cluster new.
]
