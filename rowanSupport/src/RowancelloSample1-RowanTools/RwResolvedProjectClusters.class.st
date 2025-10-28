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
	^ self clusters
		at: aClusterName
		put:
			(RwCluster new
				clusterName: aClusterName;
				comment: aString;
				yourself)
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addPackagesNamed: packageNames toSubclusterNamed: aSubclusterName [
	self addPackagesNamed: packageNames toSubclusterNamed: aSubclusterName
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
	| cluster subcluster |
	(aSubclusterName includes: $/) ifTrue: [self halt:'not renamed'].
	(cluster := self clusters at: aClusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ].
	subcluster := (self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNil: [ 
			self subclusters
				at: aSubclusterName
				put:
					(RwSubclusterV2 new
						subclusterName: aSubclusterName;
						comment: aString;
						yourself) ].
	cluster addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toClusterNamed: aClusterName condition: aCondition comment: aString [
	| cluster subcluster |
	(aClusterName includes: $/) ifTrue: [self halt:'cluster not renamed'].
	(aSubclusterName includes: $/) ifTrue: [self halt:'subcluster not renamed'].
	(cluster := self clusters at: aClusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ].
	subcluster := (self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNil: [ 
			self subclusters
				at: aSubclusterName
				put:
					(RwSubclusterV2 new
						subclusterName: aSubclusterName;
						comment: aString;
						condition: aCondition;
						yourself) ].
	cluster addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> clusterNamed: aClusterName [
	^ self
		clusterNamed: aClusterName
		ifAbsent: [ 
			self
				error:
					'There is no cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> clusterNamed: aClusterName ifAbsent: absentBlock [
	^ self clusters at: aClusterName ifAbsent: absentBlock
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
RwResolvedProjectClusters >> subclusterNamed: aClusterName [
	^ self
		subclusterNamed: aClusterName
		ifAbsent: [ 
			self
				error:
					'There is no subcluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> subclusterNamed: aClusterName ifAbsent: absentBlock [
	^ self subclusters at: aClusterName ifAbsent: absentBlock
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> subclusters [
	^subclusters
]
