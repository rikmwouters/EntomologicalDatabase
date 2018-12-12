USE EntoBase
GO

DROP PROCEDURE IF EXISTS dbo.AddIndividual;  
GO
------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE AddIndividual
		@GivenGenusName varchar(255) = null,
		@GivenSpeciesName varchar(255) = null,
		@GivenDeterminedBy varchar(255) = null,
		@GivenDeterminationDate varchar(255) = null,
		@GivenInferior bit = 0,
		@GivenYcoor float = null,
		@GivenXcoor float = null,
		@GivenLocalityName varchar(255) = null,
		@GivenSamplingDate varchar(255) = null,
		@GivenPhysicalSpecimenID int = null,
		@GivenCollectionName varchar(255) = null,
		@RelevantIndividualID int = null,
		@RelevantTaxonID int = null,
		@RelevantDeterminationID int = null,
		@RelevantSampleID int = null,
		@RelevantSpecimenID int = null,
		@OrphanMessage varchar(255) = null
AS

IF @GivenGenusName IS NOT NULL
	BEGIN
		SELECT @GivenSpeciesName = 'sp'
	END

-------------Add Individual------------------------------------------------------------------------------------

INSERT INTO Individuals (EntryTime)
	VALUES (GETDATE())
SELECT @RelevantIndividualID = SCOPE_IDENTITY()

-------------Add taxon?-----------------------------------------------------------------------------------------

IF NOT EXISTS(
	SELECT Species.TaxonID
	FROM Taxons AS Species
	INNER JOIN Taxons AS Genus ON Genus.TaxonID=Species.ParentTaxonID
	WHERE Species.TaxonName = @GivenSpeciesName
	AND Genus.TaxonName = @GivenGenusName
)
BEGIN
	INSERT INTO Taxons (TaxonName, TaxonRank)
	VALUES (@GivenGenusName, 'Genus')
	SET @OrphanMessage = CONCAT('No parent has been associated with the new ', @GivenGenusName, ' genus. (TaxonID:', (SELECT TaxonID FROM Taxons WHERE TaxonName = @GivenGenusName), ')')
	RAISERROR(@OrphanMessage, 0, 1)
	INSERT INTO Taxons (TaxonName, TaxonRank, ParentTaxonID)
	VALUES (@GivenSpeciesName, 'Species', SCOPE_IDENTITY())
	SELECT @RelevantTaxonID = SCOPE_IDENTITY()
END
ELSE
	IF EXISTS (
	SELECT TaxonID FROM Taxons 
	WHERE TaxonName = @GivenSpeciesName
	AND ParentTaxonID = (SELECT TaxonID FROM Taxons WHERE TaxonName = @GivenGenusName)
	)
	BEGIN
		SET @RelevantTaxonID = (SELECT TaxonID FROM Taxons 
		WHERE TaxonName = @GivenSpeciesName)
	END
	ELSE
		BEGIN
			INSERT INTO Taxons (TaxonName, TaxonRank, ParentTaxonID)
			VALUES (@GivenSpeciesName, 'Species', (SELECT TaxonID FROM Taxons WHERE TaxonName = @GivenGenusName))
			SELECT @RelevantTaxonID = SCOPE_IDENTITY()
		END

---------------Add determination-----------------------------------------------------------------------------------------
IF @RelevantTaxonID IS NOT NULL
	BEGIN
		INSERT INTO Determinations (DeterminedBy, DeterminationDate, DeterminedTaxonID, IndividualID, Inferior)
			VALUES (@GivenDeterminedBy, @GivenDeterminationDate, @RelevantTaxonID, @RelevantIndividualID, @GivenInferior)
		SELECT @RelevantDeterminationID = SCOPE_IDENTITY()
	END
---------------Add sample?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT SampleID FROM Samples 
		WHERE Ycoor = @GivenYcoor AND Xcoor = @GivenXcoor AND LocalityName = @GivenLocalityName AND SamplingDate = @GivenSamplingDate
	)
	BEGIN
		INSERT INTO Samples (Ycoor, Xcoor, LocalityName, SamplingDate)
		VALUES (@GivenYcoor, @GivenXcoor, @GivenLocalityName, @GivenSamplingDate)
		SELECT @RelevantSampleID = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		SET @RelevantSampleID = (SELECT SampleID FROM Samples 
		WHERE Ycoor = @GivenYcoor AND Xcoor = @GivenXcoor AND LocalityName = @GivenLocalityName AND SamplingDate = @GivenSamplingDate)
	END

UPDATE Individuals
SET SampleID = @RelevantSampleID
WHERE IndividualID = @RelevantIndividualID

--------------Add specimen?-----------------------------------------------------------------------------------------

IF @GivenPhysicalSpecimenID IS NOT NULL
	BEGIN
		INSERT INTO Specimens (IndividualID, PhysicalSpecimenID)
		VALUES (@RelevantIndividualID, @GivenPhysicalSpecimenID)
	END

----------Add collection?--------------------------------------------------------------------------------------------

IF @GivenCollectionName IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT CollectionID FROM Collections WHERE CollectionName = @GivenCollectionName)
			BEGIN
				INSERT INTO Collections (CollectionName)
				VALUES (@GivenCollectionName)
			END				
		INSERT INTO ColRelations (IndividualID, CollectionID)
		VALUES (@RelevantIndividualID, (SELECT CollectionID FROM Collections WHERE CollectionName = @GivenCollectionName))
	END