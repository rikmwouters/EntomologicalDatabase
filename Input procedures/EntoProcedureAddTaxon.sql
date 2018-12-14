USE Rapento
GO

CREATE PROCEDURE AddTaxon
	@TaxonName varchar(255),
	@TaxonRank varchar(255),
	@ParentTaxonID int
AS
INSERT INTO Taxons (TaxonName, TaxonRank, ParentTaxonID)
VALUES (@TaxonName, @TaxonRank, @ParentTaxonID)