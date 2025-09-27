Class {
	#name : 'RwProjectSpecificationV4_cluster_1',
	#superclass : 'RwSpecification',
	#instVars : [
		'specName',
		'projectName',
		'projectSpecPath',
		'clusterPath',
		'subclusterPath',
		'packagesPath',
		'projectsPath',
		'specsPath',
		'packageFormat',
		'packageConvention',
		'comment',
		'repoType',
		'loadedCommitId',
		'projectVersion'
	],
	#category : 'Rowan-SpecificationsV2'
}

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 class >> label [
	^ 'project specification '
]

{ #category : 'private' }
RwProjectSpecificationV4_cluster_1 >> _projectVersion: anObject [
	"set iv without error checking ... used by copyAsV4"

	projectVersion := anObject
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> _repoType [
	"direct access to IV ... used by ="

	^ repoType
]

{ #category : 'private' }
RwProjectSpecificationV4_cluster_1 >> _repoType: anObject [
	"set iv without error checking ... used by copyAsV4 and copyAsV3"

	repoType := anObject
]

{ #category : 'private' }
RwProjectSpecificationV4_cluster_1 >> _validate [
	"ensure that the data structures within the receiver contain valid information:
		1. platform implementation is responsible for validating platform structures"

	#(#'componentsPath' #'packagesPath' #'projectsPath' #'specsPath' #'projectName' #'specName' #'projectSpecPath')
		do: [ :messageName | 
			(self perform: messageName)
				ifNil: [ 
					Error
						signal:
							'The instance variable ' , messageName asString printString , ' cannot be nil' ] ].
	^ true
]

{ #category : 'comparing' }
RwProjectSpecificationV4_cluster_1 >> = anObject [
	| lazyEqual |
	^ self specName = anObject specName
		and: [ 
			self projectName = anObject projectName
				and: [ 
					self componentsPath = anObject componentsPath
						and: [ 
							self packageFormat = anObject packageFormat
								and: [ 
									self packageConvention = anObject packageConvention
										and: [ 
											self packagesPath = anObject packagesPath
												and: [ 
													self projectsPath = anObject projectsPath
														and: [ 
															self specsPath = anObject specsPath
																and: [ 
																	lazyEqual := self _repoType = anObject _repoType
																		or: [ self repoType = anObject repoType ].
																	lazyEqual
																		and: [ 
																			self comment = anObject comment
																				and: [ self loadedCommitId = anObject loadedCommitId and: [self projectVersion = anObject projectVersion] ] ] ] ] ] ] ] ] ] ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> clusterPath [
	^clusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> clusterPath: object [
	clusterPath := object
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> comment [
	^ comment ifNil: [ ^ '' ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> comment: aString [
	comment := aString
]

{ #category : 'copying' }
RwProjectSpecificationV4_cluster_1 >> copyAsV3 [
	"copy all of the raw ivs from the receiver to an instance of RwProjectSpecificationV3"

	^ RwProjectSpecificationV3 new
		comment: self comment;
		componentsPath: self componentsPath;
		loadedCommitId: self loadedCommitId;
		packageConvention: self packageConvention;
		packageFormat: self packageFormat;
		packagesPath: self packagesPath;
		projectName: self projectName;
		projectSpecPath: self projectSpecPath;
		projectsPath: self projectsPath;
		_repoType: self _repoType;
		specName: self specName;
		specsPath: self specsPath;
		_projectVersion:
				(self instVarAt: (self class allInstVarNames indexOf: #'projectVersion'));
		yourself
]

{ #category : 'copying' }
RwProjectSpecificationV4_cluster_1 >> copyAsV4 [
	"copy all of the raw ivs from the receiver to an instance of RwProjectSpecificationV4 ... to conform to method sort order in tonel spec -- WARNING the method sort order of any existing tonel files may radically change"

	^ RwProjectSpecificationV4 new
		comment: self comment;
		componentsPath: self componentsPath;
		loadedCommitId: self loadedCommitId;
		packageConvention: self packageConvention;
		packageFormat: self packageFormat;
		packagesPath: self packagesPath;
		projectName: self projectName;
		projectSpecPath: self projectSpecPath;
		projectsPath: self projectsPath;
		_repoType: self _repoType;
		specName: self specName;
		specsPath: self specsPath;
		_projectVersion:
				(self instVarAt: (self class allInstVarNames indexOf: #'projectVersion'));
		yourself
]

{ #category : 'exporting' }
RwProjectSpecificationV4_cluster_1 >> exportTo: directoryReference [
	| filePath |
	filePath := self projectSpecPath
		ifNil: [ directoryReference / self specName , 'ston' ]
		ifNotNil: [ :path | directoryReference / path / self specName , 'ston' ].
	filePath
		writeStreamDo: [ :fileStream | 
			fileStream truncate.
			STON put: self copy initializeForExport onStreamPretty: fileStream ]
]

{ #category : 'comparing' }
RwProjectSpecificationV4_cluster_1 >> hash [
	| hashValue |
	hashValue := self specName hash.
	hashValue := hashValue bitXor: self projectName hash.
	hashValue := hashValue bitXor: projectVersion hash.
	hashValue := hashValue bitXor: self componentsPath hash.
	hashValue := hashValue bitXor: self packagesPath hash.
	hashValue := hashValue bitXor: self projectsPath hash.
	hashValue := hashValue bitXor: self specsPath hash.
	hashValue := hashValue bitXor: self _repoType hash.
	hashValue := hashValue bitXor: self comment hash.
	hashValue := hashValue bitXor: self packageFormat hash.
	hashValue := hashValue bitXor: self packageConvention hash.
	hashValue := hashValue bitXor: self loadedCommitId hash.
	^ hashValue
]

{ #category : 'initialization' }
RwProjectSpecificationV4_cluster_1 >> initialize [
	"for v3, packageConvention and packageForm is explicit and the default location of the packages directory is the root of the project tree ... keep the Rowan meta data isolated in the rowan directory"

	super initialize.
	packagesPath := 'rowan/src'.
	projectsPath := 'rowan/projects'.
	specsPath := 'rowan/specs'.
	projectSpecPath := 'rowan'.
	specName := 'project'.
	comment := ''.
	packagesPath := 'src'.
	projectVersion := '1.0.0'.
	packageConvention := 'RowanHybrid'.
	packageFormat := 'tonel'.
	clusterPath := 'rowan/clusters'.
	subclusterPath := 'rowan/subclusters'.
]

{ #category : 'initialization' }
RwProjectSpecificationV4_cluster_1 >> initializeForExport [
	"if spec is to be exported, clear out any of the fields that represent local disk state"

	super initializeForExport.
	projectName := loadedCommitId := repoType := nil
]

{ #category : 'ston' }
RwProjectSpecificationV4_cluster_1 >> instVarNamesInOrderForSton [
	^ #(#'specName' #'projectName' #'projectVersion' #'projectSpecPath' #'componentsPath' #'packagesPath' #'projectsPath' #'specsPath' #'packageFormat' #'packageConvention' #'comment' #'repoType' #'loadedCommitId')
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> loadedCommitId [
	^ loadedCommitId ifNil: [ '' ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> loadedCommitId: aCommitId [
	loadedCommitId := aCommitId
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> methodSortOrder [
	"methods in tonel projects will be sorted in unicode codePoint sort order"

	^ 'codePoint'
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packageConvention [
	^ packageConvention ifNil: [ 'RowanHybrid' ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packageConvention: aString [
	"
		RowanHybrid	- [default] Class category is package name, method protocol with leading $* is case insensitive package name
		Monticello		- Class category is package name, method protocol with leading $* begins with case insensitive package name
		Rowan			- Class category and method protocol are not overloaded with packaging information
	"

	packageConvention := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packageFormat [
	^ self packageFormatIfAbsent: [ 'tonel' ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packageFormat: aString [
	(#('tonel' 'filetree' 'topaz') includes: aString)
		ifFalse: [ 
			self
				error:
					'Unknown package format ' , aString printString
						, '. Should be one of: tonel, or filetree' ].
	packageFormat := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packageFormatIfAbsent: absentBlock [
	^ packageFormat ifNil: absentBlock
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packagesPath [

	^ packagesPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> packagesPath: aString [
	packagesPath := aString
]

{ #category : 'printing' }
RwProjectSpecificationV4_cluster_1 >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' for ';
		nextPutAll: (self specName ifNil: ['nil'])
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectName [

	^ projectName
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectName: aString [
	projectName := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectsPath [

	^ projectsPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectsPath: aString [
	projectsPath := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectSpecPath [

	^ projectSpecPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectSpecPath: aStringOrNil [
	"nil value indicates projectSpec file is in repository root directory"

	projectSpecPath := aStringOrNil
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectVersion [
	^ projectVersion
		ifNotNil: [ :str | str asRwSemanticVersionNumber ]
		ifNil: [ '0.0.0' asRwSemanticVersionNumber ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> projectVersion: aStringOrVersionOrNil [
	aStringOrVersionOrNil
		ifNil: [ projectVersion := nil ]
		ifNotNil: [ 
			aStringOrVersionOrNil asRwSemanticVersionNumber.	"expect an error if aStringOrVersion is not a valid semantic version number"
			projectVersion := aStringOrVersionOrNil asString ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> repoType [
	^ repoType ifNil: [ repoType := #disk ]
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> repoType: aSymbol [
	"#disk, #git or #none"

	(#(#'disk' #'git' #'none') includes: aSymbol asSymbol)
		ifFalse: [ self error: 'Unknown repo type ' , aSymbol asSymbol printString ].
	^ repoType := aSymbol asSymbol
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> specName [

	^ specName
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> specName: aString [
	specName := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> specsPath [

	^ specsPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> specsPath: aString [
	specsPath := aString
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> subclusterPath [
	^subclusterPath
]

{ #category : 'accessing' }
RwProjectSpecificationV4_cluster_1 >> subclusterPath: object [
	subclusterPath := object
]

{ #category : 'v2 vs v3' }
RwProjectSpecificationV4_cluster_1 >> useV3ComponentClasses [

	^ true
]
