USE EntoBase
GO

DROP PROCEDURE IF EXISTS dbo.AddIdentification
GO

CREATE PROCEDURE AddIdentification
				@GivenSpecimenID int,
				@GivenGenusName varchar(255),
				@GivenSpeciesName varchar(255),
				@GivenIdentifiedBy varchar(255),
				@GivenIdentificationDate varchar(255),
				@RelevantTaxonID int = null,
				@RelevantIdentificationID int = null,
				@RelevantCollectionID int = null,
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
		INSERT INTO Identifications (IdentifiedBy, IdentificationDate, DeterminedTaxonID)
		VALUES (@GivenIdentifiedBy, @GivenIdentificationDate, @RelevantTaxonID)
		SELECT @RelevantIdentificationID = SCOPE_IDENTITY()
	END
ELSE 
	SET @RelevantIdentificationID = (SELECT IdentificationID FROM Identifications 
	WHERE IdentifiedBy = @GivenIdentifiedBy AND IdentificationDate = @GivenIdentificationDate)

SELECT IdentificationID FROM Identifications 
WHERE IdentifiedBy = @GivenIdentifiedBy AND IdentificationDate = @GivenIdentificationDate

----------------Modify identificationID------------------------------------------------------------------------------------

UPDATE Specimens
SET IdentificationID = @RelevantIdentificationID
WHERE SpecimenID = @GivenSpecimenID

GO