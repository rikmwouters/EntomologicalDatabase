USE EntoBase
GO

CREATE PROCEDURE AutoAddTaxons
	@GivenGenusName varchar(255),
	@GivenSpeciesName varchar(255),
	@RelevantTaxonID int,
	@OrphanMessage varchar(255) = null
AS
IF EXISTS (
		SELECT TaxonID FROM PrimaryTaxons 
		WHERE TaxonName = @GivenSpeciesName
	)
	BEGIN
		SET @RelevantTaxonID = (SELECT TaxonID FROM PrimaryTaxons 
		WHERE TaxonName = @GivenSpeciesName)
	END
ELSE
	IF EXISTS (
		SELECT TaxonID FROM PrimaryTaxons 
		WHERE TaxonName = @GivenGenusName
	)
	BEGIN
		INSERT INTO PrimaryTaxons (TaxonName, TaxonRank, ParentTaxonID)
		VALUES (@GivenSpeciesName, 'Species', (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName))
		SELECT @RelevantTaxonID = SCOPE_IDENTITY()
	END
	ELSE
		BEGIN
			INSERT INTO PrimaryTaxons (TaxonName, TaxonRank)
			VALUES (@GivenGenusName, 'Genus')
			SET @OrphanMessage = CONCAT('No parent has been associated with the new ', @GivenGenusName, ' genus. (TaxonID:', (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @GivenGenusName), ')')
			RAISERROR(@OrphanMessage, 0, 1)
			INSERT INTO PrimaryTaxons (TaxonName, TaxonRank, ParentTaxonID)
			VALUES (@GivenSpeciesName, 'Species', SCOPE_IDENTITY())
			SELECT @RelevantTaxonID = SCOPE_IDENTITY()
		END