USE EntoBase
GO

CREATE FUNCTION NumberOfSpecimensForTaxon(@TaxonID int)
	RETURNS int
	AS
	
	BEGIN
		DECLARE @NumberOfSpecimens int
		SELECT @NumberOfSpecimens = COUNT(SpecimenID)
			FROM Identifications
			WHERE DeterminedTaxonID = @TaxonID

		RETURN @NumberOfSpecimens
	END