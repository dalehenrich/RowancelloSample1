Class {
	#name : 'RwProjectComponentClusterVisitor',
	#superclass : 'RwResolvedProjectComponentVisitorV2',
	#instVars : [
		'currentCluster'
	],
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

{ #category : 'accessing' }
RwProjectComponentClusterVisitor >> currentCluster [
	^currentCluster
]

{ #category : 'accessing' }
RwProjectComponentClusterVisitor >> currentCluster: object [
	currentCluster := object
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visit: aProjectLoadComponent [

	^aProjectLoadComponent acceptClusterVisitor: self
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitComponent: aComponent [

	^self visitComponent: aComponent withConditions: {}
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitComponent: aComponent withConditions: conditionsArray [

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
			self halt: 'Is the projectSpec important for clusters and subclusters?'.
			projectSpec acceptVisitor: self ]
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent [
	self visitLoadComponent: aComponent withConditions: {}
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent withConditions: conditionsArray [
	"RwLoad component .
	For each load component create a cluster andfollow the depth first chain of components reference by this
	top level component, creating subcomponents, accumulating a conditional expression for each component 
	visited. When a component contains a package or project reference create a subcluster to record the 
	expression and references. Ideally I should be able identify shared subclusters.
	"

	| theCluster componentsToBeVisited |
	(aComponent class == RwLoadComponent
		or: [ 
			aComponent class == RwSimpleProjectLoadComponentV2
				or: [ 
					aComponent class == RwSimpleNestedProjectLoadComponentV2
						or: [ aComponent class == RwPlatformNestedProjectLoadComponentV2 ] ] ])
		ifFalse: [ self error: 'expected a RwLoadComponent or RwSimpleProjectLoadComponentV2' ].

	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].
	self componentNames add: aComponent name.	"make this guy happy"
	theCluster := (resolvedProject
		addClusterNamed: aComponent name
		comment: aComponent comment)
		addPackagesNamed: aComponent packageNames;
		addProjectsNamed: aComponent projectNames;
		yourself.
	currentCluster
		ifNil: [ currentCluster := theCluster ]
		ifNotNil: [ 
			(aComponent class == RwLoadComponent
				or: [ aComponent class == RwSimpleProjectLoadComponentV2 ])
				ifTrue: [ 
					"these guys are expected to have a cluster associated with them, and subclusters will be added to them"
					self
						error:
							'Unexpected use of a top-level cluster {' aComponent name
								, '( inside of another top-level cluster { ' , currentCluster clusterName , ')' ] ].
	aComponent conditionalPackageMapSpecs isEmpty
		ifFalse: [ 
			| theSubcluster |
			aComponent conditionalPackageMapSpecs
				keysAndValuesDo: [ :condition :thePackageNames | 
					theSubcluster := resolvedProject
						addSubclusterNamed: aComponent name , '_condition'
						toClusterNamed: theCluster clusterName
						condition: condition
						comment: 'subcluster generated from ' , aComponent name.
					theSubcluster addPackagesNamed: thePackageNames ] ].
	self _visited: aComponent.

	componentsToBeVisited := aComponent componentNames
		collect: [ :theComponentName | 
			| theComponent |
			theComponent := self readComponents
				at: theComponentName
				ifAbsentPut: [ 
					(RwAbstractRowanProjectLoadComponentV2
						fromComponentsDirectory: resolvedProject componentsRoot
						named: theComponentName)
						projectName: resolvedProject projectName;
						yourself ] ].

	componentsToBeVisited
		do: [ :component | 
			(visitedComponentNames includes: component name)
				ifFalse: [ component acceptClusterVisitor: self ] ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt.
			projectSpec acceptClusterVisitor: self ].
	currentCluster := nil
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent [
	self visitSubcomponent: aComponent withConditions: {}
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent withConditions: conditionsArray [
	"Following the chain of subcomponents....take note of the condition ... if the package names are not empty, then we need to snap off a subCluster to record the expression and the package names ... continue traversing accumluating the conditional expression until we hit the end of the chain ...
	NOTE it is possible that we will find that a subcluster is reached from a different path (conditional expression) so we will need update the expression with an OR operatior.
	It seems that we'll need a way to easily determine whether or not we have reached a component with a comon conditional expression or not ... seems we want to hold a list of OR attributes and a list of AND attributes? 
	It seems that this could get complicated"

	| theSubCluster componentsToBeVisited |
	(aComponent class == RwSimpleNestedProjectLoadComponentV2
		or: [ 
			aComponent class == RwPlatformNestedProjectLoadComponentV2
				or: [ aComponent class == RwSimpleProjectLoadComponentV2 ] ])
		ifFalse: [ self error: 'expected a RwLoadComponent or RwSimpleProjectLoadComponentV2' ].
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].
	self componentNames add: aComponent name.	"make this guy happy"

	(aComponent packageNames isEmpty and: [ aComponent projectNames isEmpty ])
		ifFalse: [ 
			"Create a subcluster to record the packageNames and projectNames"
			theSubCluster := (resolvedProject
				addSubclusterNamed: aComponent name
				toClusterNamed: currentCluster clusterName
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.

			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					| theSubcluster |
					aComponent conditionalPackageMapSpecs
						keysAndValuesDo: [ :condition :thePackageNames | 
							theSubcluster := resolvedProject
								addSubclusterNamed: aComponent name , '_condition'
								toClusterNamed: currentCluster clusterName
								condition: condition
								comment: 'subcluster generated from ' , aComponent name.
							theSubcluster addPackagesNamed: thePackageNames ] ].
			self _visited: aComponent.

			componentsToBeVisited := aComponent componentNames
				collect: [ :theComponentName | 
					| theComponent |
					theComponent := self readComponents
						at: theComponentName
						ifAbsentPut: [ 
							(RwAbstractRowanProjectLoadComponentV2
								fromComponentsDirectory: resolvedProject componentsRoot
								named: theComponentName)
								projectName: resolvedProject projectName;
								yourself ] ].
			componentsToBeVisited
				do: [ :component | 
					(visitedComponentNames includes: component name)
						ifFalse: [ component acceptClusterVisitor: self withConditions: {(aComponent condition)} ] ] ].
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt.
			projectSpec
				acceptClusterVisitor: self
				withConditions: {(aComponent condition)} ]
]
