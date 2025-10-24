Class {
	#name : 'RwProjectComponentClusterVisitor',
	#superclass : 'RwResolvedProjectComponentVisitorV2',
	#category : 'RowancelloSample1-RowanClasses'
}

{ #category : 'cluster analysis' }
RwProjectComponentClusterVisitor class >> clusterAnalysisForProject: resolvedProject [
	| visitor |
	visitor := self readLoadSpecForProject: resolvedProject.
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _component: componentPath forProject: aProjectName [
	| componentFile component visit |
self halt: 'am I used?'.
	componentFile := componentPath asFileReference.
	component := RwAbstractComponent _readStonFrom: componentFile readStream.
	visit := false.
	self readComponents
		at: component name
		ifAbsentPut: [ 
			visit := true.
			component ].
	visit
		ifTrue: [ component acceptClusterVisitor: self ].
	^ component
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _readComponentsForProject: aResolvedProject withComponentNames: componentNamesToRead  customConditionalAttributes: aCustomConditionalAttributes platformConditionalAttributes: aPlatformConditionalAttributes [
	resolvedProject := aResolvedProject.
	platformConditionalAttributes := aPlatformConditionalAttributes.
	customConditionalAttributes := aCustomConditionalAttributes.
	^ self _visitComponents: componentNamesToRead
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visit: aProjectLoadComponent [

	^aProjectLoadComponent acceptClusterVisitor: self
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitComponent: aComponent [
	| component |
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].

	self _visited: aComponent.
	aComponent conditionalPropertyMatchers
		keysAndValuesDo: [ :platformMatchers :ignored | 
			(self _platformAttributeMatchIn: platformMatchers)
				ifTrue: [ 
					self _addPackageNames: aComponent packageNames for: aComponent.
					self componentNames addAll: aComponent componentNames.
					self projectNames addAll: aComponent projectNames ] ].

	component := self
		_component: self componentsPath
		forProject: aComponent projectName.
	(visitedComponentNames includes: component name)
		ifFalse: [ component acceptClusterVisitor: self ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'may not be necessary'.
			projectSpec acceptVisitor: self ]
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent [
	"RwLoad component .
	For each load component create a cluster andfollow the depth first chain of components reference by this
	top level component, creating subcomponents, accumulating a conditional expression for each component 
	visited. When a component contains a package or project reference create a subcluster to record the 
	expression and references. Ideally I should be able identify shared subclusters.
	"

	| theCluster |
	(aComponent class == RwLoadComponent
		or: [ aComponent class == RwSimpleProjectLoadComponentV2 ])
		ifFalse: [ self error: 'expected a RwLoadComponent or RwSimpleProjectLoadComponentV2' ].

	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].

	theCluster := (resolvedProject
		addClusterNamed: aComponent name
		comment: aComponent comment)
		addPackagesNamed: aComponent packageNames;
		addProjectsNamed: aComponent projectNames;
		yourself.

	aComponent conditionalPackageMapSpecs isEmpty
		ifFalse: [ 
			"The conditionaPackageMapSpecs requires the creation of subclusters"
			self
				halt:
					'non-empty conditionalPackageMapSpecs will require the creation of subclusters ... NOT EMPLEMENTED yet' ].
	self _visited: aComponent.
	(self _components: self componentsPath forProject: aComponent projectName)
		do: [ :component | 
			(visitedComponentNames includes: component name)
				ifFalse: [ component acceptClusterVisitor: self ] ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt.
			projectSpec acceptClusterVisitor: self ]
]
