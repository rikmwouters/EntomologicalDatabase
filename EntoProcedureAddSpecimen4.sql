USE EntoBase
GO

DROP PROCEDURE IF EXISTS dbo.AddSpecimen;  
GO
------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE AddSpecimen 
		@GivenGenusName varchar(255),
		@GivenSpeciesName varchar(255) = 'sp',
		@GivenIdentifiedBy varchar(255),
		@GivenIdentificationDate varchar(255),
		@GivenInferior bit,
		@GivenYcoor float,
		@GivenXcoor float,
		@GivenLocalityName varchar(255),
		@GivenCollectionDate varchar(255),
		@RelevantTaxonID int = null,
		@RelevantIdentificationID int = null,
		@RelevantCollectionID int = null,
		@RelevantSpecimenID int = null,
		@OrphanMessage varchar(255) = null
AS 

-------------Add taxon?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
	SELECT TaxonID FROM PrimaryTaxons
	WHERE TaxonName = @GivenGenusName
)
BEGIN
	INSERT INTO PrimaryTaxons (TaxonName, TaxonRank)
	VALUES (@GivenGenusName, 'Genus')
	SET @OrphanMessage = CONCAT('No parent has been associated with the new ', @GivenGenusName, ' genus. (TaxonID:', (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName), ')')
	RAISERROR(@OrphanMessage, 0, 1)
	INSERT INTO PrimaryTaxons (TaxonName, TaxonRank, ParentTaxonID)
	VALUES (@GivenSpeciesName, 'Species', SCOPE_IDENTITY())
	SELECT @RelevantTaxonID = SCOPE_IDENTITY()
END
ELSE
	IF EXISTS (
	SELECT TaxonID FROM PrimaryTaxons 
	WHERE TaxonName = @GivenSpeciesName
	AND ParentTaxonID = (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName)
	)
	BEGIN
		SET @RelevantTaxonID = (SELECT TaxonID FROM PrimaryTaxons 
		WHERE TaxonName = @GivenSpeciesName)
	END
	ELSE
		BEGIN
			INSERT INTO PrimaryTaxons (TaxonName, TaxonRank, ParentTaxonID)
			VALUES (@GivenSpeciesName, 'Species', (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName))
			SELECT @RelevantTaxonID = SCOPE_IDENTITY()
		END

---------------Add identification?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT IdentificationID FROM Identifications 
		WHERE IdentifiedBy = @GivenIdentifiedBy AND IdentificationDate = @GivenIdentificationDate AND DeterminedTaxonID = @RelevantTaxonID
	)
	BEGIN
		INSERT INTO Identifications (IdentifiedBy, IdentificationDate, DeterminedTaxonID, Inferior)
		VALUES (@GivenIdentifiedBy, @GivenIdentificationDate, @RelevantTaxonID, @GivenInferior)
		SELECT @RelevantIdentificationID = SCOPE_IDENTITY()
	END
ELSE 
	SET @RelevantIdentificationID = (SELECT IdentificationID FROM Identifications 
	WHERE IdentifiedBy = @GivenIdentifiedBy AND IdentificationDate = @GivenIdentificationDate)


---------------Add Collection?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT CollectionID FROM Collections 
		WHERE Ycoor = @GivenYcoor AND Xcoor = @GivenXcoor AND LocalityName = @GivenLocalityName AND CollectionDate = @GivenCollectionDate
	)
	BEGIN
		INSERT INTO Collections (Ycoor, Xcoor, LocalityName, CollectionDate)
		VALUES (@GivenYcoor, @GivenXcoor, @GivenLocalityName, @GivenCollectionDate)
		SELECT @RelevantCollectionID = SCOPE_IDENTITY()
	END
ELSE 
	SET @RelevantCollectionID = (SELECT CollectionID FROM Collections 
	WHERE Ycoor = @GivenYcoor AND Xcoor = @GivenXcoor)


-------------Add specimen?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT Specimens.SpecimenID FROM Specimens
		INNER JOIN Identifications ON Specimens.SpecimenID=Identifications.SpecimenID
		WHERE CollectionID = @RelevantCollectionID AND IdentificationID = @RelevantIdentificationID
	)
	BEGIN
		INSERT INTO Specimens (CollectionID, CreationDate)
		VALUES (@RelevantCollectionID, GETDATE())
		SELECT @RelevantSpecimenID = SCOPE_IDENTITY()
	END
ELSE 
	PRINT 'Deze specimen bestaat al.'


-------------Update identifications-----------------------------------------------------------------------------------
UPDATE Identifications
SET SpecimenID = @RelevantSpecimenID
WHERE IdentificationID = @RelevantIdentificationID

GO