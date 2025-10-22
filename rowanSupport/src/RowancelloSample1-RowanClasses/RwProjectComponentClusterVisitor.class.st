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

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visit: aProjectLoadComponent [

	^aProjectLoadComponent acceptClusterVisitor: self
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitComponent: aComponent [
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

	(self _components: self componentsPath forProject: aComponent projectName)
		do: [ :component | 
			(visitedComponentNames includes: component name)
				ifFalse: [ component acceptClusterVisitor: self ] ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | projectSpec acceptVisitor: self ]
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent [
	"RwLoad component 
	
	For each load component create a cluster, follow the chain of subcomponents, accumulating a conditional 
	expression for each component visited. When a component contains a package or project reference create 
	a subcluster to record the expression and references. Ideally I should be able identify shared subclusters.
	"
	| theCluster |
	aComponent class == RwLoadComponent ifFalse: [ self error: 'expected a RwLoadComponent'].

	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].

	theCluster := (resolvedProject addClusterNamed: aComponent name comment: aComponent comment)
		addPackagesNamed: aComponent packageNames;
		addProjectsNamed: aComponent projectNames;
		yourself.

	(aComponent packageNames isEmpty not or: [aComponent projectNames isEmpty not])
		ifTrue: [
			| theSubcluster subclusterName |
			theSubcluster := resolvedProject 
				addSubclusterNamed: (subclusterName := aComponent name, '_subcluster') 
				toClusterNamed: aComponent name
				condition: '' 
				comment: ''.
		theCluster addSubclusterNamed: subclusterName ].

	self _visited: aComponent.
	(self _components: self componentsPath forProject: aComponent projectName)
		do: [ :component | 
			(visitedComponentNames includes: component name)
				ifFalse: [ component acceptClusterVisitor: self ] ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | self halt. projectSpec acceptClusterVisitor: self ].
]
