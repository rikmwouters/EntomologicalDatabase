USE EntoBase
GO

CREATE PROCEDURE ModifyParentTaxonWithID
	@TaxonID int,
	@ParentTaxonID int

AS

IF EXISTS (
	SELECT TaxonID FROM PrimaryTaxons
	WHERE TaxonID = @TaxonID
) AND EXISTS (
	SELECT TaxonID FROM PrimaryTaxons
	WHERE TaxonID = @ParentTaxonID
)
BEGIN
	UPDATE PrimaryTaxons
	SET ParentTaxonID = @ParentTaxonID
	WHERE TaxonID = @TaxonID
END
GO

CREATE PROCEDURE ModifyParentTaxonWithName
	@TaxonName varchar(255),
	@ParentTaxonName varchar(255)

AS

IF EXISTS (
	SELECT TaxonID FROM PrimaryTaxons
	WHERE TaxonName = @TaxonName
) AND EXISTS (
	SELECT TaxonID FROM PrimaryTaxons
	WHERE TaxonName = @ParentTaxonName
)
BEGIN
	UPDATE PrimaryTaxons
	SET ParentTaxonID = (SELECT TaxonID FROM PrimaryTaxons WHERE TaxonName = @ParentTaxonName)
	WHERE TaxonName = @TaxonName
END
GO