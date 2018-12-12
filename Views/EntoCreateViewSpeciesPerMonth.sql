USE EntoBase
GO

DROP VIEW IF EXISTS SpeciesFoundPerMonth
GO

CREATE VIEW SpeciesFoundPerMonth
AS
SELECT  DATENAME(MONTH, CollectionDate) AS CollectionMonth,
        COUNT(TaxonID) AS NumberOfSpecies
	FROM Collections
	INNER JOIN Specimens ON Specimens.CollectionID = Collections.CollectionID
	INNER JOIN Identifications ON Specimens.SpecimenID = Identifications.SpecimenID
	INNER JOIN PrimaryTaxons ON Identifications.DeterminedTaxonID = PrimaryTaxons.TaxonID
	WHERE TaxonRank = 'Species'
	GROUP BY DATEPART(YEAR, CollectionDate), DATENAME(MONTH, CollectionDate)
GO

SELECT * FROM SpeciesFoundPerMonth