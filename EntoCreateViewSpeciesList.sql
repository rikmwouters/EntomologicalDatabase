USE EntoBase
GO

DROP VIEW IF EXISTS dbo.SpeciesList ;  
GO  

CREATE VIEW SpeciesList AS
SELECT Species.TaxonID, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, COUNT(DISTINCT SpecimenID) AS SpecimenCount FROM Specimens
INNER JOIN Collections ON Specimens.CollectionID=Collections.CollectionID
INNER JOIN Identifications ON Specimens.IdentificationID=Identifications.IdentificationID
INNER JOIN PrimaryTaxons AS Species ON Identifications.DeterminedTaxonID=Species.TaxonID
INNER JOIN PrimaryTaxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
WHERE Species.TaxonRank = 'Species'
GROUP BY Species.TaxonID, Species.TaxonName, Genus.TaxonName
GO