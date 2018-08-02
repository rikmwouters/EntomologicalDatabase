USE EntoBase
GO

BEGIN TRAN
BEGIN TRY

	CREATE TABLE dbo.PrimaryTaxons (
		TaxonID int IDENTITY(0,1) NOT NULL,
		TaxonName varchar(255) NOT NULL,
		TaxonRank varchar(255) NOT NULL,
		ParentTaxonID int,
		PRIMARY KEY (TaxonID)
	)
	INSERT INTO dbo.PrimaryTaxons (TaxonName, TaxonRank)
	VALUES ('ORIGIN', 'ORIGIN')
	
	CREATE TABLE dbo.HostTaxons (
		TaxonID int IDENTITY(0,1) NOT NULL,
		TaxonName varchar(255) NOT NULL,
		TaxonRank varchar(255),
		ParentTaxonID int,
		PRIMARY KEY (TaxonID)
	)
	INSERT INTO dbo.HostTaxons (TaxonName, TaxonRank)
	VALUES ('ORIGIN', 'ORIGIN')

	CREATE TABLE dbo.HostRelations (
		RelationID int IDENTITY(1,1) NOT NULL,
		HostTaxonID int,
		GuestTaxonID int,
		PRIMARY KEY (RelationID),
		CONSTRAINT FK_HostTaxonID FOREIGN KEY (HostTaxonID) REFERENCES HostTaxons(TaxonID),
		CONSTRAINT FK_GuestTaxonID FOREIGN KEY (GuestTaxonID) REFERENCES PrimaryTaxons(TaxonID)
	)

	CREATE TABLE dbo.Collections (
		CollectionID int IDENTITY(1,1) not null,
		Ycoor float,
		Xcoor float,
		LocalityName varchar(255),
		CollectionDate date,
		PRIMARY KEY (CollectionID),
	)

	CREATE TABLE dbo.Specimens (
		SpecimenID int IDENTITY(1,1) not null,
		CollectionID int,
		CreationDate datetime NOT NULL DEFAULT GETDATE(),
		PRIMARY KEY (SpecimenID),
		CONSTRAINT FK_CollectionID FOREIGN KEY (CollectionID) REFERENCES Collections(CollectionID),
	)
	
	CREATE TABLE dbo.Identifications (
		IdentificationID int IDENTITY(1,1) NOT NULL,
		DeterminedTaxonID int,
		IdentifiedBy varchar(255),
		IdentificationDate date,
		SpecimenID int,
		Inferior bit DEFAULT 0,
		CONSTRAINT FK_DeterminedTaxonID FOREIGN KEY (DeterminedTaxonID) REFERENCES PrimaryTaxons(TaxonID),
		CONSTRAINT FK_SpecimenID FOREIGN KEY (SpecimenID) REFERENCES Specimens(SpecimenID) ON DELETE CASCADE,
		PRIMARY KEY (IdentificationID)
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
