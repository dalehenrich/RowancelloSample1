Class {
	#name : 'RwClusterConditionTest',
	#superclass : 'RwCAQEvaluatorTest',
	#category : 'RowancelloSample1-RowanKernel-Extensions-Tests'
}

{ #category : 'context management' }
RwClusterConditionTest >> prepareContext [
	"Load all of the implicit variables into context."

	super prepareContext.
	context set: 'gemstone.user' to: GsSession currentSession userProfile userId
]

{ #category : 'tests' }
RwClusterConditionTest >> testBasic [
	"Create a project that with clusters and subclusters ... has embedded utility functionality that can be leveraged by other external projects"
	"specify condition expressions for the subclusters"

	| definedProject packageName1 packageName2 packageName3 packageName4 packageName5 projectName loadSpec specName externalLoadSpec projectName1 |
	projectName := 'Cluster_test'.
	specName := projectName, 'External'.
	
	projectName1 := 'RequiredProject'.
	packageName1 := projectName , '-Utiity-Internal'.
	packageName2 := projectName , '-Utiity-Core'.
	packageName3 := projectName , '-Utiity-External'.
	
	packageName3 := projectName , '-Utiity-External'.
	packageName4 := projectName , '-Core'.
	packageName5 := projectName , '-GemStone'.

	(Rowan image loadedProjectNamed: projectName ifAbsent: [  ])
		ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ].

	definedProject := (Rowan newV4_clusterProjectNamed: projectName)
		projectsHome: '$ROWAN_PROJECTS_SANDBOX';
		gemstoneSetDefaultSymbolDictNameTo: 'UserGlobals';
		addClusterNamed: 'Core'  comment: 'Core implementation';
		addClusterNamed: 'Utility-Core'  comment: 'Core functionality for utility code';
		addClusterNamed: 'Utility-External' comment: 'External API for core utility code' ;

		addSubclusterNamed: 'Core' toClusterNamed: 'Core';
		addSubclusterNamed: 'Utility-Core' toClusterNamed: 'Utility-Core';
		addSubclusterNamed: 'Utility-External' toClusterNamed: 'Utility-External';

		addPackagesNamed: {packageName1} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName4} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName2} toSubclusterNamed: 'Utility-Core';
		addPackagesNamed: {packageName3} toSubclusterNamed: 'Utility-External';
		addPackagesNamed: {packageName5} toSubclusterNamed: 'Core' condition: 'gemstone';

		addProjectsNamed: {projectName1} toSubclusterNamed: 'Core' condition: 'gemstone';

		packageConvention: 'Rowan';
		yourself.
		
	loadSpec := definedProject loadSpecification
		addClustersNamed: {  'Core' . 'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code';
		yourself.
	externalLoadSpec := RwLoadSpecificationV4_cluster new
		projectName: projectName;
		specName: specName;
		projectSpecFile: 'rowan/project.ston';
		addClustersNamed: {   'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code into an external project';
		yourself.
	
	'/bosch1/users/dhenrich/_stones/git/RowancelloSample1/rowan/specs/RowancelloSample1_utility.ston'
		asFileReference writeStreamDo: [:stream | 
			stream truncate.
			externalLoadSpec exportToStream: stream ].
	"not quite ready"
	definedProject resolveProject
		projectsHome: '/bosch1/users/dhenrich/_stones/git/';
		diskUrl:  'file:/bosch1/users/dhenrich/_stones/git/RowancelloSample1';
		export
]
