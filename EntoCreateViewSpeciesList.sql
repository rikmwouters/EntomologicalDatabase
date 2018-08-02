USE EntoBase
GO

DROP VIEW IF EXISTS dbo.SpeciesList ;  
GO  

CREATE VIEW SpeciesList AS
	SELECT Species.TaxonID, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, COUNT(DISTINCT Identifications.SpecimenID) AS SpecimenCount FROM Identifications
		INNER JOIN Specimens ON Identifications.SpecimenID=Specimens.SpecimenID
		INNER JOIN Collections ON Specimens.CollectionID=Collections.CollectionID
		INNER JOIN PrimaryTaxons AS Species ON Identifications.DeterminedTaxonID=Species.TaxonID
		INNER JOIN PrimaryTaxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
	WHERE Species.TaxonRank = 'Species'
		AND EXISTS (SELECT IdentificationID FROM BestIdentifications) 
	GROUP BY Species.TaxonID, Species.TaxonName, Genus.TaxonName
GO