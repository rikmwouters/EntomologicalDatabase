USE EntoBase
GO

CREATE PROCEDURE FindTaxonID @TaxonName varchar(255)
AS
SELECT TaxonID FROM PrimaryTaxons
WHERE TaxonName = @TaxonName