USE Rapento
GO

DROP VIEW IF EXISTS MonthlySamples
GO

CREATE VIEW MonthlySamples
AS
SELECT  SamplingDate = DATEPART(YEAR, SamplingDate),
        DATENAME(MONTH, SamplingDate) AS SamplingMonth,
        COUNT(SampleID) AS NumberOfSamples
	FROM Samples
WHERE SamplingDate IS NOT NULL
GROUP BY DATEPART(YEAR, SamplingDate), DATENAME(MONTH, SamplingDate)
GO

SELECT * FROM MonthlySamples