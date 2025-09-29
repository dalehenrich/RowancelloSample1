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
RwLoadSpecificationV4_cluster >> addClusterNames: anArray [
	"add to the existing component names. make sure that we eliminate any duplicate component names (https://github.com/GemTalk/Rowan/issues/942)"

	| set |
	set := self componentNames asSet.
	set addAll: anArray.
	componentNames := set asArray
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
	clusterNames := {}.
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
