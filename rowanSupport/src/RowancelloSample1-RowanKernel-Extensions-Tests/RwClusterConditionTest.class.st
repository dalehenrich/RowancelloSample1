Class {
	#name : 'RwClusterConditionTest',
	#superclass : 'TestCase',
	#category : 'RowancelloSample1-RowanKernel-Extensions-Tests'
}

{ #category : 'tests' }
RwClusterConditionTest >> testBasic_1 [
	"Create a project that with clusters and subclusters ... has embedded utility functionality that can be leveraged by other external projects"

	"Separate subclusters for tests and core"
	
	| definedProject packageName1 packageName2 packageName3 packageName4 packageName5 packageName6 packageName7 packageName8 packageName9 projectName loadSpec specName externalLoadSpec projectName1 |
	projectName := 'Cluster_Example'.
	specName := projectName, 'External'.
	
	projectName1 := 'RequiredProject'.
	packageName1 := projectName , '-Utiity-Internal'.
	packageName2 := projectName , '-Utiity-Core'.
	
	packageName3 := projectName , '-Utiity-External'.
	packageName4 := projectName , '-Core'.
	packageName5 := projectName , '-GemStone'.
	
	packageName6 := projectName , '-Core-Tests'.
	packageName7:= projectName , '-GemStone-Tests'.
	packageName8 := projectName , '-Utility-Tests'.
	packageName9 := projectName , '-Utility-External-Tests'.

	(Rowan image loadedProjectNamed: projectName ifAbsent: [  ])
		ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ].

	definedProject := (Rowan newV4_clusterProjectNamed: projectName)
		projectsHome: '$ROWAN_PROJECTS_SANDBOX';
		gemstoneSetDefaultSymbolDictNameTo: 'UserGlobals';
		"clusters are the loadable components of a project -- Core, Utility-Core, and Utility-External -- are the three independently loadable entities defined in this project"
		addClusterNamed: 'Core'  comment: 'Core implementation';
		addClusterNamed: 'Utility-Core'  comment: 'Utility code is code that is used by other projects and hasn''t been split out into a project of it''s own';
		addClusterNamed: 'Utility-External' comment: 'External API for core utility code -- shares an API with anouther project with a slightly different implementation' ;
		"subclusters are added to clusters ... and subclusters hold onlto conditional lists of package names and package properties"
		addSubclusterNamed: 'Core' toClusterNamed: 'Core';
		addSubclusterNamed: 'Utility-Core' toClusterNamed: 'Utility-Core';
		addSubclusterNamed: 'Utility-External' toClusterNamed: 'Utility-External';
		addSubclusterNamed: 'Tests' toClusterNamed: 'Core';
		addSubclusterNamed: 'Utility-Tests' toClusterNamed: 'Utility-Core';
		addSubclusterNamed: 'Utility-External-Tests' toClusterNamed: 'Utility-External';
		"Here we add packages to subclusters"
		addPackagesNamed: {packageName1} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName4} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName2} toSubclusterNamed: 'Utility-Core';
		addPackagesNamed: {packageName3} toSubclusterNamed: 'Utility-External';
		"Here we are adding packages to subclusters with conditional expressions ... typically the conditions conrol platform or tests"
		addPackagesNamed: {packageName5} toSubclusterNamed: 'Core' condition: 'gemstone';
		addPackagesNamed: {packageName6} toSubclusterNamed: 'Tests' condition: 'tests';
		addPackagesNamed: {packageName7} toSubclusterNamed: 'Tests' condition: 'gemstone & tests';
		addPackagesNamed: {packageName8} toSubclusterNamed: 'Utility-Tests' condition: 'tests';
		addPackagesNamed: {packageName9} toSubclusterNamed: 'Utility-External-Tests' condition: 'tests';

		addProjectsNamed: {projectName1} toSubclusterNamed: 'Core' condition: 'gemstone';

		packageConvention: 'Rowan';
		yourself.
	"Here we define the project load spec in terms of named clusters, if we set a conditional attribute like tests to true, then the tests associated with these clusters will be loaded as well"
	loadSpec := definedProject loadSpecification
		addClustersNamed: {  'Core' . 'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code';
		yourself.
	"Here we define an lload spec intended to be used by folks interested in uing the Utility-External functionality in this project"
	externalLoadSpec := RwLoadSpecificationV4_cluster new
		projectName: projectName;
		specName: specName;
		projectSpecFile: 'rowan/project.ston';
		addClustersNamed: {   'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code into an external project';
		yourself.
	"Here we export the external loadSpect to disk"
	'/bosch1/users/dhenrich/_stones/git/RowancelloSample1/rowan/specs/RowancelloSample1_utility.ston'
		asFileReference writeStreamDo: [:stream | 
			stream truncate.
			externalLoadSpec exportToStream: stream ].
	"and here we export the entire project to disk"
	definedProject resolveProject
		projectsHome: '/bosch1/users/dhenrich/_stones/git/';
		diskUrl:  'file:/bosch1/users/dhenrich/_stones/git/RowancelloSample1';
		export
]

{ #category : 'tests' }
RwClusterConditionTest >> testBasic_2 [
	"Create a project that with clusters and subclusters ... has embedded utility functionality that can be leveraged by other external projects"

	"Combine tests and core in a single subcluster"
	
	| definedProject packageName1 packageName2 packageName3 packageName4 packageName5 packageName6 packageName7 packageName8 packageName9 projectName loadSpec specName externalLoadSpec projectName1 |
	projectName := 'Cluster_Example'.
	specName := projectName, 'External'.
	projectName1 := 'RequiredProject'.
	packageName1 := projectName , '-Utiity-Internal'.
	packageName2 := projectName , '-Utiity-Core'.
	
	packageName3 := projectName , '-Utiity-External'.
	packageName4 := projectName , '-Core'.
	packageName5 := projectName , '-GemStone'.
	
	packageName6 := projectName , '-Core-Tests'.
	packageName7:= projectName , '-GemStone-Tests'.
	packageName8 := projectName , '-Utility-Tests'.
	packageName9 := projectName , '-Utility-External-Tests'.

	(Rowan image loadedProjectNamed: projectName ifAbsent: [  ])
		ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ].

	definedProject := (Rowan newV4_clusterProjectNamed: projectName)
		projectsHome: '$ROWAN_PROJECTS_SANDBOX';
		gemstoneSetDefaultSymbolDictNameTo: 'UserGlobals';
		"clusters are the loadable components of a project -- Core, Utility-Core, and Utility-External -- are the three independently loadable entities defined in this project"
		addClusterNamed: 'Core'  comment: 'Core implementation';
		addClusterNamed: 'Utility-Core'  comment: 'Utility code is code that is used by other projects and hasn''t been split out into a project of it''s own';
		addClusterNamed: 'Utility-External' comment: 'External API for core utility code -- shares an API with anouther project with a slightly different implementation' ;
		"subclusters are added to clusters ... and subclusters hold onlto conditional lists of package names and package properties"
		addSubclusterNamed: 'Core' toClusterNamed: 'Core';
		addSubclusterNamed: 'Utility-Core' toClusterNamed: 'Utility-Core';
		addSubclusterNamed: 'Utility-External' toClusterNamed: 'Utility-External';

		"Here we add packages to subclusters"
		addPackagesNamed: {packageName1} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName4} toSubclusterNamed: 'Core';
		addPackagesNamed: {packageName2} toSubclusterNamed: 'Utility-Core';
		addPackagesNamed: {packageName3} toSubclusterNamed: 'Utility-External';
		"Here we are adding packages to subclusters with conditional expressions ... typically the conditions conrol platform or tests"
		addPackagesNamed: {packageName5} toSubclusterNamed: 'Core' condition: 'gemstone';
		addPackagesNamed: {packageName6} toSubclusterNamed: 'Core' condition: 'tests';
		addPackagesNamed: {packageName7} toSubclusterNamed: 'Core' condition: 'gemstone & tests';
		addPackagesNamed: {packageName8} toSubclusterNamed: 'Utility-Core' condition: 'tests';
		addPackagesNamed: {packageName9} toSubclusterNamed: 'Utility-External' condition: 'tests';

		addProjectsNamed: {projectName1} toSubclusterNamed: 'Core' condition: 'gemstone';

		packageConvention: 'Rowan';
		yourself.
	"Here we define the project load spec in terms of named clusters, if we set a conditional attribute like tests to true, then the tests associated with these clusters will be loaded as well"
	loadSpec := definedProject loadSpecification
		addClustersNamed: {  'Core' . 'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code';
		yourself.
	"Here we define an lload spec intended to be used by folks interested in uing the Utility-External functionality in this project"
	externalLoadSpec := RwLoadSpecificationV4_cluster new
		projectName: projectName;
		specName: specName;
		projectSpecFile: 'rowan/project.ston';
		addClustersNamed: {   'Utility-External' };
		comment: 'Load spec to be used to load Utility-External code into an external project';
		yourself.
	"Here we export the external loadSpect to disk"
	'/bosch1/users/dhenrich/_stones/git/RowancelloSample1/rowan/specs/RowancelloSample1_utility.ston'
		asFileReference writeStreamDo: [:stream | 
			stream truncate.
			externalLoadSpec exportToStream: stream ].
	"and here we export the entire project to disk"
	definedProject resolveProject
		projectsHome: '/bosch1/users/dhenrich/_stones/git/';
		diskUrl:  'file:/bosch1/users/dhenrich/_stones/git/RowancelloSample1';
		export
]
