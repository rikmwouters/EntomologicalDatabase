USE EntoBase
GO

CREATE VIEW DeterminedSpecimens AS
SELECT Identifications.SpecimenID, CollectionDate, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, Ycoor, Xcoor FROM Identifications
INNER JOIN Specimens ON Identifications.SpecimenID = Specimens.SpecimenID
INNER JOIN Collections ON Specimens.CollectionID=Collections.CollectionID
INNER JOIN PrimaryTaxons AS Species ON Identifications.DeterminedTaxonID=Species.TaxonID
INNER JOIN PrimaryTaxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
WHERE Species.TaxonRank = 'Species'