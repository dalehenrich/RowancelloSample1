"
A RwCluster has a name and a list of subclusters. 

A RwSubcluster has a name, and a collection of condition/packageAndProjectNames pairs. When a subcluster is loaded, the list of packageAndProjectNames associated with a condition  that evaluates to true are loaded. A packageOrPronectName may not be present in more than one packageAndProjectName list in a subcluster and a packageOrProjectName may not be referenced by more than one subcluster ... Essentially each packageorProject must be associated with a single, unique condition in a single subcluster. 

These restrictions are put into place, because it can become too difficult to manage the dependencies if a package shows up in multple subclusters ...

See class comment for RwLoadeSpecifictionV4_cluster for additional information.
"
Class {
	#name : 'RwCluster',
	#superclass : 'Object',
	#instVars : [
		'clusterName',
		'subclusters',
		'comment'
	],
	#category : 'RowancelloSample1-Rowan-Classes'
}

{ #category : 'instance creation' }
RwCluster class >> new [

	^ self basicNew initialize
]

{ #category : 'accessing' }
RwCluster >> addSubclusterNamed: aSubclusterName comment: aString [

	| subcluster |
	subcluster := RwSubcluster new
		subclusterName: aSubclusterName;
		comment: aString
		yourself
]

{ #category : 'accessing' }
RwCluster >> clusterName [
	^clusterName
]

{ #category : 'accessing' }
RwCluster >> clusterName: object [
	clusterName := object
]

{ #category : 'accessing' }
RwCluster >> comment [
	^comment
]

{ #category : 'accessing' }
RwCluster >> comment: object [
	comment := object
]

{ #category : 'initialization' }
RwCluster >> initialize [
	subclusters := Dictionary new
]

{ #category : 'accessing' }
RwCluster >> subclusters [
	^subclusters
]

{ #category : 'accessing' }
RwCluster >> subclusters: object [
	subclusters := object
]
