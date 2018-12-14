USE Rapento
GO

DROP VIEW IF EXISTS SpeciesFoundPerMonth
GO

CREATE VIEW SpeciesFoundPerMonth
AS
SELECT  DATENAME(MONTH, SamplingDate) AS SamplingMonth,
        COUNT(TaxonID) AS NumberOfSpecies
	FROM Samples
	INNER JOIN Individuals ON Individuals.SampleID = Samples.SampleID
	INNER JOIN Determinations ON Individuals.IndividualID = Determinations.IndividualID
	INNER JOIN Taxons ON Determinations.DeterminedTaxonID = Taxons.TaxonID
	WHERE TaxonRank = 'Species'
	AND SamplingDate IS NOT NULL
	GROUP BY DATEPART(YEAR, SamplingDate), DATENAME(MONTH, SamplingDate)
GO

SELECT * FROM SpeciesFoundPerMonth