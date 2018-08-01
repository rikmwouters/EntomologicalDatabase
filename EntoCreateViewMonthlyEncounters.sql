USE EntoBase
GO

DROP VIEW IF EXISTS MonthlyCollections
GO

CREATE VIEW MonthlyCollections
AS
SELECT  CollectionDate = DATEPART(YEAR, CollectionDate),
        DATENAME(MONTH, CollectionDate) AS CollectionMonth,
        COUNT(CollectionID) AS NumberOfCollections
	FROM Collections
GROUP BY DATEPART(YEAR, CollectionDate), DATENAME(MONTH, CollectionDate)
GO

SELECT * FROM MonthlyCollections