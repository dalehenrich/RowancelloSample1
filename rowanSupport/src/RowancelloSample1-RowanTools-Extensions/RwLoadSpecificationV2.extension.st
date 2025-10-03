Extension { #name : 'RwLoadSpecificationV2' }

{ #category : 'extensions' }
RwLoadSpecificationV2 >> copyAsV4_cluster [
	^ RwLoadSpecificationV4_cluster new
		specName: specName;
		projectName: projectName;
		projectAlias: projectAlias;
		gitUrl: gitUrl;
		diskUrl: diskUrl;
		mercurialUrl: mercurialUrl;
		readOnlyDiskUrl: readonlyDiskUrl;
		relativeRepositoryRoot: relativeRepositoryRoot;
		svnUrl: svnUrl;
		revision: revision;
		projectSpecFile: projectSpecFile;
		versionPrefix: versionPrefix;
		_componentNames: componentNames;
		customConditionalAttributes: customConditionalAttributes;
		comment: comment;
		projectsHome: projectsHome;
		repositoryResolutionPolicy: repositoryResolutionPolicy;
		yourself
]
