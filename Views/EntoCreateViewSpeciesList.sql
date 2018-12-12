USE EntoBase
GO

DROP VIEW IF EXISTS dbo.SpeciesList ;  
GO  

CREATE VIEW SpeciesList AS
	SELECT Species.TaxonID, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, COUNT(DISTINCT Determinations.IndividualID) AS SpecimenCount FROM Determinations
		INNER JOIN Individuals ON Determinations.IndividualID=Individuals.IndividualID
		INNER JOIN Samples ON Individuals.SampleID=Samples.SampleID
		INNER JOIN Taxons AS Species ON Determinations.DeterminedTaxonID=Species.TaxonID
		INNER JOIN Taxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
	WHERE Species.TaxonRank = 'Species'
		AND EXISTS (SELECT DeterminationID FROM BestDeterminations) 
	GROUP BY Species.TaxonID, Species.TaxonName, Genus.TaxonName
GO