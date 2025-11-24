Extension { #name : 'RwRowanSample9V4Test' }

{ #category : 'cluster tests' }
RwRowanSample9V4Test >> testSpec_0024_clusterConversion [
	"convert components to clusters and subclusters"

	"https://github.com/GemTalk/Rowan/issues/939"

	| loadSpec projectName resolvedProject loadedProjects |
	loadSpec := self _loadSpecNamed: 'spec_0024'.

	projectName := loadSpec projectName.

	(Rowan image loadedProjectNamed: projectName ifAbsent: [  ])
		ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ].	"resolve project"
	resolvedProject := loadSpec resolveProject.	"load project"
	loadedProjects := resolvedProject load.	"validate"
	self _standard_validate: resolvedProject loadedProjects: loadedProjects
]

{ #category : 'cluster tests' }
RwRowanSample9V4Test >> testSpec_0032_clustersConversion [
	"spec_0032 should load cleanly"

	"Explore the use of shared directory for sharing code between two conditions, like v1 and v2 ... first create v1 and v2 packages (that can be independently loaded or loaded together in GemStone and use the class in shared component for code that is common to both -- not controlled by attributes"

	"https://github.com/dalehenrich/Rowan/issues/573"

	| loadSpec projectName projectNames resolvedProject loadedProjects |
	loadSpec := self _loadSpecNamed: 'spec_0032'.

	projectName := loadSpec projectName.
	projectNames := {projectName}.

	projectNames do: [:pn | 
		(Rowan image loadedProjectNamed: pn ifAbsent: [  ])
			ifNotNil: [ :proj | Rowan image _removeLoadedProject: proj ] ].

"resolve project"
	resolvedProject := loadSpec resolveProject.

"load project"
	loadedProjects := resolvedProject load.

"validate"
	{ projectName, 'SpecsSharedClass4' . projectName, 'Specsv1Class5' . projectName, 'Specsv2Class5'} do: [:className |
		self assert: (Rowan globalNamed: className) notNil ].

	self
		_standard_validate: resolvedProject
		loadedProjects: loadedProjects
		expectedProjectNames: projectNames.

"remove v1 from the conditional attributes and resolve -- RowanSample9Specsv1Class5 should not be loaded"
	loadSpec customConditionalAttributes remove: 'v1'.
	resolvedProject := loadSpec resolveProject.
"load project"
	loadedProjects := resolvedProject load.
"validate"
	{ projectName, 'Specsv1Class5' }do: [:className |
		self assert: (Rowan globalNamed: className) isNil ].
	{ projectName, 'SpecsSharedClass4' . projectName, 'Specsv2Class5'} do: [:className |
		self assert: (Rowan globalNamed: className) notNil ].
	self
		_standard_validate: resolvedProject
		loadedProjects: loadedProjects
		expectedProjectNames: projectNames.

"remove v2 from the conditional attributes, add v1 back  and resolve -- RowanSample9Specsv1Class5 should not be loaded"
	loadSpec customConditionalAttributes remove: 'v2'.
	loadSpec customConditionalAttributes add: 'v1'.
	resolvedProject := loadSpec resolveProject.
"load project"
	loadedProjects := resolvedProject load.
"validate"
	{ projectName, 'Specsv2Class5' } do: [:className |
		self assert: (Rowan globalNamed: className) isNil ].
	{ projectName, 'SpecsSharedClass4' . projectName, 'Specsv1Class5'} do: [:className |
		self assert: (Rowan globalNamed: className) notNil ].
	self
		_standard_validate: resolvedProject
		loadedProjects: loadedProjects
		expectedProjectNames: projectNames.
]
