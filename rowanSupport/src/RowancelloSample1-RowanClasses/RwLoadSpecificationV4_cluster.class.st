"
A RwLoadSpecificationV4_cluster is used to configure  a project load. One or more clusters may be referenced by a load spec. The load spec includes a list of customConditionalAttributes which may be used in the condition expression in a subcluster. The system generates a set of platform attributes that corresponds to the current platform. Note that platform attributes can be added to a load spec as a customConditionalAttributes ... this is recommended for doing loads, but it useful when reading and writing .gs files for different gemstone versions.

A RwCluster has a name and a list of subclusters. 

A RwSubcluster has a name, and a collection of condition/packageAndProjectNames pairs. When a subcluster is loaded, the list of packageAndProjectNames associated with a condition  that evaluates to true are loaded. A packageOrPronectName may not be present in more than one packageAndProjectName list in a subcluster and a packageOrProjectName may not be referenced by more than one subcluster ... Essentially each packageorProject must be associated with a single, unique condition in a single subcluster. 

These restrictions are put into place, because it can become too difficult to manage the dependencies if a package shows up in multple subclusters ...
"
Class {
	#name : 'RwLoadSpecificationV4_cluster',
	#superclass : 'RwLoadSpecificationV2',
	#instVars : [
		'clusterNames'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> addClusterNamed: clusterName [
	(clusterNames includes: clusterName)
		ifTrue: [ 
			"make sure that we eliminate any duplicate cluster names"
			^ self ].
	clusterNames add: clusterName
]

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> addClustersNamed: anArray [
	"add to the existing component names. make sure that we eliminate any duplicate component names (https://github.com/GemTalk/Rowan/issues/942)"

	anArray do: [ :each | self addClusterNamed: each ]
]

{ #category : 'unsupported' }
RwLoadSpecificationV4_cluster >> addComponentNamed: componentName [
	self error: 'The receiver does not support components, use clusters instead.'
]

{ #category : 'unsupported' }
RwLoadSpecificationV4_cluster >> addComponentNames: anArray [

	self error: 'The receiver does not support components, use clusters instead.'
]

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> clusterNames [
	^clusterNames
]

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> clusterNames: object [
	clusterNames := object
]

{ #category : 'unsupported' }
RwLoadSpecificationV4_cluster >> componentNames [
	self error: 'The receiver does not support components, use clusters instead.'
]

{ #category : 'unsupported' }
RwLoadSpecificationV4_cluster >> componentNames: anArray [
	self error: 'The receiver does not support components, use clusters instead.'
]

{ #category : 'ston' }
RwLoadSpecificationV4_cluster >> excludedInstVars [
	"restore full #instVarNamesInOrderForSton - no componentsPath ... use  clusterPath & subclusterPath"

	^ #( componentNames )
]

{ #category : 'initialization' }
RwLoadSpecificationV4_cluster >> initialize [
	super initialize.
	clusterNames := Array new.
	projectSpecFile := 'rowan/project.ston'.
	comment := ''.
	componentNames := nil
]

{ #category : 'copying' }
RwLoadSpecificationV4_cluster >> postCopy [
	"don't forget to copy any compound state objects"

	super postCopy.
	clusterNames := clusterNames copy.
]
