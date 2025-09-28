Class {
	#name : 'RwProjectSpecificationV4_cluster_2',
	#superclass : 'RwProjectSpecificationV4',
	#instVars : [
		'clusterPath',
		'subclusterPath'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_2 >> clusterPath [
	^clusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_2 >> clusterPath: object [
	clusterPath := object
]

{ #category : 'ston' }
RwProjectSpecificationV4_cluster_2 >> excludedInstVars [
	"restore full #instVarNamesInOrderForSton - no componentsPath ... use  clusterPath & subclusterPath"

	^ #( componentsPath )
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_2 >> subclusterPath [
	^subclusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_2 >> subclusterPath: object [
	subclusterPath := object
]

{ #category : 'v3 vs v4' }
RwProjectSpecificationV4_cluster_2 >> useV4ClusterClasses [

	^ true
]
