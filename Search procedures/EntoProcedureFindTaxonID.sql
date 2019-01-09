USE Rapento
GO

DROP PROCEDURE IF EXISTS dbo.FindTaxonID;
GO

CREATE PROCEDURE FindTaxonID @TaxonName varchar(255)
AS
SELECT TaxonID FROM Taxons
WHERE TaxonName = @TaxonName