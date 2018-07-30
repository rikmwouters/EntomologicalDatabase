USE EntoBase
GO

CREATE VIEW DeterminedSpecimens AS
SELECT SpecimenID, CollectionDate, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, Ycoor, Xcoor FROM Specimens
INNER JOIN Collections ON Specimens.CollectionID=Collections.CollectionID
INNER JOIN Identifications ON Specimens.IdentificationID=Identifications.IdentificationID
INNER JOIN PrimaryTaxons AS Species ON Identifications.DeterminedTaxonID=Species.TaxonID
INNER JOIN PrimaryTaxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
WHERE Species.TaxonRank = 'Species'