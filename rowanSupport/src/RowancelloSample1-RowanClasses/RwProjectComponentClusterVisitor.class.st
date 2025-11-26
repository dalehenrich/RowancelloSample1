Class {
	#name : 'RwProjectComponentClusterVisitor',
	#superclass : 'RwResolvedProjectComponentVisitorV2',
	#instVars : [
		'currentClusterStack',
		'topLevelComponentNames'
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
RwProjectComponentClusterVisitor >> _conditionComponentName: aComponentName [
	"replace `/` characters in aComponentName with `_` ... the componentName will be used as the name of a file and we don not want the directory structure currently used by components"
	
	"true ifTrue: [ ^aComponentName]."
	^ aComponentName copyReplaceAll: '/' with: '_'
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _conditionConditionsArray: aConditionStringOrArray [
	"remove `common` condition from incoming String or Array "

	aConditionStringOrArray _isArray
		ifTrue: [ ^ aConditionStringOrArray copyWithout: 'common' ]
		ifFalse: [ 
			aConditionStringOrArray = 'common'
				ifTrue: [ ^ '' ]
				ifFalse: [ ^ aConditionStringOrArray ] ]
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _conditionFromArray: anArray [
	"anArray is the list of conditions accumulated from  the components on the path leading to the subcluster being created"

	| condition |
	self halt: 'Use RwCluster>>updateConditionExpression:conditions:'.
	condition := String new.
	1 to: anArray size do: [ :index | 
		condition add: (anArray at: index).
		index < anArray size
			ifTrue: [ condition add: ' & ' ] ].
self halt.
GsFile gciLogServer: '3. (_conditionFromArray:) ', condition printString.
	^ condition
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _readComponentsForProject: aResolvedProject withComponentNames: componentNamesToRead  customConditionalAttributes: aCustomConditionalAttributes platformConditionalAttributes: aPlatformConditionalAttributes [
	resolvedProject := aResolvedProject.
	platformConditionalAttributes := aPlatformConditionalAttributes.
	customConditionalAttributes := aCustomConditionalAttributes.
	^ self _visitTopLevelComponents: componentNamesToRead
]

{ #category : 'private' }
RwProjectComponentClusterVisitor >> _visitTopLevelComponents: componentNamesToRead [
	"visiting top-level components"

	self topLevelComponentNames: componentNamesToRead.
	^ self _visitComponents: componentNamesToRead
]

{ #category : 'accessing' }
RwProjectComponentClusterVisitor >> currentClusterStack [
	^ currentClusterStack ifNil: [ currentClusterStack := Array new ]
]

{ #category : 'accessing' }
RwProjectComponentClusterVisitor >> topLevelComponentNames [
	^topLevelComponentNames
]

{ #category : 'accessing' }
RwProjectComponentClusterVisitor >> topLevelComponentNames: object [
	topLevelComponentNames := object
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
self halt: 'Is this guy being used? ... '.
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].

	self _visited: aComponent.
	aComponent conditionalPropertyMatchers
		keysAndValuesDo: [ :platformMatchers :ignored | 
			self halt: 'conditional matchers'.
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
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent withAccumulatedConditions: accumulatedConditionExpression [
	"RwLoad component .
	For each load component create a cluster andfollow the depth first chain of components reference by this
	top level component, creating subcomponents, adding  conditions to the accumulatedConditionExpression for each component 
	visited. When a component contains a package or project reference create a subcluster to record the 
	expression and references. 
	"

	| componentsToBeVisited createdCluster |
	createdCluster := false.
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
	(self topLevelComponentNames includes: aComponent name)
		ifTrue: [ 
			| theCluster |
			theCluster := (resolvedProject
				addClusterNamed: (self _conditionComponentName: aComponent name)
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.
			createdCluster := true.
			self currentClusterStack isEmpty
				ifFalse: [ 
					(aComponent class == RwLoadComponent
						or: [ aComponent class == RwSimpleProjectLoadComponentV2 ])
						ifTrue: [ 
							"these guys are expected to have a cluster associated with them, and subclusters will be added to them"
							self
								error:
									'Unexpected use of a top-level cluster {' aComponent name
										, '( inside of another top-level cluster { '
										, self currentClusterStack last clusterName , ')' ] ].
			self currentClusterStack addLast: theCluster.
			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					self halt: 'hello conditionalPackageMapSpecs'.
					false
						ifTrue: [ 
							| theSubcluster |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									theSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '_condition'
										toClusterNamed: theCluster clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									theSubcluster addPackagesNamed: thePackageNames ] ] ] ]
		ifFalse: [ 
			(aComponent packageNames isEmpty
				and: [ aComponent projectNames isEmpty and: [ self currentClusterStack isEmpty not ] ])
				ifFalse: [ 
					| theSubcluster |
					"create a subcluster for aComponent"
					(resolvedProject
						subclusterNamed: (self _conditionComponentName: aComponent name)
						ifAbsent: [  ])
						ifNotNil: [ self error: 'Unexpectedly overriding an existing subcluster ' , aComponent name ].
					theSubcluster := resolvedProject
						addSubclusterNamed: (self _conditionComponentName: aComponent name)
						toClusterNamed: self currentClusterStack last clusterName
						condition: accumulatedConditionExpression
						comment: 'subcluster generated from ' , aComponent name.
					theSubcluster addPackagesNamed: aComponent packageNames ] ].

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
				ifTrue: [ 
					(resolvedProject clusterNamed: self currentClusterStack last clusterName)
						addSubclusterNamed: (self _conditionComponentName: component name) ]
				ifFalse: [ 
					component
						acceptClusterVisitor: self
						withAccumulatedConditions: accumulatedConditionExpression ] ].
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'so what have we here? Not sure what project spec has to do with it'.
			projectSpec acceptClusterVisitor: self ].
	createdCluster
		ifTrue: [ self currentClusterStack removeLast ]
]

{ #category : 'obsolete' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent withAccumulatedConditions: accumulatedConditions withConditions: conditions [
	"RwLoad component .
	For each load component create a cluster andfollow the depth first chain of components reference by this
	top level component, creating subcomponents, accumulating a conditional expression for each component 
	visited. When a component contains a package or project reference create a subcluster to record the 
	expression and references. Ideally I should be able identify shared subclusters.
	"

	| componentsToBeVisited createdCluster conditionsArray |
	self halt: 'no longer used ... see visitLoadComponent:withAccumulatedConditions:' .
	createdCluster := false.
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
	(self topLevelComponentNames includes: aComponent name)
		ifTrue: [ 
			| theCluster |
			(conditions isEmpty or: [ conditions = {'common'} ])
				ifFalse: [ 
					"have to create an empty cluster and add a subcluster to hold the conditional packages and projects"
					self
						error:
							'conditions is not empty for ' , aComponent name
								, '... top level component with a condition? NOT EXPECTED' ].
			theCluster := (resolvedProject
				addClusterNamed: (self _conditionComponentName: aComponent name)
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.
			createdCluster := true.
			self currentClusterStack isEmpty
				ifFalse: [ 
					(aComponent class == RwLoadComponent
						or: [ aComponent class == RwSimpleProjectLoadComponentV2 ])
						ifTrue: [ 
							"these guys are expected to have a cluster associated with them, and subclusters will be added to them"
							self
								error:
									'Unexpected use of a top-level cluster {' aComponent name
										, '( inside of another top-level cluster { '
										, self currentClusterStack last clusterName , ')' ] ].
			self currentClusterStack addLast: theCluster.
			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					self halt: 'hello conditionalPackageMapSpecs'.
					false
						ifTrue: [ 
							| theSubcluster |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									theSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '_condition'
										toClusterNamed: theCluster clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									theSubcluster addPackagesNamed: thePackageNames ] ] ] ]
		ifFalse: [ 
			(aComponent packageNames isEmpty
				and: [ aComponent projectNames isEmpty and: [ self currentClusterStack isEmpty not ] ])
				ifFalse: [ 
					| theSubcluster xConditions |
					"create a subcluster for aComponent"
					self
						halt:
							'create subcluster for aComponent  to hold the package and project names ... manage accumulated and conditions'.
					xConditions := conditionsArray copy.
					xConditions add: aComponent condition.
					(resolvedProject
						subclusterNamed: (self _conditionComponentName: aComponent name)
						ifAbsent: [  ])
						ifNotNil: [ self error: 'Unexpectedly overriding an existing subcluster ' , aComponent name ].
					theSubcluster := resolvedProject
						addSubclusterNamed: (self _conditionComponentName: aComponent name)
						toClusterNamed: self currentClusterStack last clusterName
						condition: xConditions
						comment: 'subcluster generated from ' , aComponent name.
					theSubcluster addPackagesNamed: aComponent packageNames ] ].

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
				ifTrue: [ 
					| subclusterName |
					subclusterName := self _conditionComponentName: component name.
					(self topLevelComponentNames includes: component name)
						ifTrue: [ 
							self
								halt:
									'to activate or not ... that is the question - TOP LEVEL ' , component name
										, '(' , accumulatedConditions printString , ')' ]
						ifFalse: [ 
							"this is a shared component ... add the subcluster to the current cluster, unless he is already a cluster"
							self
								halt:
									'to activate or not ... that is the question - SHARED ' , component name , '('
										, accumulatedConditions printString , ')' ] ]
				ifFalse: [ 
					component
						acceptClusterVisitor: self
						withAccumulatedConditions: accumulatedConditions
						conditions: conditions ] ].
	self halt: 'did not stop in compnentsToBeVisited condition'.
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'so what have we here? Not sure what project spec has to do with it'.
			projectSpec acceptClusterVisitor: self ].
	createdCluster
		ifTrue: [ self currentClusterStack removeLast ]
]

{ #category : 'obsolete' }
RwProjectComponentClusterVisitor >> visitLoadComponent: aComponent withConditions: conditionsArray [
	"RwLoad component .
	For each load component create a cluster andfollow the depth first chain of components reference by this
	top level component, creating subcomponents, accumulating a conditional expression for each component 
	visited. When a component contains a package or project reference create a subcluster to record the 
	expression and references. Ideally I should be able identify shared subclusters.
	"

	| componentsToBeVisited accumulatedConditions createdCluster |
	self halt: 'no longer used ... see visitLoadComponent:withAccumulatedConditions:' .
	createdCluster := false.
	accumulatedConditions := self _conditionConditionsArray: conditionsArray copy.	"conditionsArray includes the conditions for aComponent"
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
	(self topLevelComponentNames includes: aComponent name)
		ifTrue: [ 
			| theCluster |
			(conditionsArray isEmpty or: [ conditionsArray = {'common'} ])
				ifFalse: [ 
					"have to create an empty cluster and add a subcluster to hold the conditional packages and projects"
					self
						error:
							'conditionsArray is not empty for ' , aComponent name
								, '... top level component with a condition? NOT EXPECTED' ].
			theCluster := (resolvedProject
				addClusterNamed: (self _conditionComponentName: aComponent name)
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.
			createdCluster := true.
			self currentClusterStack isEmpty
				ifFalse: [ 
					(aComponent class == RwLoadComponent
						or: [ aComponent class == RwSimpleProjectLoadComponentV2 ])
						ifTrue: [ 
							"these guys are expected to have a cluster associated with them, and subclusters will be added to them"
							self
								error:
									'Unexpected use of a top-level cluster {' aComponent name
										, '( inside of another top-level cluster { '
										, self currentClusterStack last clusterName , ')' ] ].
			self currentClusterStack addLast: theCluster.
			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					self halt: 'hello conditionalPackageMapSpecs'.
					false
						ifTrue: [ 
							| theSubcluster |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									theSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '_condition'
										toClusterNamed: theCluster clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									theSubcluster addPackagesNamed: thePackageNames ] ] ] ]
		ifFalse: [ 
			(aComponent packageNames isEmpty
				and: [ aComponent projectNames isEmpty and: [ self currentClusterStack isEmpty not ] ])
				ifFalse: [ 
					| theSubcluster conditions |
					"create a subcluster for aComponent"
					conditions := conditionsArray copy.
					(conditions includes: aComponent condition)
						ifFalse: [ 
							self condition = 'common'
								ifFalse: [ conditions add: aComponent condition ] ].
					(resolvedProject
						subclusterNamed: (self _conditionComponentName: aComponent name)
						ifAbsent: [  ])
						ifNotNil: [ self error: 'Unexpectedly overriding an existing subcluster ' , aComponent name ].
					theSubcluster := resolvedProject
						addSubclusterNamed: (self _conditionComponentName: aComponent name)
						toClusterNamed: self currentClusterStack last clusterName
						condition: conditions
						comment: 'subcluster generated from ' , aComponent name.
"
					self
						halt:
							'to activate or not activate (load component)... that is the question - '
								, theSubcluster subclusterName , ' - '
								, theSubcluster condition printString.
"
					theSubcluster addPackagesNamed: aComponent packageNames ] ].
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
				ifTrue: [ 
					| subclusterName |
					subclusterName := self _conditionComponentName: component name.
					(self topLevelComponentNames includes: component name)
						ifTrue: [ 
							self
								halt:
									'to activate or not ... that is the question - TOP LEVEL ' , component name
										, '(' , accumulatedConditions printString , ')' ]
						ifFalse: [ 
							"this is a shared component ... add the subcluster to the current cluster, unless he is already a cluster"
"
							self
								halt:
									'to activate or not ... that is the question - SHARED ' , component name , '('
										, accumulatedConditions printString , ')'.
"
							resolvedProject
								addSubclusterNamed: subclusterName
								toClusterNamed: self currentClusterStack last clusterName ] ]
				ifFalse: [ component acceptClusterVisitor: self withAccumulatedConditions: accumulatedConditions ] ].

	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'so what have we here? Not sure what project spec has to do with it'.
			projectSpec acceptClusterVisitor: self ].
	createdCluster
		ifTrue: [ self currentClusterStack removeLast ]
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent [
	self visitSubcomponent: aComponent withConditions: {}
]

{ #category : 'visiting' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent withAccumulatedConditions: accumulatedExpression [
	"Following the chain of subcomponents....take note of the condition ... if the package names are not empty, then we need to snap off a subCluster to record the expression and the package names ... continue traversing accumluating the conditional expression until we hit the end of the chain ...
	NOTE it is possible that we will find that a subcluster is reached from a different path (conditional expression) so we will need update the expression with an OR operatior.
	It seems that we'll need a way to easily determine whether or not we have reached a component with a comon conditional expression or not ... seems we want to hold a list of OR attributes and a list of AND attributes? 
	It seems that this could get complicated"

	| componentsToBeVisited    theSubcluster ast evaluator |
	(aComponent class == RwSimpleNestedProjectLoadComponentV2
		or: [ 
			aComponent class == RwPlatformNestedProjectLoadComponentV2
				or: [ 
					aComponent class == RwSimpleProjectLoadComponentV2
						or: [ 
							aComponent class = RwSubcomponent
								or: [ aComponent class = RwPlatformSubcomponent ] ] ] ])
		ifFalse: [ 
			self
				error:
					'expected a RwPlatformNestedProjectLoadComponentV2 or RwSimpleProjectLoadComponentV2 or RwSubcomponent' ].
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].
	self componentNames add: aComponent name.	"make this guy happy"

	(aComponent packageNames isEmpty and: [ aComponent projectNames isEmpty ])
		ifFalse: [ 
			"Create a subcluster to record the packageNames and projectNames"
			theSubcluster := (resolvedProject
				addSubclusterNamed: (self _conditionComponentName: aComponent name)
				toClusterNamed: self currentClusterStack last clusterName
				condition: accumulatedExpression
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.

			ast := RwCAQParser new parse: accumulatedExpression.
			evaluator := RwCAQEvaluator
				context: resolvedProject expressionContext
				ast: ast.
			evaluator evaluate. "make sure that we con't have syntax errors"
			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					false
						ifTrue: [ 
							| thatSubcluster "skipping  this ... until basic structure is valid" |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									thatSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '-condition'
										toClusterNamed: self currentClusterStack last clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									thatSubcluster addPackagesNamed: thePackageNames ] ] ] ].
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
				ifFalse: [ component acceptClusterVisitor: self withAccumulatedConditions:  accumulatedExpression ] ].
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'handling required projects'  ]
]

{ #category : 'obsolete' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent withAccumulatedConditions: accumulatedExpression withConditions: conditionsArray [
	"Following the chain of subcomponents....take note of the condition ... if the package names are not empty, then we need to snap off a subCluster to record the expression and the package names ... continue traversing accumluating the conditional expression until we hit the end of the chain ...
	NOTE it is possible that we will find that a subcluster is reached from a different path (conditional expression) so we will need update the expression with an OR operatior.
	It seems that we'll need a way to easily determine whether or not we have reached a component with a comon conditional expression or not ... seems we want to hold a list of OR attributes and a list of AND attributes? 
	It seems that this could get complicated"

	| componentsToBeVisited    theSubcluster ast evaluator |
	self halt: 'no longer used ... see visitLoadComponent:withAccumulatedConditions:' .
	(aComponent class == RwSimpleNestedProjectLoadComponentV2
		or: [ 
			aComponent class == RwPlatformNestedProjectLoadComponentV2
				or: [ 
					aComponent class == RwSimpleProjectLoadComponentV2
						or: [ 
							aComponent class = RwSubcomponent
								or: [ aComponent class = RwPlatformSubcomponent ] ] ] ])
		ifFalse: [ 
			self
				error:
					'expected a RwPlatformNestedProjectLoadComponentV2 or RwSimpleProjectLoadComponentV2 or RwSubcomponent' ].
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].
	self componentNames add: aComponent name.	"make this guy happy"

	(aComponent packageNames isEmpty and: [ aComponent projectNames isEmpty ])
		ifFalse: [ 
			| conditions |
			"Create a subcluster to record the packageNames and projectNames"
			conditions := self _conditionConditionsArray: conditionsArray.
			theSubcluster := (resolvedProject
				addSubclusterNamed: (self _conditionComponentName: aComponent name)
				toClusterNamed: self currentClusterStack last clusterName
				condition: conditions
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.

			ast := RwCAQParser new parse: accumulatedExpression.
			evaluator := RwCAQEvaluator
				context: resolvedProject expressionContext
				ast: ast.
			evaluator evaluate
				ifTrue: [ self halt: 'expression ', accumulatedExpression printString, 'evaluated true'  ]
				ifFalse: [ 
					self halt: 'expression ', accumulatedExpression printString, '  evaluated false' 
					"
					self
						halt:
							'no activation  - ' , theSubcluster subclusterName , ' - '
								, theSubcluster condition printString 
"
					 ].

			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					false
						ifTrue: [ 
							| thatSubcluster "skipping  this ... until basic structure is valid" |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									thatSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '-condition'
										toClusterNamed: self currentClusterStack last clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									thatSubcluster addPackagesNamed: thePackageNames ] ] ] ].
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
				ifFalse: [ component acceptClusterVisitor: self withAccumulatedConditions:  accumulatedExpression ] ].
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'handling required projects'  ]
]

{ #category : 'obsolete' }
RwProjectComponentClusterVisitor >> visitSubcomponent: aComponent withConditions: conditionsArray [
	"Following the chain of subcomponents....take note of the condition ... if the package names are not empty, then we need to snap off a subCluster to record the expression and the package names ... continue traversing accumluating the conditional expression until we hit the end of the chain ...
	NOTE it is possible that we will find that a subcluster is reached from a different path (conditional expression) so we will need update the expression with an OR operatior.
	It seems that we'll need a way to easily determine whether or not we have reached a component with a comon conditional expression or not ... seems we want to hold a list of OR attributes and a list of AND attributes? 
	It seems that this could get complicated"

	| componentsToBeVisited accumulatedConditions accumulatedCondition theSubcluster ast evaluator |
	self halt: 'no longer used ... see visitLoadComponent:withAccumulatedConditions:' .
	accumulatedConditions := self _conditionConditionsArray: conditionsArray copy.	"conditionsArray includes the conditions for aComponent"
	accumulatedCondition := self _conditionFromArray: accumulatedConditions.
	(aComponent class == RwSimpleNestedProjectLoadComponentV2
		or: [ 
			aComponent class == RwPlatformNestedProjectLoadComponentV2
				or: [ 
					aComponent class == RwSimpleProjectLoadComponentV2
						or: [ 
							aComponent class = RwSubcomponent
								or: [ aComponent class = RwPlatformSubcomponent ] ] ] ])
		ifFalse: [ 
			self
				error:
					'expected a RwPlatformNestedProjectLoadComponentV2 or RwSimpleProjectLoadComponentV2 or RwSubcomponent' ].
	(visitedComponentNames includes: aComponent name)
		ifTrue: [ ^ self ].
	self componentNames add: aComponent name.	"make this guy happy"

	(aComponent packageNames isEmpty and: [ aComponent projectNames isEmpty ])
		ifFalse: [ 
			| conditions |
			"Create a subcluster to record the packageNames and projectNames"
			conditions := self _conditionConditionsArray: conditionsArray.
			theSubcluster := (resolvedProject
				addSubclusterNamed: (self _conditionComponentName: aComponent name)
				toClusterNamed: self currentClusterStack last clusterName
				condition: conditions
				comment: aComponent comment)
				addPackagesNamed: aComponent packageNames;
				addProjectsNamed: aComponent projectNames;
				yourself.

			ast := RwCAQParser new parse: accumulatedCondition.
			evaluator := RwCAQEvaluator
				context: resolvedProject expressionContext
				ast: ast.
			evaluator evaluate
				ifTrue: [  ]
				ifFalse: [ 
					"
					self
						halt:
							'no activation  - ' , theSubcluster subclusterName , ' - '
								, theSubcluster condition printString 
"
					 ].

			aComponent conditionalPackageMapSpecs isEmpty
				ifFalse: [ 
					false
						ifTrue: [ 
							| thatSubcluster "skipping  this ... until basic structure is valid" |
							aComponent conditionalPackageMapSpecs
								keysAndValuesDo: [ :condition :thePackageNames | 
									thatSubcluster := resolvedProject
										addSubclusterNamed:
											(self _conditionComponentName: aComponent name) , '-condition'
										toClusterNamed: self currentClusterStack last clusterName
										condition: condition
										comment: 'subcluster generated from ' , aComponent name.
									thatSubcluster addPackagesNamed: thePackageNames ] ] ] ].
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
				ifFalse: [ component acceptClusterVisitor: self withAccumulatedConditions: accumulatedConditions ] ].
	(self _projects: self projectsPath forProject: aComponent projectName)
		do: [ :projectSpec | 
			self halt: 'handling required projects'  ]
]
