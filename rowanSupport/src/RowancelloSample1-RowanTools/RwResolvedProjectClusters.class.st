Class {
	#name : 'RwResolvedProjectClusters',
	#superclass : 'Object',
	#instVars : [
		'projectName',
		'clusters',
		'subclusters'
	],
	#category : 'RowancelloSample1-RowanTools'
}

{ #category : 'instance creation' }
RwResolvedProjectClusters class >> new [
	^ self basicNew initialize
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addClusterNamed: aClusterName comment: aString [
	(self clusters at: aClusterName ifAbsent: [  ])
		ifNotNil: [ 
			self
				error:
					'There is already a cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ].
	self clusters
		at: aClusterName
		put:
			(RwCluster new
				clusterName: aClusterName;
				comment: aString;
				yourself)
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addPackagesNamed: packageNames toSubclusterNamed: aSubclusterName [
	self addPackagesNamed: packageNames toSubclusterNamed: aSubclusterName condition: 'true'
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addPackagesNamed: packageNames toSubclusterNamed: aSubclusterName  condition: conditionExpression [
	( self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNotNil: [ :subcluster | subcluster addPackagesNamed: packageNames  condition: conditionExpression]
		ifNil: [ 
			self
				error:
					'There is no subcluster named ' , aSubclusterName printString
						, ' defined in the project named ' , self projectName printString ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addProjectsNamed: projectNames toSubclusterNamed: subclusterName condition: conditionExpression [
	(self subclusters at: subclusterName ifAbsent: [  ])
		ifNotNil: [ :subcluster | subcluster addProjectsNamed: projectNames condition: conditionExpression ]
		ifNil: [ 
			self
				error:
					'There is no subcluster named ' , subclusterName printString
						, ' defined in the project named ' , self projectName printString ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toClusterNamed: aClusterName comment: aString [
	| cluster |
	(cluster := self clusters at: aClusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ].
	(self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNotNil: [ 
			self
				error:
					'There is a subcluster named ' , aSubclusterName printString
						, ' already defined in the project named ' , self projectName printString ].
	self subclusters
		at: aSubclusterName
		put:
			(RwSubcluster new
				subclusterName: aSubclusterName;
				comment: aString;
				yourself)
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> clusters [
	^clusters
]

{ #category : 'exporting' }
RwResolvedProjectClusters >> export: clustersRoot [
	self clusters values
		do: [ :cluster | cluster exportToUrl: 'file:' , clustersRoot pathString , '/clusters/' ].
	self subclusters values
		do: [ :packgeGroup | packgeGroup exportToUrl: 'file:' , clustersRoot pathString , '/subclusters/' ].
	(self clusters isEmpty and: [ self subclusters isEmpty ])
		ifTrue: [ 
			"add README.md as placeholder to ensure that the directory is preserved by git"
			clustersRoot / 'README' , 'md' writeStreamDo: [ :fileStream | fileStream truncate. ] ]
]

{ #category : 'initialization' }
RwResolvedProjectClusters >> initialize [
	clusters := Dictionary new.
	subclusters := Dictionary new
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> projectName [
	^projectName
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> projectName: object [
	projectName := object
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> subclusters [
	^subclusters
]
