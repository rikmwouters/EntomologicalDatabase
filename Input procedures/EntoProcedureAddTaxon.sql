USE EntoBase
GO

CREATE PROCEDURE AddTaxon
	@TaxonName varchar(255),
	@TaxonRank varchar(255),
	@ParentTaxonID int
AS
INSERT INTO PrimaryTaxons (TaxonName, TaxonRank, ParentTaxonID)
VALUES (@TaxonName, @TaxonRank, @ParentTaxonID)