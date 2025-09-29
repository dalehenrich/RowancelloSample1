Class {
	#name : 'RwLoadSpecificationV4_cluster',
	#superclass : 'RwLoadSpecificationV2',
	#instVars : [
		'clusterNames'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> clusterNames [
	^clusterNames
]

{ #category : 'accessing' }
RwLoadSpecificationV4_cluster >> clusterNames: object [
	clusterNames := object
]

{ #category : 'ston' }
RwLoadSpecificationV4_cluster >> excludedInstVars [
	"restore full #instVarNamesInOrderForSton - no componentsPath ... use  clusterPath & subclusterPath"

	^ #( componentNames )
]
