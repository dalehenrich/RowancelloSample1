Class {
	#name : 'RwProjectSpecificationV4_cluster',
	#superclass : 'RwProjectSpecificationV4',
	#instVars : [
		'clusterPath',
		'subclusterPath'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'comparing' }
RwProjectSpecificationV4_cluster >> = anObject [
	^ super = anObject and: [ self clusterPath = anObject clusterPath and: [self subclusterPath = anObject subclusterPath] ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> clusterPath [
	^clusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> clusterPath: object [
	clusterPath := object
]

{ #category : 'ston' }
RwProjectSpecificationV4_cluster >> excludedInstVars [
	"restore full #instVarNamesInOrderForSton - no componentsPath ... use  clusterPath & subclusterPath"

	^ #( componentsPath )
]

{ #category : 'comparing' }
RwProjectSpecificationV4_cluster >> hash [
	| hashValue |
	hashValue := super hash.
	hashValue := hashValue bitXor: self clusterPath hash.
	hashValue := hashValue bitXor: self clusterPath hash.
	^ hashValue
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> subclusterPath [
	^subclusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> subclusterPath: object [
	subclusterPath := object
]

{ #category : 'v3 vs v4' }
RwProjectSpecificationV4_cluster >> useV4ClusterClasses [

	^ true
]
