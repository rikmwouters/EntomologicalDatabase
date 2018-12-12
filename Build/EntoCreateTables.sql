USE EntoBase
GO

BEGIN TRAN
BEGIN TRY

	CREATE TABLE dbo.Taxons (
		TaxonID int IDENTITY(0,1) NOT NULL,
		TaxonName varchar(255) NOT NULL,
		TaxonRank varchar(255) NOT NULL,
		ParentTaxonID int,
		PRIMARY KEY (TaxonID)
	)
	INSERT INTO dbo.Taxons (TaxonName, TaxonRank)
	VALUES ('ORIGIN', 'ORIGIN')
	
	CREATE TABLE dbo.TaxonRelations (
		RelationID int IDENTITY(1,1) NOT NULL,
		ActorTaxonID int,
		SubjectTaxonID int,
		PRIMARY KEY (RelationID),
		CONSTRAINT FK_ActorTaxonID FOREIGN KEY (ActorTaxonID) REFERENCES Taxons(TaxonID),
		CONSTRAINT FK_SubjectTaxonID FOREIGN KEY (SubjectTaxonID) REFERENCES Taxons(TaxonID)
	)

	CREATE TABLE dbo.Collections (
		CollectionID int IDENTITY(1,1) NOT NULL,
		CollectionName varchar(255),
		PRIMARY KEY (CollectionID)
	)

	CREATE TABLE dbo.Samples (
		SampleID int IDENTITY(1,1) NOT NULL,
		Ycoor float,
		Xcoor float,
		LocalityName varchar(255),
		SamplingDate date,
		SamplingTime time,
		PRIMARY KEY (SampleID)
	)

	CREATE TABLE dbo.Individuals (
		IndividualID int IDENTITY(1,1) NOT NULL,
		SampleID int,
		EntryTime datetime NOT NULL DEFAULT GETDATE(),
		PRIMARY KEY(IndividualID),
		CONSTRAINT FK_SampleID FOREIGN KEY (SampleID) REFERENCES Samples(SampleID)
	)

	CREATE TABLE dbo.Specimens (
		SpecimenID int IDENTITY(1,1) NOT NULL,
		IndividualID int NOT NULL,
		HostIndividualID int,
		PhysicalSpecimenID int,
		PRIMARY KEY (SpecimenID),
		CONSTRAINT FK_IndividualID FOREIGN KEY (IndividualID) REFERENCES Individuals(IndividualID) ON DELETE CASCADE,
		CONSTRAINT FK_HostIndividualID FOREIGN KEY (HostIndividualID) REFERENCES Individuals(IndividualID)
	)

	CREATE TABLE dbo.ColRelations (
		RelationID int IDENTITY(1,1) NOT NULL,
		CollectionID int NOT NULL,
		IndividualID int NOT NULL,
		PRIMARY KEY (RelationID),
		CONSTRAINT FK_CollectionID FOREIGN KEY (CollectionID) REFERENCES Collections(CollectionID) ON DELETE CASCADE,
		CONSTRAINT FK_IndividualID5 FOREIGN KEY (IndividualID) REFERENCES Individuals(IndividualID) ON DELETE CASCADE
	)

	CREATE TABLE dbo.Images (
		ImageID int IDENTITY(1,1) NOT NULL,
		ImageName varchar(60),
		ImageFile varbinary(max) NOT NULL,
		EntryTime datetime DEFAULT GETDATE() NOT NULL,
		PRIMARY KEY (ImageID)
	)

	CREATE TABLE dbo.ImageRelations (
		RelationID int IDENTITY(1,1) NOT NULL,
		ImageID int NOT NULL,
		IndividualID int NOT NULL,
		SubjectDescription varchar(255),
		PRIMARY KEY (RelationID),
		CONSTRAINT FK_IndividualID4 FOREIGN KEY (IndividualID) REFERENCES Individuals(IndividualID) ON DELETE CASCADE,
		CONSTRAINT FK_ImageID FOREIGN KEY (ImageID) REFERENCES Images(ImageID) ON DELETE CASCADE
	)

	CREATE TABLE dbo.Determinations (
		DeterminationID int IDENTITY(1,1) NOT NULL,
		DeterminedTaxonID int,
		DeterminedBy varchar(255),
		DeterminationDate date,
		IndividualID int,
		Inferior bit DEFAULT 0,
		CONSTRAINT FK_DeterminedTaxonID FOREIGN KEY (DeterminedTaxonID) REFERENCES Taxons(TaxonID),
		CONSTRAINT FK_IndividualID3 FOREIGN KEY (IndividualID) REFERENCES Individuals(IndividualID) ON DELETE CASCADE,
		PRIMARY KEY (DeterminationID)
	)
	
	COMMIT
END TRY

BEGIN CATCH
	ROLLBACK
	SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH

GO
