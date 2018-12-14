USE Rapento
GO

CREATE VIEW DeterminedIndividuals AS
SELECT Determinations.IndividualID, SamplingDate, Genus.TaxonName AS GenusName, Species.TaxonName AS SpeciesName, Ycoor, Xcoor FROM Determinations
INNER JOIN Individuals ON Determinations.IndividualID = Individuals.IndividualID
INNER JOIN Samples ON Individuals.SampleID=Samples.SampleID
INNER JOIN Taxons AS Species ON Determinations.DeterminedTaxonID=Species.TaxonID
INNER JOIN Taxons AS Genus ON Species.ParentTaxonID=Genus.TaxonID
WHERE Species.TaxonRank = 'Species'