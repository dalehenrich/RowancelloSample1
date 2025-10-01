Class {
	#name : 'RwProjectSpecificationV4_cluster',
	#superclass : 'RwProjectSpecificationV4',
	#instVars : [
		'clustersPath'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'comparing' }
RwProjectSpecificationV4_cluster >> = anObject [
	^ super = anObject and: [ self clustersPath = anObject clustersPath ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> clustersPath [
	^clustersPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster >> clustersPath: object [
	clustersPath := object
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
	hashValue := hashValue bitXor: self clustersPath hash.
	^ hashValue
]

{ #category : 'initilizaton' }
RwProjectSpecificationV4_cluster >> initialize [
	"for v3, packageConvention and packageForm is explicit and the default location of the packages directory is the root of the project tree ... keep the Rowan meta data isolated in the rowan directory"

	super initialize.
	clustersPath := 'rowan/clusters'.
]

{ #category : 'v3 vs v4' }
RwProjectSpecificationV4_cluster >> useV4ClusterClasses [

	^ true
]
