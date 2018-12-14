USE Rapento
GO

---------Using the TaxonID----------
CREATE PROCEDURE ModifyParentTaxonWithID
	@TaxonID int,
	@ParentTaxonID int

AS

IF EXISTS (
	SELECT TaxonID FROM Taxons
	WHERE TaxonID = @TaxonID
) AND EXISTS (
	SELECT TaxonID FROM Taxons
	WHERE TaxonID = @ParentTaxonID
)
BEGIN
	UPDATE Taxons
	SET ParentTaxonID = @ParentTaxonID
	WHERE TaxonID = @TaxonID
END
GO

---------Using the TaxonName---------
CREATE PROCEDURE ModifyParentTaxonWithName
	@TaxonName varchar(255),
	@ParentTaxonName varchar(255)

AS

IF EXISTS (
	SELECT TaxonID FROM Taxons
	WHERE TaxonName = @TaxonName
) AND EXISTS (
	SELECT TaxonID FROM Taxons
	WHERE TaxonName = @ParentTaxonName
)
BEGIN
	UPDATE Taxons
	SET ParentTaxonID = (SELECT TaxonID FROM Taxons WHERE TaxonName = @ParentTaxonName)
	WHERE TaxonName = @TaxonName
END
GO