Extension { #name : 'RwProjectSpecificationV2' }

{ #category : 'copying' }
RwProjectSpecificationV2 >> copyAsV4_cluster [
	"copy all of the raw ivs from the receiver to an instance of RwProjectSpecificationV4 ... to conform to method sort order in tonel spec -- WARNING the method sort order of any existing tonel files may radically change"

	^ RwProjectSpecificationV4_cluster new
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
		clustersPath: 'rowan/clusters';
		yourself
]
