USE EntoBase
GO

CREATE FUNCTION NumberOfSpecimensForTaxon(@TaxonID int)
	RETURNS int
	AS
	
	BEGIN
		DECLARE @NumberOfSpecimens int
		SELECT @NumberOfSpecimens = COUNT(SpecimenID)
			FROM Specimens
			INNER JOIN Identifications ON Specimens.IdentificationID = Identifications.IdentificationID
			WHERE DeterminedTaxonID = @TaxonID

		RETURN @NumberOfSpecimens
	END