Class {
	#name : 'RwSimpleProjectClusterTest',
	#superclass : 'RwAbstractClusterTest',
	#category : 'RowancelloSample1-RowanKernel-Extensions-Tests'
}

{ #category : 'tests' }
RwSimpleProjectClusterTest >> testBasic [
	"excercise basic functionality for RwResolvedLoadComponentV2"

	| definedProject packageName projectName |
	projectName := 'Cluster_test'.
	packageName := projectName , '-Core'.

	(Rowan image loadedProjectNamed: projectName ifAbsent: [  ])
		ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ].

	definedProject := (Rowan newV4_clusterProjectNamed: projectName)
		projectsHome: '$ROWAN_PROJECTS_SANDBOX';
		gemstoneSetDefaultSymbolDictNameTo: 'UserGlobals';
		addClusterNamed: 'Core';
		addPackagesNamed: {packageName} toClusterNamed: 'Core';
		packageConvention: 'Rowan';
		yourself.
]
