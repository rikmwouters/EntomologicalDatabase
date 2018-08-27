USE EntoBase
GO

DROP PROCEDURE IF EXISTS dbo.AddIndividual;  
GO
------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE AddIndividual
		@GivenGenusName varchar(255),
		@GivenSpeciesName varchar(255) = 'sp',
		@GivenDeterminedBy varchar(255),
		@GivenDeterminationDate varchar(255),
		@GivenInferior bit,
		@GivenYcoor float,
		@GivenXcoor float,
		@GivenLocalityName varchar(255),
		@GivenSamplingDate varchar(255),
		@RelevantIndividualID int,
		@RelevantTaxonID int = null,
		@RelevantDeterminationID int = null,
		@RelevantSampleID int = null,
		@RelevantSpecimenID int = null,
		@OrphanMessage varchar(255) = null
AS

-------------Add Individual------------------------------------------------------------------------------------

INSERT INTO Individuals (EntryTime)
	VALUES (GETDATE())
SELECT @RelevantIndividualID = SCOPE_IDENTITY()

-------------Add taxon?-----------------------------------------------------------------------------------------

IF NOT EXISTS(
	SELECT TaxonID
	FROM Taxons
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

INSERT INTO Determinations (DeterminedBy, DeterminationDate, DeterminedTaxonID, IndividualID, Inferior)
	VALUES (@GivenDeterminedBy, @GivenDeterminationDate, @RelevantTaxonID, @RelevantIndividualID, @GivenInferior)
SELECT @RelevantDeterminationID = SCOPE_IDENTITY()

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
	SET @RelevantSampleID = (SELECT SampleID FROM Samples 
	WHERE Ycoor = @GivenYcoor AND Xcoor = @GivenXcoor AND LocalityName = @GivenLocalityName AND SamplingDate = @GivenSamplingDate)

--------------Add specimen-----------------------------------------------------------------------------------------
