Class {
	#name : 'RwResolvedProjectClusters',
	#superclass : 'Object',
	#instVars : [
		'projectName',
		'slices',
		'clusters',
		'subclusters',
		'expressionContext'
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
RwResolvedProjectClusters >> addSliceNamed: aSliceName comment: aString [
	(self slices at: aSliceName ifAbsent: [  ])
		ifNotNil: [ 
			self
				error:
					'There is already a slice named ' , aSliceName printString
						, ' defined in the project named ' , self projectName printString ].
	^ self slices
		at: aSliceName
		put:
			(RwSlice new
				sliceName: aSliceName;
				comment: aString;
				yourself)
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toClusterNamed: aClusterName [
	"add existing subcluster to aClusterName"

	| cluster subcluster |
	(aSubclusterName includes: $/)
		ifTrue: [ self halt: 'not renamed' ].
	(cluster := self clusters at: aClusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no cluster named ' , aClusterName printString
						, ' defined in the project named ' , self projectName printString ].
	subcluster := (self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no subcluster named ' , aSubclusterName printString
						, ' defined in the project named ' , self projectName printString ].
	cluster addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toClusterNamed: aClusterName comment: aString [
	"add new subcluster to aClusterName"

	| cluster subcluster |
	(aSubclusterName includes: $/)
		ifTrue: [ self halt: 'not renamed' ].
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
					(RwSubcluster new
						subclusterName: aSubclusterName;
						comment: aString;
						yourself) ].
	cluster addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toClusterNamed: aClusterName condition: aCondition comment: aString [
	"add new subcluster to aClusterName"

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
					(RwSubcluster new
						subclusterName: aSubclusterName;
						comment: aString;
						condition: aCondition;
						yourself) ].
	cluster addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toSliceNamed: aSliceName [
	"add existing subcluster to aSliceName"

	| slice subcluster |
	(aSubclusterName includes: $/)
		ifTrue: [ self halt: 'not renamed' ].
	(slice := self slices at: aSliceName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no slice named ' , aSliceName printString
						, ' defined in the project named ' , self projectName printString ].
	subcluster := (self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no subcluster named ' , aSubclusterName printString
						, ' defined in the project named ' , self projectName printString ].
	slice addSubclusterNamed: aSubclusterName.
	^ subcluster
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> addSubclusterNamed: aSubclusterName toSliceNamed: aSliceName  comment: aString [
	"add new subcluster to aSliceName"

	| slice subcluster |
	(aSubclusterName includes: $/)
		ifTrue: [ self halt: 'not renamed' ].
	(slice := self slices at: aSliceName ifAbsent: [  ])
		ifNil: [ 
			self
				error:
					'There is no slice named ' , aSliceName printString
						, ' defined in the project named ' , self projectName printString ].
	subcluster := (self subclusters at: aSubclusterName ifAbsent: [  ])
		ifNil: [ 
			self subclusters
				at: aSubclusterName
				put:
					(RwSubcluster new
						subclusterName: aSubclusterName;
						comment: aString;
						yourself) ].
	slice addSubclusterNamed: aSubclusterName.
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

{ #category : 'accessing' }
RwResolvedProjectClusters >> expressionContext [
	^expressionContext
]

{ #category : 'initialization' }
RwResolvedProjectClusters >> initialize [
	clusters := Dictionary new.
	subclusters := Dictionary new.
	slices := Dictionary new.
	expressionContext := RwCAQContext new
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> projectName [
	^projectName
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> projectName: object [
	projectName := object
]

{ #category : 'queries' }
RwResolvedProjectClusters >> referencesToPackageNamed: packageName [
	| refs clusterReferences subclusterReferences |
	refs := Dictionary new.
	clusterReferences := Dictionary new.
	subclusterReferences := Dictionary new.
	refs
		at: 'clusters' put: clusterReferences;
		at: 'subclusters' put: subclusterReferences;
		yourself.
	self clusters
		do: [ :cluster | 
			(cluster packageNames includes: packageName)
				ifTrue: [ (clusterReferences at: packageName ifAbsentPut: [ Set new ]) add: cluster clusterName ] ].
	self subclusters
		do: [ :subcluster | 
			(subcluster packageNames includes: packageName)
				ifTrue: [ 
					(subclusterReferences at: packageName ifAbsentPut: [ Set new ])
						add: subcluster subclusterName ] ].
	^ refs
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> sliceNamed: aSliceName [
	^ self
		sliceNamed: aSliceName
		ifAbsent: [ 
			self
				error:
					'There is no slice named ' , aSliceName printString
						, ' defined in the project named ' , self projectName printString ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> sliceNamed: aSliceName ifAbsent: absentBlock [
	^ self slices at: aSliceName ifAbsent: absentBlock
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> slices [
	^ slices ifNil: [ slices := Array new ]
]

{ #category : 'accessing' }
RwResolvedProjectClusters >> slices: object [
	slices := object
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
