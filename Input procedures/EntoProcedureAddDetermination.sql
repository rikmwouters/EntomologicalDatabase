USE Rapento
GO

DROP PROCEDURE IF EXISTS dbo.AddDetermination
GO

CREATE PROCEDURE AddDetermination
				@GivenIndividualID int,
				@GivenGenusName varchar(255),
				@GivenSpeciesName varchar(255),
				@GivenDeterminedBy varchar(255),
				@GivenDeterminationDate varchar(255),
				@RelevantTaxonID int = null,
				@RelevantDeterminationID int = null,
				@RelevantCollectionID int = null,
				@OrphanMessage varchar(255) = null

AS

-------------Add taxon?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
	SELECT TaxonID FROM Taxons
	WHERE TaxonName = @GivenGenusName
)
BEGIN
	INSERT INTO Taxons (TaxonName, TaxonRank)
	VALUES (@GivenGenusName, 'Genus')
	SET @OrphanMessage = CONCAT('No parent has been associated with the new ', @GivenGenusName, ' genus. (TaxonID:', (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName), ')')
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

---------------Add identification?-----------------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT DeterminationID FROM Determinations 
		WHERE DeterminedBy = @GivenDeterminedBy AND DeterminationDate = @GivenDeterminationDate AND DeterminedTaxonID = @RelevantTaxonID AND IndividualID = @GivenIndividualID
	)
	BEGIN
		INSERT INTO Determinations (DeterminedBy, DeterminationDate, DeterminedTaxonID, IndividualID)
		VALUES (@GivenDeterminedBy, @GivenDeterminationDate, @RelevantTaxonID, @GivenIndividualID)
		SELECT @RelevantDeterminationID = SCOPE_IDENTITY()
	END
ELSE 
	SET @RelevantDeterminationID = (SELECT DeterminationID FROM Determinations 
	WHERE DeterminedBy = @GivenDeterminedBy AND DeterminationDate = @GivenDeterminationDate)

GO